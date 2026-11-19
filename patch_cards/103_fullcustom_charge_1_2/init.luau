--!strict
-- The patch card FullCustom Charge 1/2 (103, チャージフルカスタム1/2), slot 0D's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local chips = require("../navis/megaman/weapons/chips")

local card: SlottedPatchCard = {
    slot = cards.SLOT_0D,
    effects = {
        cards.pair(cards.SLOT_0E, "104_fullcustom_charge_2_2", { cards.charged_shot(chips.full_custom), cards.custom_down(2) }),
    },
}

return { ["103_fullcustom_charge_1_2"] = card }
