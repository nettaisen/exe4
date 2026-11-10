--!strict
-- EXE4's rulesets: what a ruleset may hold back of a build, and the rulesets the game offers ready-made, as data
-- (nettai-match's `ruleset`, for nettai's lobby and build screens; docs/design/rules-in-luau.md, "Rulesets";
-- docs/design/versions.md §2.3). The simulation reads none of it: a ruleset says which builds may play a match, never
-- how its rounds play. A category is a fact of the setup (../init.luau's `setup`) that names definitions, by the fact's
-- name; what it ranges over is the fact's type's. The groups a ruleset offers as quick choices and holds a build to are
-- the versions (./builds), each with what it states that the other doesn't (its six souls and five Giga chips; Duo is
-- both's). EXE4 has no navi but MegaMan, so no category of navis. Names are the locales' ([rulesets],
-- `category.<fact>`, `limit.<name>`, `preset.<id>`).

return {
    -- In the order a ruleset's page lists them.
    categories = {
        { fact = "folder" },
        { fact = "navicust_programs" },
        { fact = "patch_cards" },
        { fact = "souls" },
        -- The auto battle data's places (./auto_battle/block), a page of their own (the user: "you should instead have a
        -- separate abd rules page"): the chips a folder lists, and the Program Advances besides (`classes`), which the
        -- program advance list holds and no folder does. What the folder's category holds back is allowed here.
        { fact = "auto_battle_places", classes = { program_advance = true } },
    },
    -- The limits a ruleset may change, in the order its page lists them: each by the name the rules ask it by
    -- (`battle.limit`: @exelib/folder_rules), with the most a ruleset may set it to and the number its page first
    -- offers (`start`: the rules' own, where that is one number). A ruleset leaves a limit the rules' own, sets a
    -- number of its own up to that, or lifts it; a build's checks hold it to them (`build_check`), a match's don't.
    limits = {
        { name = "copies", most = 30, start = 4 },
        { name = "mega", most = 30, start = 5 },
        { name = "giga", most = 30, start = 1 },
        { name = "regular_memory", most = 99, start = 50 },
    },
    -- The rulesets ready-made, the first a player's and a new lobby's until they pick another. `versions`: whether each
    -- build must be one version's (`one_per_build`: what it holds of the versions' own things all one's) or `mixed`;
    -- `only`: what a category allows, by the items' names (a category it doesn't name allows everything). Masters class
    -- is the cartridges' own rules, one version per build with patch cards; Senior class the same without patch cards;
    -- Unrestricted lets a build mix the versions (the user: "no patch card rules is known as "senior class". patch card
    -- rules is known as "masters class". mixed rules is known as "unrestricted". get rid of version only rules").
    presets = {
        { id = "masters", versions = "one_per_build" },
        { id = "senior", versions = "one_per_build", only = { patch_cards = {} } },
        { id = "unrestricted", versions = "mixed" },
    },
}
