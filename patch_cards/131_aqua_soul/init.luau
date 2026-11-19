--!strict
-- The patch card Aqua Soul (131, アクアソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local aqua_soul = require("../navis/megaman/forms/aqua_soul").aqua_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(aqua_soul),
        cards.bug("hp", 2),
    },
}

return { ["131_aqua_soul"] = card }
