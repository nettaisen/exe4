--!strict
-- EXE4's sonic boom (attack object 0x58, 0x080D8878: EXE6's code, @exelib/swords/sonic_boom), EXE4's kind with EXE5's
-- look: the sword's slash (0c-14) on the ground, palette 9 going through, else by its element (0x080D8928), a slash
-- (row 7) hitting navis. AntiSwrd's counter throws it (chips/anti/sword).

local collision = require("../rules/collision")
local common = require("@exelib/swords/sonic_boom")
local sword_slash_sprite = asset.sprite("sword-slash")

local sonic_boom = {}

sonic_boom.kind = common.make_kind("sonic-boom", {
    sprite = sword_slash_sprite,
    z = 0,
    piercing_palette = 9,
    palettes = { null = 0, fire = 2, aqua = 5, elec = 4, wood = 8, drain = 0 },
    whole_byte = true,
    is = collision.slash,
    hits = collision.hits_navis,
})

return sonic_boom
