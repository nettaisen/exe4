--!strict
-- BassAnly (EXE4 chip 0x132, Blue Moon's): a navi chip, the dimming chips' action 0x0C, its variant 0x45: its
-- controller (./navi) brings BassAnly, who fires four dark balls up and down the slant, seeking enemy navis.
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local navi = require("@self/navi")

local chip: Chip = {
    -- The version whose saves hold it (rules/folder; rules/builds' groups).
    version = Version.bluemoon,
    codes = { "X" },
    element = Element.null,
    family = Family.null,
    class = "giga",
    rarity = 4,
    mb = 95,
    damage = 160,
    counter = 50,
    cant_counter = true,
    lockout = 0,
    flags = { dimming = true, has_damage = true, navi = true, library = true },
    dimming = navi.controller { id = "bassanly/controller" }.hook,
    auto_battle = { class = "into_reach", range = "ahead_then_column" },
}

return { bassanly = chip }
