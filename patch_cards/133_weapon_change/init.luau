--!strict
-- The patch card Weapon Change (133, ウェポンチェンジ), slot 0A's.
-- Written by tools/exe4/gen_patch_cards.py (bn6battle-verify) from the EXE4 ROMs.

local cards = require("../rules/patch_cards/cards")
local chips = require("../navis/megaman/weapons/chips")

local card: SlottedPatchCard = {
    slot = cards.SLOT_0A,
    effects = {
        cards.b_button(chips.mini_bomb),
    },
}

return { ["133_weapon_change"] = card }
