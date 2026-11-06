--!strict
-- Collision types (docs/engine/field-collision-damage.md §3.3): what an object is (its self type) and what it
-- reaches (its target type), by its members (of the object's side, `own_`, or the other's, `enemy_`: side 1's
-- word side 0's mirrored), from EXE4's table (0x08012660: 61 rows, EXE5's first 61 the same words), EXE5's names
-- by row (content/exe5/rules/collision.luau). `row_offset` as EXE5's.
-- Written by tools/exe4/gen_rules.py (bn6battle-verify) from the EXE4 ROM; people own it now.

local collision = {}

collision.attack = new.collision { flags = { "own_attack" }, row_offset = 0x20 }
collision.thrown = new.collision { flags = { "own_attack", "reaches_submerged" }, row_offset = 0x50 }
collision.slash = new.collision { flags = { "own_attack", "sword" }, row_offset = 0x38 }
collision.thrown_slash = new.collision { flags = { "own_attack", "sword", "reaches_submerged" }, row_offset = 0xe0 }
collision.piercing = new.collision { flags = { "own_attack", "piercing" }, row_offset = 0x58 }
collision.hits_navis = new.collision {
    flags = { "enemy_object", "enemy_body", "enemy_other_body", "neutral" },
    row_offset = 0x28,
}
collision.hit_by_other_side = new.collision {
    flags = { "enemy_attack", "enemy_object", "enemy_body", "enemy_other_body", "neutral" },
    row_offset = 0xa0,
}
collision.hit_by_other_side_or_blockers = new.collision {
    flags = { "enemy_attack", "enemy_object", "enemy_body", "enemy_other_body", "neutral", "reaches_set_objects" },
    row_offset = 0x68,
}
collision.piercing_break = new.collision { flags = { "own_attack", "piercing", "break" }, row_offset = 0xb0 }
collision.own_object = new.collision { flags = { "own_object", "hits_while_dimmed" }, row_offset = 0x60 }
collision.everything = new.collision {
    flags = {
        "own_attack",
        "enemy_attack",
        "own_object",
        "enemy_object",
        "own_body",
        "enemy_body",
        "own_other_body",
        "enemy_other_body",
        "neutral",
        "break",
    },
    row_offset = 0x78,
}
collision.hit_by_other_attacks = new.collision { flags = { "enemy_attack", "enemy_object" }, row_offset = 0xc0 }
collision.mine = new.collision {
    flags = { "own_attack", "enemy_attack", "reaches_set_objects", "reaches_submerged", "piercing", "break" },
    row_offset = 0x198,
}
collision.hits_both_sides = new.collision {
    flags = { "own_object", "enemy_object", "own_body", "enemy_body", "enemy_other_body", "neutral" },
    row_offset = 0x150,
}
collision.navi = new.collision { flags = { "own_body", "own_navi", "hits_while_dimmed" }, row_offset = 0x8 }
collision.navi_target = new.collision {
    flags = { "enemy_attack", "enemy_object", "enemy_body", "enemy_other_body", "neutral", "pull" },
    row_offset = 0x10,
}
collision.floating_navi = new.collision {
    flags = { "own_body", "own_navi", "floating", "hits_while_dimmed" },
    row_offset = 0x80,
}
collision.thrown_break = new.collision { flags = { "own_attack", "reaches_submerged", "break" }, row_offset = 0xa8 }
collision.thrown_piercing_break = new.collision {
    flags = { "own_attack", "reaches_submerged", "piercing", "break" },
    row_offset = 0xb8,
}
collision.pull = new.collision { flags = { "no_guard_spark", "pull" }, row_offset = 0xf0 }
collision.breaking = new.collision { flags = { "own_attack", "break" }, row_offset = 0x30 }
collision.chip_destruction = new.collision { flags = { "own_attack", "chip_destruction" }, row_offset = 0x40 }
collision.pushing = new.collision { flags = { "own_attack", "pushing" }, row_offset = 0x90 }
collision.curse = new.collision { flags = { "own_attack", "reaches_submerged", "piercing" }, row_offset = 0xc8 }
collision.attack_480 = new.collision { flags = { "own_attack", "dark" }, row_offset = 0x128 }
collision.neutral_body = new.collision { flags = { "neutral", "hits_while_dimmed", "break" }, row_offset = 0x70 }
collision.nothing = new.collision { flags = {}, row_offset = 0x0 }
collision.own_body = new.collision { flags = { "own_other_body", "hits_while_dimmed" }, row_offset = 0x98 }
collision.guard_breaking = new.collision {
    flags = { "own_attack", "no_guard_spark", "breaks_guard" },
    row_offset = 0x190,
}
collision.drain = new.collision {
    flags = { "own_attack", "no_guard_spark", "reaches_submerged", "piercing" },
    row_offset = 0x160,
}
collision.breaking_drain = new.collision {
    flags = { "own_attack", "no_guard_spark", "reaches_submerged", "piercing", "break" },
    row_offset = 0x180,
}
collision.collision_03 = new.collision {
    flags = { "enemy_attack", "enemy_object", "enemy_other_body", "neutral", "drain" },
    row_offset = 0x18,
}
collision.collision_09 = new.collision { flags = { "own_attack", "drain" }, row_offset = 0x48 }
collision.collision_11 = new.collision { flags = { "own_attack", "sword", "dark" }, row_offset = 0x88 }
collision.collision_1a = new.collision {
    flags = { "own_attack", "chip_destruction", "reaches_submerged", "piercing", "break" },
    row_offset = 0xd0,
}
collision.collision_1b = new.collision { flags = { "own_attack", "no_guard_spark", "wind" }, row_offset = 0xd8 }
collision.collision_1d = new.collision {
    flags = { "own_attack", "chip_destruction", "reaches_submerged", "piercing" },
    row_offset = 0xe8,
}
collision.collision_1f = new.collision { flags = { "own_attack", "reaches_set_objects", "break" }, row_offset = 0xf8 }
collision.collision_20 = new.collision { flags = { "own_attack", "pushing", "reaches_submerged" }, row_offset = 0x100 }
collision.collision_21 = new.collision {
    flags = { "own_attack", "reaches_set_objects", "reaches_submerged", "break" },
    row_offset = 0x108,
}
collision.collision_22 = new.collision {
    flags = {
        "own_attack",
        "enemy_attack",
        "reaches_set_objects",
        "ground_only",
        "reaches_submerged",
        "piercing",
        "break",
    },
    row_offset = 0x110,
}
collision.collision_23 = new.collision { flags = { "blocker" }, row_offset = 0x118 }
collision.collision_24 = new.collision {
    flags = { "own_attack", "pushing", "dark", "reaches_submerged" },
    row_offset = 0x120,
}
collision.collision_26 = new.collision {
    flags = { "own_attack", "enemy_attack", "reaches_set_objects", "reaches_submerged" },
    row_offset = 0x130,
}
collision.collision_27 = new.collision {
    flags = { "own_attack", "enemy_attack", "reaches_set_objects", "ground_only", "break" },
    row_offset = 0x138,
}
collision.collision_28 = new.collision { flags = { "own_attack", "sword", "piercing", "break" }, row_offset = 0x140 }
collision.collision_29 = new.collision {
    flags = { "own_other_body", "hits_while_dimmed", "break" },
    row_offset = 0x148,
}
collision.collision_2d = new.collision {
    flags = { "own_attack", "no_guard_spark", "reaches_submerged", "break" },
    row_offset = 0x168,
}
collision.collision_2e = new.collision {
    flags = { "own_attack", "no_guard_spark", "piercing", "break" },
    row_offset = 0x170,
}
collision.collision_2f = new.collision {
    flags = { "own_attack", "no_guard_spark", "reaches_submerged" },
    row_offset = 0x178,
}
collision.collision_31 = new.collision {
    flags = { "own_attack", "no_guard_spark", "breaks_guard", "piercing" },
    row_offset = 0x188,
}
collision.collision_35 = new.collision {
    flags = { "own_body", "own_navi", "hits_while_dimmed", "break" },
    row_offset = 0x1a8,
}
collision.collision_36 = new.collision { flags = { "own_attack", "no_guard_spark", "break" }, row_offset = 0x1b0 }
collision.collision_37 = new.collision {
    flags = { "own_other_body", "hits_while_dimmed", "reaches_submerged", "break" },
    row_offset = 0x1b8,
}
collision.collision_38 = new.collision {
    flags = { "own_body", "enemy_body", "own_other_body", "enemy_other_body", "neutral" },
    row_offset = 0x1c0,
}
collision.collision_39 = new.collision {
    flags = { "own_body", "own_navi", "floating", "hits_while_dimmed", "break" },
    row_offset = 0x1c8,
}
collision.collision_3a = new.collision {
    flags = { "own_body", "own_navi", "hits_while_dimmed", "reaches_submerged", "break" },
    row_offset = 0x1d0,
}
collision.collision_3b = new.collision { flags = { "own_object", "hits_while_dimmed", "break" }, row_offset = 0x1d8 }
collision.collision_3c = new.collision {
    flags = { "own_attack", "no_guard_spark", "reaches_submerged", "break" },
    row_offset = 0x1e0,
}
collision.collision_2b = new.collision { flags = { "own_attack", "dark", "reaches_submerged" }, row_offset = 0x158 }
collision.collision_34 = new.collision { flags = { "own_attack", "no_guard_spark", "piercing" }, row_offset = 0x1a0 }

return collision
