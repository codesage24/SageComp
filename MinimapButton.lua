local SC = _G.SageComp

SC.minimapButton = nil

local BUTTON_SIZE = 31
local DEFAULT_ANGLE = 225
local ICON = "Interface\\Icons\\INV_Misc_Map_01"

local minimapShapes = {
    ["ROUND"] = { true, true, true, true },
    ["SQUARE"] = { false, false, false, false },
    ["CORNER-TOPLEFT"] = { true, false, false, false },
    ["CORNER-TOPRIGHT"] = { false, false, true, false },
    ["CORNER-BOTTOMLEFT"] = { false, true, false, false },
    ["CORNER-BOTTOMRIGHT"] = { false, false, false, true },
    ["SIDE-LEFT"] = { true, true, false, false },
    ["SIDE-RIGHT"] = { false, false, true, true },
    ["SIDE-TOP"] = { true, false, true, false },
    ["SIDE-BOTTOM"] = { false, true, false, true },
    ["TRICORNER-TOPLEFT"] = { true, true, true, false },
    ["TRICORNER-TOPRIGHT"] = { true, false, true, true },
    ["TRICORNER-BOTTOMLEFT"] = { true, true, false, true },
    ["TRICORNER-BOTTOMRIGHT"] = { false, true, true, true },
}

local function Atan2(y, x)
    if math.atan2 then
        return math.atan2(y, x)
    end

    if x > 0 then
        return math.atan(y / x)
    elseif x < 0 and y >= 0 then
        return math.atan(y / x) + math.pi
    elseif x < 0 and y < 0 then
        return math.atan(y / x) - math.pi
    elseif x == 0 and y > 0 then
        return math.pi / 2
    elseif x == 0 and y < 0 then
        return -math.pi / 2
    end

    return 0
end

function SC:EnsureMinimapDB()
    self:EnsureDB()

    if not SageCompDB.minimap then
        SageCompDB.minimap = {}
    end

    if SageCompDB.minimap.minimapPos == nil then
        SageCompDB.minimap.minimapPos = DEFAULT_ANGLE
    end

    if SageCompDB.minimap.hide == nil then
        SageCompDB.minimap.hide = false
    end
end

function SC:GetMinimapDB()
    self:EnsureMinimapDB()
    return SageCompDB.minimap
end

function SC:UpdateMinimapButtonPosition()
    local button = self.minimapButton

    if not button then
        return
    end

    local db = self:GetMinimapDB()
    local angle = math.rad(db.minimapPos or DEFAULT_ANGLE)

    local x = math.cos(angle)
    local y = math.sin(angle)
    local q = 1

    if x < 0 then
        q = q + 1
    end

    if y > 0 then
        q = q + 2
    end

    local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
    local quadTable = minimapShapes[minimapShape] or minimapShapes["ROUND"]

    if quadTable[q] then
        x = x * 80
        y = y * 80
    else
        local diagRadius = 103.13708498985

        x = math.max(-80, math.min(x * diagRadius, 80))
        y = math.max(-80, math.min(y * diagRadius, 80))
    end

    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function SC:UpdateMinimapButtonFromCursor()
    local button = self.minimapButton

    if not button then
        return
    end

    local db = self:GetMinimapDB()

    local mx, my = Minimap:GetCenter()
    local px, py = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()

    px = px / scale
    py = py / scale

    db.minimapPos = math.deg(Atan2(py - my, px - mx)) % 360

    self:UpdateMinimapButtonPosition()
end

function SC:ShowMinimapButton()
    local button = self:CreateMinimapButton()

    self:GetMinimapDB().hide = false
    button:Show()
    self:UpdateMinimapButtonPosition()
end

function SC:HideMinimapButton()
    local button = self:CreateMinimapButton()

    self:GetMinimapDB().hide = true
    button:Hide()
end

function SC:ToggleMinimapButton()
    local button = self:CreateMinimapButton()

    if button:IsShown() then
        self:HideMinimapButton()
    else
        self:ShowMinimapButton()
    end
end

function SC:CreateMinimapButton()
    if self.minimapButton then
        return self.minimapButton
    end

    self:EnsureMinimapDB()

    local button = CreateFrame("Button", "SageCompMinimapButton", Minimap)
    button:SetFrameStrata("MEDIUM")
    button:SetWidth(BUTTON_SIZE)
    button:SetHeight(BUTTON_SIZE)
    button:SetFrameLevel(8)
    button:RegisterForClicks("AnyUp")
    button:RegisterForDrag("LeftButton")
    button:EnableMouse(true)

    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    -- This is the exact LibDBIcon-style border placement.
    -- Do not offset this border.
    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetWidth(53)
    overlay:SetHeight(53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")

    button.overlay = overlay

    -- This is the exact LibDBIcon-style icon placement.
    -- The icon sits inside the tracking border at TOPLEFT 7, -5.
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetWidth(20)
    icon:SetHeight(20)
    icon:SetTexture(ICON)
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 7, -5)

    button.icon = icon

    button:SetScript("OnMouseDown", function(self)
        self.icon:SetTexCoord(0, 1, 0, 1)
    end)

    button:SetScript("OnMouseUp", function(self)
        self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end)

    button:SetScript("OnClick", function(self, mouseButton)
        if mouseButton == "LeftButton" then
            SC:ToggleUI()
        elseif mouseButton == "RightButton" then
            print("|cff88ccffSageComp:|r Left-click to open. Drag to move. Type |cffffffff/scmp|r to open from chat.")
        end
    end)

    button:SetScript("OnEnter", function(self)
        if self.isMoving then
            return
        end

        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cff88ccffSage Comp|r")
        GameTooltip:AddLine("|cffffffffLeft-click:|r Open Comp Frame")
        GameTooltip:AddLine("|cffffffffDrag:|r Move button")
        GameTooltip:AddLine("|cffffffffRight-click:|r Help")
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    button:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self.icon:SetTexCoord(0, 1, 0, 1)
        self.isMoving = true
        GameTooltip:Hide()

        self:SetScript("OnUpdate", function()
            SC:UpdateMinimapButtonFromCursor()
        end)
    end)

    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        self:UnlockHighlight()
        self.isMoving = nil

        SC:UpdateMinimapButtonFromCursor()
    end)

    self.minimapButton = button

    self:UpdateMinimapButtonPosition()

    if SageCompDB.minimap.hide then
        button:Hide()
    else
        button:Show()
    end

    return button
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function()
    SC:CreateMinimapButton()
end)