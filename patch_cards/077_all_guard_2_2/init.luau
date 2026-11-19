--!strict
-- The patch card All Guard 2/2 (77, オールガード1/2), slot 0D's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")

local card: SlottedPatchCard = {
    slot = cards.SLOT_0D,
    effects = {
        cards.pair(cards.SLOT_0C, "076_all_guard_1_2", { cards.all_guard(), cards.bug("hp", 3) }),
    },
}

return { ["077_all_guard_2_2"] = card }
