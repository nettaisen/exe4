--!strict
-- MagBolt1, MagBolt2 and MagBolt3 (EXE4 chips 0x023 to 0x025; their records at 0x080197EC + n * 0x2C): the magnets'
-- action 0x59 (./action), its variants 0 to 2: the field on the panel ahead of the navi, the pull over the six panels
-- ahead (region 8), no paralysis (their parameters' first byte, 0).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local magnet_bolt = require("@self/action")
local regions = require("@exelib/regions")

local function action(id: string): Action
    return magnet_bolt.action {
        id = id,
        rows = { 0 },
        paralyzes = false,
        pull = function(_me: Object): Region
            return regions.row
        end,
    }
end

local magnet_bolt_1: Chip = {
    action = action("magnet_bolt_1/action"),
    codes = { "B", "C", "D", "*" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 0,
    mb = 18,
    damage = 90,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_in_row" },
}

local magnet_bolt_2: Chip = {
    action = action("magnet_bolt_2/action"),
    codes = { "E", "F", "G" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 1,
    mb = 28,
    damage = 110,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_in_row" },
}

local magnet_bolt_3: Chip = {
    action = action("magnet_bolt_3/action"),
    codes = { "A", "B", "C" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 2,
    mb = 38,
    damage = 130,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_in_row" },
}

return { magnet_bolt_1 = magnet_bolt_1, magnet_bolt_2 = magnet_bolt_2, magnet_bolt_3 = magnet_bolt_3 }
