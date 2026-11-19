--!strict
-- GunSol1, GunSol2, GunSol3 and GunSolEX (EXE4 chips 0x020 to 0x022 and 0x0DB; their records at 0x080197EC + n * 0x2C):
-- EXE4's GunSol (./gun_del_sol, action 0x58, its variants 0 to 3): a sun beam that drains the column two panels ahead while
-- A is held, more in the sun, for 60, 90 or 120 ticks; GunSolEX's the column past it too, for 120.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local gun_del_sol = require("@self/gun_del_sol")
local regions = require("@exelib/regions")
local sun_beam_ex_sprite = asset.sprite("sun_beam_ex")
local sun_beam_sprite = asset.sprite("sun_beam")

-- GunSol1 to 3's beam (0x080E7130's first sprite) in the shade and in the sun, and GunSolEX's (its second).
local BEAM: SunBeamLook = { sprite = sun_beam_sprite, palette = 0 }
local BEAM_IN_SUN: SunBeamLook = { sprite = sun_beam_sprite, palette = 2 }
local WIDE_BEAM: SunBeamLook = { sprite = sun_beam_ex_sprite, palette = 0 }
local WIDE_BEAM_IN_SUN: SunBeamLook = { sprite = sun_beam_ex_sprite, palette = 3 }

local gun_del_sol_1: Chip = {
    action = gun_del_sol.action {
        id = "gun_del_sol_1/action",
        gun = gun_del_sol.gun(0),
        firing_ticks = 60,
        beam = BEAM,
        beam_in_sun = BEAM_IN_SUN,
        region = regions.wide,
        columns = 1,
    },
    codes = { "A", "G", "M", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 1,
    mb = 15,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { standard_library = true, library = true },
    megaman = "light",
    auto_battle = { class = "into_reach", range = "column_two_ahead" },
}

local gun_del_sol_2: Chip = {
    action = gun_del_sol.action {
        id = "gun_del_sol_2/action",
        gun = gun_del_sol.gun(3),
        firing_ticks = 90,
        beam = BEAM,
        beam_in_sun = BEAM_IN_SUN,
        region = regions.wide,
        columns = 1,
    },
    codes = { "B", "G", "S" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 25,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { standard_library = true, library = true },
    megaman = "light",
    auto_battle = { class = "into_reach", range = "column_two_ahead" },
}

local gun_del_sol_3: Chip = {
    action = gun_del_sol.action {
        id = "gun_del_sol_3/action",
        gun = gun_del_sol.gun(6),
        firing_ticks = 120,
        beam = BEAM,
        beam_in_sun = BEAM_IN_SUN,
        region = regions.wide,
        columns = 1,
    },
    codes = { "C", "G", "T" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 3,
    mb = 35,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { standard_library = true, library = true },
    megaman = "light",
    auto_battle = { class = "into_reach", range = "column_two_ahead" },
}

local gun_del_sol_ex: Chip = {
    action = gun_del_sol.action {
        id = "gun_del_sol_ex/action",
        gun = gun_del_sol.gun(9),
        firing_ticks = 120,
        beam = WIDE_BEAM,
        beam_in_sun = WIDE_BEAM_IN_SUN,
        region = regions.wide_long,
        columns = 2,
    },
    codes = { "G" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.mega,
    rarity = 4,
    mb = 80,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { library = true },
    megaman = "light",
    auto_battle = { class = "into_reach", range = "columns_two_and_three" },
}

return { gun_del_sol_1 = gun_del_sol_1, gun_del_sol_2 = gun_del_sol_2, gun_del_sol_3 = gun_del_sol_3, gun_del_sol_ex = gun_del_sol_ex }
