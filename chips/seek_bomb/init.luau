--!strict
-- SeekBom1, SeekBom2 and SeekBom3 (EXE4 chips 0x0A0 to 0x0A2; their records at 0x080197EC + n * 0x2C): the throw,
-- action 0x09's variant 9: the navi holds a bomb (attachment row 0x2F, its animation 0: 0x080EB4EC) and
-- throws it (./bomb, 0x080DEEF2) at the other side's navi ahead, where it bursts. (Their parameter, 0 to 2, nothing
-- reads.)
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local attachment = require("../objects/attachment")
local bomb = require("@self/bomb")
local bombs = require("../lib/bombs")
local bomb_sprite = asset.sprite("bomb")

-- The bomb in hand (attachment row 0x2F: the bomb, 0c-02, in palette 7).
local HELD = attachment.look { sprite = bomb_sprite, palette = 7 }
local THROWER = bomb.thrower()

local function throw(id: string): Action
    return bombs.throw { id = id, held = HELD, thrower = THROWER }
end

local seek_bomb_1: Chip = {
    action = throw("seek_bomb_1/action"),
    codes = { "B", "R", "S", "*" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 1,
    mb = 25,
    damage = 80,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "at_once" },
}

local seek_bomb_2: Chip = {
    action = throw("seek_bomb_2/action"),
    codes = { "C", "I", "O" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 2,
    mb = 35,
    damage = 110,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "at_once" },
}

local seek_bomb_3: Chip = {
    action = throw("seek_bomb_3/action"),
    codes = { "M", "U", "W" },
    element = Element.null,
    family = Family.null,
    class = ChipClass.standard,
    rarity = 3,
    mb = 45,
    damage = 140,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "at_once" },
}

return { seek_bomb_1 = seek_bomb_1, seek_bomb_2 = seek_bomb_2, seek_bomb_3 = seek_bomb_3 }
