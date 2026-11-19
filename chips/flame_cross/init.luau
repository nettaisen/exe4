--!strict
-- FlmCros1, FlmCros2 and FlmCros3 (EXE4 chips 0x149 to 0x14B; their records at 0x080197EC + n * 0x2C): the Program
-- Advances of three FlmLine1s, FlmLine2s or FlmLine3s of consecutive codes (the recipe table, the pointer list at
-- 0x080212B0). The flame burners' action 0x22 (./flame_line/action), its variant 1: a cross of five flames around the
-- panel two ahead (0x080D00F8).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local flame_line = require("./flame_line/action")
local flmlines = require("./flame_line")

local flame_cross_1: Chip = {
    action = flame_line.action("flame_cross_1/action", flame_line.cross),
    codes = { "A", "B", "C", "*" },
    element = Element.fire,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 300,
    counter = 40,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 20, code_run = { chip = flmlines.flame_line_1, count = 3 } } },
    auto_battle = { class = "into_reach", range = "cross_two_ahead" },
}

local flame_cross_2: Chip = {
    action = flame_line.action("flame_cross_2/action", flame_line.cross),
    codes = { "A", "B", "C", "*" },
    element = Element.fire,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 400,
    counter = 40,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 21, code_run = { chip = flmlines.flame_line_2, count = 3 } } },
    auto_battle = { class = "into_reach", range = "cross_two_ahead" },
}

local flame_cross_3: Chip = {
    action = flame_line.action("flame_cross_3/action", flame_line.cross),
    codes = { "A", "B", "C", "*" },
    element = Element.fire,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 500,
    counter = 40,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 22, code_run = { chip = flmlines.flame_line_3, count = 3 } } },
    auto_battle = { class = "into_reach", range = "cross_two_ahead" },
}

return { flame_cross_1 = flame_cross_1, flame_cross_2 = flame_cross_2, flame_cross_3 = flame_cross_3 }
