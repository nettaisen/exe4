--!strict
-- MegaMan's machine gun as a charged shot (`megaman/machine_gun`, weapon routine 0x28, 0x0800D01E: patch card 20): the
-- routine sets no attack variable and starts action 0x10, GutsSoul's machine gun (../forms/guts_soul/machine_gun), whose
-- shots' damage is their own. Its charge row (0x28): 60 ticks at every Charge.

local machine_gun_action = require("../forms/guts_soul/machine_gun").action

local machine_gun = {}

machine_gun.weapon = new.weapon {
    id = "megaman/machine_gun",
    charge_ticks = { 60, 60, 60, 60, 60, 60 },
    -- 0x0800D01E.
    setup = function(_navi: Object): Action
        return machine_gun_action
    end,
}

return machine_gun
