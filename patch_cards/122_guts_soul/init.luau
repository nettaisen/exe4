--!strict
-- The patch card Guts Soul (122, ガッツソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local guts_soul = require("../navis/megaman/forms/guts_soul").guts_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(guts_soul),
        cards.bug("hp", 2),
    },
}

return { ["122_guts_soul"] = card }
