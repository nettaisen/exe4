--!strict
-- The weapon routines that fire a chip, which the patch cards name for MegaMan's B button, charged shot and B+Left
-- special (NaviStats +0x09, +0x0A, +0x0C: the table at 0x0800CA7C): each loads the chip as the attack (0x0800D406,
-- EXE5's 0x0800FE78: the chip's record's damage and hit parameter, lockout, element, variant and parameters; no extra)
-- and starts the chip's use. Each weapon is its routine (`megaman/<chip>`), its charge time the charge table's row
-- (0x080180B8, by the routine) by Charge 0 to 4, Charge 5 reading on into the next row's first entry.
--
-- The rest wait on their chips (docs/design/exe4-map.md §18 item 57).

local air_shot = require("../../../chips/air_shot").air_shot
local anti_chips = require("../../../chips/anti")
local cannon_ball = require("../../../chips/cannon_ball").cannon_ball
local breath_chips = require("../../../chips/breath")
local bubbler = require("../../../chips/bubbler").bubbler
local bug_bomb = require("../../../chips/bug_bomb").bug_bomb
local cannon = require("../../../chips/cannon").cannon
local copy_damage = require("../../../chips/copy_damage").copy_damage
local crakout_chips = require("../../../chips/crack_out")
local energbom_chips = require("../../../chips/energy_bomb")
local full_custom = require("../../../chips/full_custom").full_custom
local guard_chips = require("../../../chips/guard")
local heat_shot = require("../../../chips/heat_shot").heat_shot
local hole = require("../../../chips/hole").hole
local lance = require("../../../chips/lance").lance
local mini_bomb = require("../../../chips/mini_bomb").mini_bomb
local north_wind = require("../../../chips/north_wind").north_wind
local panel_return = require("../../../chips/panel_return").panel_return
local recov_chips = require("../../../chips/recov")
local repair = require("../../../chips/repair").repair
local sand_ring = require("../../../chips/sand_ring").sand_ring
local spreader = require("../../../chips/spreader").spreader
local sword_chips = require("../../../chips/sword")
local thunder_chips = require("../../../chips/thunder")
local widesht_chips = require("../../../chips/wide_shot")
local wind_racket = require("../../../chips/wind_racket").wind_racket

local chips = {}

-- The weapon `id` that loads `chip` (0x0800D406) and starts its use, charging for `ticks` (its row).
local function fires(id: string, chip: Chip, ticks: { number }): Weapon
    return new.weapon {
        id = id,
        charge_ticks = ticks,
        setup = function(navi: Object): Chip
            navi:load_chip_attack(chip)
            return chip
        end,
    }
end

-- Rows 0x29 to 0x62 of the charge table: 60 ticks at every Charge, but the Thunders' and WideShts' 120, 150 and 180,
-- FullCust's 90, and the Charge 5 of Bubbler, CopyDmg, Hole, EnergBom, FullCust, ElecShok and Guard1 (rows 0x2D's,
-- 0x38's, 0x43's, 0x46's, 0x4C's, 0x61's and 0x63's first entries).
local SIXTY: { number } = { 60, 60, 60, 60, 60, 60 }

