--!strict
-- WindSoul's charged shot (`wind_soul/charged_shot`): weapon routine 0x09 (0x0800D204): WindRack's attack (chip 0x035,
-- loaded as 0x0800D406 loads a chip) with 50 damage and counter byte 0x9E, and WindRack's use (its action 0x32).

local wind_racket = require("../../../../chips/wind_racket").wind_racket

local charge = {}

-- 0x0800D204.
local function setup(navi: Object): Chip
    navi:load_chip_attack(wind_racket)
    navi.attack_word = damage_word.of { amount = 50, counter = 30, cant_counter = true }
    return wind_racket
end

charge.weapon = new.weapon {
    id = "wind_soul/charged_shot",
    -- The charge table's row 0x09 (0x080180B8 by AIData +0x0F), by Charge 0 to 4; Charge 5 reads on into row 0x0A's
    -- first entry.
    charge_ticks = { 60, 60, 60, 60, 60, 100 },
    setup = setup,
}

return charge
