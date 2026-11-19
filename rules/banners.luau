--!strict
-- Banners that hold until removed (type 2 of the 41 banner records at 0x08016C04: 0x08016158).
-- Written by tools/exe4/gen_rules.py (bn6battle-verify) from the EXE4 ROM; people own it now.

return {
    holding = {
        asset.banner("program_advance"),
        asset.banner("hit_damage_judge"),
        asset.banner("program_advance_empty"),
    },
}
