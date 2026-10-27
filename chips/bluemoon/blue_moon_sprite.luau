--!strict
-- The blue-moon sprite: its animations, each its frames' durations in ticks.
return asset.sprite("blue-moon", {
    { 2, 2, 2, 2, 3, 12, 3, 2, 3, 2, 3, 2, 3, 2, 2 },
    { 2, 2, 2, 3, loop = true },
    { 3, 2, 4 },
})
