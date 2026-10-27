--!strict
-- The battle sprites and the portraits: the sprite list (EXE6's `SpritePointersList`; Red Sun US's 0x0802793C: per
-- category, a table of sprite archive entries, bit 31 LZ77 compressed). The four ROMs have the same sprites: the pack
-- has the Red Sun US ROM's.

local place = require("@exelib/extract/place")
local lists = require("@exelib/extract/sprites")

local sprites = {}

local SPRITE_LIST = place.pointer(0x0800_28BC, 0x0800_289C)
-- The categories of the sprite list with battle sprites (byte offsets 0x00..=0x14, as EXE5's and EXE6's) of its ten.
local BATTLE_CATEGORIES = 6
local CATEGORIES = 10
-- The portraits' category (the sprite list's byte offset 0x20: the mugshot table 0x08028038, which 0x080028F2 loads
-- from, EXE6's `mugshotSpritePtrs`).
local PORTRAITS = 0x20

-- The battle sprites of `rom`'s sprite list.
local function battle(rom: Rom): { Sheet }
    local categories = lists.categories(rom, place.at(rom, SPRITE_LIST), CATEGORIES)
    local out: { Sheet } = {}
    for k = 1, BATTLE_CATEGORIES do
        for index = 0, lists.slots(categories, k) - 1 do
            local sheet = lists.sheet(rom, rom:u32(categories[k] + 4 * index), (k - 1) * 4, index)
            if sheet ~= nil then
                table.insert(out, sheet)
            end
        end
    end
    return out
end

-- The portraits content names (the chatbox's speakers: a no-running message's `F4 00 n`, 0x0804F750), from `rom`.
local function portraits(rom: Rom, names: AssetNames): { Sheet }
    local table_at = rom:u32(place.at(rom, SPRITE_LIST) + PORTRAITS)
    local indexes: { number } = {}
    for index in ((names.sprites or {})[PORTRAITS] or {}) do
        table.insert(indexes, index)
    end
    table.sort(indexes)
    local out: { Sheet } = {}
    for _, index in indexes do
        local archive = sprite.archive(rom, rom:u32(table_at + 4 * index))
        local sheet = if archive ~= nil then sprite.portrait(archive, PORTRAITS, index) else nil
        if sheet ~= nil then
            table.insert(out, sheet)
        end
    end
    return out
end

-- The battle sprites and the named portraits, from `rom`.
function sprites.sprites(rom: Rom, names: AssetNames): { Sheet }
    local out = battle(rom)
    for _, sheet in portraits(rom, names) do
        table.insert(out, sheet)
    end
    return out
end

return sprites
