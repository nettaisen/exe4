--!strict
-- The patch card All Guard 1/2 (76, オールガード1/2), slot 0C's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")

local card: SlottedPatchCard = {
    slot = cards.SLOT_0C,
    effects = {
        cards.pair(cards.SLOT_0D, "077_all_guard_2_2", { cards.all_guard(), cards.bug("hp", 3) }),
    },
}

return { ["076_all_guard_1_2"] = card }
