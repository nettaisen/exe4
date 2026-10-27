--!strict
-- The field and the backgrounds: the same in the four ROMs. The routines that read them are EXE6's or EXE5's, the same
-- or nearly (docs/design/exe4-map.md §3), or EXE4's own (§14); the addresses in the comments are Red Sun US's.

local place = require("@exelib/extract/place")
local colors = require("@exelib/extract/colors")
local field = require("@exelib/extract/field")
local backgrounds = require("@exelib/extract/backgrounds")
local scroll = require("@exelib/extract/scroll")

local at = place.at
local pointer, pointer_in_each, stated = place.pointer, place.pointer_in_each, place.stated

local stage = {}

-- ---- Field ---------------------------------------------------------------------------------------------------

-- The field's tiles (the field's load, 0x08006A40: decompressed to VRAM 0x06001460, as EXE5's and EXE6's) and
-- background palettes 1..=8 (its transfer list, 0x08006A68, to the palette buffer's 0x03002A70).
local FIELD_TILES = pointer(0x0800_6A94, 0x0800_6A74)
local FIELD_PALETTES = pointer(0x0800_6A68, 0x0800_6A48)
-- Panel blocks: 32 bytes (5x3 map entries) per 6 * type + 3 * owner + row - 1 (0x080093FC, EXE6 `sub_800C01C`'s
-- counterpart), for EXE4's 12 panel types (0x0800A3A8's flag words).
local PANEL_BLOCKS = pointer(0x0800_944C, 0x0800_9418)
local PANEL_TYPES = 12
-- The highlighted panel block (0x0800948A, EXE6 `sub_800C0BA`'s): one, which EXE4 draws for both highlights (it takes
-- no highlight number).
local HIGHLIGHT_BLOCK = pointer(0x0800_94BC, 0x0800_9488)
-- The front edges by owner (0x080094C4: + 32 an owner).
local FRONT_EDGES = pointer(0x0800_9530, 0x0800_94FC)
-- The palette buffer's background palette 0 (the field's transfer list's palette 1 is at + 0x20).
local FIELD_PALETTE_BUFFER = 0x0300_2A50
-- The panel palettes that cycle (0x08009556, called as the field is drawn: EXE6 `sub_800C192`'s counterpart, written
-- out a palette at a time rather than from a list): each a counter pair at 0x02037AB0 + 2k (its frame, then a timer
-- from 14, 13, 12, 11, 10 and 9, 0x08009120), a frame every 14 ticks, from a table of palette pointers (its first the
-- palette the field loads there; Red Sun US's tables 0x08009648 on) to a palette of the buffer.
local PANEL_PALETTE_ANIMS: { { table: Place, count: number, dest: number } } = {
    { table = pointer(0x0800_9644, 0x0800_9610), count = 10, dest = 0x0300_2A70 },
    { table = pointer(0x0800_9674, 0x0800_9640), count = 10, dest = 0x0300_2AF0 },
    { table = pointer(0x0800_96A4, 0x0800_9670), count = 6, dest = 0x0300_2AB0 },
    { table = pointer(0x0800_96C4, 0x0800_9690), count = 6, dest = 0x0300_2B30 },
    { table = pointer(0x0800_96E4, 0x0800_96B0), count = 10, dest = 0x0300_2AD0 },
    { table = pointer(0x0800_9714, 0x0800_96E0), count = 10, dest = 0x0300_2B50 },
}
local PANEL_PALETTE_TICKS = 14

-- EXE4's panel types' names by number (compat/panels.toml, `[types.N]`: the names content/exe4/rules/panels.luau
-- gives the same numbers).
function stage.panel_names(): { string }
    local types: { [string]: any } = data("compat/panels.toml").types or {}
    local by_number: { [number]: string } = {}
    for key, entry in types do
        local n = if string.match(key, "^%d+$") then tonumber(key) else nil
        if n == nil or n > 0xFF then
            error(string.format("panels.toml: type %q is no number", key), 0)
        end
        by_number[n] = entry.name
    end
    local out: { string } = {}
    for n = 0, PANEL_TYPES - 1 do
        local name: string? = by_number[n]
        if name == nil then
            error(string.format("EXE4 panel %d: panels.toml has no type %d", n, n), 0)
        end
        table.insert(out, name)
    end
    return out
end

-- The field, from `rom`: its panel blocks by EXE4's numbers, each type by the name content gives that number.
function stage.field(rom: Rom): Field
    local panel_types = stage.panel_names()
    local palette_anims: { PaletteAnim } = {}
    for k, anim in PANEL_PALETTE_ANIMS do
        local frames: { { any } } = {}
        for i = 0, anim.count - 1 do
            local colors_ = colors.masked(gba.palette(rom, rom:u32(at(rom, anim.table) + 4 * i)))
            table.insert(frames, { colors_, PANEL_PALETTE_TICKS } :: { any })
        end
        table.insert(palette_anims, {
            slot = (anim.dest - FIELD_PALETTE_BUFFER) // 32,
            frames = frames,
            initial_timer = PANEL_PALETTE_TICKS - (k - 1),
        })
    end
    local tiles = at(rom, FIELD_TILES)
    local palettes = at(rom, FIELD_PALETTES)
    local panels = at(rom, PANEL_BLOCKS)
    local highlight = at(rom, HIGHLIGHT_BLOCK)
    local a: FieldAddresses = {
        tiles = tiles,
        palettes = palettes,
        panels = panels,
        highlights = { highlight, highlight },
        edges = at(rom, FRONT_EDGES),
        palette_anims = 0,
        palette_buffer = FIELD_PALETTE_BUFFER,
    }
    return field.with(rom, a, panel_types, palette_anims)
end

-- ---- Backgrounds ---------------------------------------------------------------------------------------------

-- EXE4's battle backgrounds (0 to 26: the loader 0x08085430 takes the game state's +0x0F, else the battle settings'
-- +5, else the map's from 0x08085BAC): their load descriptors by background id (the loader's literal; Red Sun US's
-- 0x0808563C), their scroll records (16 bytes each: two callbacks, the second BG1's, an argument and display bits;
-- 0x08085488) and their GFX animation lists (0x08085A50; EXE5's 0x0808C578, 0x0808C32C, 0x0808C96C). The same
-- backgrounds in the four ROMs, the literals at an address of their own in each.
local BACKGROUNDS = pointer_in_each({ 0x0808_5638, 0x0808_5644, 0x0808_5684, 0x0808_5690 })
local BACKGROUND_SCROLL = pointer_in_each({ 0x0808_5484, 0x0808_5490, 0x0808_54D0, 0x0808_54DC })
local BACKGROUND_ANIMS = pointer_in_each({ 0x0808_5480, 0x0808_548C, 0x0808_54CC, 0x0808_54D8 })
local BACKGROUND_COUNT = 27
-- The first of the scroll callbacks (a routine that returns; the ones after it at the same offsets in the four ROMs):
-- code, which the scroll records point into, so its own address is stated.
local SCROLLERS = stated({ 0x0800_1ED0, 0x0800_1ED0, 0x0800_1EB0, 0x0800_1EB0 })
-- EXE4's descriptor (0x08026234, 0x08026266): the tiles' archive, its buffer, their VRAM destination, the map's
-- archive, its buffer and destination, the palette's source.
local DESCRIPTOR: BackgroundDescriptor = { gfx = 0, dest = 8, map = 0x0C, palette = 0x18 }
-- The palette buffer's background palette 0 (the descriptors' palette destination; EXE5's 0x03003960).
local PALETTE_BUFFER = 0x0300_2A50
-- The BG1 scroll callbacks by their offset from the first (`SCROLLERS`), and their counters' steps (1/16 pixel a
-- frame): EXE6's `BGScrollCB_*` and EXE5's in EXE4's order. +0xB8 (Red Sun US's 0x08001F88, background 0x17's) speeds
-- a left scroll up from the background's load, by 1/16 pixel a frame each frame to 4 pixels a frame: a speeding
-- scroll, read from its code (@exelib/extract/scroll).
local SCROLLER_STEPS: { [number]: { number } } = {
    [0x00] = { 0, 0 }, -- returns (EXE6 nullsub_35)
    [0x02] = { -8, -4 }, -- EXE6 BGScrollCB_BG1Diagonal3to2Scroll
    [0x4C] = { 0, -4 }, -- BGScrollCB_BG1UpScroll
    [0x5E] = { 0, 4 }, -- BGScrollCB_BG1DownScroll
    [0x94] = { -8, 0 }, -- BGScrollCB_BG1FastLeftScroll
    [0xE4] = { 0, 0 }, -- returns (EXE5's 0x08001A24)
}

-- The battle backgrounds by number, from `rom`.
function stage.backgrounds(rom: Rom): { [number]: Background, n: number }
    local loads = at(rom, BACKGROUNDS)
    local scrolls = at(rom, BACKGROUND_SCROLL)
    local anim_lists = at(rom, BACKGROUND_ANIMS)
    local scrollers = at(rom, SCROLLERS)
    local out: { [number]: Background, n: number } = { n = BACKGROUND_COUNT }
    for id = 0, BACKGROUND_COUNT - 1 do
        local b = backgrounds.picture(rom, rom:u32(loads + 4 * id), DESCRIPTOR)
        if b ~= nil then
            local callback = bit32.band(rom:u32(scrolls + 16 * id + 4), 0xFFFFFFFE)
            b.scroll = SCROLLER_STEPS[callback - scrollers] or { 0, 0 }
            b.speeding = scroll.speeding(rom, callback)
            b.anims = gfx.anims(rom, rom:u32(anim_lists + 4 * id), PALETTE_BUFFER)
            out[id] = b
        end
    end
    return out
end

return stage
