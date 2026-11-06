--!strict
-- SearchMan's scope, EXE4's (effect object #0x43, 0x080E6B44): @exelib/serchman/scope with EXE4's look (10-22) and
-- sounds (0x128 as it moves, 0x080E6C08: 41 + 255; the lock's 0x12F; no power-up sound) and its sweep (0x080E6D30):
-- from the other side's front-most column (@exelib/panels' `front_most`, AreaGrab's, 0x0800A1E4), its bounds the
-- column before it and the field's edge. It reads its side's navi's presses (0x0800C09A); under event flag 0x1187,
-- which no netbattle sets, it would take no B (0x080E6C96, 0x080E6CF6).

local common = require("@exelib/serchman/scope")
local panels = require("@exelib/panels")
local search_scope_sprite = asset.sprite("search-scope")

-- The panel filters by side: a side's own panels (0x080E6D32).
local OWN = "own_area"

-- 0x080E6D30: the other side's front-most column; the one before it; the field's edge.
local function columns(me: Object): (number, number, number)
    local other = battle.other_side(me.alliance)
    local x = panels.front_most(other, OWN, nil, other)
    return x, x - me.facing, if me.facing > 0 then 7 else 0
end

return common.make {
    id = "serchman/scope",
    scope = search_scope_sprite,
    move_sound = asset.sound("scope-move"),
    lock_sound = asset.sound("mark"),
    columns = columns,
}
