--!strict
-- TwnFng1, TwnFng2 and TwnFng3 (EXE4 chips 0x045 to 0x047; their records at 0x080197EC + n * 0x2C): the twin fangs'
-- action 0x34 (./action), its variant 0: one pair of fangs, their hits strong.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local twin_fang = require("@self/action")

local twin_fang_1: Chip = {
    action = twin_fang.action("twin_fang_1/action", 1, false),
    codes = { "A", "B", "C", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 0,
    mb = 13,
    damage = 70,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "spot_test", range = "a_row_off" },
}

local twin_fang_2: Chip = {
    action = twin_fang.action("twin_fang_2/action", 1, false),
    codes = { "O", "P", "Q" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 1,
    mb = 26,
    damage = 100,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "spot_test", range = "a_row_off" },
}

local twin_fang_3: Chip = {
    action = twin_fang.action("twin_fang_3/action", 1, false),
    codes = { "F", "G", "H" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 39,
    damage = 130,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "spot_test", range = "a_row_off" },
}

return { twin_fang_1 = twin_fang_1, twin_fang_2 = twin_fang_2, twin_fang_3 = twin_fang_3 }
