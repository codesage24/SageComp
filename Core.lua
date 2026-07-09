SageComp = SageComp or {}

local ADDON = "SageComp"
local ICON_SIZE = 28
local ICON_PADDING = 5
local HEADER_HEIGHT = 16
local LEFT_WIDTH = 200
local TOP_HEIGHT = 54
local FRAME_PADDING = 10
local DEFAULT_ICON_COLUMNS = 4
local MIN_ICON_COLUMNS = 2
local MAX_ICON_COLUMNS = 8
local ROW_HEIGHT = 16
local MAX_MEMBER_ROWS = 48

local function Normalize(value)
    value = value or ""
    value = string.lower(value)
    value = string.gsub(value, "^%s+", "")
    value = string.gsub(value, "%s+$", "")
    return value
end

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccSageComp:|r " .. tostring(msg))
end

function EnsureDB()
    SageCompDB = SageCompDB or {}
    SageCompDB.minimap = SageCompDB.minimap or {}
    SageCompDB.specs = SageCompDB.specs or {}
    SageCompDB.point = SageCompDB.point or {
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = 0
    }

    SageCompDB.iconColumns = SageCompDB.iconColumns or DEFAULT_ICON_COLUMNS

    if SageCompDB.iconColumns < MIN_ICON_COLUMNS then
        SageCompDB.iconColumns = MIN_ICON_COLUMNS
    end

    if SageCompDB.iconColumns > MAX_ICON_COLUMNS then
        SageCompDB.iconColumns = MAX_ICON_COLUMNS
    end

    return SageCompDB
end

function SageComp:EnsureDB()
    return EnsureDB()
end

local function GetRosterUnits()
    local units = {}

    if GetNumRaidMembers and GetNumRaidMembers() > 0 then
        for i = 1, GetNumRaidMembers() do
            table.insert(units, "raid" .. i)
        end
    elseif GetNumPartyMembers and GetNumPartyMembers() > 0 then
        table.insert(units, "player")
        for i = 1, GetNumPartyMembers() do
            table.insert(units, "party" .. i)
        end
    else
        table.insert(units, "player")
    end

    return units
end

local function GetClassColor(className)
    local provider = SageComp.Providers and SageComp.Providers[className]

    if provider and provider.color then
        return provider.color
    end

    return { r = 0.85, g = 0.85, b = 0.85 }
end

local function SplitClassSpec(value)
    if not value then return nil, nil end

    local colon = string.find(value, ":")
    if colon then
        return string.sub(value, 1, colon - 1), string.sub(value, colon + 1)
    end

    return nil, value
end

local function GetSpecData(className, specName)
    if not className or not specName then return nil end
    local classData = SageComp.Providers and SageComp.Providers[className]
    if not classData or not classData.specs then return nil end
    return classData.specs[specName]
end

local function GetRoleForSpec(className, specName)
    local specData = GetSpecData(className, specName)
    return specData and specData.role or nil
end

local function GetPlayerInfo(unit)
    if not UnitExists(unit) then return nil end

    local name = UnitName(unit)
    if not name then return nil end

    local localizedClass = UnitClass(unit)
    local className = localizedClass or "Unknown"
    local override = EnsureDB().specs[name]
    local overrideClass, overrideSpec = SplitClassSpec(override)
    local specName = overrideSpec

    if overrideClass and overrideClass ~= "" then
        className = overrideClass
    end

    local role = GetRoleForSpec(className, specName)
    local display

    if specName and role then
        display = name .. ": " .. role .. " (" .. className .. ":" .. specName .. ")"
    elseif specName then
        display = name .. " (" .. className .. ":" .. specName .. ")"
    else
        display = name .. " (" .. className .. ")"
    end

    return {
        unit = unit,
        name = name,
        color = GetClassColor(className),
        className = className,
        specName = specName,
        role = role,
        display = display,
    }
end

