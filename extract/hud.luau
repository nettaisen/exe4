--!strict
-- The HUD's graphics: what EXE4's HUD tasks (0x08014D10's table at 0x08014D34, EXE6 `sub_801BF64`'s counterpart) draw
-- and copy to VRAM, read from those tasks and the routines that start them; with the fonts, the HUD's text lines and
-- the chips' icons. EXE4's HUD is laid out as EXE6's (the HUD layer's tiles from 0x130 in EXE6's order: the HP digits,
-- the box, the damage digits, '?', '+'; the gauge's from 0x80 in EXE6's order), its emotion window as EXE5's (a face
-- brings its box, a soul's face shows a count), and it has no link navis' faces.
--
-- Each block is stated by where the game's own pointer to it is in each of the four ROMs (a place: one address in both
-- versions' code of a release, but for the chatbox's and the dialogue font's); the routines that load them are named
-- by Red Sun US's addresses, and the blocks' addresses in the comments are Red Sun US's. What the four have alike is
-- the Red Sun US ROM's, the English words the same ROM's, a version's souls' faces a ROM's of that version. Every
-- palette drops each color's bit 15.

local place = require("@exelib/extract/place")
local colors = require("@exelib/extract/colors")
local texts = require("@exelib/extract/texts")
local glyphs = require("@exelib/extract/glyphs")
local chatbox = require("@exelib/extract/chatbox")
local versions = require("./versions")
local cards = require("./cards")

local band, rshift = bit32.band, bit32.rshift
local at = place.at
local pointer, pointer_in_each = place.pointer, place.pointer_in_each

local hud = {}

-- ---- Fonts and text lines --------------------------------------------------------------------------------------

-- The 8x16 font (0x40 bytes a glyph; what follows its glyphs is other data; Red Sun US's 0x0868DF5C), which the
-- chip's name is drawn with (0x08015078) in the HP box's palette. The US fonts draw the first 0x70; the Japanese fonts
-- their encoding's first page and the second page up to `FONT_GLYPHS`.
local FONT = pointer(0x0801_51F4, 0x0801_5190)
local FONT_GLYPHS = 0x1A0
-- The dialogue font (16x12 glyphs, 0x60 bytes each; 0x08694F5C) and its advances (a word a glyph; 0x080515E0): the
-- chatbox's literals, at an address of their own in each ROM.
local DIALOGUE_FONT = pointer_in_each({ 0x0803_1BEC, 0x0803_1BF0, 0x0803_1B00, 0x0803_1B04 })
local DIALOGUE_ADVANCES = pointer_in_each({ 0x0804_E294, 0x0804_E29C, 0x0804_E184, 0x0804_E18C })
local DIALOGUE_GLYPHS = 0x1C0
-- The HUD's text lines (EXE6 `TextScript86F0374`'s counterpart; 0x087491CC), which end in 0xE5 (EXE5's and EXE6's
-- 0xE6) or at text.toml's `first_control`.
local TEXTS = pointer(0x0801_543C, 0x0801_53D8)
local TEXT_END = 0xE5

-- A palette (the hardware ignores bit 15 of a color).
function hud.palette(rom: Rom, a: number): Palette
    return colors.masked(gba.palette(rom, a))
end

