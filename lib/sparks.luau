--!strict
-- EXE4's hit sparks: what shows where a hit lands (`collision:set_hit_effect`). EXE4's spark table (0x080E2090, rows
-- 0 to 0x0C: sprite, animation, palette) is EXE5's rows 0 to 0x0C (0x080E0814) with EXE4's sprites; its spark (0x080E20E4)
-- is EXE5's code.

local sparks = {}

local HIT_SPARKS = asset.sprite("hit-sparks")
local chip_destruction_spark_sprite = asset.sprite("chip-destruction-spark")
local explosion_sprite = asset.sprite("explosion")
local hit_sprite = asset.sprite("hit")
local impact_sprite = asset.sprite("impact")
local pink_flash_sprite = asset.sprite("pink-flash")

-- By primary element (null, fire, aqua, elec, wood, and the drain): hit effects 0 to 5.
local BY_ELEMENT: { [string]: Spark } = {
    null = new.spark { sprite = HIT_SPARKS, anim = 0, palette = 0, steps = 5 },
    fire = new.spark { sprite = HIT_SPARKS, anim = 2, palette = 0, steps = 18 },
    aqua = new.spark { sprite = HIT_SPARKS, anim = 3, palette = 0, steps = 14 },
    elec = new.spark { sprite = HIT_SPARKS, anim = 4, palette = 0, steps = 14 },
    wood = new.spark { sprite = HIT_SPARKS, anim = 5, palette = 0, steps = 16 },
    drain = new.spark { sprite = pink_flash_sprite, anim = 0, palette = 0, steps = 10 },
}

-- The plain hit (spark 0) and the charged shot's (5).
sparks.plain = BY_ELEMENT.null
sparks.charged = BY_ELEMENT.drain
-- The element sparks by name (hit effects 1 to 4).
sparks.fire, sparks.aqua, sparks.elec, sparks.wood = BY_ELEMENT.fire, BY_ELEMENT.aqua, BY_ELEMENT.elec, BY_ELEMENT.wood
-- A heavy hit's (6).
sparks.heavy = new.spark { sprite = HIT_SPARKS, anim = 8, palette = 0, steps = 5 }
-- A cannon's impact (7).
sparks.impact = new.spark { sprite = impact_sprite, anim = 0, palette = 0, steps = 26 }
-- A guarded hit's (8).
sparks.guard = new.spark { sprite = hit_sprite, anim = 0, palette = 0, steps = 10 }
-- The chip destruction hit spark (9).
sparks.chip_destruction = new.spark { sprite = chip_destruction_spark_sprite, anim = 0, palette = 0, steps = 15 }
-- A breaking hit (0x0A).
sparks.breaking = new.spark { sprite = HIT_SPARKS, anim = 1, palette = 0, steps = 10 }
-- A blast (0x0B).
sparks.blast = new.spark { sprite = explosion_sprite, anim = 0, palette = 0, steps = 27 }
-- The erase beams' (0x0C).
sparks.erase = new.spark { sprite = pink_flash_sprite, anim = 0, palette = 2, steps = 10 }

-- 0x08012F7A (EXE6's `sub_801A146`): the spark of an attack of `element`, its whole element byte (EXE4 masks none of
-- it), hit effects 0 to 5.
function sparks.of_element(element: Element): Spark
    local p = element.primary
    local s = if p and element == Element.new(p) then BY_ELEMENT[p.name] else nil
    if not s then
        error(string.format("0x08012F7A: element %s has no hit spark", tostring(element)))
    end
    return s
end

return sparks