local function GetRosterPlayers()
    local players = {}
    local units = GetRosterUnits() or {}

    local rolePriority = {
        Tank = 1,
        Healer = 2,
        Support = 3,
        DPS = 4,
        Unassigned = 5,
    }

    for _, unit in ipairs(units) do
        local player = GetPlayerInfo(unit)

        if player then
            player.sortRole =
                player.role or "Unassigned"

            table.insert(players, player)
        end
    end

    table.sort(players, function(a, b)
        local aPriority =
            rolePriority[a.sortRole]
            or rolePriority.Unassigned

        local bPriority =
            rolePriority[b.sortRole]
            or rolePriority.Unassigned

        if aPriority ~= bPriority then
            return aPriority < bPriority
        end

        return string.lower(a.name or "")
            < string.lower(b.name or "")
    end)

    return players
end

local function SpecProvidesBuff(specData, buffKey)
    if not specData or not specData.provides then return false end

    local wanted = Normalize(buffKey)
    for _, key in ipairs(specData.provides) do
        if Normalize(key) == wanted then
            return true
        end
    end

    return false
end

local function GetConfiguredProvidersForBuff(buffKey)
    local providers = {}

    for className, classData in pairs(SageComp.Providers or {}) do
        if classData.specs then
            for specName, specData in pairs(classData.specs) do
                if SpecProvidesBuff(specData, buffKey) then
                    table.insert(providers, className .. ":" .. specName)
                end
            end
        end
    end

    table.sort(providers)
    return providers
end

local function FindMatches(buff)
    local matches = {}
    local players = GetRosterPlayers()

    for _, player in ipairs(players) do
        if player.className and player.specName then
            local specData = GetSpecData(player.className, player.specName)
            if SpecProvidesBuff(specData, buff.key) then
                table.insert(matches, player)
            end
        end
    end

    return matches
end

local function SaveFramePosition(frame)
    local db = EnsureDB()
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    db.point = { point = point, relativePoint = relativePoint, x = x, y = y }
end

local function RestoreFramePosition(frame)
    local db = EnsureDB()
    frame:ClearAllPoints()
    frame:SetPoint(db.point.point or "CENTER", UIParent, db.point.relativePoint or "CENTER", db.point.x or 0, db.point.y or 0)
end

local function SaveSpecOverride(playerName, className, specName)
    if not playerName or not className or not specName then return end

    EnsureDB().specs[playerName] = className .. ":" .. specName
    Print("Saved spec: " .. playerName .. " = " .. className .. ":" .. specName)

    if SageComp.Refresh then
        SageComp:Refresh()
    end
end

local function ClearSpecOverride(playerName)
    if not playerName then return end

    EnsureDB().specs[playerName] = nil
    Print("Removed spec assignment for " .. playerName)

    if SageComp.Refresh then
        SageComp:Refresh()
    end
end

local function BuildSpecMenu(player)
    local menu = {}
    local classData = SageComp.Providers and SageComp.Providers[player.className]

    table.insert(menu, {
        text = player.name,
        isTitle = true,
        notCheckable = true,
    })

    if classData and classData.specs then
        local specNames = {}
        for specName in pairs(classData.specs) do
            table.insert(specNames, specName)
        end
        table.sort(specNames)

        for _, specName in ipairs(specNames) do
            local specData = classData.specs[specName]
            local roleText = specData and specData.role and (" - " .. specData.role) or ""
            table.insert(menu, {
                text = specName .. roleText,
                notCheckable = true,
                func = function()
                    SaveSpecOverride(player.name, player.className, specName)
                end,
            })
        end
    else
        table.insert(menu, {
            text = "No specs configured for " .. tostring(player.className),
            disabled = true,
            notCheckable = true,
        })
    end

    table.insert(menu, {
        text = "Clear assignment",
        notCheckable = true,
        func = function()
            ClearSpecOverride(player.name)
        end,
    })

    return menu
end

local specMenuFrame = CreateFrame("Frame", "SageCompSpecMenu", UIParent, "UIDropDownMenuTemplate")

local function ShowSpecMenu(row)
    if not row or not row.player then return end
    local menu = BuildSpecMenu(row.player)
    EasyMenu(menu, specMenuFrame, "cursor", 0, 0, "MENU")
