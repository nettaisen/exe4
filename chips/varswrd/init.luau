--!strict
-- VarSwrd (EXE4 chip 0x037; its record at 0x080197EC + 0x37 * 0x2C): the navi holds A and enters a direction sequence:
-- a quarter circle forward (down, down-forward, forward) gives LongSwrd, a half circle from back FtrSword, up-forward-
-- down WideSwrd, down-back-up-forward-down LifeSrd, and back, A+B, forward, A+B SonicBom; letting go of A, or 48 ticks,
-- gives a Sword: action 0x36 (0x080ED6BE, ./action). EXE4 has no flip: its one set of sequences, forward the right.
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local action = require("@self/action")
local ftrsword = require("./ftrsword").ftrsword
local lifesrd = require("./lifesrd").lifesrd
local sonicbom = require("./sonicbom").sonicbom
local sword_family = require("./sword")

local varswrd: Chip = {
    action = action.action {
        id = "varswrd/action",
        -- The sequences (0x080ED6FC, joypad words each ending in 0), each step the buttons held, A among them.
        sequences = {
            unturned = {
                { { a = true, down = true }, { a = true, right = true, down = true }, { a = true, right = true } },
                { { a = true, left = true }, { a = true, left = true, down = true }, { a = true, down = true }, { a = true, right = true, down = true }, { a = true, right = true } },
                { { a = true, up = true }, { a = true, right = true }, { a = true, down = true } },
                { { a = true, down = true }, { a = true, left = true }, { a = true, up = true }, { a = true, right = true }, { a = true, down = true } },
                { { a = true, left = true }, { a = true, b = true }, { a = true, right = true }, { a = true, b = true } },
            },
        },
        -- LongSwrd, FtrSword, WideSwrd, LifeSrd, SonicBom (0x080ED7DC: chips 0x32, 0x172, 0x31, 0x158, 0x173); a
        -- Sword (chip 0x30).
        picks = { sword_family.longswrd, ftrsword, sword_family.wideswrd, lifesrd, sonicbom },
        sword = sword_family.sword,
    },
    codes = { "C", "J", "V" },
    element = Element.null,
    family = Family.sword,
    class = ChipClass.standard,
    rarity = 3,
    mb = 60,
    damage = 150,
    counter = 40,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "sword_swing", swings = { "two_in_row", "three_in_row", "column_ahead", "two_columns_ahead", "ahead_within_a_row", "one_ahead" } },
}

return { varswrd = varswrd }
