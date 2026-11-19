--!strict
-- BlakWing (EXE4 chip 0x0D6): the dimming chips' variant 0x29 (0x080E80CA): the shared BlakWing (@exelib/black_wing,
-- EXE5's code), EXE4's parts: perches over the enemy's columns and 18 wings falling down them, one every 12 ticks;
-- sheet 0C-42, the puff (effect row 21), the start's sound (0xAA) and the flap's (0x87, ShadeMan's call), its wings an
-- attack of type 0x480 hitting navis (row 0x25) with the plain spark; its perches each in its column's slot (columns 4
-- to 6, or 1 to 3, left to right: 0x080DD1BA), and as its controller ends the panel its user stands on becomes a hole
-- (0x080E80B6).
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local black_wing = require("@exelib/black_wing")
local collision = require("../rules/collision")
local rock = require("../lib/rock")
local sparks = require("../lib/sparks")
local black_wing_sprite = asset.sprite("black_wing")

local chip: Chip = {
    codes = { "W" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.mega,
    rarity = 3,
    mb = 58,
    damage = 20,
    counter = 5,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, library = true },
    dimming = black_wing.make {
        controller_id = "black_wing/controller",
        flock_id = "black_wing/flock",
        perch_id = "black_wing/perch",
        wing_id = "black_wing/wing",
        sprite = black_wing_sprite,
        puff = rock.effects.puff,
        sounds = { start = asset.sound("place"), flap = asset.sound("shade_call") },
        is = collision.attack_480,
        hits = collision.hits_navis,
        spark = sparks.plain,
        perches_by_column = true,
        ends_with = PanelType.hole,
    },
    megaman = "dark",
    auto_battle = { class = "into_reach", range = "ahead_then_column" },
}

return { black_wing = chip }
