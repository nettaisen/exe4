--!strict
-- The names EXE4's pack's assets are written under (docs/design/extraction-recipes.md §4.3), from compat: assets.toml
-- by number (the emotion window's faces by the number hud.luau gives them), a chip's icon and picture by its key in
-- chips.toml (`cannon`), what each glyph of the fonts draws (text.toml; the Japanese ROMs' encoding is the pack's
-- Japanese lettering's). What exe4-compat checks as it reads them is checked here, with its messages.

local names = require("@exelib/extract/names")

-- The language of the Japanese ROMs' words, as the pack names its lettering.
local JAPANESE = "ja"

return function(): AssetNames
    local assets = data("compat/assets.toml")
    local chips = data("compat/chips.toml")
    local text = data("compat/text.toml")
    -- (As exe4-compat says it: the later key first.)
    names.unique("chips.toml", chips, function(c: any): number
        return c.id
    end, function(earlier: string, later: string, n: number): string
        return string.format("chips.toml: %s and %s are both chip 0x%03x", later, earlier, n)
    end)
    local sprites = names.sprites(assets.sprites or {})
    local sounds: { [string]: number } = assets.sounds or {}
    names.unique("assets.toml: sounds", sounds, nil, function(earlier: string, later: string, n: number): string
        return string.format("assets.toml: sounds %s and %s are both 0x%03x", later, earlier, n)
    end)
    local jp = text.jp or {}
    if #text.glyphs > text.first_control or #(jp.glyphs or {}) > text.first_control then
        error(
            string.format("text.toml: more glyphs than the bytes below first_control (0x%02x)", text.first_control),
            0
        )
    end
    local chip_keys: { [number]: string } = {}
    for _, key in names.sorted(chips) do
        chip_keys[chips[key].id] = key
    end
    return {
        sprites = sprites,
        songs = names.by_number(sounds),
        backgrounds = names.by_number(assets.backgrounds or {}),
        banners = names.by_number(assets.banners or {}),
        mugshots = names.by_number(assets.mugshots or {}),
        chips = chip_keys,
        glyphs = text.glyphs,
        dialogue_glyphs = text.dialogue_glyphs or {},
        language_glyphs = { [JAPANESE] = { glyphs = jp.glyphs or {}, dialogue_glyphs = jp.dialogue_glyphs or {} } },
    }
end