chips.cannon = fires("megaman/cannon", cannon, SIXTY) -- 0x29
chips.mini_bomb = fires("megaman/mini_bomb", mini_bomb, SIXTY) -- 0x2A
chips.heat_shot = fires("megaman/heat_shot", heat_shot, SIXTY) -- 0x2B
chips.bubbler = fires("megaman/bubbler", bubbler, { 60, 60, 60, 60, 60, 120 }) -- 0x2C
chips.thunder_1 = fires("megaman/thunder_1", thunder_chips.thunder_1, { 120, 120, 120, 120, 120, 60 }) -- 0x2D
chips.sword = fires("megaman/sword", sword_chips.sword, SIXTY) -- 0x2E
chips.spreader = fires("megaman/spreader", spreader, SIXTY) -- 0x2F
-- 0x0800D074 (routine 0x31, card 40's B+Left): one of the eight Anti chips (0x0800D094: 0x8C to 0x93) at random (an
-- RNG2 draw), loaded as the attack; then its parameters' fourth byte (AIAttackVars +0x0F) 1: the trap's telop
-- shows "????" to its user too.
local ANTI_CHIPS: { Chip } = {
    anti_chips.anti_fire,
    anti_chips.anti_water,
    anti_chips.anti_elec,
    anti_chips.anti_wood,
    anti_chips.anti_navi,
    anti_chips.anti_damage,
    anti_chips.anti_sword,
    anti_chips.anti_recovery,
}
chips.anti_chip = new.weapon {
    id = "megaman/anti_chip",
    charge_ticks = SIXTY,
    setup = function(navi: Object): Chip
        local chip = ANTI_CHIPS[battle.rng_positive() % #ANTI_CHIPS + 1]
        navi:load_chip_attack(chip)
        navi.telop_hidden = true
        return chip
    end,
} -- 0x31
chips.crack_out = fires("megaman/crack_out", crakout_chips.crack_out, SIXTY) -- 0x36
chips.copy_damage = fires("megaman/copy_damage", copy_damage, { 60, 60, 60, 60, 60, 120 }) -- 0x37
chips.wide_shot_1 = fires("megaman/wide_shot_1", widesht_chips.wide_shot_1, { 120, 120, 120, 120, 120, 60 }) -- 0x38
chips.thunder_2 = fires("megaman/thunder_2", thunder_chips.thunder_2, { 150, 150, 150, 150, 150, 60 }) -- 0x3A
chips.double_crack = fires("megaman/double_crack", crakout_chips.double_crack, SIXTY) -- 0x3C
chips.wide_sword = fires("megaman/wide_sword", sword_chips.wide_sword, SIXTY) -- 0x3E
chips.recovery_10 = fires("megaman/recovery_10", recov_chips.recovery_10, SIXTY) -- 0x40
chips.lance = fires("megaman/lance", lance, SIXTY) -- 0x41
chips.hole = fires("megaman/hole", hole, { 60, 60, 60, 60, 60, 150 }) -- 0x42
chips.wide_shot_2 = fires("megaman/wide_shot_2", widesht_chips.wide_shot_2, { 150, 150, 150, 150, 150, 60 }) -- 0x43
chips.sand_ring = fires("megaman/sand_ring", sand_ring, SIXTY) -- 0x44
chips.energy_bomb = fires("megaman/energy_bomb", energbom_chips.energy_bomb, { 60, 60, 60, 60, 60, 180 }) -- 0x45
chips.thunder_3 = fires("megaman/thunder_3", thunder_chips.thunder_3, { 180, 180, 180, 180, 180, 60 }) -- 0x46
chips.triple_crack = fires("megaman/triple_crack", crakout_chips.triple_crack, SIXTY) -- 0x48
chips.long_sword = fires("megaman/long_sword", sword_chips.long_sword, SIXTY) -- 0x49
chips.full_custom = fires("megaman/full_custom", full_custom, { 90, 90, 90, 90, 90, 180 }) -- 0x4B
chips.wide_shot_3 = fires("megaman/wide_shot_3", widesht_chips.wide_shot_3, { 180, 180, 180, 180, 180, 60 }) -- 0x4C
chips.wind_racket = fires("megaman/wind_racket", wind_racket, SIXTY) -- 0x4E
chips.mega_energy_bomb = fires("megaman/mega_energy_bomb", energbom_chips.mega_energy_bomb, SIXTY) -- 0x4F
chips.cannon_ball = fires("megaman/cannon_ball", cannon_ball, SIXTY) -- 0x50
chips.bug_bomb = fires("megaman/bug_bomb", bug_bomb, SIXTY) -- 0x51
chips.wide_blade = fires("megaman/wide_blade", sword_chips.wide_blade, SIXTY) -- 0x52
chips.long_blade = fires("megaman/long_blade", sword_chips.long_blade, SIXTY) -- 0x53
chips.north_wind = fires("megaman/north_wind", north_wind, SIXTY) -- 0x54
chips.panel_return = fires("megaman/panel_return", panel_return, SIXTY) -- 0x55
chips.blizzard = fires("megaman/blizzard", breath_chips.blizzard, SIXTY) -- 0x5B
chips.heat_breath = fires("megaman/heat_breath", breath_chips.heat_breath, SIXTY) -- 0x5C
chips.woody_powder = fires("megaman/woody_powder", breath_chips.woody_powder, SIXTY) -- 0x5D
chips.repair = fires("megaman/repair", repair, SIXTY) -- 0x5E
chips.air_shot = fires("megaman/air_shot", air_shot, SIXTY) -- 0x5F
chips.elec_shock = fires("megaman/elec_shock", breath_chips.elec_shock, { 60, 60, 60, 60, 60, 80 }) -- 0x60
chips.guard_1 = fires("megaman/guard_1", guard_chips.guard_1, { 60, 60, 60, 60, 60, 20 }) -- 0x62

return chips
