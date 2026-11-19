--!strict
-- The patch card Junk Soul (130, ジャンクソウル), slot 0E's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local junk_soul = require("../navis/megaman/forms/junk_soul").junk_soul

local card: SlottedPatchCard = {
    slot = cards.SLOT_0E,
    effects = {
        cards.soul(junk_soul),
        cards.bug("hp", 2),
    },
}

return { ["130_junk_soul"] = card }
