--!strict
-- The side's wind (the battle state's +0x88 + 4 × side: @exelib/wind/registry), in the rules' state: what Wind and
-- Fan's fan (chips/wind/fan) and WindSoul's own wind (objects/wind) fill and read, and the encasing's end empties
-- (./roles).

local wind = {}

-- Its part of the rules' state (./init).
wind.state = {
    wind = { object = "object", source = { "obstacle", "navi" } },
} :: StateSchema

-- The side's slot.
function wind.of(side: number): WindSlot
    return (rules.state_of(side) :: { wind: WindSlot }).wind
end

return wind
