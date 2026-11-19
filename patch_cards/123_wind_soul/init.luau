--!strict
-- The patch card Wind Soul (123, ウインドソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local wind_soul = require("../navis/megaman/forms/wind_soul").wind_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(wind_soul),
        cards.bug("hp", 2),
    },
}

return { ["123_wind_soul"] = card }
