--!strict
-- The water-gun sprite: its animations, each its frames' durations in ticks.
return asset.sprite("water-gun", {
    { 1, 1, 1, 1, 2 },
    { 2 },
    { 3, 3, 3 },
    { 2, 2, 2, loop = true },
    { 2, 2, 1 },
    { 2, 2, 2, 2, loop = true },
})
