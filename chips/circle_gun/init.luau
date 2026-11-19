--!strict
-- CircGun1 to CircGun3: the circgun series, the dimming chips' variant 0x33: a gun sight circles the enemy's area
-- until A or 360 ticks, then leaves four shots on the panels it passes (./circle_gun: EXE4's CircGun on @exelib/circle_gun);
-- each chip its sight's period (its first parameter: 6, 4, 2), four shots in palette 0, thrown hits (each chip's own
-- comment above its definition).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local circle_gun = require("@self/circle_gun")
local collision = require("../rules/collision")

-- CircGun1 (EXE4 chip 0x042): a step every 7 ticks.
local circle_gun_1: Chip = {
    codes = { "H", "T", "Z" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 0,
    mb = 28,
    damage = 80,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = circle_gun.hook(circle_gun.variant { period = 6, shots = 4, palette = 0, hit = collision.thrown }),
    auto_battle = { class = "spot_test", range = "on_far_ring" },
}

-- CircGun2 (EXE4 chip 0x043): a step every 5 ticks.
local circle_gun_2: Chip = {
    codes = { "D", "G", "T" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 1,
    mb = 40,
    damage = 100,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = circle_gun.hook(circle_gun.variant { period = 4, shots = 4, palette = 0, hit = collision.thrown }),
    auto_battle = { class = "spot_test", range = "on_far_ring" },
}

-- CircGun3 (EXE4 chip 0x044): a step every 3 ticks.
local circle_gun_3: Chip = {
    codes = { "J", "M", "R" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 52,
    damage = 120,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = circle_gun.hook(circle_gun.variant { period = 2, shots = 4, palette = 0, hit = collision.thrown }),
    auto_battle = { class = "spot_test", range = "on_far_ring" },
}

return { circle_gun_1 = circle_gun_1, circle_gun_2 = circle_gun_2, circle_gun_3 = circle_gun_3 }
