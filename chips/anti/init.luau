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

local anti_fire: Chip = {
    codes = { "K" },
    element = Element.fire,
    family = Family.fire,
    class = ChipClass.standard,
    rarity = 2,
    mb = 58,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook(PrimaryElement.fire),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local anti_water: Chip = {
    codes = { "D" },
    element = Element.aqua,
    family = Family.aqua,
    class = ChipClass.standard,
    rarity = 2,
    mb = 54,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook(PrimaryElement.aqua),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local anti_elec: Chip = {
    codes = { "H" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 2,
    mb = 59,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook(PrimaryElement.elec),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local anti_wood: Chip = {
    codes = { "M" },
    element = Element.wood,
    family = Family.wood,
    class = ChipClass.standard,
    rarity = 2,
    mb = 55,
    damage = 200,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    dimming = anti_trap.hook(PrimaryElement.wood),
    auto_battle = { class = "when_trap_free", element_trap = true },
}

local anti_navi: Chip = {
    codes = { "J", "M", "T" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 3,
    mb = 44,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    trap = TrapKind.anti_navi,
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

local anti_damage: Chip = {
    codes = { "K", "M", "R" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 31,
    damage = 120,
    counter = 30,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    trap = TrapKind.anti_damage,
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

local anti_sword: Chip = {
    codes = { "C", "I", "N", "*" },
    element = Element.null,
    family = Family.sword,
    class = ChipClass.standard,
    rarity = 2,
    mb = 43,
    damage = 100,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, standard_library = true, library = true },
    trap = TrapKind.anti_sword,
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

local anti_recovery: Chip = {
    codes = { "B", "D", "G", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 37,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    trap = TrapKind.anti_recovery,
    dimming = traps.hook(),
    auto_battle = { class = "when_trap_free" },
}

return {
    anti_fire = anti_fire,
    anti_water = anti_water,
    anti_elec = anti_elec,
    anti_wood = anti_wood,
    anti_navi = anti_navi,
    anti_damage = anti_damage,
    anti_sword = anti_sword,
    anti_recovery = anti_recovery,
}