end

local function ShowBuffTooltip(button)
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(button.buff.name, 1, 1, 1)

    if button.matches and #button.matches > 0 then
        GameTooltip:AddLine("Provided by:", 0.2, 1, 0.4)
        for _, player in ipairs(button.matches) do
            GameTooltip:AddLine("  " .. player.display, 1, 1, 1)
        end
    else
        GameTooltip:AddLine("Missing. Can be provided by:", 1, 0.3, 0.3)
        local providers = button.configuredProviders or GetConfiguredProvidersForBuff(button.buff.key)
        if providers and #providers > 0 then
            for _, provider in ipairs(providers) do
                GameTooltip:AddLine("  " .. provider, 1, 1, 1)
            end
        else
            GameTooltip:AddLine("  No providers configured yet", 0.8, 0.8, 0.8)
        end
    end

    GameTooltip:Show()
end

local function SetIconColumns(count)
    local db = EnsureDB()
    count = tonumber(count) or db.iconColumns
    count = math.floor(count)

    if count < MIN_ICON_COLUMNS then count = MIN_ICON_COLUMNS end
    if count > MAX_ICON_COLUMNS then count = MAX_ICON_COLUMNS end

    db.iconColumns = count

    if SageComp.LayoutBuffButtons then
        SageComp:LayoutBuffButtons()
    end

    if SageComp.Refresh then
        SageComp:Refresh()
    end
end

local function ToHexColor(color)
    local r = math.floor((color.r or 1) * 255)
    local g = math.floor((color.g or 1) * 255)
    local b = math.floor((color.b or 1) * 255)

    return string.format("ff%02x%02x%02x", r, g, b)
end

local function Colorize(name, color)
    local hex = ToHexColor(color)

    return "|c" .. hex .. name .. "|r"
end

function SageComp:LayoutBuffButtons()
    if not self.frame or not self.buttons then return end

    local db = EnsureDB()
    local columns = db.iconColumns or DEFAULT_ICON_COLUMNS
    local rightX = FRAME_PADDING + LEFT_WIDTH + 18
    local y = -TOP_HEIGHT - 24
    local maxBottom = y

    if self.columnText then
        self.columnText:SetText("Columns: " .. columns)
    end

    for _, header in ipairs(self.categoryHeaders or {}) do
        header:Hide()
    end

    local headerIndex = 0

    for _, category in ipairs(self.Categories or {}) do
        headerIndex = headerIndex + 1
        local header = self.categoryHeaders[headerIndex]
        if not header then
            header = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.categoryHeaders[headerIndex] = header
        end

        header:SetPoint("TOPLEFT", self.frame, "TOPLEFT", rightX, y)
        header:SetText(category.name)
        header:Show()
        y = y - HEADER_HEIGHT

        local col = 0
        local row = 0

        for _, buff in ipairs(category.buffs) do
            local button = self.buffButtonByKey[buff.key]
            if button then
                button:ClearAllPoints()
                button:SetPoint("TOPLEFT", self.frame, "TOPLEFT", rightX + col * (ICON_SIZE + ICON_PADDING), y - row * (ICON_SIZE + ICON_PADDING))
                button:Show()
            end

            col = col + 1
            if col >= columns then
                col = 0
                row = row + 1
            end
        end

        y = y - ((row + 1) * (ICON_SIZE + ICON_PADDING)) - 9
        if y < maxBottom then maxBottom = y end
    end

    local rightWidth = columns * (ICON_SIZE + ICON_PADDING) - ICON_PADDING
    local frameWidth = rightX + rightWidth + FRAME_PADDING
    local frameHeight = math.max(620, math.abs(maxBottom) + 16)

    self.frame:SetWidth(frameWidth)
    self.frame:SetHeight(frameHeight)

    if self.leftDivider then
        self.leftDivider:SetPoint("TOPLEFT", self.frame, "TOPLEFT", FRAME_PADDING + LEFT_WIDTH + 7, -TOP_HEIGHT)
        self.leftDivider:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", FRAME_PADDING + LEFT_WIDTH + 7, 10)
    end
