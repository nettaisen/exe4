--!strict
-- The patch card Triple Supporter 1/2 (74, トリプルサポーター1/2), slot 0B's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")

local card: SlottedPatchCard = {
    slot = cards.SLOT_0B,
    effects = {
        cards.pair(cards.SLOT_0C, "075_triple_supporter_2_2", { cards.all_supports(), cards.clear_bug("support") }),
    },
}

return { ["074_triple_supporter_1_2"] = card }
