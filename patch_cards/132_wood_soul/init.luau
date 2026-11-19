--!strict
-- The patch card Wood Soul (132, ウッドソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local wood_soul = require("../navis/megaman/forms/wood_soul").wood_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(wood_soul),
        cards.bug("hp", 2),
    },
}

return { ["132_wood_soul"] = card }