end

function SageComp:RefreshRoster()
    local players = GetRosterPlayers() or {}

    local roleOrder = {
        "Unassigned",    
        "Tank",
        "Healer",
        "Support",
        "DPS",
    }

    local roleHeaderNames = {
        Unassigned = "Unassigned",    
        Tank = "Tanks",
        Healer = "Healers",
        Support = "Supports",
        DPS = "DPS",
    }

    local counts = {
        Unassigned = 0,    
        Tank = 0,
        Healer = 0,
        Support = 0,
        DPS = 0,
    }

    local groupedPlayers = {
        Unassigned = {},
        Tank = {},
        Healer = {},
        Support = {},
        DPS = {},
    }

    -------------------------------------------------
    -- Group players by role
    -------------------------------------------------
    for _, player in ipairs(players) do
        local role = player.role or "Unassigned"

        if not groupedPlayers[role] then
            role = "Unassigned"
        end

        counts[role] = counts[role] + 1
        table.insert(groupedPlayers[role], player)
    end

    local rowIndex = 1

    -------------------------------------------------
    -- Render role groups
    -------------------------------------------------
    for _, role in ipairs(roleOrder) do
        local rolePlayers = groupedPlayers[role] or {}

        if #rolePlayers > 0 then

            -------------------------------------------------
            -- Role header
            -------------------------------------------------
            local headerRow = self.memberRows
                and self.memberRows[rowIndex]

            if headerRow then
                headerRow.player = nil
                headerRow.isHeader = true

                local headerName =
                    roleHeaderNames[role] or role

                headerRow.text:SetText(
                    headerName
                    .. " ("
                    .. #rolePlayers
                    .. ")"
                )

                headerRow.text:SetTextColor(
                    1.0,
                    0.82,
                    0.20
                )

                headerRow:Show()

                rowIndex = rowIndex + 1
            end

            -------------------------------------------------
            -- Players
            -------------------------------------------------
            for _, player in ipairs(rolePlayers) do
                local row = self.memberRows
                    and self.memberRows[rowIndex]

                if row then
                    row.player = player
                    row.isHeader = false

                    row.text:SetText(player.display)

                    local color =
                        GetClassColor(player.className)

                    row.text:SetTextColor(
                        color.r,
                        color.g,
                        color.b
                    )

                    row:Show()

                    rowIndex = rowIndex + 1
                end
            end
        end
    end

    -------------------------------------------------
    -- Hide unused rows
    -------------------------------------------------
    for i = rowIndex, MAX_MEMBER_ROWS do
        local row = self.memberRows
            and self.memberRows[i]

        if row then
            row.player = nil
            row.isHeader = false
            row.text:SetText("")
            row:Hide()
        end
    end

    -------------------------------------------------
    -- Summary counts
    -------------------------------------------------
    if self.countText then
        self.countText:SetText(
            "Tanks: " .. counts.Tank
            .. "  Healers: " .. counts.Healer
            .. "  Supports: " .. counts.Support
            .. "  DPS: " .. counts.DPS
        )
    end
end

function SageComp:Refresh()
    if not self.buttons then return end

    self:RefreshRoster()

    for _, button in ipairs(self.buttons) do
        local matches = FindMatches(button.buff)
        button.matches = matches
        button.configuredProviders = GetConfiguredProvidersForBuff(button.buff.key)

        if #matches > 0 then
            button.icon:SetDesaturated(false)
            button.icon:SetAlpha(1)
            button.status:SetVertexColor(0.1, 0.9, 0.35, 1)
        else
            button.icon:SetDesaturated(true)
            button.icon:SetAlpha(0.35)
            button.status:SetVertexColor(0.8, 0.1, 0.1, 1)
        end
    end
end

