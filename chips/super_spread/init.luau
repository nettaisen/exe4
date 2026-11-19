--!strict
-- SuprSpr1, SuprSpr2 and SuprSpr3 (EXE4 chips 0x146 to 0x148; their records at 0x080197EC + n * 0x2C): the Program
-- Advances of three WideSht1s, WideSht2s or WideSht3s of consecutive codes (the recipe table, the pointer list at
-- 0x080212B0). The wide shots' action 0x31 (./wide_shot/action), its variant 1: three waves. Each chip's wave is its
-- record's parameter: 6, 7, 8 (0x080D49E8: WideSht's three speeds), going through what they hit.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local wide_shot = require("./wide_shot/action")
local wideshts = require("./wide_shot")

local super_spread_1: Chip = {
    -- Its wave 6.
    action = wide_shot.action("super_spread_1/action", wide_shot.wave(0x6_0000, true), 3),
    codes = { "A", "B", "C", "*" },
    element = Element.aqua,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 60,
    counter = 10,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 17, code_run = { chip = wideshts.wide_shot_1, count = 3 } } },
    auto_battle = { class = "spot_test", range = "ahead_within_a_row" },
}

local super_spread_2: Chip = {
    -- Its wave 7.
    action = wide_shot.action("super_spread_2/action", wide_shot.wave(0x6_8000, true), 3),
    codes = { "A", "B", "C", "*" },
    element = Element.aqua,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 80,
    counter = 10,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 18, code_run = { chip = wideshts.wide_shot_2, count = 3 } } },
    auto_battle = { class = "spot_test", range = "ahead_within_a_row" },
}

local super_spread_3: Chip = {
    -- Its wave 8.
    action = wide_shot.action("super_spread_3/action", wide_shot.wave(0x7_0000, true), 3),
    codes = { "A", "B", "C", "*" },
    element = Element.aqua,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 100,
    counter = 10,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 19, code_run = { chip = wideshts.wide_shot_3, count = 3 } } },
    auto_battle = { class = "spot_test", range = "ahead_within_a_row" },
}

return { super_spread_1 = super_spread_1, super_spread_2 = super_spread_2, super_spread_3 = super_spread_3 }
