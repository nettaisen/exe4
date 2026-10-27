--!strict
-- The topman sprite: its animations, each its frames' durations in ticks.
return asset.sprite("topman", {
    { 2 },
    { 4, 2, 2, 2, 2, 2, 4, 4, 2 },
    { 1 },
    { 4, 4, loop = true },
    { 1, 3, 3, 4 },
    { 4, 2, 3, 3, 3, 4 },
    { 2, 2, 2, 2, loop = true },
    { 2, 4, 2 },
    { 2, 2, 2, 2, loop = true },
})
