--!strict
-- TimeBom+ (EXE4 chip 0x15A): the Program Advance of three TimeBombs of consecutive codes (the recipe table, the
-- pointer list at 0x080212B0). TimeBomb's controller (./time_bomb/bomb, the dimming chips' variant 0x11) with the
-- bomb of its first parameter, 1: animations 2 and 3, 300 HP, its blast shaking the camera a second time, harder
-- (0x080D6E42).
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local bomb = require("./time_bomb/bomb")
local countdown = require("@exelib/time_bomb_plus/countdown")
local timebombs = require("./time_bomb")

local BIG_BOMB = countdown.variant {
    appear_anim = 2,
    idle_anim = 3,
    hp = 300,
    class = ObstacleClass.one_a_side,
    collision = bomb.body,
    strong_shake = true,
}

local time_bomb_plus: Chip = {
    codes = { "A", "B", "C", "*" },
    element = Element.null,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 600,
    counter = 40,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true },
    program_advances = { { order = 35, code_run = { chip = timebombs.time_bomb, count = 3 } } },
    dimming = bomb.controller.hook(BIG_BOMB),
    auto_battle = { class = "when_far_front_free" },
}

return { time_bomb_plus = time_bomb_plus }
