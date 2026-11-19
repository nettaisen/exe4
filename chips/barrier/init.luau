--!strict
-- Barrier, Barr100, Barr200, LifeAura and BlakBarr: the barrier series, the dimming chips' variant 0x15: the barrier
-- chips' controller (lib/barriers) raising each chip's barrier on its user (each chip's own comment above its
-- definition).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local barriers = require("../lib/barriers")

-- Barrier (EXE4 chip 0x087): a barrier of 10 HP (type 1).
local barrier: Chip = {
    codes = { "A", "D", "Z", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 1,
    mb = 7,
    damage = 0,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    dimming = barriers.controller.hook(barriers.barrier_10),
    megaman = "light",
    auto_battle = { class = "when_unbarriered" },
}

-- Barr100 (EXE4 chip 0x088): a barrier of 100 HP (type 2).
local barrier_100: Chip = {
    codes = { "P", "Q", "W" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 27,
    damage = 0,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    dimming = barriers.controller.hook(barriers.barrier_100),
    megaman = "light",
    auto_battle = { class = "when_unbarriered" },
}

-- Barr200 (EXE4 chip 0x089): a barrier of 200 HP (type 3).
local barrier_200: Chip = {
    codes = { "I", "O", "U" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 3,
    mb = 47,
    damage = 0,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, standard_library = true, library = true },
    dimming = barriers.controller.hook(barriers.barrier_200),
    megaman = "light",
    auto_battle = { class = "when_unbarriered" },
}

-- LifeAura (EXE4 chip 0x0C9): an aura that stops every hit of less than 200 for 3000 ticks (type 6).
local life_aura: Chip = {
    codes = { "D" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.mega,
    rarity = 4,
    mb = 70,
    damage = 0,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, library = true },
    dimming = barriers.controller.hook(barriers.life_aura),
    auto_battle = { class = "when_unbarriered" },
}

-- BlakBarr (EXE4 chip 0x134, Red Sun's): a barrier of 150 HP, back whole 180 ticks after it is worn down (type 4).
local black_barrier: Chip = {
    -- The version whose saves hold it (rules/folder; rules/builds' groups).
    version = Version.redsun,
    codes = { "A" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.giga,
    rarity = 4,
    mb = 87,
    damage = 40,
    counter = 0,
    lockout = 0,
    flags = { dimming = true, library = true },
    dimming = barriers.controller.hook(barriers.black_barrier),
    megaman = "dark",
    auto_battle = { class = "when_unbarriered" },
}

return { barrier = barrier, barrier_100 = barrier_100, barrier_200 = barrier_200, life_aura = life_aura, black_barrier = black_barrier }
