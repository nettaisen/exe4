--!strict
-- MagShok1, MagShok2 and MagShok3 (EXE4 chips 0x155 to 0x157; their records at 0x080197EC + n * 0x2C): the Program
-- Advances of three MagBolt1s, MagBolt2s or MagBolt3s of consecutive codes (the recipe table, the pointer list at
-- 0x080212B0). The magnets' action 0x59 (./magnet_bolt/action), its variant 3: MagBolt1's magnet (attachment row 0x23),
-- fields on the panel ahead and the two beside it, paralyzing (their parameters' first byte, 1), and the pull over
-- the other side's area (region 0x82 from side 0, 0x81 from side 1: 0x080EE148).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local magnet_bolt = require("./magnet_bolt/action")
local magbolts = require("./magnet_bolt")
local regions = require("@exelib/regions")

local function action(id: string): Action
    return magnet_bolt.action {
        id = id,
        rows = { 0, -1, 1 },
        paralyzes = true,
        pull = function(me: Object): Region
            return regions.area[1 - me.alliance]
        end,
    }
end

local magnet_shock_1: Chip = {
    action = action("magnet_shock_1/action"),
    codes = { "A", "B", "C", "*" },
    element = Element.elec,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 200,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 32, code_run = { chip = magbolts.magnet_bolt_1, count = 3 } } },
    auto_battle = { class = "into_reach", range = "ahead_in_row" },
}

local magnet_shock_2: Chip = {
    action = action("magnet_shock_2/action"),
    codes = { "A", "B", "C", "*" },
    element = Element.elec,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 250,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 33, code_run = { chip = magbolts.magnet_bolt_2, count = 3 } } },
    auto_battle = { class = "into_reach", range = "ahead_in_row" },
}

local magnet_shock_3: Chip = {
    action = action("magnet_shock_3/action"),
    codes = { "A", "B", "C", "*" },
    element = Element.elec,
    family = Family.program_advance,
    class = ChipClass.program_advance,
    rarity = 0,
    mb = 5,
    damage = 300,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true },
    program_advances = { { order = 34, code_run = { chip = magbolts.magnet_bolt_3, count = 3 } } },
    auto_battle = { class = "into_reach", range = "ahead_in_row" },
}

return { magnet_shock_1 = magnet_shock_1, magnet_shock_2 = magnet_shock_2, magnet_shock_3 = magnet_shock_3 }
