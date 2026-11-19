--!strict
-- HolyDrem's shot (EXE4's attack object #0x83, 0x080DD9EC: @exelib/holy_dream/shot) in EXE4's look: sheet 0c-3e, the
-- energy burst's sound (0xBD) and collision rows 0x17 and 5, the plain spark; its spawn (0x080DDB14) takes its owner's
-- side alone.

local collision = require("../../rules/collision")
local common = require("@exelib/holy_dream/shot")
local sparks = require("../../lib/sparks")
local holy_dream_shot_sprite = asset.sprite("holy_dream_shot")

return common.make {
    id = "holy_dream/shot",
    sprite = holy_dream_shot_sprite,
    sound = asset.sound("energy_burst"),
    is = collision.thrown_piercing_break,
    hits = collision.hits_navis,
    spark = sparks.plain,
    side_only = true,
}
