--!strict
-- BugCurse (EXE4 chip 0x12F, Blue Moon's): the dimming chips' variant 0x2A, a curse on the enemy navi's panel that
-- infects it with bugs: @exelib/bugcurse (its controller, effect object #0x56, 0x080E81C4; its curse, attack object
-- #0x80, 0x080DD39C) in EXE4's look: the curse's sheet and VDoll's curse's sound (0x141); what keeps it off the enemy
-- navi (0x080E8208: 0x206, invisible, submerged or flashing); its four bugs (0x080DD494: kinds 2, 3, 4 and 6, each as
-- the hit's byte 3 with 0xFF before it, 0x080DD516).
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local collision = require("../rules/collision")
local common = require("@exelib/bugcurse")
local bug_curse_sprite = asset.sprite("bug-curse")

local chip: Chip = {
    -- The version whose saves hold it (rules/folder; rules/builds' groups).
    version = Version.bluemoon,
    codes = { "C" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.giga,
    rarity = 4,
    mb = 73,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, library = true },
    dimming = common.make {
        controller_id = "bugcurse/controller",
        curse_id = "bugcurse/curse",
        sprite = bug_curse_sprite,
        sound = asset.sound("curse"),
        untouched = { invisible = true, submerged = true, flashing = true },
        bugs = { { bug = 0xFF, arg = 2 }, { bug = 0xFF, arg = 3 }, { bug = 0xFF, arg = 4 }, { bug = 0xFF, arg = 6 } },
        is = collision.breaking,
        hits = collision.hits_navis,
    },
    damage = 0,
    megaman = "dark",
    auto_battle = { class = "at_once" },
}

return { bugcurse = chip }
