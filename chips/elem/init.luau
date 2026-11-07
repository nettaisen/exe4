--!strict
-- ElemFlar, ElemIce, ElemLeaf, ElemSand and ElemDark (EXE4 chips 0x019, 0x01A, 0x07E, 0x080 and 0x0D5; their records at
-- 0x080197EC + n * 0x2C): action 0x60 (./elem), its variants 0 to 4: three flames along the row for 60 ticks each,
-- five and paralyzing on the chip's panel (their parameters: 3 flames, 60 ticks; ElemDark's flames row 0x25 attacks,
-- its flags 8: `attack_480`). The variants' rows: the panel (0x080EE3EF), the flames' palette (0x080EE3EA) and, ElemDark's, the poison
-- its raging flames leave (0x080EE3F4).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local elem = require("@self/elem")

local COUNT, TICKS = 3, 60

local elemflar: Chip = {
    action = elem.action {
        id = "elemflar/action",
        rages_on = PanelType.lava,
        palette = 0,
        count = COUNT,
        ticks = TICKS,
    },
    codes = { "K", "N", "P" },
    element = Element.fire,
    family = Family.fire,
    class = ChipClass.standard,
    rarity = 2,
    mb = 24,
    damage = 100,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "three_in_row" },
}

local elemice: Chip = {
    action = elem.action {
        id = "elemice/action",
        rages_on = PanelType.ice,
        palette = 1,
        count = COUNT,
        ticks = TICKS,
    },
    codes = { "H", "Q", "V" },
    element = Element.aqua,
    family = Family.aqua,
    class = ChipClass.standard,
    rarity = 2,
    mb = 24,
    damage = 100,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "three_in_row" },
}

local elemleaf: Chip = {
    action = elem.action {
        id = "elemleaf/action",
        rages_on = PanelType.grass,
        palette = 2,
        count = COUNT,
        ticks = TICKS,
    },
    codes = { "C", "D", "I" },
    element = Element.wood,
    family = Family.wood,
    class = ChipClass.standard,
    rarity = 2,
    mb = 24,
    damage = 80,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "three_in_row" },
}

local elemsand: Chip = {
    action = elem.action {
        id = "elemsand/action",
        rages_on = PanelType.pitfall,
        palette = 3,
        count = COUNT,
        ticks = TICKS,
    },
    codes = { "A", "L", "S", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 24,
    damage = 120,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "three_in_row" },
}

local elemdark: Chip = {
    action = elem.action {
        id = "elemdark/action",
        rages_on = PanelType.poison,
        palette = 4,
        raging_leaves = PanelType.poison,
        count = COUNT,
        ticks = TICKS,
        attack_480 = true,
    },
    codes = { "E" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.mega,
    rarity = 3,
    mb = 38,
    damage = 220,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    megaman = "dark",
    auto_battle = { class = "into_reach", range = "three_in_row" },
}

return { elemflar = elemflar, elemice = elemice, elemleaf = elemleaf, elemsand = elemsand, elemdark = elemdark }
