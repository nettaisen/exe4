--!strict
-- When the souls' part of the navi's intake is asked (the rules' `navi_intake`, ../init: ./init's `grass_heal` and
-- `navi_intake`; rules.listen): while something can come of it. In a soul (WoodSoul's heal on grass, the turns'
-- revert, the dark soul's ticks); the dark soul asked for; a change asked for, which the intake drops or keeps; a soul's
-- chip in the side's hand, which it asks the change for (the hand's chips change as it is installed); a navi of the
-- navi type on the side, whose own chip it reads. Else it would only drop a change no one asked for. What brings one of
-- these asks again (the hand's install, the dark soul's ask, a soul's emerging and revert), and so does the intake.

local chip_hand = require("@exelib/chip_hand")

local intake = {}

local function needed(side: number): boolean
    if not battle.navi(side).form.base then
        return true
    end
    if (rules.state_of(side) :: { dark_soul_asked: boolean }).dark_soul_asked then
        return true
    end
    for i = 1, 4 do
        local navi = battle.alive_actor_slot(side, i)
        if navi ~= nil and (navi.actor_type == "navi" or navi:request("form_change")) then
            return true
        end
    end
    for i = 0, 5 do
        local chip = chip_hand.chip(side, i)
        if chip ~= nil and chip.family == "special" then
            return true
        end
    end
    return false
end

function intake.listen(side: number)
    rules.listen(side, "navi_intake", needed(side))
end

return intake