function SageComp:CreateFrame()
    EnsureDB()

    local frame = CreateFrame("Frame", "SageCompFrame", UIParent)
    frame:SetWidth(470)
    frame:SetHeight(620)
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); SaveFramePosition(self) end)

    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame)
    bg:SetTexture(0, 0, 0, 0.86)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -8)
    title:SetText("SageComp")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)

    local counts = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    counts:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -32)
    counts:SetText("Tanks: 0  Healers: 0  Supports: 0  DPS: 0")
    self.countText = counts

    local rosterTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rosterTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", FRAME_PADDING, -TOP_HEIGHT)
    rosterTitle:SetText("Members")

    local buffsTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    buffsTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", FRAME_PADDING + LEFT_WIDTH + 18, -TOP_HEIGHT)
    buffsTitle:SetText("Buffs / Debuffs")

--[[
    local minus = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    minus:SetWidth(22)
    minus:SetHeight(18)
    minus:SetText("-")
    minus:SetPoint("TOPLEFT", buffsTitle, "TOPRIGHT", 8, 2)
    minus:SetScript("OnClick", function() SetIconColumns((EnsureDB().iconColumns or DEFAULT_ICON_COLUMNS) - 1) end)

    local plus = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    plus:SetWidth(22)
    plus:SetHeight(18)
    plus:SetText("+")
    plus:SetPoint("LEFT", minus, "RIGHT", 3, 0)
    plus:SetScript("OnClick", function() SetIconColumns((EnsureDB().iconColumns or DEFAULT_ICON_COLUMNS) + 1) end)

    local columnText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    columnText:SetPoint("LEFT", plus, "RIGHT", 6, 0)
    columnText:SetText("Columns: " .. EnsureDB().iconColumns)
    self.columnText = columnText
]]

    local divider = frame:CreateTexture(nil, "OVERLAY")
    divider:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    divider:SetWidth(1)
    divider:SetVertexColor(0.45, 0.45, 0.45, 0.65)
    self.leftDivider = divider

    self.frame = frame
    self.buttons = {}
    self.buffButtonByKey = {}
    self.categoryHeaders = {}
    self.memberRows = {}

    for i = 1, MAX_MEMBER_ROWS do
        local row = CreateFrame("Button", nil, frame)
        row:SetWidth(LEFT_WIDTH)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", frame, "TOPLEFT", FRAME_PADDING, -TOP_HEIGHT - 22 - ((i - 1) * ROW_HEIGHT))
        row:RegisterForClicks("RightButtonUp")
        row:SetScript("OnClick", function(self, button)
            if button == "RightButton" then
                ShowSpecMenu(self)
            end
        end)
        row:SetScript("OnEnter", function(self)
            if self.player then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()
                GameTooltip:AddLine(self.player.name, 1, 1, 1)
                GameTooltip:AddLine("Right-click to assign specialization", 0.2, 1, 0.8)
                if self.player.specName and self.player.role then
                    GameTooltip:AddLine(self.player.className .. ":" .. self.player.specName .. " - " .. self.player.role, 1, 1, 1)
                elseif self.player.className then
                    GameTooltip:AddLine(self.player.className, 1, 1, 1)
                end
                GameTooltip:Show()
            end
        end)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.text:SetPoint("LEFT", row, "LEFT", 0, 0)
        row.text:SetJustifyH("LEFT")
        row.text:SetWidth(LEFT_WIDTH)
        row.text:SetText("")
        row:Hide()

        self.memberRows[i] = row
    end

    for _, category in ipairs(self.Categories or {}) do
        for _, buff in ipairs(category.buffs or {}) do
            local button = CreateFrame("Button", nil, frame)
            button:SetWidth(ICON_SIZE)
            button:SetHeight(ICON_SIZE)
            button.buff = buff

            button.icon = button:CreateTexture(nil, "ARTWORK")
            button.icon:SetAllPoints(button)
            button.icon:SetTexture(buff.icon)
