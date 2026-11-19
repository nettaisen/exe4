--!strict
-- The patch card Metal Soul (129, メタルソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local metal_soul = require("../navis/megaman/forms/metal_soul").metal_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(metal_soul),
        cards.bug("hp", 2),
    },
}

return { ["129_metal_soul"] = card }
