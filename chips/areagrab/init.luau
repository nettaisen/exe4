--!strict
-- AreaGrab (EXE4 chip 0x075; its record at 0x080197EC + 0x75 * 0x2C): a dimming chip (action 0x0C's variant 0, its
-- parameter 1) that drops grab shots on the other side's front column: lib/grab.

local grab = require("../lib/grab")

local chip: Chip = {
    codes = { "E", "M", "S", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 0,
    mb = 8,
    damage = 10,
    counter = 10,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    dimming = grab.area,
    auto_battle = { class = "at_once", answers = "area_lost" },
}

return { areagrab = chip }
