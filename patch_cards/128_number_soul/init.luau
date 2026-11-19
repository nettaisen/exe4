--!strict
-- The patch card Number Soul (128, ナンバーソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local number_soul = require("../navis/megaman/forms/number_soul").number_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(number_soul),
        cards.bug("hp", 2),
    },
}

return { ["128_number_soul"] = card }