-- `rom`'s 8x16 font: the glyphs its release's encoding (`cell`, `dialogue`) names, no more than the font has, with
-- their characters.
function hud.font(rom: Rom, cell: { string }, dialogue: { string }): (Tiles, { string })
    local n = math.min(#cell + #dialogue, FONT_GLYPHS)
    return gba.tiles(rom, at(rom, FONT), 0x40 * n), glyphs.chars(cell, dialogue, n)
end

-- `rom`'s dialogue font, its glyphs drawing the encoding's characters.
function hud.dialogue_font(rom: Rom, cell: { string }, dialogue: { string }): DialogueFont
    local chars = glyphs.chars(cell, dialogue, DIALOGUE_GLYPHS)
    return font.dialogue(rom, at(rom, DIALOGUE_FONT), at(rom, DIALOGUE_ADVANCES), DIALOGUE_GLYPHS, 4, chars)
end

-- `rom`'s HUD text lines: a line with anything but glyphs in it (a text command) is cut there.
function hud.texts(rom: Rom): { { number } }
    local first_control: number = data("compat/text.toml").first_control
    return texts.lines(rom, at(rom, TEXTS), TEXT_END, first_control)
end

-- ---- The HUD ----------------------------------------------------------------------------------------------------

-- The battle's HUD load list (0x08015A0C, EXE6 `off_801ECB4`'s counterpart, which 0x080159F4 queues): the HUD layer's
-- tiles to tile 0x130 (the HP digits, the box's, the damage digits, '?', '+', ':'), then the 8x16 font's '×' (glyph
-- 0x41) and '2' (glyph 3) to tiles 0x162 and 0x164 (the doubled chip's "×2", 0x08015190).
local HUD_TILES = pointer(0x0801_5A18, 0x0801_5974)
local HUD_FIRST_TILE = 0x130
local TIMES_GLYPH = pointer(0x0801_5A30, 0x0801_598C)
local TWO_GLYPH = pointer(0x0801_5A3C, 0x0801_5998)
-- The gauge's tiles (0x08016824 and 0x08016842: to tile 0x80), its frame (0x08015F1C: 18x2 at column 6, row 0, with
-- "CUSTOM" over it) and the HP box (0x08015EFC: 6x2 where the HUD block's +7 and +8 put it). The gauge's tiles,
-- "CUSTOM" among them, are the same in the four ROMs.
local GAUGE_TILES = pointer(0x0801_686C, 0x0801_67C0)
local GAUGE_BYTES = 0x380
local GAUGE_FIRST_TILE = 0x80
local GAUGE_FRAME = pointer(0x0801_5F64, 0x0801_5EB8)
local HP_BOX = pointer(0x0801_5F18, 0x0801_5E6C)
-- Background palette 13, the HP box's, by color (normal, healing, hurt or low: 0x08014D98 copies + 0x20 a color); the
-- gauge's palette (9) is the first (0x08015F1C).
local HUD_PALETTES = pointer(0x0801_5A24, 0x0801_5980)
-- The opponent's HP digits (0x08014EB8: a pointer a digit, 0x08014F9C; one color, the digits of 0x08707580 on), a
-- sprite in palette 14, which the load list's first fills (0x08707800, to 0x03002800: EXE5's 0x086CBA48, EXE6's
-- `byte_86B7AC0`'s place).
local ENEMY_DIGITS = pointer(0x0801_4F9C, 0x0801_4F3C)
local ENEMY_PALETTE = pointer(0x0801_5A0C, 0x0801_5968)
-- The chip icons' sprite palette (the load list's to 0x03002780: EXE5's 0x0874AAF8's place) and the hidden chip's
-- icon (the load list's to sprite tile 0x35C).
local ICON_PALETTE = pointer(0x0801_5A84, 0x0801_59E0)
local HIDDEN_ICON = pointer(0x0801_5A9C, 0x0801_59F8)
-- The emotion window (0x08014B78): picture n < 5 (MegaMan's faces) at FACES + 0x180 n (the 32x16 face, then its 16x16
-- box), n >= 5 (the version's souls) at SOUL_FACES + 0x100 (n - 5), beside the count box showing c at COUNTS + 0x80
-- (5 - c); picture n's palette at FACE_PALETTES + 0x20 n (sprite palette 12), white while Full Synchro (3) blinks in.
-- MegaMan's five faces, the counts and the first five palettes are the same in the four ROMs; the souls' faces and
-- palettes are each version's own six (0x08014B78's literals).
local FACES = pointer(0x0801_4C54, 0x0801_4BF4)
local SOUL_FACES = pointer(0x0801_4C58, 0x0801_4BF8)
local COUNTS = pointer(0x0801_4CB4, 0x0801_4C54)
local FACE_PALETTES = pointer(0x0801_4C68, 0x0801_4C08)
-- The faces MegaMan has of his own (normal, angry, worried, Full Synchro, dark), and each version's souls.
local OWN_FACES = 5
local SOULS = 6
-- The highest count the window's box shows.
local COUNT_MAX = 5
-- "PAUSE" (0x080166BC's list, 0x080166D0, to sprite tile 0x360: a 32x16 sprite's eight tiles and an 8x16 one's two),
-- drawn by 0x0801554C at (100, 64) in palette 14.
local PAUSE = pointer(0x0801_66D0, 0x0801_6624)
-- The banners (0x0801617E: a pointer a banner, by its number, `BANNERS`): a record's halfword place (x, then y), its
-- kind byte, then 20 glyph pointers (no filler: EXE4 reads twenty), then a kind-1 banner's number place; the banner
-- font's digits (a pointer a digit, the tenth the blank: a zeroed block) and the banners' palette (to 0x030027A0,
-- sprite palette 11). 41 banners: EXE6's first fifteen in EXE6's places, then EXE4's navis' wins and deletions. The
-- records and their glyphs are each release's words; the digits and the palette are the same in the four ROMs.
local BANNERS = pointer(0x0801_6264, 0x0801_61B8)
local BANNER_DIGITS = pointer(0x0801_626C, 0x0801_61C0)
local BANNER_PALETTE = pointer(0x0801_6274, 0x0801_61C8)
local BANNER_COUNT = 41
-- "BUSY..." (7x2 tiles: 0x080166F0's list, 0x08016710, to tile 0xAC, with the banners' palette as background palette
-- 10), drawn by 0x08015624 at column 22, row 4 while the other player is still choosing; each release's words.
local WAITING = pointer(0x0801_6710, 0x0801_6664)
local WAITING_BYTES = 0x1C0
-- The warning marker (0x08008424, EXE6 `sub_800AE90`'s counterpart: a 16x16 sprite at sprite tile 0x360, its second
-- frame 4 tiles on, in palette 13): its two frames and its palette, which the objects that show it load (0x080E3FC8's
-- list).
local WARNING = pointer(0x0801_DE74, 0x0801_DDB4)
local WARNING_PALETTE = pointer(0x0802_0B24, 0x0802_0A64)
-- "PAUSE"'s place (0x0801554C: its 32x16 sprite at x 100, y 64), and the priority the HP numbers under objects are
-- drawn at (0x08014EB8's 0xE730: 1).
local PAUSE_AT = { 100, 64 }
local HP_NUMBER_PRIORITY = 1
-- The HUD's layer's priority: BG3's (the battle's video init's table at 0x08006AD4: BG3CNT 0x1F00, priority 0; the
-- custom screen's 0x1F08 too), over the HP numbers where the custom screen is.
local HUD_PRIORITY = 0
-- A message (0x08015FE8: "COUNTER HIT!", text line 14, rendered 14 glyphs wide by 0x080162CC): its map from column 8
-- of row 2, 14 columns wide.
local MESSAGE_AT = { 8, 2, 14 }
-- The telops (0x0801650C, which lays out the user's on the banner block and the other player's on the second block):
-- fifteen glyphs centered from x 0 on the user's console and from x 120 on the other's, at y 32; after the chip's
-- name the HUD layer's damage digits (TELOP_DIGITS' ten pointers, then a blank and '+') and the font's '×' and '2'
-- (0x08016680's list), in their own palette (to 0x030027A0, sprite palette 11, which the banners' shares).
local TELOP_PLACES = { { 0, 32 }, { 120, 32 } }
local TELOP_DIGITS = pointer(0x0801_6644, 0x0801_6598)
local TELOP_PALETTE = pointer(0x0801_6660, 0x0801_65B4)
-- Where the telops' sprite tiles go among the banners': a banner's glyphs from tile 0x360 (0x0801617E's transfers to
-- 0x06016C00, five 32x16 sprites drawn by 0x080151FC); a telop's name from 0x360 on the left and 0x384 on the right
-- (0x0801662A's 0x06016C00 and 0x06017080; 0x08015488 draws a telop from x 104 on from 0x360 + 36); the '×' and '2'
-- pieces into 0x380 to 0x383 (0x08016680's list, whichever telop); "PAUSE" loads the banners' palette, 0x08750E40,
-- into sprite palette 11 with its tiles (0x080166D0's list).
local TELOP_TILES: TelopTiles = {
    banner = 0x360,
    names = { 0x360, 0x384 },
    signs = 0x380,
    pause_loads_banner_palette = true,
}
-- The chatbox (0x0804E3B4, `chatbox_runScript`'s counterpart): the box's twenty tiles (to BG0's tile 0x2AC, which its
-- maps count from) and palette, the text's palette; the box's maps (0x0804E384: a kind's four opening steps, 30x8
-- entries each: EXE4 shows a chip's description in the message box, the table's second kind being no maps); the
-- key-wait arrow's three 16x16 frames.
local CHATBOX: ChatboxPlaces = {
    tiles = pointer_in_each({ 0x0804_E484, 0x0804_E48C, 0x0804_E374, 0x0804_E37C }),
    tile_count = 20,
    first_tile = 0x2AC,
    palette = pointer_in_each({ 0x0804_E490, 0x0804_E498, 0x0804_E380, 0x0804_E388 }),
    text_palette = pointer_in_each({ 0x0804_E498, 0x0804_E4A0, 0x0804_E388, 0x0804_E390 }),
    boxes = pointer_in_each({ 0x0804_E37C, 0x0804_E384, 0x0804_E26C, 0x0804_E274 }),
    kinds = 1,
    arrow = pointer_in_each({ 0x0804_E5C8, 0x0804_E5D0, 0x0804_E4B8, 0x0804_E4C0 }),
    masked = true,
}
-- Where the chatbox's text starts (0x0804E3B4's +0x18, +0x19: 0x3F, 0x6D; EXE6's 0x33, 0x6C). The portrait's place is
-- EXE6's.
local CHATBOX_TEXT = { 0x3F, 0x6D }
-- The Japanese games' (Red Sun Japan's 0x0804E2A4, the same routine: 0x33, 0x6C, EXE6's place; the US games moved it
-- twelve pixels right and one down). Its arrow's place is the same.
hud.CHATBOX_TEXT_JA = { 0x33, 0x6C }
-- The key-wait arrow's place (0x0804E3B4's +0x1A, +0x1B), EXE6's message box's.
local CHATBOX_ARROW_AT = { 0xE2, 0x8D }
-- The damage judge's banner (number 0x28, which 0x080163EE shows as it turns on the HUD's element 0x200: 0x080152EA
-- draws "VS" at column 14, row 5, the one side's damage in columns 9 to 12 and the other's from column 17, as EXE6's
-- `sub_801D048` does): the judge's layout, which adds the two numbers (kind 4). Its record's own kind byte, 2 (held
-- until removed), says nothing of them.
local JUDGE_BANNER = 0x28 // 4
local JUDGE_KIND = 4

-- The chip records (0x2C bytes: +0x20 the icon, +0x24 the picture, +0x28 its palette; the chip accessor's literal, Red
-- Sun US's table 0x080197EC).
hud.CHIPS = pointer(0x0801_90DC, 0x0801_901C)
-- A chip's icon's bytes (2x2 tiles).
local ICON_BYTES = 0x80

-- Banner `id` (the banner block's number / 4) of `rom`, in its release's words.
function hud.banner(rom: Rom, id: number): BannerLayout
    local p = rom:u32(at(rom, BANNERS) + 4 * id)
    local xy = rom:u16(p)
    local kind = if id == JUDGE_BANNER then JUDGE_KIND else rom:u8(p + 2)
    local glyphs: { Tiles } = {}
    for g = 0, 19 do
        table.insert(glyphs, gba.tiles(rom, rom:u32(p + 4 + 4 * g), 0x40))
    end
    local number_at: { number }? = nil
    if kind == 1 then
        local n = rom:u16(p + 4 + 4 * 20)
        number_at = { band(n, 0xFF), rshift(n, 8) }
    end
    return { x = band(xy, 0xFF), y = rshift(xy, 8), kind = kind, glyphs = gba.join(glyphs), number_at = number_at }
end

-- "BUSY..." in `rom`'s release's words.
function hud.waiting(rom: Rom): Tiles
    return gba.tiles(rom, at(rom, WAITING), WAITING_BYTES)
end

-- The banner font's digits (a pointer a glyph), and the blank as glyph 10.
local function banner_digits(rom: Rom): Tiles
    local table_at = at(rom, BANNER_DIGITS)
    local glyphs: { Tiles } = {}
    for d = 0, 10 do
        table.insert(glyphs, gba.tiles(rom, rom:u32(table_at + 4 * d), 0x40))
    end
    return gba.join(glyphs)
end

-- An emotion-window face of `rom` (4x2 tiles) with its palette, and the box it brings (2x2; none for a soul's, which
-- shows a count).
local function face(rom: Rom, picture: number): ({ any }, Tiles)
    local palette = hud.palette(rom, at(rom, FACE_PALETTES) + 0x20 * picture)
    if picture < OWN_FACES then
        local a = at(rom, FACES) + 0x180 * picture
        return { gba.tiles(rom, a, 0x100), palette }, gba.tiles(rom, a + 0x100, 0x80)
    end
    return { gba.tiles(rom, at(rom, SOUL_FACES) + 0x100 * (picture - OWN_FACES), 0x100), palette }, gba.join({})
end

-- The emotion window's faces, as compat/assets.toml numbers them (its [mugshots]): MegaMan's five and Red Sun's souls
-- in their own palettes (the face table's eleven pictures), then Blue Moon's souls; each with the box it brings
-- (`mugshot_boxes`). MegaMan's are the Red Sun US ROM's, a version's souls' its US ROM's.
local function mugshots(set: Set): ({ { any } }, { Tiles })
    local faces: { { any } } = {}
    local boxes: { Tiles } = {}
    local function add(rom: Rom, first: number, last: number)
        for picture = first, last do
            local f, b = face(rom, picture)
            table.insert(faces, f)
            table.insert(boxes, b)
        end
    end
    add(set.B4WE, 0, OWN_FACES - 1)
    add(versions.rom(set, versions.RED_SUN), OWN_FACES, OWN_FACES + SOULS - 1)
    add(versions.rom(set, versions.BLUE_MOON), OWN_FACES, OWN_FACES + SOULS - 1)
    return faces, boxes
end

-- The telops' look (`TELOP_PLACES`): the digits and '+' by the telop's table (its eleventh pointer the blank, which it
-- draws nothing of), the font's '×' and '2'. Where and how they are laid out is the game's code.
local function telop(rom: Rom): TelopLook
    local glyphs: { Tiles } = {}
    for _, d in { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11 } do
        table.insert(glyphs, gba.tiles(rom, rom:u32(at(rom, TELOP_DIGITS) + 4 * d), 0x40))
    end
    table.insert(glyphs, gba.tiles(rom, at(rom, TIMES_GLYPH), 0x40))
    table.insert(glyphs, gba.tiles(rom, at(rom, TWO_GLYPH), 0x40))
    return {
        places = TELOP_PLACES,
        glyphs = gba.join(glyphs),
        palette = hud.palette(rom, at(rom, TELOP_PALETTE)),
        tiles = TELOP_TILES,
    }
end

-- The chips' numbers compat names, in order.
function hud.chip_ids(names: AssetNames): { number }
    local ids: { number } = {}
    for id in (names.chips or {}) do
        table.insert(ids, id)
    end
    table.sort(ids)
    return ids
end

-- The named chips' icons, each under its chip's key, from a ROM of the chip's version (versions.luau's
-- `chip_source`); an e-Reader card's chip's after chip 0x136's (cards.luau). None where its record has none in the
-- ROM.
local function chip_icons(
    set: Set,
    names: AssetNames,
    chip_versions: { [number]: string }
): { { key: string, tiles: Tiles? } }
    local keys = names.chips or {}
    local out: { { key: string, tiles: Tiles? } } = {}
    for _, id in hud.chip_ids(names) do
        local rom = versions.chip_source(set, chip_versions, id)
        local chips_at = at(rom, hud.CHIPS)
        local icon: Tiles? = nil
        if cards.has(id) then
            icon = cards.icon(rom, chips_at, id)
        else
            local p = rom:u32(chips_at + 0x2C * id + 0x20)
            icon = if rom:holds(p) then gba.tiles(rom, p, ICON_BYTES) else nil
        end
        local entry: { key: string, tiles: Tiles? } = { key = keys[id], tiles = icon }
        table.insert(out, entry)
    end
    return out
end

-- `h` with what the four ROMs have alike, read from `rom`.
local function drawn(rom: Rom, h: Hud)
    local hud_tiles = gba.join({
        gba.tiles(rom, at(rom, HUD_TILES), 0x640),
        gba.tiles(rom, at(rom, TIMES_GLYPH), 0x40),
        gba.tiles(rom, at(rom, TWO_GLYPH), 0x40),
    })
    -- "PAUSE" as five glyphs: the first four are the 32x16 sprite's columns (its tiles go row by row), the fifth the
    -- 8x16 sprite.
    local pause = gba.tiles(rom, at(rom, PAUSE), 0x140):pick({ 0, 4, 1, 5, 2, 6, 3, 7, 8, 9 })
    -- (The pointer is the first of a digit's each: the digits follow one another from it.)
    local digits = gba.tiles(rom, at(rom, ENEMY_DIGITS), 0x40 * 10)
    local banner_palette = hud.palette(rom, at(rom, BANNER_PALETTE))
    h.tiles = hud_tiles
    h.first_tile = HUD_FIRST_TILE
    h.gauge_tiles = gba.tiles(rom, at(rom, GAUGE_TILES), GAUGE_BYTES)
    h.gauge_first_tile = GAUGE_FIRST_TILE
    local hp_palettes: { Palette } = {}
    for i = 0, 2 do
        table.insert(hp_palettes, hud.palette(rom, at(rom, HUD_PALETTES) + 0x20 * i))
    end
    h.hp_palettes = hp_palettes
    h.gauge_palette = hud.palette(rom, at(rom, HUD_PALETTES))
    h.hp_box = gba.map(rom, at(rom, HP_BOX), 12)
    h.gauge_frame = gba.map(rom, at(rom, GAUGE_FRAME), 36)
    -- (One color: EXE4's numbers don't change color as HP drops or rises.)
    h.enemy_digits = { digits, digits, digits }
    h.enemy_palette = hud.palette(rom, at(rom, ENEMY_PALETTE))
    h.hidden_icon = gba.tiles(rom, at(rom, HIDDEN_ICON), 0x80)
    h.icon_palette = hud.palette(rom, at(rom, ICON_PALETTE))
    -- The count boxes: 0..=5. (EXE4 has no box without a count, `count_box`: its faces bring their own; and no link
    -- navis.)
    local counts: { Tiles } = {}
    for c = 0, COUNT_MAX do
        table.insert(counts, gba.tiles(rom, at(rom, COUNTS) + 0x80 * (COUNT_MAX - c), 0x80))
    end
    h.counts = counts
    h.pause = pause
    h.banner_digits = banner_digits(rom)
    h.banner_palette = banner_palette
    h.waiting_palette = banner_palette
    h.warning = gba.tiles(rom, at(rom, WARNING), 0x100)
    h.warning_palette = hud.palette(rom, at(rom, WARNING_PALETTE))
    -- (The message box's four steps, for both kinds: EXE4's description box is it.)
    local box = chatbox.of(rom, CHATBOX)
    local message = (box.boxes :: { { Map } })[1]
    box.boxes = { message, message }
    h.chatbox = box
end

-- `h` with the words of `rom`'s release (a US ROM's: the pack's own language is English, and the Japanese ROMs' words
-- are lettering.luau's).
local function worded(rom: Rom, names: AssetNames, h: Hud)
    local cell, dialogue = names.glyphs or {}, names.dialogue_glyphs or {}
    h.font, h.font_chars = hud.font(rom, cell, dialogue)
    h.dialogue_font = hud.dialogue_font(rom, cell, dialogue)
    h.texts = hud.texts(rom)
    local banners: { BannerLayout } = {}
    for id = 0, BANNER_COUNT - 1 do
        table.insert(banners, hud.banner(rom, id))
    end
    h.banners = banners
    h.waiting = hud.waiting(rom)
end

-- The HUD's graphics; `names` gives the chip icons their chips' keys and the fonts their characters, `chip_versions`
-- the version chips' versions (versions.luau). What the four ROMs have alike is the Red Sun US ROM's (`drawn`), the
-- English words the same ROM's (`worded`), a version's souls' faces and own chips' icons a ROM's of that version.
function hud.hud(set: Set, names: AssetNames, chip_versions: { [number]: string }): Hud
    local h: Hud = {}
    h.chip_icons = chip_icons(set, names, chip_versions)
    h.mugshots, h.mugshot_boxes = mugshots(set)
    local rom = set.B4WE
    h.layout = {
        pause = PAUSE_AT,
        hp_number_priority = HP_NUMBER_PRIORITY,
        hud_priority = HUD_PRIORITY,
        message = MESSAGE_AT,
        -- (The damage judge's numbers, task 9 from 0x080163C8: from its holding banner's hold, 0x08014AA8, until the
        -- judge's release, 0x080163B6, slides the banner out and clears them.)
        judge_from_hold = true,
        chatbox_text = CHATBOX_TEXT,
        -- (A description shows in the message box: its arrow's place.)
        chatbox_arrows = { CHATBOX_ARROW_AT, CHATBOX_ARROW_AT },
        telop = telop(rom),
    }
    drawn(rom, h)
    worded(rom, names, h)
    return h
end

return hud
