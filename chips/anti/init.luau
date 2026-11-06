--!strict
-- AntiFire, AntiWatr, AntiElec, AntiWood, AntiNavi, AntiDmg, AntiSwrd and AntiRecv (EXE4 chips 0x08C to 0x093; their
-- records at 0x080197EC + n * 0x2C): the dimming chips' action 0x0C, its variant 0x13 (0x080E514E): the trap chips'
-- controller (lib/traps) makes the chip its user's side's defensive chip. AntiFire to AntiWood (their parameter 0 to
-- 3) set a trap the other side's first hit of their element springs (lib/traps/anti_trap); the others (4 to 7) set
-- nothing but the record, which the other side's navi chip (AntiNavi), hit (AntiDmg), sword (AntiSwrd) or recovery
-- (AntiRecv) springs.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local anti_trap = require("../lib/traps/anti_trap")
local traps = require("../lib/traps")

local antifire: Chip = {
    codes = { "K" },
    element = "fire",
    family = "fire",
    class = "standard",
    rarity = 2,
    mb = 58,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook("fire"),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local antiwatr: Chip = {
    codes = { "D" },
    element = "aqua",
    family = "aqua",
    class = "standard",
    rarity = 2,
    mb = 54,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook("aqua"),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local antielec: Chip = {
    codes = { "H" },
    element = "elec",
    family = "elec",
    class = "standard",
    rarity = 2,
    mb = 59,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook("elec"),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local antiwood: Chip = {
    codes = { "M" },
    element = "wood",
    family = "wood",
    class = "standard",
    rarity = 2,
    mb = 55,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook("wood"),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local antinavi: Chip = {
    codes = { "J", "M", "T" },
    element = "null",
    family = "null",
    class = "standard",
    rarity = 3,
    mb = 44,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    trap = "anti_navi",
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

local antidmg: Chip = {
    codes = { "K", "M", "R" },
    element = "null",
    family = "null",
    class = "standard",
    rarity = 2,
    mb = 31,
    damage = 120,
    counter = 30,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    trap = "anti_damage",
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

local antiswrd: Chip = {
    codes = { "C", "I", "N", "*" },
    element = "null",
    family = "sword",
    class = "standard",
    rarity = 2,
    mb = 43,
    damage = 100,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    trap = "anti_sword",
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

local antirecv: Chip = {
    codes = { "B", "D", "G", "*" },
    element = "null",
    family = "null",
    class = "standard",
    rarity = 2,
    mb = 37,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    trap = "anti_recovery",
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

return {
    antifire = antifire,
    antiwatr = antiwatr,
    antielec = antielec,
    antiwood = antiwood,
    antinavi = antinavi,
    antidmg = antidmg,
    antiswrd = antiswrd,
    antirecv = antirecv,
}