--[[
            button.border = button:CreateTexture(nil, "OVERLAY")
            button.border:SetAllPoints(button)
            button.border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
]]
            button.status = button:CreateTexture(nil, "OVERLAY")
            button.status:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            button.status:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2, 2)
            button.status:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
            button.status:SetHeight(3)

            button:SetScript("OnEnter", ShowBuffTooltip)
            button:SetScript("OnLeave", function() GameTooltip:Hide() end)

            table.insert(self.buttons, button)
            self.buffButtonByKey[buff.key] = button
        end
    end

    self:LayoutBuffButtons()
    RestoreFramePosition(frame)
    self:Refresh()
end

local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
eventFrame:RegisterEvent("RAID_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local wasInRaid = false

local function IsCurrentlyInRaid()
    return GetNumRaidMembers and GetNumRaidMembers() > 0
end

local function UpdateRaidFrameVisibility()
    local isInRaid = IsCurrentlyInRaid()

    -- Joined a raid or converted party -> raid
    if isInRaid and not wasInRaid then
        SageComp:ShowUI()

    -- Left or disbanded raid
    elseif not isInRaid and wasInRaid then
        SageComp:HideUI()
    end

    wasInRaid = isInRaid
end

function SageComp:ShowUI()
    if not self.frame then
        self:CreateFrame()
    end

    self.frame:Show()

    if self.Refresh then
        self:Refresh()
    end
end

function SageComp:HideUI()
    if self.frame then
        self.frame:Hide()
    end
end

function SageComp:ToggleUI()
    if not self.frame then
        self:CreateFrame()
    end

    if self.frame:IsShown() then
        self:HideUI()
    else
        self:ShowUI()
    end
end

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON then
        EnsureDB()

    elseif event == "PLAYER_LOGIN" then
        SageComp:CreateFrame()

        -- Always default hidden on login/reload.
        SageComp.frame:Hide()

        -- Record initial state without opening the frame.
        -- This means reloading while already in a raid
        -- does NOT automatically show the frame.
        wasInRaid = IsCurrentlyInRaid()

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Keep the frame hidden by default when zoning/loading.
        -- Synchronize state so zoning does not count as "joining a raid".
        wasInRaid = IsCurrentlyInRaid()

        if SageComp.Refresh then
            SageComp:Refresh()
        end

    elseif event == "PARTY_MEMBERS_CHANGED"
        or event == "RAID_ROSTER_UPDATE" then

        UpdateRaidFrameVisibility()

        if SageComp.Refresh then
            SageComp:Refresh()
        end
    end
end)

SLASH_SAGECOMP1 = "/sagecomp"
SLASH_SAGECOMP2 = "/scmp"
SlashCmdList["SAGECOMP"] = function(msg)
    msg = msg or ""
    local command, rest = string.match(msg, "^(%S*)%s*(.-)$")
    command = Normalize(command)

    if command == "show" then
        SageComp:ShowUI()
    elseif command == "hide" then
        SageComp:HideUI()
    elseif command == "toggle" or command == "" then
        SageComp:ToggleUI()
    elseif command == "spec" then
        local name, spec = string.match(rest, "^(%S+)%s+(.+)$")
        local className, specName = SplitClassSpec(spec)
        if name and className and specName then
            SaveSpecOverride(name, className, specName)
        else
            Print("Usage: /sagecomp spec PlayerName ClassName:SpecName")
        end
    elseif command == "clearspec" then
        local name = string.match(rest, "^(%S+)$")
        if name then
            ClearSpecOverride(name)
        else
            Print("Usage: /sagecomp clearspec PlayerName")
        end
    elseif command == "cols" or command == "columns" then
        local count = tonumber(rest)
        if count then
            SetIconColumns(count)
            Print("Icon columns set to " .. EnsureDB().iconColumns)
        else
            Print("Usage: /sagecomp cols 2-8")
        end
    elseif command == "reset" then
        SageCompDB.point = { point="CENTER", relativePoint="CENTER", x=0, y=0 }
        RestoreFramePosition(SageComp.frame)
        Print("Frame position reset.")
    else
        Print("Commands: /sagecomp toggle, show, hide, reset")
        Print("Spec: /sagecomp spec PlayerName ClassName:SpecName")
        Print("Columns: /sagecomp cols 2-8")
    end
end
