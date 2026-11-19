--!strict
-- EXE4's forms (docs/design/content-model-v2.md §4.0), by id: the tables of the modules that define them as one, which
-- the game's init.luau returns as its `forms`. Written by tools/content/index.py (the verification workspace) from the
-- modules that are there: run it again rather than edit this, also to settle a merge conflict in it.

local merge = require("@exelib/merge")

return merge {
    -- Forms.
    require("@self/aqua_soul"),
    require("@self/base"),
    require("@self/dark_soul"),
    require("@self/fire_soul"),
    require("@self/guts_soul"),
    require("@self/junk_soul"),
    require("@self/metal_soul"),
    require("@self/number_soul"),
    require("@self/proto_soul"),
    require("@self/roll_soul"),
    require("@self/search_soul"),
    require("@self/thunder_soul"),
    require("@self/wind_soul"),
    require("@self/wood_soul"),
}
