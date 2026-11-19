--!strict
-- SprSonic (EXE4 chip 0x177, past the library: NeoVari's pick): a swing that throws a sonic boom through the row,
-- action 0x37 (../sonic_boom/action), hit modifier 1, going through.
-- Its record is written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local action = require("./sonic_boom/action")

local super_sonic: Chip = {
    action = action.make("super_sonic/action", { flinch = true }, true),
    codes = { "E", "L", "S", "*" },
    element = Element.null,
    family = Family.sword,
    class = ChipClass.special,
    rarity = 0,
    mb = 8,
    damage = 80,
    counter = 30,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "into_reach", range = "ahead_then_column" },
}

return { super_sonic = super_sonic }
