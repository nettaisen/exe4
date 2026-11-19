--!strict
-- FlmLine1, FlmLine2 and FlmLine3 (EXE4 chips 0x00C to 0x00E; their records at 0x080197EC + n * 0x2C): the flame
-- burners' action 0x22 (./action), its variant 0: flames on the column two panels ahead, its level panel, then up, then
-- down (0x080D00D8).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local flame_line = require("@self/action")

local flame_line_1: Chip = {
    action = flame_line.action("flame_line_1/action", flame_line.column),
    codes = { "F", "G", "H", "*" },
    element = Element.fire,
    family = Family.fire,
    class = ChipClass.standard,
    rarity = 0,
    mb = 18,
    damage = 70,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "column_two_ahead" },
}

local flame_line_2: Chip = {
    action = flame_line.action("flame_line_2/action", flame_line.column),
    codes = { "D", "E", "F" },
    element = Element.fire,
    family = Family.fire,
    class = ChipClass.standard,
    rarity = 1,
    mb = 26,
    damage = 120,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "column_two_ahead" },
}

local flame_line_3: Chip = {
    action = flame_line.action("flame_line_3/action", flame_line.column),
    codes = { "J", "K", "L" },
    element = Element.fire,
    family = Family.fire,
    class = ChipClass.standard,
    rarity = 2,
    mb = 54,
    damage = 170,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "column_two_ahead" },
}

return { flame_line_1 = flame_line_1, flame_line_2 = flame_line_2, flame_line_3 = flame_line_3 }
