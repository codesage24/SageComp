SageComp = SageComp or {}

SageComp.Providers = {
    ["Barbarian"] = {
        color = { r = 0.78, g = 0.31, b = 0.31 },
        specs = {
            ["Brutality"] = {
                role = "DPS",
                range = "Melee",
                provides = { "strength", "agility", "attackPower", "attackPower5", "concentration", "physicalDamage4", "bleedDamage30", "armorReduction" }
            },
            ["Headhunting"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "strength", "agility", "attackPower", "attackPower5", "critAll3", "concentration", "bleedDamage30", "healingReduction" }
            },
            ["Ancestry"] = {
                role = "Support",
                range = "Melee",
                provides = { "strength", "agility", "attackPower", "concentration", "armor", "heroism", "resReduction" }
            }
        }
    },
    ["Bloodmage"] = {
        color = { r = 0.70, g = 0.05, b = 0.10 },
        specs = {
            ["Sanguine"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stamina", "spellHaste3", "concentration", "bleedDamage30", "spellCrit3", "attackSpeedSlow" }
            },
            ["Accursed"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stamina", "spellHaste3", "critAll3", "concentration", "bleedDamage30", "healingReduction" }
            },
            ["Eternal"] = {
                role = "Tank",
                range = "Melee",
                provides = { "stamina", "attackPower5", "healingDone6", "concentration", "bleedDamage30", "attackSpeedSlow", "hitReduction3" }
            },
            ["Fleshweaver"] = {
                role = "Support",
                range = "Ranged",
                provides = { "stamina", "concentration", "armor", "heroism", "bleedDamage30" }
            },
        }
    },
    ["Chronomancer"] = {
        color = { r = 0.35, g = 0.65, b = 1.00 },
        specs = {
            ["Infinite"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "spirit", "manaCooldown", "damageAll3", "amplifyMagic", "dampenMagic", "spellDamage10", "spellHit3", "castSpeedSlow" }
            },
            ["Time"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "intellect", "spirit", "spellHaste3", "manaCooldown", "damageReduction3", "amplifyMagic", "dampenMagic" }
            },
            ["Artificer"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "spirit", "replenishment", "manaCooldown", "critAll3", "amplifyMagic", "dampenMagic", "attackSpeedSlow", "hitReduction3" }
            }
        }
    },
    ["Cultist"] = {
        color = { r = 0.45, g = 0.25, b = 0.65 },
        specs = {
            ["Godblade"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stats10", "intellect", "spirit", "shadow", "dampenMagic", "spellDamage10", "apReduction", "healingReduction" }
            },
            ["Corruption"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stats10", "intellect", "spirit", "spellPower", "spellHaste3", "shadow", "dampenMagic", "spellHit3", "hitReduction3" }
            },
            ["Dreadnought"] = {
                role = "Tank",
                range = "Melee",
                provides = { "stats10", "intellect", "spirit", "shadow", "dampenMagic", "apReduction", "attackSpeedSlow", "hitReduction3" }
            },
            ["Heretic"] = {
                role = "Healer",
                range = "Melee",
                provides = { "stats10", "intellect", "spirit", "replenishment", "shadow", "damageReduction3", "dampenMagic" }
            }
        }
    },
    ["Felsworn"] = {
        color = { r = 0.35, g = 0.90, b = 0.20 },
        specs = {
            ["Slaying"] = {
                role = "DPS",
                range = "Melee",
                provides = { "minorArmorStats", "attackPower", "meleeHaste10", "fire", "shadow", "armor", "armorReduction", "healingReduction", "castSpeedSlow", "damageDoneReduction" }
            },
            ["Infernal"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "minorArmorStats", "attackPower", "critAll3", "fire", "shadow", "spellDamage10", "spellHit3", "damageDoneReduction" }
            },
            ["Tyrant"] = {
                role = "Tank",
                range = "Melee",
                provides = { "minorArmorStats", "attackPower", "meleeHaste10", "damageAll3", "fire", "shadow", "raidDefensive", "physicalDamage4", "apReduction", "attackSpeedSlow", "damageDoneReduction" }
            }
        }
    },
    ["Guardian"] = {
        color = { r = 0.70, g = 0.85, b = 0.45 },
        specs = {
            ["Vanguard"] = {
                role = "Tank",
                range = "Melee",
                provides = { "strength", "nature", "damageReduction3", "armorReduction", "apReduction", "attackSpeedSlow" }
            },
            ["Inspiration"] = {
                role = "Support",
                range = "Melee",
                provides = { "strength", "nature", "armor", "heroism", "armorReduction", "resReduction" }
            },
            ["Gladiator"] = {
                role = "DPS",
                range = "Melee",
                provides = { "strength", "attackPower5", "nature", "physicalDamage4", "armorReduction", "healingReduction" }
            }
        }
    },
    ["Knight of Xoroth"] = {
        color = { r = 0.90, g = 0.35, b = 0.20 },
        specs = {
            ["War"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stamina", "strength", "intellect", "critAll3", "fire", "frost", "shadow", "arcane", "resourceReduction5", "physicalDamage4", "armorReduction", "healingReduction" }
            },
            ["Hellfire"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stamina", "strength", "attackPower5", "intellect", "damageAll3", "fire", "frost", "shadow", "arcane", "resourceReduction5", "spellCrit3", "castSpeedSlow" }
            },
            ["Defiance"] = {
                role = "Tank",
                range = "Melee",
                provides = { "stamina", "strength", "intellect", "fire", "frost", "shadow", "arcane", "resourceReduction5", "armorReduction", "spellDamage10", "apReduction", "attackSpeedSlow" }
            }
        }
    },
    ["Necromancer"] = {
        color = { r = 0.35, g = 0.80, b = 0.55 },
        specs = {
            ["Death"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stamina", "spellPower", "spellHaste3", "fire", "armorReduction", "spellDamage10", "apReduction", "attackSpeedSlow", "healingReduction" }
            },
            ["Rime"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stamina", "spellPower", "critAll3", "fire", "armorReduction", "spellCrit3", "apReduction", "attackSpeedSlow", "healingReduction" }
            },
            ["Animation"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stamina", "spellPower", "damageAll3", "fire", "armorReduction", "apReduction", "attackSpeedSlow", "healingReduction" }
            }
        }
    },
    ["Primalist"] = {
        color = { r = 0.45, g = 0.75, b = 0.30 },
        specs = {
            ["Wildwalker"] = {
                role = "DPS",
                range = "Melee",
                provides = { "minorArmorStats", "agility", "attackPower5", "spirit", "resAllSmall", "nature", "arcane", "physicalDamage4", "bleedDamage30" }
            },
            ["Geomancy"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "minorArmorStats", "agility", "spirit", "spellHaste3", "resAllSmall", "nature", "arcane", "spellCrit3", "spellHit3", "hitReduction3" }
            },
            ["Grovekeeper"] = {
                role = "Healer",
                range = "Melee",
                provides = { "minorArmorStats", "agility", "spirit", "resAllSmall", "nature", "arcane", "healingDone6", "armor", "heroism", "armorReduction" }
            },
            ["Mountain King"] = {
                role = "Tank",
                range = "Melee",
                provides = { "minorArmorStats", "agility", "spirit", "replenishment", "resAllSmall", "nature", "arcane", "physicalDamage4", "attackSpeedSlow", "hitReduction3" }
            }
        }
    },
    ["Pyromancer"] = {
        color = { r = 1.00, g = 0.35, b = 0.10 },
        specs = {
            ["Incineration"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "spirit", "manaCooldown", "critAll3", "fire", "arcane", "spellCrit3", "healingReduction" }
            },
            ["Flameweaving"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "intellect", "spirit", "manaCooldown", "replenishment", "fire", "arcane", "healingReduction" }
            },
            ["Draconic"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "spirit", "manaCooldown", "spellHaste3", "fire", "arcane", "spellHit3", "healingReduction" }
            }
        }
    },
    ["Ranger"] = {
        color = { r = 0.55, g = 0.80, b = 0.35 },
        specs = {
            ["Archery"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "minorArmorStats", "agility", "meleeHaste10", "nature", "physicalDamage4", "bleedDamage30", "hitReduction3" }
            },
            ["Brigand"] = {
                role = "DPS",
                range = "Melee",
                provides = { "minorArmorStats", "agility", "meleeHaste10", "nature", "hitReduction3", "healingReduction" }
            },
            ["Farstrider"] = {
                role = "Support",
                range = "Ranged",
                provides = { "minorArmorStats", "agility", "meleeHaste10", "nature", "armor", "heroism", "apReduction", "hitReduction3" }
            }
        }
    },
    ["Reaper"] = {
        color = { r = 0.60, g = 0.55, b = 0.75 },
        specs = {
            ["Harvest"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stamina", "strength", "critAll3", "resAllSmall", "apReduction", "hitReduction3", "healingReduction" }
            },
            ["Soul"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stamina", "strength", "resAllSmall", "spellDamage10", "attackSpeedSlow", "hitReduction3" }
            },
            ["Domination"] = {
                role = "Tank",
                range = "Melee",
                provides = { "stamina", "strength", "critAll3", "resAllSmall", "damageReduction3", "physicalDamage4", "attackSpeedSlow", "hitReduction3" }
            }
        }
    },
    ["Runemaster"] = {
        color = { r = 0.45, g = 0.70, b = 1.00 },
        specs = {
            ["Engravement"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stats10", "agility", "meleeHaste10", "replenishment", "manaCooldown", "fire", "nature", "arcane", "resourceReduction5", "amplifyMagic", "apReduction", "healingReduction" }
            },
            ["Glyphic"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stats10", "agility", "manaCooldown", "fire", "nature", "arcane", "resourceReduction5", "amplifyMagic", "spellDamage10", "healingReduction" }
            },
            ["Riftblade"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stats10", "agility", "replenishment", "manaCooldown", "damageAll3", "fire", "nature", "arcane", "resourceReduction5", "amplifyMagic", "healingReduction" }
            }
        }
    },
    ["Starcaller"] = {
        color = { r = 0.65, g = 0.55, b = 1.00 },
        specs = {
            ["Moon Guard"] = {
                role = "Tank",
                range = "Melee",
                provides = { "intellect", "manaCooldown", "arcane", "damageReduction3", "spellDamage10", "resReduction", "attackSpeedSlow", "hitReduction3" }
            },
            ["Sentinel"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "meleeHaste10", "intellect", "manaCooldown", "arcane", "spellDamage10", "resReduction" }
            },
            ["Moon Priest"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "intellect", "manaCooldown", "critAll3", "arcane", "resReduction" }
            },
            ["Warden"] = {
                role = "DPS",
                range = "Melee",
                provides = { "intellect", "manaCooldown", "critAll3", "arcane", "resReduction", "healingReduction" }
            }
        }
    },
    ["Stormbringer"] = {
        color = { r = 0.20, g = 0.80, b = 1.00 },
        specs = {
            ["Lightning"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "manaRegen", "critAll3", "resAllSmall", "nature", "concentration", "spellCrit3" }
            },
            ["Wind"] = {
                role = "Support",
                range = "Ranged",
                provides = { "intellect", "manaRegen", "resAllSmall", "nature", "concentration", "armor", "heroism" }
            },
            ["Maelstrom"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "manaRegen", "damageAll3", "resAllSmall", "nature", "concentration", "spellDamage10", "attackSpeedSlow" }
            }
        }
    },
    ["Sun Cleric"] = {
        color = { r = 1.00, g = 0.85, b = 0.25 },
        specs = {
            ["Piety"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "stats10", "attackPower", "spellPower", "manaRegen", "replenishment", "resourceReduction5", "spellHit3", "resReduction", "hitReduction3" }
            },
            ["Blessings"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "stats10", "attackPower", "spellPower", "spellHaste3", "manaRegen", "resourceReduction5", "resReduction" }
            },
            ["Valkyrie"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stats10", "attackPower", "spellPower", "manaRegen", "damageAll3", "resourceReduction5", "resReduction", "attackSpeedSlow" }
            },
            ["Seraphim"] = {
                role = "Tank",
                range = "Melee",
                provides = { "stats10", "attackPower", "spellPower", "manaRegen", "resourceReduction5", "healingDone6", "raidDefensive", "attackSpeedSlow", "hitReduction3", "damageDoneReduction" }
            }
        }
    },
    ["Templar"] = {
        color = { r = 0.95, g = 0.80, b = 0.45 },
        specs = {
            ["Zealot"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stats10", "agility", "meleeHaste10", "armorReduction" }
            },
            ["Oathkeeper"] = {
                role = "Tank",
                range = "Melee",
                provides = { "stats10", "agility", "attackPower5", "healingDone6", "raidDefensive", "hitReduction3", "castSpeedSlow" }
            },
            ["Crusader"] = {
                role = "DPS",
                range = "Melee",
                provides = { "stats10", "agility", "damageAll3", "apReduction" }
            }
        }
    },
    ["Tinker"] = {
        color = { r = 0.90, g = 0.60, b = 0.25 },
        specs = {
            ["Demolition"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "attackPower", "attackPower5", "manaRegen", "manaCooldown", "concentration", "amplifyMagic", "apReduction" }
            },
            ["Invention"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "attackPower", "spellHaste3", "manaRegen", "manaCooldown", "damageReduction3", "healingDone6", "concentration", "amplifyMagic" }
            },
            ["Mechanics"] = {
                role = "DPS",
                range = "Melee",
                provides = { "attackPower", "meleeHaste10", "manaRegen", "manaCooldown", "concentration", "amplifyMagic", "armorReduction" }
            }
        }
    },
    ["Venomancer"] = {
        color = { r = 0.35, g = 0.85, b = 0.25 },
        specs = {
            ["Rot"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "minorArmorStats", "agility", "spirit", "spellHaste3", "fire", "spellHit3", "healingReduction", "castSpeedSlow" }
            },
            ["Stalking"] = {
                role = "DPS",
                range = "Melee",
                provides = { "minorArmorStats", "agility", "spirit", "fire", "spellDamage10", "spellCrit3", "castSpeedSlow" }
            },
            ["Fortitude"] = {
                role = "Tank",
                range = "Melee",
                provides = { "minorArmorStats", "agility", "spirit", "fire", "damageReduction3", "attackSpeedSlow", "hitReduction3", "castSpeedSlow" }
            },
            ["Vizier"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "minorArmorStats", "agility", "spirit", "fire", "replenishment", "healingDone6", "castSpeedSlow" }
            }
        }
    },
    ["Witch Doctor"] = {
        color = { r = 0.55, g = 0.35, b = 0.80 },
        specs = {
            ["Voodoo"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "intellect", "spirit", "spellHaste3", "manaRegen", "damageAll3", "resAllSmall", "resourceReduction5", "resReduction", "attackSpeedSlow", "castSpeedSlow" }
            },
            ["Brewing"] = {
                role = "Healer",
                range = "Ranged",
                provides = { "intellect", "spirit", "spellHaste3", "manaRegen", "replenishment", "resAllSmall", "resourceReduction5", "resReduction", "apReduction", "castSpeedSlow" }
            },
            ["Shadowhunting"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "attackPower5", "meleeHaste10", "intellect", "spirit", "spellHaste3", "manaRegen", "resAllSmall", "resourceReduction5", "resReduction", "castSpeedSlow" }
            }
        }
    },
    ["Witch Hunter"] = {
        color = { r = 0.85, g = 0.45, b = 0.25 },
        specs = {
            ["Boltslinger"] = {
                role = "DPS",
                range = "Ranged",
                provides = { "minorArmorStats", "attackPower", "manaRegen", "critAll3", "shadow", "armorReduction", "healingReduction", "castSpeedSlow" }
            },
            ["Houndmaster"] = {
                role = "DPS",
                range = "Melee",
                provides = { "minorArmorStats", "attackPower", "attackPower5", "spellHaste3", "manaRegen", "shadow", "castSpeedSlow" }
            },
            ["Black Knight"] = {
                role = "Tank",
                range = "Melee",
                provides = { "minorArmorStats", "attackPower", "manaRegen", "replenishment", "shadow", "raidDefensive", "attackSpeedSlow", "castSpeedSlow" }
            },
            ["Inquisition"] = {
                role = "DPS",
                range = "Melee",
                provides = { "minorArmorStats", "attackPower", "meleeHaste10", "manaRegen", "shadow", "castSpeedSlow", "damageDoneReduction" }
            }
        }
    }
}

