--!strict
-- The patch card Thunder Soul (126, サンダーソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local thunder_soul = require("../navis/megaman/forms/thunder_soul").thunder_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(thunder_soul),
        cards.bug("hp", 2),
    },
}

return { ["126_thunder_soul"] = card }
