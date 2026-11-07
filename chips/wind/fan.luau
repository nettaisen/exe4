--!strict
-- EXE4's fan for Wind and Fan (attack object #0x48, 0x080D6488): the shared one (@exelib/wind/fan, EXE6's code) in
-- EXE4's look (sprite 0c-21, its rising sound 0x121) with EXE4's gust (../../objects/gust: the fan gives no tracking
-- slot) and EXE4's differences: no NameID (0x080D64A8: no identity); its leaving (0x080D664C) an explosion with its
-- sound whatever removes it; and its gust's column (0x080D6688, `column`): on the enemy's front column of the row (the
-- panel nearest the user's side, 0x0800A1AE on the other side's far edge: its side's condition, 0x080D66E8), none when
-- another obstacle stands there; Fan's from there on toward the far edge until another obstacle or the field's edge,
-- the panel before it. It takes hits as EXE6's (0x0801393E: a push keeps the damage). Its actions are EXE6's numbers
-- (EXE4's table, 0x080D655C, has six shared entries, its rising and blowing EXE4's 6 and 7).

local collision = require("../../rules/collision")
local common = require("@exelib/wind/fan")
local gust = require("../../objects/gust")
local panels = require("@exelib/panels")
local winds = require("../../rules/wind")
local explosion_sprite = asset.sprite("explosion")
local fan_sprite = asset.sprite("fan")

local fan = {}

fan.variant = common.variant

-- 0x080D66E8 by the fan's side: the other side's panels.
local FRONT: PanelCondition = { enemy_area = true }

local NEUTRAL: PanelFlags = { neutral = true }

-- 0x080D6688.
local function column(me: Object, row: number, pulls: boolean): number
    local x = panels.closest_in_row(battle.other_side(me.alliance), row, FRONT, me.alliance)
    -- (Another obstacle on the panel: a neutral object.)
    if field.any(x, row, NEUTRAL) then
        return 0
    end
    if not pulls then
        return x
    end
    local step = panels.side_direction(me.alliance)
    repeat
        x += step
    until x < 1 or x > 6 or field.any(x, row, NEUTRAL)
    return x - step
end

local made = common.make {
    id = "wind/fan",
    sprite = fan_sprite,
    appear_sound = asset.sound("appear"),
    blow_sound = asset.sound("wind"),
    break_sound = asset.sound("hit-bomb-1"),
    -- 0x080D6660: effect row 0 (14-00) where it stands.
    explosion = new.effect { sprite = explosion_sprite, anim = 0, palette = 0, steps = 27 },
    is = collision.own_body,
    hits = collision.hit_by_other_side,
    spawn_gust = function(x: number, y: number, alliance: number, _flip: boolean, how: GustHow, damage: number): Object?
        return gust.spawn(x, y, alliance, how, damage, nil, 0)
    end,
    wind = winds.of,
    absorbs = false,
    removal_explodes = true,
    -- 0x08013F3E: a crushing touch destroys it, its HP as it is.
    crush = ObstacleCrush.destroys,
    column = column,
}

fan.kind = made.kind
fan.spawn = made.spawn

return fan
