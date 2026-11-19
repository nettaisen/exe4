--!strict
-- Counter1, Counter2 and Counter3 (EXE4 chips 0x03C to 0x03E; their records at 0x080197EC + n * 0x2C): the spawners'
-- action 0x20 (lib/spawners), its variant 0: a strike on the other side's navi wherever it is, if its counter window is
-- open (./strike).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local spawners = require("../lib/spawners")
local strike = require("@self/strike")

local counter_1: Chip = {
    action = spawners.action { id = "counter_1/action", spawn = strike.spawner },
    codes = { "F", "M", "T", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 14,
    damage = 70,
    counter = 50,
    lockout = 30,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "when_counterable" },
}

local counter_2: Chip = {
    action = spawners.action { id = "counter_2/action", spawn = strike.spawner },
    codes = { "B", "H", "L", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 28,
    damage = 110,
    counter = 50,
    lockout = 30,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "when_counterable" },
}

local counter_3: Chip = {
    action = spawners.action { id = "counter_3/action", spawn = strike.spawner },
    codes = { "A", "N", "V" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 42,
    damage = 150,
    counter = 50,
    lockout = 30,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "when_counterable" },
}

return { counter_1 = counter_1, counter_2 = counter_2, counter_3 = counter_3 }
