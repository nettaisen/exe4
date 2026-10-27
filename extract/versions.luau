--!strict
-- What is a version's own, which the pack takes from a ROM of that version (its US ROM: `MEGAMANBN4RS`, B4WE, or
-- `MEGAMANBN4BM`, B4BE). The same code reaches it in every ROM, so the places are the other modules'; here is which
-- of them are a version's.
--
-- - A version's own giga chips (compat/chips.toml's `version`): every ROM has every chip's record, the other
--   version's too; the pack has each one's picture and icon from a ROM of its version, marked with it (custom.luau's
--   `chip_art`). Every other chip's are a Red Sun ROM's, as four chips' icons aren't the same in a Blue Moon ROM and
--   the pack has Red Sun's.
-- - Each version's souls' faces in the emotion window (hud.luau's `mugshots`).

local names = require("@exelib/extract/names")

local versions = {}

-- The versions, as the pack has what is a version's own under (the base version first).
versions.RED_SUN = "redsun"
versions.BLUE_MOON = "bluemoon"

-- Each version's US ROM: the pack has a version's own from it.
function versions.rom(set: Set, version: string): Rom
    return if version == versions.BLUE_MOON then set.B4BE else set.B4WE
end

-- The version chips' versions (chips.toml's `version`), by chip number.
function versions.chips(): { [number]: string }
    local chips = data("compat/chips.toml")
    local out: { [number]: string } = {}
    for _, key in names.sorted(chips) do
        local v = chips[key].version
        if v ~= nil then
            if v ~= versions.RED_SUN and v ~= versions.BLUE_MOON then
                local red, blue = versions.RED_SUN, versions.BLUE_MOON
                error(string.format("chips.toml: %s's version is %q, not %s or %s", key, v, red, blue), 0)
            end
            out[chips[key].id] = v
        end
    end
    return out
end

-- The ROM chip `id`'s picture and icon are read from, by the versions `versions.chips` gives: its own version's, a Red
-- Sun ROM for any other chip.
function versions.chip_source(set: Set, chip_versions: { [number]: string }, id: number): Rom
    return versions.rom(set, chip_versions[id] or versions.RED_SUN)
end

return versions
