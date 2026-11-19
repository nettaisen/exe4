--!strict
-- WideSht1, WideSht2 and WideSht3 (EXE4 chips 0x009 to 0x00B; their records at 0x080197EC + n * 0x2C): the wide shots'
-- action 0x31 (./action), its variant 0: one wave. Each chip's wave is its record's parameter: 3, 4, 5, each faster
-- (0x080D49E8), ending on its first hit.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local wide_shot = require("@self/action")

local wide_shot_1: Chip = {
    -- Its wave 3.
    action = wide_shot.action("wide_shot_1/action", wide_shot.wave(0x6_0000, false), 1),
    codes = { "C", "D", "E", "*" },
    element = Element.aqua,
    family = Family.aqua,
    class = ChipClass.standard,
    rarity = 0,
    mb = 10,
    damage = 60,
    counter = 10,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "spot_test", range = "ahead_within_a_row" },
}

local wide_shot_2: Chip = {
    -- Its wave 4.
    action = wide_shot.action("wide_shot_2/action", wide_shot.wave(0x6_8000, false), 1),
    codes = { "L", "M", "N" },
    element = Element.aqua,
    family = Family.aqua,
    class = ChipClass.standard,
    rarity = 1,
    mb = 30,
    damage = 80,
    counter = 10,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "spot_test", range = "ahead_within_a_row" },
}

local wide_shot_3: Chip = {
    -- Its wave 5.
    action = wide_shot.action("wide_shot_3/action", wide_shot.wave(0x7_0000, false), 1),
    codes = { "S", "T", "U" },
    element = Element.aqua,
    family = Family.aqua,
    class = ChipClass.standard,
    rarity = 2,
    mb = 50,
    damage = 100,
    counter = 10,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "spot_test", range = "ahead_within_a_row" },
}

return { wide_shot_1 = wide_shot_1, wide_shot_2 = wide_shot_2, wide_shot_3 = wide_shot_3 }
