--!strict
-- NumbrMan, NumbMnSP and NumbMnDS (EXE4 chips 0x0F2 to 0x0F4): navi chips, the dimming chips' action 0x0C, its variant
-- 0x02: each chip's controller (./navi) brings NumberMan, who throws a die three columns ahead, its face times his
-- damage when it bursts; each chip states his palette (0x0800B950 by its first parameter, its level 0, 3 or 4: 0, 2,
-- 3). NumbMnSP's damage goes by how fast its user deleted NumberMan SP (rules/sp_chips: formula 8, the table's row 7),
-- NumbMnDS's by the field's holes (formula 30).
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local navi = require("@self/navi")
local navi_chips = require("../lib/navi_chips")
local sp_chips = require("../rules/sp_chips")

-- NumberMan's row of the navi chips' damage (0x08018B48's row 7), by step.
local ROW: { number } = { 90, 85, 80, 75, 70, 65, 60, 55, 50, 45, 40 }

local numbrman: Chip = {
    codes = { "N" },
    element = Element.null,
    family = Family.plus,
    class = ChipClass.mega,
    rarity = 3,
    mb = 33,
    damage = 30,
    counter = 50,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, navi = true, library = true },
    dimming = navi.controller { id = "numbrman/controller", palette = 0 }.hook,
    megaman = "light",
    auto_battle = { class = "three_before_around_target" },
}

local numbmn_sp: Chip = {
    codes = { "N" },
    element = Element.null,
    family = Family.plus,
    class = ChipClass.mega,
    rarity = 4,
    mb = 66,
    sp = ROW,
    damage = sp_chips.damage,
    counter = 50,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, navi = true, library = true },
    dimming = navi.controller { id = "numbmn-sp/controller", palette = 2 }.hook,
    megaman = "light",
    auto_battle = { class = "three_before_around_target" },
}

local numbmn_ds: Chip = {
    codes = { "N" },
    element = Element.null,
    family = Family.plus,
    class = ChipClass.mega,
    rarity = 4,
    mb = 66,
    damage = { formula = Formula.count, of = { panels = PanelType.hole }, by_count = navi_chips.by_holes(ROW) },
    counter = 50,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, navi = true, library = true, variable_damage = true },
    dimming = navi.controller { id = "numbmn-ds/controller", palette = 3 }.hook,
    megaman = "dark",
    auto_battle = { class = "three_before_around_target" },
}

return { numbrman = numbrman, ["numbmn-sp"] = numbmn_sp, ["numbmn-ds"] = numbmn_ds }
