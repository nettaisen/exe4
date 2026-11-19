--!strict
-- The patch card Roll Soul (121, ロールソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local roll_soul = require("../navis/megaman/forms/roll_soul").roll_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(roll_soul),
        cards.bug("hp", 2),
    },
}

return { ["121_roll_soul"] = card }
