--!strict
-- Jealousy (EXE4 chip 0x0D4): the dimming chips' variant 0x1A, a hit on every panel the other side stands on once for
-- each chip the other side's navi holds, 10 ticks apart: EXE6's leftover controller (effect object #0x36, 0x080E5EF4:
-- @exelib/jealousy/controller) in EXE4's look: the chips counted (0x080E5FDC: the other side's local navi when that
-- side is the console's, `battle_networkInvert`, else the most any of its listed actors holds; in a netbattle each is
-- the other side's navi, its hand from the cursor, 0x080E6014), its hits' row 0x1A at navis with the heavy spark; no
-- operation battle.
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local collision = require("../rules/collision")
local controller = require("@exelib/jealousy/controller")
local sparks = require("../lib/sparks")
local chip_hand = require("@exelib/chip_hand")

-- 0x080E5FDC: the chips the other side's navi holds (none without one).
local function count(me: Object): number
    local navi = battle.player(battle.other_side(me.alliance))
    if not navi then
        return 0
    end
    return chip_hand.left(navi.alliance)
end

local chip: Chip = {
    codes = { "J" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.mega,
    rarity = 3,
    mb = 35,
    damage = 80,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, library = true },
    dimming = controller.make {
        id = "jealousy/controller",
        count = count,
        is = collision.collision_1a,
        hits = collision.hits_navis,
        spark = sparks.heavy,
    },
    auto_battle = { class = "at_once" },
}

return { jealousy = chip }
