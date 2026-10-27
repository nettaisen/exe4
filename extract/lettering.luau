--!strict
-- The Japanese ROMs' lettering (`ROCK_EXE4_RS`, B4WJ; `ROCK_EXE4_BM`, B4BJ): the pack's Japanese, beside the US ROMs'
-- English. The same code reaches each block as in the US ROMs (the HUD's and the custom screen's places), and both
-- Japanese ROMs have the same words: the pack has the Japanese Red Sun ROM's.

local hud = require("./hud")
local custom = require("./custom")

local lettering = {}

-- The pack's name for the Japanese ROMs' language.
lettering.LANGUAGE = "ja"

-- Whether two banners are one: their place, kind, glyphs and number's place.
local function same_banner(a: BannerLayout, b: BannerLayout): boolean
    local na, nb = a.number_at, b.number_at
    local numbers = if na == nil or nb == nil then na == nb else na[1] == nb[1] and na[2] == nb[2]
    return a.x == b.x and a.y == b.y and a.kind == b.kind and a.glyphs == b.glyphs and numbers
end

-- The HUD's Japanese words: its fonts, its text lines, its banners and "BUSY..." ("カスタム中…", seven tiles wide as
-- the US's), from the Japanese Red Sun ROM. A banner is kept where its words differ from the base's (`base`: the
-- pack's own, a US ROM's), each where it starts (a longer name further left); what has no words and is the pack's own
-- is the base's: the gauge's tiles ("CUSTOM" in every ROM) and the banners' palette. The Japanese games place the
-- chatbox's text themselves (code, `hud.CHATBOX_TEXT_JA`).
function lettering.hud(set: Set, base: Hud, names: AssetNames): HudLettering
    local rom = set.B4WJ
    local languages: { [string]: { glyphs: { string }?, dialogue_glyphs: { string }? } } = names.language_glyphs or {}
    local glyphs = languages[lettering.LANGUAGE]
    local cell: { string } = if glyphs and glyphs.glyphs then glyphs.glyphs else {}
    local dialogue: { string } = if glyphs and glyphs.dialogue_glyphs then glyphs.dialogue_glyphs else {}
    local font, font_chars = hud.font(rom, cell, dialogue)
    local dialogue_font = hud.dialogue_font(rom, cell, dialogue)
    local texts = hud.texts(rom)
    local own_banners = base.banners or {}
    local banners: { [number]: BannerLayout, n: number } = { n = #own_banners }
    for i, own in own_banners do
        local b = hud.banner(rom, i - 1)
        if not same_banner(b, own) then
            banners[i - 1] = b
        end
    end
    return {
        font = font,
        font_chars = font_chars,
        dialogue_font = dialogue_font,
        texts = texts,
        banners = banners,
        banner_palette = base.banner_palette,
        waiting = hud.waiting(rom),
        waiting_palette = base.waiting_palette,
        gauge_tiles = base.gauge_tiles,
        chatbox_text = hud.CHATBOX_TEXT_JA,
    }
end

-- What the Japanese ROMs show in words on the custom screen (the same routines' literals: 0x0801FDFE's and
-- 0x0801FE78's pictures, the load list's UNITE button): OK's two pictures and SHUFFLE's in Japanese, with their
-- palette, and the UNITE button's tiles ("uni son" in two rows), from the Japanese Red Sun ROM. The UNITE picture, the
-- SHUFFLE button's tiles and "FINAL TURN" have no words of a release's own: the pack's. `base` is the pack's own
-- screen, whose UNITE button's fill set (the window's) is kept in every language.
function lettering.custom(set: Set, base: CustomScreen): CustomLettering
    local rom = set.B4WJ
    local unite = custom.tiles(rom, custom.UNITE_TILES)
    for _, b in base.buttons or {} do
        local tiles = b.value.tiles
        if b.name == custom.SOUL_BUTTON and tiles ~= nil then
            unite = gba.join({ unite, tiles:sub(custom.UNITE_LABELED, custom.UNITE_CELLS) })
        end
    end
    local ok = custom.picture(rom, custom.OK)
    local ok_picked = custom.picture(rom, custom.OK_PICKED)
    local shuffle = custom.picture(rom, custom.SHUFFLE_PICTURE)
    return {
        pictures = { ok = ok, ok_picked = ok_picked },
        buttons = {
            { name = custom.SOUL_BUTTON, value = { tiles = unite } },
            { name = custom.REDEAL_BUTTON, value = { picture = shuffle } },
        },
    }
end

return lettering
