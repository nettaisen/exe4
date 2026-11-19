--!strict
-- WhitWeb1, WhitWeb2 and WhitWeb3 (EXE4 chips 0x048 to 0x04A; their records at 0x080197EC + n * 0x2C): the spawners'
-- action 0x20 (lib/spawners), its variants 8 to 10 (0x080D4F20, 0x080D4F2A, 0x080D4F34: rows 1 to 3): webs over the
-- other side's panels of row 1, 2 or 3 (./web).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local spawners = require("../lib/spawners")
local web = require("@self/web")

local white_web_1: Chip = {
    action = spawners.action { id = "white_web_1/action", spawn = web.spawner(1) },
    codes = { "D", "L", "R", "*" },
    element = Element.wood,
    family = Family.wood,
    class = ChipClass.standard,
    rarity = 0,
    mb = 26,
    damage = 40,
    counter = 10,
    lockout = 30,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_then_column" },
}

local white_web_2: Chip = {
    action = spawners.action { id = "white_web_2/action", spawn = web.spawner(2) },
    codes = { "C", "E", "Y", "*" },
    element = Element.wood,
    family = Family.wood,
    class = ChipClass.standard,
    rarity = 1,
    mb = 36,
    damage = 40,
    counter = 10,
    lockout = 30,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_then_column" },
}

local white_web_3: Chip = {
    action = spawners.action { id = "white_web_3/action", spawn = web.spawner(3) },
    codes = { "K", "O", "V", "*" },
    element = Element.wood,
    family = Family.wood,
    class = ChipClass.standard,
    rarity = 2,
    mb = 46,
    damage = 40,
    counter = 10,
    lockout = 30,
    flags = { has_damage = true, standard_library = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_then_column" },
}

return { white_web_1 = white_web_1, white_web_2 = white_web_2, white_web_3 = white_web_3 }
