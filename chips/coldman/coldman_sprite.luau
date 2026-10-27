--!strict
-- The coldman sprite: its animations, each its frames' durations in ticks.
return asset.sprite("coldman", {
    { 1 },
    { 3, 2, 3, 1 },
    { 1 },
    { 1, 2 },
    { 2, 1 },
    { 1, 3, 5 },
    { 3, 10 },
    { 3, 1 },
    { 1, 3, 5 },
    { 5, 5, loop = true },
    { 3, 1 },
    { 1, 3, 3, 2, 2, 1 },
    { 3, 5, 3, 1 },
    { 3, 3, 1 },
    { 3, 3 },
    { 10, 8, 10, 8, loop = true },
    { 5, 5 },
})
