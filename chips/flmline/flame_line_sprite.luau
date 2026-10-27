--!strict
-- The flame-line sprite: its animations, each its frames' durations in ticks.
return asset.sprite("flame-line", {
    { 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, loop = true },
    { 1, 1, 1 },
    { 1, 2, 2, 2 },
    { 2, 2, 2, 1 },
})
