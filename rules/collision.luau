--!strict
-- Collision types (docs/engine/field-collision-damage.md §3.3): what an object is (its self type) and what it
-- reaches (its target type), by its members (of the object's side, `own_`, or the other's, `enemy_`: side 1's
-- word side 0's mirrored), from EXE4's table (0x08012660: 61 rows, EXE5's first 61 the same words), EXE5's names
-- by row (content/exe5/rules/collision.luau). Each type's row is compat's (rules.toml).
-- Written by tools/exe4/gen_rules.py (bn6battle-verify) from the EXE4 ROM; people own it now.

local collision = {}

collision.attack = new.collision { flags = { own_attack = true } }
collision.thrown = new.collision { flags = { own_attack = true, reaches_submerged = true } }
collision.slash = new.collision { flags = { own_attack = true, sword = true } }
collision.thrown_slash = new.collision { flags = { own_attack = true, sword = true, reaches_submerged = true } }
collision.piercing = new.collision { flags = { own_attack = true, piercing = true } }
collision.hits_navis = new.collision {
    flags = { enemy_object = true, enemy_body = true, enemy_other_body = true, neutral = true },
}
collision.hit_by_other_side = new.collision {
    flags = { enemy_attack = true, enemy_object = true, enemy_body = true, enemy_other_body = true, neutral = true },
}
collision.hit_by_other_side_or_blockers = new.collision {
    flags = {
        enemy_attack = true,
        enemy_object = true,
        enemy_body = true,
        enemy_other_body = true,
        neutral = true,
        reaches_set_objects = true,
    },
}
collision.piercing_break = new.collision { flags = { own_attack = true, piercing = true, ["break"] = true } }
collision.own_object = new.collision { flags = { own_object = true, hits_while_dimmed = true } }
collision.everything = new.collision {
    flags = {
        own_attack = true,
        enemy_attack = true,
        own_object = true,
        enemy_object = true,
        own_body = true,
        enemy_body = true,
        own_other_body = true,
        enemy_other_body = true,
        neutral = true,
        ["break"] = true,
    },
}
collision.hit_by_other_attacks = new.collision { flags = { enemy_attack = true, enemy_object = true } }
collision.mine = new.collision {
    flags = {
        own_attack = true,
        enemy_attack = true,
        reaches_set_objects = true,
        reaches_submerged = true,
        piercing = true,
        ["break"] = true,
    },
}
collision.hits_both_sides = new.collision {
    flags = {
        own_object = true,
        enemy_object = true,
        own_body = true,
        enemy_body = true,
        enemy_other_body = true,
        neutral = true,
    },
}
collision.navi = new.collision { flags = { own_body = true, own_navi = true, hits_while_dimmed = true } }
collision.navi_target = new.collision {
    flags = {
        enemy_attack = true,
        enemy_object = true,
        enemy_body = true,
        enemy_other_body = true,
        neutral = true,
        pull = true,
    },
}
collision.floating_navi = new.collision {
    flags = { own_body = true, own_navi = true, floating = true, hits_while_dimmed = true },
}
collision.thrown_break = new.collision { flags = { own_attack = true, reaches_submerged = true, ["break"] = true } }
collision.thrown_piercing_break = new.collision {
    flags = { own_attack = true, reaches_submerged = true, piercing = true, ["break"] = true },
}
collision.pull = new.collision { flags = { no_guard_spark = true, pull = true } }
collision.breaking = new.collision { flags = { own_attack = true, ["break"] = true } }
collision.chip_destruction = new.collision { flags = { own_attack = true, chip_destruction = true } }
collision.pushing = new.collision { flags = { own_attack = true, pushing = true } }
collision.curse = new.collision { flags = { own_attack = true, reaches_submerged = true, piercing = true } }
collision.attack_480 = new.collision { flags = { own_attack = true, dark = true } }
collision.neutral_body = new.collision { flags = { neutral = true, hits_while_dimmed = true, ["break"] = true } }
collision.nothing = new.collision { flags = {} }
collision.own_body = new.collision { flags = { own_other_body = true, hits_while_dimmed = true } }
collision.guard_breaking = new.collision { flags = { own_attack = true, no_guard_spark = true, breaks_guard = true } }
collision.drain = new.collision {
    flags = { own_attack = true, no_guard_spark = true, reaches_submerged = true, piercing = true },
}
collision.breaking_drain = new.collision {
    flags = { own_attack = true, no_guard_spark = true, reaches_submerged = true, piercing = true, ["break"] = true },
}
collision.collision_03 = new.collision {
    flags = { enemy_attack = true, enemy_object = true, enemy_other_body = true, neutral = true, drain = true },
}
collision.collision_09 = new.collision { flags = { own_attack = true, drain = true } }
collision.collision_11 = new.collision { flags = { own_attack = true, sword = true, dark = true } }
collision.collision_1a = new.collision {
    flags = { own_attack = true, chip_destruction = true, reaches_submerged = true, piercing = true, ["break"] = true },
}
collision.collision_1b = new.collision { flags = { own_attack = true, no_guard_spark = true, wind = true } }
collision.collision_1d = new.collision {
    flags = { own_attack = true, chip_destruction = true, reaches_submerged = true, piercing = true },
}
collision.collision_1f = new.collision { flags = { own_attack = true, reaches_set_objects = true, ["break"] = true } }
collision.collision_20 = new.collision { flags = { own_attack = true, pushing = true, reaches_submerged = true } }
collision.collision_21 = new.collision {
    flags = { own_attack = true, reaches_set_objects = true, reaches_submerged = true, ["break"] = true },
}
collision.collision_22 = new.collision {
    flags = {
        own_attack = true,
        enemy_attack = true,
        reaches_set_objects = true,
        ground_only = true,
        reaches_submerged = true,
        piercing = true,
        ["break"] = true,
    },
}
collision.collision_23 = new.collision { flags = { blocker = true } }
collision.collision_24 = new.collision {
    flags = { own_attack = true, pushing = true, dark = true, reaches_submerged = true },
}
collision.collision_26 = new.collision {
    flags = { own_attack = true, enemy_attack = true, reaches_set_objects = true, reaches_submerged = true },
}
collision.collision_27 = new.collision {
    flags = {
        own_attack = true,
        enemy_attack = true,
        reaches_set_objects = true,
        ground_only = true,
        ["break"] = true,
    },
}
collision.collision_28 = new.collision {
    flags = { own_attack = true, sword = true, piercing = true, ["break"] = true },
}
collision.collision_29 = new.collision { flags = { own_other_body = true, hits_while_dimmed = true, ["break"] = true } }
collision.collision_2d = new.collision {
    flags = { own_attack = true, no_guard_spark = true, reaches_submerged = true, ["break"] = true },
}
collision.collision_2e = new.collision {
    flags = { own_attack = true, no_guard_spark = true, piercing = true, ["break"] = true },
}
collision.collision_2f = new.collision {
    flags = { own_attack = true, no_guard_spark = true, reaches_submerged = true },
}
collision.collision_31 = new.collision {
    flags = { own_attack = true, no_guard_spark = true, breaks_guard = true, piercing = true },
}
collision.collision_35 = new.collision {
    flags = { own_body = true, own_navi = true, hits_while_dimmed = true, ["break"] = true },
}
collision.collision_36 = new.collision { flags = { own_attack = true, no_guard_spark = true, ["break"] = true } }
collision.collision_37 = new.collision {
    flags = { own_other_body = true, hits_while_dimmed = true, reaches_submerged = true, ["break"] = true },
}
collision.collision_38 = new.collision {
    flags = { own_body = true, enemy_body = true, own_other_body = true, enemy_other_body = true, neutral = true },
}
collision.collision_39 = new.collision {
    flags = { own_body = true, own_navi = true, floating = true, hits_while_dimmed = true, ["break"] = true },
}
collision.collision_3a = new.collision {
    flags = { own_body = true, own_navi = true, hits_while_dimmed = true, reaches_submerged = true, ["break"] = true },
}
collision.collision_3b = new.collision { flags = { own_object = true, hits_while_dimmed = true, ["break"] = true } }
collision.collision_3c = new.collision {
    flags = { own_attack = true, no_guard_spark = true, reaches_submerged = true, ["break"] = true },
}
collision.collision_2b = new.collision { flags = { own_attack = true, dark = true, reaches_submerged = true } }
collision.collision_34 = new.collision { flags = { own_attack = true, no_guard_spark = true, piercing = true } }

return collision
