--!strict
-- The custom screen's graphics. EXE4's screen is laid out as EXE5's (the window on the HUD layer's left, the chip
-- window's name, picture, code and damage, two rows of five slots, OK and the UNITE button under it, the picked column)
-- by its own code: the screen's open (0x0801DC28: the window's map 0x0870CC80 and its patch list 0x0801DD90, from tile
-- 0x9C), the HUD's load list (0x08015A0C: the frame, the column's cells, the UNITE button's tiles, the emblem's, "FINAL
-- TURN"), the chip window (0x0801FC40), the slots (0x0801F5EC on) and the screen's sprites (0x0801DE68's list: the
-- cursor's corners, the warning's tiles, sprite palette 13). What EXE4 draws otherwise than EXE5 is said in the pack
-- (`CustomScreen`): its element icon is a sprite in a palette of its own (0x0801EECC); its cursor and the Regular
-- chip's frame have a palette of their own (sprite palette 13: 0x0801EE38's and 0x0801EF00's attributes 0xD360,
-- 0xD362) where EXE5's take the navi's emblem's; the emblem over the picked column is the window's own (0x08020028: an
-- orb drawn by frames on the map, which turns as a chip is picked), no navi's sprite; the UNITE button is drawn at its
-- own place on the map (0x0801FF14), not among the slots' patches; and the window has one frame color for every chip
-- (0x0801DC28 loads it once).
--
-- Each block is stated by where the game's own pointer to it is in each of the four ROMs (a place, at one address in
-- both versions' code of a release; the addresses in the comments are Red Sun US's). The window and its parts are the
-- same in the four, and the pack has the Red Sun US ROM's; OK's and SHUFFLE's pictures and the UNITE button's label are
-- each release's words (lettering.luau has the Japanese ones'). Every palette drops each color's bit 15.

local place = require("@exelib/extract/place")
local colors = require("@exelib/extract/colors")
local patches = require("@exelib/extract/patches")
local hud = require("./hud")
local versions = require("./versions")
local cards = require("./cards")

local band, rshift = bit32.band, bit32.rshift
local at = place.at
local pointer = place.pointer

local custom = {}

-- A block: its place and its length in bytes.
type Block = { place: Place, len: number }
-- A picture of the chip window: its tiles' place and its palette's.
type Details = { gfx: Place, palette: Place }