SageComp.Categories = {
    {
        name = "Physical Buffs",
        buffs = {
            { key="stats10",          name="10% Stats",                         icon="Interface\\Icons\\Spell_Nature_Regeneration", providers={} },
            { key="minorArmorStats",  name="Minor Armor and All Stats",         icon="Interface\\Icons\\Spell_Holy_WordFortitude", providers={} },
            { key="stamina",          name="Stamina",                           icon="Interface\\Icons\\Spell_Holy_WordFortitude", providers={} },
            { key="strength",         name="Strength",                          icon="Interface\\Icons\\Ability_Warrior_BattleShout", providers={} },
            { key="agility",          name="Agility",                           icon="Interface\\Icons\\Ability_Hunter_AspectOfTheMonkey", providers={} },
            { key="attackPower",      name="Attack Power",                      icon="Interface\\Icons\\Ability_Warrior_BattleShout", providers={} },
            { key="attackPower5",     name="5% Attack Power",                   icon="Interface\\Icons\\Ability_Warrior_RallyingCry", providers={} },
            { key="meleeHaste10",     name="10% Melee & Ranged Haste",          icon="Interface\\Icons\\Spell_Nature_BloodLust", providers={} },
        }
    },
    {
        name = "Caster Buffs",
        buffs = {
            { key="intellect",        name="Intellect",                         icon="Interface\\Icons\\Spell_Holy_ArcaneIntellect", providers={} },
            { key="spirit",           name="Spirit",                            icon="Interface\\Icons\\Spell_Holy_DivineSpirit", providers={} },
            { key="spellPower",       name="Spell Power",                       icon="Interface\\Icons\\Spell_Holy_MagicalSentry", providers={} },
            { key="spellHaste3",      name="3% Spell Haste",                    icon="Interface\\Icons\\Spell_Nature_Invisibilty", providers={} },
            { key="manaRegen",        name="Mana Regeneration",                 icon="Interface\\Icons\\Spell_Frost_ManaRecharge", providers={} },
            { key="replenishment",    name="Replenishment",                     icon="Interface\\Icons\\Spell_Holy_Rapture", providers={} },
            { key="manaCooldown",     name="Strong Mana Cooldown",              icon="Interface\\Icons\\Spell_Nature_Lightning", providers={} },
        }
    },
    {
        name = "Utility Buffs",
        buffs = {
            { key="critAll3",           name="3% Critical Strike (All)",          icon="Interface\\Icons\\Ability_Warrior_InnerRage", providers={} },
            { key="damageAll3",         name="3% Damage Done (All)",              icon="Interface\\Icons\\Ability_Warrior_BloodFrenzy", providers={} },
            { key="resAllSmall",        name="Small Resistances (All)",           icon="Interface\\Icons\\Spell_Nature_ResistNature", providers={} },
            { key="fire",               name="Fire",                              icon="Interface\\Icons\\Spell_Fire_FireArmor", providers={} },
            { key="frost",              name="Frost",                             icon="Interface\\Icons\\Spell_Frost_FrostArmor02", providers={} },
            { key="nature",             name="Nature",                            icon="Interface\\Icons\\Spell_Nature_NatureResistanceTotem", providers={} },
            { key="shadow",             name="Shadow",                            icon="Interface\\Icons\\Spell_Shadow_AntiShadow", providers={} },
            { key="arcane",             name="Arcane",                            icon="Interface\\Icons\\Spell_Holy_MindSooth", providers={} },
            { key="resourceReduction5", name="5% Resource Reduction",             icon="Interface\\Icons\\Spell_Holy_BorrowedTime", providers={} },
            { key="damageReduction3",   name="3% Damage Reduction (All)",         icon="Interface\\Icons\\Spell_Holy_PowerWordShield", providers={} },
            { key="healingDone6",       name="6% Healing Done",                   icon="Interface\\Icons\\Spell_Holy_GreaterHeal", providers={} },
            { key="concentration",      name="Concentration",                     icon="Interface\\Icons\\Spell_Holy_MindVision", providers={} },
            { key="amplifyMagic",       name="Amplify Magic",                     icon="Interface\\Icons\\Spell_Holy_FlashHeal", providers={} },
            { key="dampenMagic",        name="Dampen Magic",                      icon="Interface\\Icons\\Spell_Nature_AbolishMagic", providers={} },
            { key="armor",              name="Armor",                             icon="Interface\\Icons\\INV_Shield_06", providers={} },
            { key="raidDefensive",      name="Defensive Cooldown (Raid)",         icon="Interface\\Icons\\Spell_Holy_DevotionAura", providers={} },
            { key="heroism",            name="Heroism/Bloodlust",                 icon="Interface\\Icons\\Spell_Nature_BloodLust", providers={} },
        }
    },
    {
        name = "Physical Debuffs",
        buffs = {
            { key="physicalDamage4",  name="4% Physical Damage",  icon="Interface\\Icons\\Ability_Warrior_BloodFrenzy", providers={} },
            { key="bleedDamage30",    name="30% Bleed Damage",    icon="Interface\\Icons\\Ability_Gouge", providers={} },
            { key="armorReduction",   name="Armor Reduction",     icon="Interface\\Icons\\Ability_Warrior_Sunder", providers={} },
        }
    },
    {
        name = "Magic Debuffs",
        buffs = {
            { key="spellDamage10",          name="10% Spell Damage",                  icon="Interface\\Icons\\Spell_Shadow_ShadowWordPain", providers={} },
            { key="spellCrit3",             name="3% Spell Critical Strike Chance",   icon="Interface\\Icons\\Spell_Shadow_MindTwisting", providers={} },
            { key="spellHit3",              name="3% Spell Hit",                      icon="Interface\\Icons\\Spell_Arcane_StarFire", providers={} },
            { key="resReduction",           name="Resistance Reduction",              icon="Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", providers={} },
        }
    },
    {
        name = "Utility Debuffs",
        buffs = {
            { key="apReduction",            name="Attack Power Reduction",  icon="Interface\\Icons\\Ability_Warrior_WarCry", providers={} },
            { key="attackSpeedSlow",        name="Attack Speed Slow",       icon="Interface\\Icons\\Spell_Nature_Slow", providers={} },
            { key="hitReduction3",          name="3% Hit Reduction",        icon="Interface\\Icons\\Spell_Shadow_CurseOfMannoroth", providers={} },
            { key="healingReduction",       name="Healing Reduction",       icon="Interface\\Icons\\Ability_Warrior_SavageBlow", providers={} },
            { key="castSpeedSlow",          name="Cast Speed Slow",         icon="Interface\\Icons\\Spell_Frost_Stun", providers={} },
            { key="damageDoneReduction",    name="Damage Done Reduction",   icon="Interface\\Icons\\Spell_Shadow_PainfulAfflictions", providers={} },
        }
    },
}
