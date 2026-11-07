--!strict
-- Spreader (EXE4 chip 0x012; its record at 0x080197EC + 0x12 * 0x2C): the spreaders' action 0x1E (./spreader), its
-- variant 0: the gun (attachment row 0x0A) fires past the first tick, at height 0x10, bullet row 3 (its parameter
-- +0x10): a burst over the 3x3 around the first thing it finds.
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local attachment = require("../objects/attachment")
local bullet = require("../objects/bullet")
local regions = require("@exelib/regions")
local spreader = require("@self/spreader")
local pink_flash_sprite = asset.sprite("pink-flash")
local spreader_sprite = asset.sprite("spreader")

-- Its gun (attachment row 0x0A: 0c-19).
local GUN = attachment.look { sprite = spreader_sprite, palette = 0 }
-- Bullet row 3: a burst (effect row 0x27) over the 3x3 around the panel found; sound 0x8D.
local BURST = bullet.variant {
    region = regions.square,
    hit_mod = {},
    effect = new.effect { sprite = pink_flash_sprite, anim = 0, palette = 0, steps = 10 },
    sound = asset.sound("spreader"),
}

local chip: Chip = {
    action = spreader.action { id = "spreader/action", gun = GUN, delay = 1, z = 0x10, shot = BURST },
    codes = { "L", "M", "N", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 1,
    mb = 10,
    damage = 30,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "behind_target" },
}

return { spreader = chip }