-- The window frame's tiles (to tile 1, 62 tiles), the picked column's cells (tile 0x43), "FINAL TURN" (tile 0x70): the
-- HUD's load list.
local WINDOW_TILES: Block = { place = pointer(0x0801_5A48, 0x0801_59A4), len = 0x7C0 }
local COLUMN_CELLS: Block = { place = pointer(0x0801_5A54, 0x0801_59B0), len = 0x80 }
local TURN_LIMIT: Block = { place = pointer(0x0801_5AA8, 0x0801_5A04), len = 0x1C0 }
-- The window's 15x20 map and its patch list, from tile 0x9C (0x0801DC28).
local WINDOW_MAP = pointer(0x0801_DE4C, 0x0801_DD8C)
local WINDOW_PATCHES = pointer(0x0801_DD8C, 0x0801_DCCC)
local WINDOW_PATCHES_FROM = 0x9C
local MAP_CELLS = 15 * 20
-- The cursor's corners (two frames of four words: y in the low half, x and the flips, 0x1000 h and 0x2000 v, in the
-- high): over OK (0x0801EDA4's table), over the UNITE button (0x0801EE08's), over the SHUFFLE button (0x0801EDD4's).
local OK_CORNERS = pointer(0x0801_EDB0, 0x0801_ECF0)
local UNITE_CORNERS = pointer(0x0801_EE14, 0x0801_ED54)
local ROW_BUTTON_CORNERS = pointer(0x0801_EDE4, 0x0801_ED24)
-- The cursor over the UNITE button (0x08020DD0: column 11, row 17) and over SHUFFLE (0x0801EDD4: slot 8's place, a
-- slot's (2 * column + 1, 3 * row + 13) cells, 0x08020D9A).
local UNITE_CURSOR = { x = 11 * 8, y = 17 * 8 }
local ROW_BUTTON_CURSOR = { x = 56, y = 128 }
-- The window's palette 9 (0x0801DC28: once, for every chip), palettes 11 and 12 (the slots' icons, grayed: the load
-- list's 0x40 bytes, the gray one after the icons') and 14.
local FRAME_PALETTE = pointer(0x0801_DE38, 0x0801_DD78)
local ICON_PALETTE = pointer(0x0801_5A78, 0x0801_59D4)
local OTHER_PALETTE = pointer(0x0801_5A90, 0x0801_59EC)
-- The chip window's pictures for OK (0x0801FDFE: nothing picked, "NO DATA SELECTED"; picked, "CHIP DATA
-- TRANSMISSION") and the UNITE button's and the SHUFFLE button's (0x0801FE44, 0x0801FE78), with their palettes. OK's
-- two and SHUFFLE's have words, each release's own, in one palette (its own too); UNITE's is the same in the four
-- ROMs.
local WORDED_PALETTE = pointer(0x0801_FE40, 0x0801_FD80)
custom.OK = { gfx = pointer(0x0801_FE38, 0x0801_FD78), palette = WORDED_PALETTE } :: Details
custom.OK_PICKED = { gfx = pointer(0x0801_FE3C, 0x0801_FD7C), palette = WORDED_PALETTE } :: Details
local UNITE_PICTURE: Details = { gfx = pointer(0x0801_FE70, 0x0801_FDB0), palette = pointer(0x0801_FE74, 0x0801_FDB4) }
custom.SHUFFLE_PICTURE = {
    gfx = pointer(0x0801_FEB8, 0x0801_FDF8),
    palette = pointer(0x0801_FEC4, 0x0801_FE04),
} :: Details
-- A chip window picture's bytes (7x6 tiles).
local PICTURE_BYTES = 0x540
-- Chip codes (8x16: A..Z, '*', then one no chip has), damage digits (0-9, '?'), the element icons (2x2, 13 of them: a
-- byte past them shows the last, 0x0801FCC4) and their palette (sprite palette 11, the icon a sprite at (24, 80) from
-- the window's left edge: 0x0801EECC).
local CODES = pointer(0x0801_FD3C, 0x0801_FC7C)
local CODE_GLYPHS = 28
local DIGITS = pointer(0x0801_FD4C, 0x0801_FC8C)
local DIGIT_GLYPHS = 11
local ELEMENTS = pointer(0x0801_FD44, 0x0801_FC84)
local ELEMENT_COUNT = 13
local ELEMENT_PALETTE = pointer(0x0801_E0E4, 0x0801_E024)
local ELEMENT_SPRITE = { x = 24, y = 80 }
-- The icons are by the chip record's element byte (+7), EXE4's own family numbers, which its rules' families are
-- (`elements.families`): 0 to 15, those past the icons (13 none's, 14 the program advance's, 15 the souls') showing
-- the last, null's.
local FAMILIES = 16
-- The slots' codes (16x8: 0x0801F5CC, by code; code 27 is the fill solid 1, 0x08020EDC, and a code past it, the empty
-- slot's, the table's 28th glyph, dark as the empty icon) and the empty slot's icon (0x0801F59C).
local SLOT_CODES = pointer(0x0801_F5E4, 0x0801_F524)
local SLOT_CODE_GLYPHS = 28
local EMPTY_ICON = pointer(0x0801_F5B4, 0x0801_F4F4)
-- The UNITE button (0x0801FF14: 3x2 at column 11, row 17, in palette 9, by its entries at 0x0801FF54's table): its
-- tiles, on offer and gray (the load list's to tile 0x52: 0x52 on offer, 0x58 gray, when unavailable or a soul is
-- chosen), and the window's fill tile it shows with no button (0x2A, the window frame's). The tiles have the button's
-- label, each release's own ("UNITE" in the US ROMs).
custom.UNITE_TILES = { place = pointer(0x0801_5A60, 0x0801_59BC), len = 0x180 } :: Block
-- The icons of the souls' chips, chip 0x160 (no soul) and 0x161 to 0x16C (their records' +0x20, one after another;
-- every ROM's alike), by the offer: the soul's choice flies its soul's (0x0802084E: chip 0x160 plus the screen's
-- +0x0D) as a sprite in their palette (0x0802086C, sprite palette 11, 0x08020DF4).
local SOUL_ICONS: Block = { place = pointer(0x0801_D48C, 0x0801_D3CC), len = 13 * 0x80 }
local SOUL_ICON_PALETTE = pointer(0x0802_087C, 0x0802_07BC)
local UNITE_PLACE: ButtonPlace = { x = 11, y = 17, first_tile = 0x52, palette = 9 }
local WINDOW_FILL_TILE = 0x2A
-- The UNITE button's tiles a set (3x2), and those of its sets with the label (on offer and gray), which the fill set
-- follows.
custom.UNITE_CELLS = 6
custom.UNITE_LABELED = 2 * custom.UNITE_CELLS
-- The SHUFFLE button over slots 8 and 9: 4x3 cells at column 7, row 16, in palette 9, numbered on from slot 8's first
-- tile (0x0801DD34: the slots' tiles are from 0xDE, six a slot, 0x0801F680); its twelve tiles a look, by the screen's
-- +0x13 (0x0801F6C2): as it is, shuffling (0x080209BA) and with no shuffle left (0x080209B8). The pack has a button's
-- sets as selectable, unavailable and picked: its looks 0, 2 and 1.
local SHUFFLE_TILES: Block = { place = pointer(0x0801_F718, 0x0801_F658), len = 0x480 }
local SHUFFLE_PLACE: ButtonPlace = { x = 7, y = 16, first_tile = 0x10E, palette = 9 }
local SHUFFLE_WIDTH, SHUFFLE_HEIGHT = 4, 3
local SHUFFLE_SETS = { 0, 2, 1 }
-- The names EXE4's rules give their buttons (as EXE5's: the soul button's `soul`, Shuffle's `redeal`), which the pack
-- has their looks by.
custom.SOUL_BUTTON = "soul"
custom.REDEAL_BUTTON = "redeal"
-- The emblem over the picked column (0x08020028): 2x3 cells at column 12, row 0, its tiles at 0x5E (the load list's),
-- its four frames' entries and the steps of its turn (0x08020078: a frame's entries, 1 a step that holds the last, 0
-- the end).
local EMBLEM_TILES: Block = { place = pointer(0x0801_5A6C, 0x0801_59C8), len = 0x240 }
local EMBLEM_FIRST_TILE = 0x5E
local EMBLEM_STEPS = pointer(0x0802_0074, 0x0801_FFB4)
local EMBLEM_WIDTH, EMBLEM_HEIGHT = 2, 3
local EMBLEM_AT = { x = 12, y = 0 }
-- Sprites: the cursor's corner (two frames), its palette and the Regular chip's frame's (sprite palette 13,
-- 0x0801DE68's list), the Regular chip's frame (two frames of 4x4: 0x0801EF00).
local CURSOR: Block = { place = pointer(0x0801_DE68, 0x0801_DDA8), len = 0x40 }
local CURSOR_PALETTE = pointer(0x0801_DE80, 0x0801_DDC0)
local REGULAR: Block = { place = pointer(0x0801_EF40, 0x0801_EE80), len = 0x400 }
-- The Program Advance animation's names' colors (0x0801E684's table: three sets of four).
local ADVANCE_NAME_COLORS = pointer(0x0801_E684, 0x0801_E5C4)
local ADVANCE_NAME_SETS = 3

-- Where the blocks load (the patch list's runs: the name from 0x9C, the picture 0xAC, the code 0xD6, the damage 0xD8,
-- the slots 0xDE, the picked column's icons 0x11A); no element tiles (a sprite) and no enemy names' bar; a hidden
-- slot's fill solid 1 (0x08020EDC, as EXE6's), a blank code or damage cell's solid 7 (0x08020E5C: 0x0801FD08,
-- 0x0801FE2A); the empty icon in palette 9 (the slots' patches' palette, which 0x0801FB00 leaves on an empty slot and
-- sets on a picked one; 0x0801FB6E's on an empty cell of the picked column); the cursor over OK at column 11, row 14
-- (0x08020DBC: (0x58, 0x70)), its corners `corners` (`OK_CORNERS`).
local function layout(corners: { { { any } } }): CustomLayout
    return {
        column_cells = 0x43,
        turn_limit = 0x70,
        -- (0x0801EE6C's map at 0x0801EE9C: palette 14.)
        turn_limit_palette = 14,
        name = 0x9C,
        art = 0xAC,
        code = 0xD6,
        element = 0,
        digits = 0xD8,
        slots = 0xDE,
        column_icons = 0x11A,
        name_bar = 0,
        form_names = 0,
        slot_blank = 1,
        detail_blank = 7,
        empty_palette = 9,
        ok_cursor = { x = 0x58, y = 0x70, corners = corners },
        regular = { 1, 100 },
        column_columns = { 11, 14 },
        column_row = 3,
        form_names_at = { 1, 1 },
    }
end

-- A palette (the hardware ignores bit 15 of a color).
local function palette(rom: Rom, a: number): Palette
    return colors.masked(gba.palette(rom, a))
end

-- A block's tiles in `rom`.
function custom.tiles(rom: Rom, b: Block): Tiles
    return gba.tiles(rom, at(rom, b.place), b.len)
end

-- A picture of the chip window in `rom`, with its palette.
function custom.picture(rom: Rom, d: Details): Picture
    local tiles = gba.tiles(rom, at(rom, d.gfx), PICTURE_BYTES)
    return { tiles = tiles, palette = palette(rom, at(rom, d.palette)) }
end

-- A byte as a signed one.
local function signed(b: number): number
    return if b >= 0x80 then b - 0x100 else b
end

-- A cursor's corners from a table of them at `a`: two frames of four, each { y, x, hflip, vflip }.
local function cursor_corners(rom: Rom, a: number): { { { any } } }
    local frames: { { { any } } } = {}
    for f = 0, 1 do
        local four: { { any } } = {}
        for k = 0, 3 do
            local w = rom:u32(a + 16 * f + 4 * k)
            local hi = rshift(w, 16)
            local y, x = signed(band(w, 0xFF)), signed(band(hi, 0xFF))
            local corner: { any } = { y, x, band(hi, 0x1000) ~= 0, band(hi, 0x2000) ~= 0 }
            table.insert(four, corner)
        end
        table.insert(frames, four)
    end
    return frames
end

-- The emblem's frames and steps (0x08020078: a pointer a step, a frame's six entries, 1 a hold, 0 the end; the frames
-- in the order they first show). The first step is the open's draw of the first frame: the turn's are the rest.
local function window_emblem(rom: Rom): WindowEmblem
    local frames_at: { number } = {}
    -- Each step's frame from 0, or -1 for a hold.
    local list: { number } = {}
    local k = 0
    while true do
        local p = rom:u32(at(rom, EMBLEM_STEPS) + 4 * k)
        if p == 0 then
            break
        elseif p == 1 then
            table.insert(list, -1)
        else
            local f = table.find(frames_at, p)
            if f == nil then
                table.insert(frames_at, p)
                f = #frames_at
            end
            table.insert(list, (f :: number) - 1)
        end
        k += 1
    end
    local tiles = custom.tiles(rom, EMBLEM_TILES)
    local frames: { Map } = {}
    for _, p in frames_at do
        table.insert(frames, gba.map(rom, p, EMBLEM_WIDTH * EMBLEM_HEIGHT))
    end
    local steps: { [number]: number, n: number } = { n = math.max(#list - 1, 0) }
    for i = 2, #list do
        if list[i] >= 0 then
            steps[i - 2] = list[i]
        end
    end
    return {
        x = EMBLEM_AT.x,
        y = EMBLEM_AT.y,
        width = EMBLEM_WIDTH,
        height = EMBLEM_HEIGHT,
        first_tile = EMBLEM_FIRST_TILE,
        tiles = tiles,
        frames = frames,
        steps = steps,
    }
end

-- The chips' pictures, each under its chip's key, from a ROM of the chip's version (versions.luau's `chip_source`) and
-- marked with it; an e-Reader card's chip's the recipe's own (cards.luau). None where its record has none in the ROM;
-- a black palette where its picture has none there.
local function chip_art(set: Set, names: AssetNames, chip_versions: { [number]: string }): { ChipArt }
    local keys = names.chips or {}
    local out: { ChipArt } = {}
    for _, id in hud.chip_ids(names) do
        local picture: Picture = {}
        if cards.has(id) then
            picture = cards.picture(id)
        else
            local rom = versions.chip_source(set, chip_versions, id)
            local record = at(rom, hud.CHIPS) + 0x2C * id
            local gfx, pal = rom:u32(record + 0x24), rom:u32(record + 0x28)
            if rom:holds(gfx) then
                local tiles = gba.tiles(rom, gfx, PICTURE_BYTES)
                picture = { tiles = tiles, palette = if rom:holds(pal) then palette(rom, pal) else nil }
            end
        end
        local art: ChipArt = { key = keys[id] :: string, picture = picture, version = chip_versions[id] :: string? }
        table.insert(out, art)
    end
    return out
end

-- The element icons by family (`FAMILIES`), those past the icons the last's.
local function elements(rom: Rom): Tiles
    local icons: { Tiles } = {}
    for b = 0, FAMILIES - 1 do
        table.insert(icons, gba.tiles(rom, at(rom, ELEMENTS) + 0x80 * math.min(b, ELEMENT_COUNT - 1), 0x80))
    end
    return gba.join(icons)
end

-- The Program Advance animation's names' colors: three sets of four.
local function advance_name_colors(rom: Rom): { { number } }
    local out: { { number } } = {}
    for i = 0, ADVANCE_NAME_SETS - 1 do
        local four: { number } = {}
        for k = 0, 3 do
            local color: number = colors.color(rom:u16(at(rom, ADVANCE_NAME_COLORS) + 8 * i + 2 * k))
            table.insert(four, color)
        end
        table.insert(out, four)
    end
    return out
end

-- The custom screen's graphics; `names` gives the chips' pictures their chips' keys, `chip_versions` the version
-- chips' versions (versions.luau). The window and its parts are the Red Sun US ROM's, the worded pictures and the
-- UNITE button's label the same ROM's.
function custom.custom(set: Set, names: AssetNames, chip_versions: { [number]: string }): CustomScreen
    local chip_arts = chip_art(set, names, chip_versions)
    local rom = set.B4WE
    local function glyphs(p: Place, n: number): Tiles
        return gba.tiles(rom, at(rom, p), 0x40 * n)
    end
    local window_tiles = custom.tiles(rom, WINDOW_TILES)
    -- The UNITE button's sets: on offer, gray (both with its label), and with no button the window's fill tile in its
    -- six cells.
    local fill: { number } = table.create(custom.UNITE_CELLS, WINDOW_FILL_TILE - 1)
    local unite_tiles = gba.join({ custom.tiles(rom, custom.UNITE_TILES), window_tiles:pick(fill) })
    local unite_picture = custom.picture(rom, UNITE_PICTURE)
    local soul: ButtonPictures = {
        width = 3,
        height = 2,
        tiles = unite_tiles,
        -- (Gray when unavailable and when a soul is chosen.)
        sets = "other",
        hidden = 2,
        cursor = {
            x = UNITE_CURSOR.x,
            y = UNITE_CURSOR.y,
            corners = cursor_corners(rom, at(rom, UNITE_CORNERS)),
        },
        palettes = { unite_picture.palette :: Palette },
        picture = unite_picture,
        place = UNITE_PLACE,
        icons = custom.tiles(rom, SOUL_ICONS),
        icon_palette = palette(rom, at(rom, SOUL_ICON_PALETTE)),
    }
    local shuffle_picture = custom.picture(rom, custom.SHUFFLE_PICTURE)
    local shuffle_looks = custom.tiles(rom, SHUFFLE_TILES)
    local cells = SHUFFLE_WIDTH * SHUFFLE_HEIGHT
    local shuffle_tiles: { number } = {}
    for _, look in SHUFFLE_SETS do
        for k = 0, cells - 1 do
            table.insert(shuffle_tiles, look * cells + k)
        end
    end
    local redeal: ButtonPictures = {
        width = SHUFFLE_WIDTH,
        height = SHUFFLE_HEIGHT,
        tiles = shuffle_looks:pick(shuffle_tiles),
        sets = "each",
        cursor = {
            x = ROW_BUTTON_CURSOR.x,
            y = ROW_BUTTON_CURSOR.y,
            corners = cursor_corners(rom, at(rom, ROW_BUTTON_CORNERS)),
        },
        palettes = { shuffle_picture.palette :: Palette },
        picture = shuffle_picture,
        -- 0x0801FEA2: the shuffles left, in the damage's last cell.
        uses_digit = true,
        place = SHUFFLE_PLACE,
    }
    -- The slots' codes, the last the empty slot's.
    local slot_codes = glyphs(SLOT_CODES, SLOT_CODE_GLYPHS)
    local map = gba.map(rom, at(rom, WINDOW_MAP), MAP_CELLS)
    local window_patches = at(rom, WINDOW_PATCHES)
    return {
        layout = layout(cursor_corners(rom, at(rom, OK_CORNERS))),
        -- The window's label: CHIP SELECT over the slots (tiles 0x22 to 0x28, color 4 on 1).
        labels = { { name = "chip-select", first = 0x22, last = 0x28, top = 3, bottom = 6, letters = { 4 } } },
        buttons = { { name = custom.SOUL_BUTTON, value = soul }, { name = custom.REDEAL_BUTTON, value = redeal } },
        window_tiles = window_tiles,
        column_cells = custom.tiles(rom, COLUMN_CELLS),
        turn_limit = custom.tiles(rom, TURN_LIMIT),
        window_maps = { map },
        window_patches = patches.list(rom, window_patches, WINDOW_PATCHES_FROM),
        frame_palettes = { palette(rom, at(rom, FRAME_PALETTE)) },
        icon_palette = palette(rom, at(rom, ICON_PALETTE)),
        gray_palette = palette(rom, at(rom, ICON_PALETTE) + 0x20),
        other_palette = palette(rom, at(rom, OTHER_PALETTE)),
        chip_art = chip_arts,
        -- (EXE4 has no other kind of slot.)
        pictures = { ok = custom.picture(rom, custom.OK), ok_picked = custom.picture(rom, custom.OK_PICKED) },
        codes = glyphs(CODES, CODE_GLYPHS),
        elements = elements(rom),
        digits = glyphs(DIGITS, DIGIT_GLYPHS),
        slot_codes = slot_codes,
        empty_icon = gba.tiles(rom, at(rom, EMPTY_ICON), 0x80),
        -- (No version shows anything of its own here.)
        versioned = { base_version = versions.RED_SUN, base = {} },
        cursor = custom.tiles(rom, CURSOR),
        regular = custom.tiles(rom, REGULAR),
        advance_name_colors = advance_name_colors(rom),
        element_sprite = {
            x = ELEMENT_SPRITE.x,
            y = ELEMENT_SPRITE.y,
            palette = palette(rom, at(rom, ELEMENT_PALETTE)),
        },
        cursor_palette = palette(rom, at(rom, CURSOR_PALETTE)),
        window_emblem = window_emblem(rom),
    }
end

return custom
