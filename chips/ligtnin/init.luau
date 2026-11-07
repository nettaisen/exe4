--!strict
-- Ligtnin1, Ligtnin2 and Ligtnin3 (EXE4 chips 0x0A6 to 0x0A8; their records at 0x080197EC + n * 0x2C): the spawners'
-- action 0x20 (lib/spawners), its variant 0x0C, their parameter 2: the towers' controller (lib/towers) strikes
-- lightning onto each panel holding an obstacle, a column at a time.
-- Their records are written by tools/exe4/gen_content.py (bn6battle-verify) from the EXE4 ROMs.

local lightning = require("../objects/lightning")
local spawners = require("../lib/spawners")
local towers = require("../lib/towers")

-- An obstacle on a panel (0x080DF9AC): another body of either side, or a neutral object.
local OBSTACLE: PanelFlags = { own_other_body = true, enemy_other_body = true, neutral = true }

-- 0x080DF964: any panel holding an obstacle: a lightning.
local function strike(me: Object, x: number, y: number): boolean
    if not field.any(x, y, OBSTACLE) then
        return false
    end
    lightning.spawn(me, x, y, me.element, towers.damage_word(me))
    return true
end

local RAISE = towers.controller { id = "ligtnin/controller", strike = strike }

local ligtnin1: Chip = {
    action = spawners.action { id = "ligtnin1/action", spawn = RAISE },
    codes = { "L", "T", "W", "*" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 1,
    mb = 37,
    damage = 100,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "when_any_obstacle" },
}

local ligtnin2: Chip = {
    action = spawners.action { id = "ligtnin2/action", spawn = RAISE },
    codes = { "A", "E", "V" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 2,
    mb = 45,
    damage = 130,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "when_any_obstacle" },
}

local ligtnin3: Chip = {
    action = spawners.action { id = "ligtnin3/action", spawn = RAISE },
    codes = { "H", "J", "Q" },
    element = Element.elec,
    family = Family.elec,
    class = ChipClass.standard,
    rarity = 3,
    mb = 53,
    damage = 160,
    counter = 20,
    lockout = 0,
    flags = { has_damage = true, library = true },
    auto_battle = { class = "when_any_obstacle" },
}

return { ligtnin1 = ligtnin1, ligtnin2 = ligtnin2, ligtnin3 = ligtnin3 }
