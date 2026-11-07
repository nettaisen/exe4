--!strict
-- MetlGer1 to MetlGer3: the dimming chips' variant 0x22, EXE4's own. A controller (effect object #0x49, 0x080E7244:
-- the usual dimming phases, @exelib/dimming; its spawn 0x080E72EC takes the user's side, not its facing) whose effect
-- (0x080E7288) sets a gear (objects/gear, its mode 1: rolling for 1800 ticks on the other side, one of its side's
-- field objects) on the other side's solid, free panel of the user's row nearest that side's far edge, with the
-- chip's damage (no telop bonus) and a sound (0xA0); then 60 ticks. No such panel, no gear.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local dimming_chips = require("@exelib/dimming")
local gear = require("../objects/gear")
local panels = require("@exelib/panels")

local SOUND = asset.sound("tops")
local WAIT = 60
-- The gear's mode (the controller's first parameter): a lifetime gear.
local MODE = 1
-- The gear's panel: solid, of the other side's own area, without a body (0x080E72DC by the user's side).
local GEAR_PANEL: PanelCondition = { solid = true, own_area = true, any_body = false }

-- 0x080E7288.
local function effect(me: Object)
    if me.phase_init == 0 then
        local other = battle.other_side(me.alliance)
        -- (Its own area: side 1's for a side 1, else side 0's.)
        local x = panels.closest_in_row(other, me.panel_y, GEAR_PANEL, if other == 1 then 1 else 0)
        if x ~= 0 then
            local damage = me.damage_word
            gear.spawn(x, me.panel_y, me.element, me.alliance, MODE, damage)
            battle.play_sound(SOUND)
        end
        me.timer = WAIT
        me.phase_init = 4
    end
    local left = me.timer - 1
    me.timer = int.u16(left)
    if left > 0 then
        return
    end
    dimming_chips.done(me)
end

local kind = new.kind {
    id = "metlger/controller",
    pool = "effect",
    -- 0x080E7244.
    update = dimming_chips.phases { name = "MetlGer", effect = effect },
}

-- 0x080E72EC.
local function hook(user: Object, spec: DimmingChipSpec): Object?
    return dimming_chips.spawn(kind, user, spec, true)
end

-- MetlGer1 (EXE4 chip 0x0AF).
local metlger1: Chip = {
    codes = { "A", "M", "P", "*" },
    element = Element.null,
    family = Family.metal,
    class = "standard",
    rarity = 1,
    mb = 20,
    damage = 100,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, library = true },
    dimming = hook,
    auto_battle = { class = "into_open_row" },
}

-- MetlGer2 (EXE4 chip 0x0B0).
local metlger2: Chip = {
    codes = { "C", "E", "G", "*" },
    element = Element.null,
    family = Family.metal,
    class = "standard",
    rarity = 2,
    mb = 28,
    damage = 130,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, library = true },
    dimming = hook,
    auto_battle = { class = "into_open_row" },
}

-- MetlGer3 (EXE4 chip 0x0B1).
local metlger3: Chip = {
    codes = { "I", "L", "Q", "*" },
    element = Element.null,
    family = Family.metal,
    class = "standard",
    rarity = 3,
    mb = 36,
    damage = 160,
    counter = 20,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, library = true },
    dimming = hook,
    auto_battle = { class = "into_open_row" },
}

return { metlger1 = metlger1, metlger2 = metlger2, metlger3 = metlger3 }
