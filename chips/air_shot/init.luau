--!strict
-- AirShot (EXE4 chip 0x004; its record at 0x080197EC + 4 * 0x2C): the chips' action 0x23 (lib/air_shot), its variant 0:
-- the air shooter (attachment row 9), the air shot (projectile row 4, its parameter +0x10), no recovery.
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local air_shot = require("../lib/air_shot")
local collision = require("../rules/collision")
local projectile = require("../objects/projectile")
local sparks = require("../lib/sparks")

-- The air shot (projectile row 4, action 0x23's: 0x080ECBEE, its parameter +0x10): it pushes (hit modifier 0x21;
-- EXE5's row 4 0x61), with the impact spark.
local SHOT = projectile.variant {
    id = "air_shot/shot",
    collision = { is = collision.pushing, hits = collision.hits_navis },
    hit_mod = { flinch = true, back = true },
    element = Element.null,
    spark = sparks.impact,
}

local chip: Chip = {
    codes = { "A", "S", "V", "*" },
    element = Element.null,
    family = Family.wind,
    class = ChipClass.standard,
    rarity = 1,
    mb = 6,
    damage = 20,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    action = air_shot.action { id = "air_shot/action", shooter = air_shot.shooter, shot = SHOT, recovery = 0 },
    auto_battle = { class = "past_obstacle" },
}

return { air_shot = chip }
