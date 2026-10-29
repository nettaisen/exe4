--!strict
-- EXE4's extraction recipe (docs/design/extraction-recipes.md): how its pack's assets are extracted from a complete
-- Legacy Collection's four ROMs (its `roms`: Red Sun US, `MEGAMANBN4RS`; Blue Moon US, `MEGAMANBN4BM`; Red Sun Japan,
-- `ROCK_EXE4_RS`; Blue Moon Japan, `ROCK_EXE4_BM`). It reads the ROMs through the primitives
-- (content/nettai/extract.d.luau) and returns the asset model, which the host finishes. The game's root gives it as its
-- `extract` (init.luau), so it loads with the content.
--
-- The routines that read the blocks are EXE6's or EXE5's, the same or nearly (docs/design/exe4-map.md §3), or EXE4's
-- own (§14); the verification workspace's tools/exe5/bmap.py and tools/exe4/emap.py pair EXE4's routines with EXE6's
-- and EXE5's, and its tools/cross-rom find each block's pointer. What the four ROMs have alike (the battle sprites,
-- the backgrounds, the sound, the field, most of the HUD and the custom screen) is read from the Red Sun US ROM
-- (B4WE), Red Sun's base version; a version's own (its giga chips, its souls' faces) from its US ROM (versions.luau);
-- the Japanese words from the Japanese Red Sun ROM (lettering.luau). The e-Reader cards' pictures, which no ROM holds,
-- are the recipe's own (cards.luau).

local names = require("@self/names")
local versions = require("@self/versions")
local sprites = require("@self/sprites")
local hud = require("@self/hud")
local custom = require("@self/custom")
local lettering = require("@self/lettering")
local stage = require("@self/stage")

local recipe: Recipe = {
    -- Every ROM of a complete Legacy Collection, each required, in the order its places read an address by (a
    -- ROM's slot): Red Sun's US ROM, Blue Moon's, then their Japanese ones.
    roms = { "B4WE", "B4BE", "B4WJ", "B4BJ" },
    extract = function(set: Set): Extracted
        local n = names()
        local chip_versions = versions.chips()
        local rom = set.B4WE
        local battle_sprites = sprites.sprites(rom, n)
        local h = hud.hud(set, n, chip_versions)
        -- The US ROMs' words are English; the Japanese ROMs' lettering is the pack's Japanese.
        h.languages = { { name = lettering.LANGUAGE, value = lettering.hud(set, h, n) } }
        h.language = "en"
        local c = custom.custom(set, n, chip_versions)
        c.languages = { { name = lettering.LANGUAGE, value = lettering.custom(set, c) } }
        local backgrounds = stage.backgrounds(rom)
        local field = stage.field(rom)
        return {
            names = n,
            graphics = { sprites = battle_sprites, field = field, backgrounds = backgrounds, hud = h, custom = c },
            sound = { from = rom },
        }
    end,
}

return recipe
