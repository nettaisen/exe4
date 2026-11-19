--!strict
-- BstFang1, BstFang2 and BstFang3 (EXE4 chips 0x14F to 0x151; their records at 0x080197EC + n * 0x2C): the Program
-- Advances of three TwnFng1s, TwnFng2s or TwnFng3s of consecutive codes (the recipe table, the pointer list at
-- 0x080212B0). The twin fangs' action 0x34 (./twin_fang/action), its variant 1: eight pairs of fangs, 10 ticks apart,
-- their hits weak (the parameters' second byte, 1).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local twin_fang = require("./twin_fang/action")
local twnfngs = require("./twin_fang")

local beast_fang_1: Chip = {
    action = twin_fang.action("beast_fang_1/action", 8, true),
    codes = { "A", "B", "C", "*" },
    element = Element.null,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 50,
    counter = 5,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 26, code_run = { chip = twnfngs.twin_fang_1, count = 3 } } },
    auto_battle = { class = "spot_test", range = "a_row_off" },
}

local beast_fang_2: Chip = {
    action = twin_fang.action("beast_fang_2/action", 8, true),
    codes = { "A", "B", "C", "*" },
    element = Element.null,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 60,
    counter = 5,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 27, code_run = { chip = twnfngs.twin_fang_2, count = 3 } } },
    auto_battle = { class = "spot_test", range = "a_row_off" },
}

local beast_fang_3: Chip = {
    action = twin_fang.action("beast_fang_3/action", 8, true),
    codes = { "A", "B", "C", "*" },
    element = Element.null,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 70,
    counter = 5,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 28, code_run = { chip = twnfngs.twin_fang_3, count = 3 } } },
    auto_battle = { class = "spot_test", range = "a_row_off" },
}

return { beast_fang_1 = beast_fang_1, beast_fang_2 = beast_fang_2, beast_fang_3 = beast_fang_3 }
