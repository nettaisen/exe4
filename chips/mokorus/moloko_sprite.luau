--!strict
-- The moloko sprite: its animations, each its frames' durations in ticks.
return asset.sprite("moloko", {
    { 2 },
    { 2 },
    { 2, 2, 2, 2, loop = true },
    { 2, 2, 2, 2, loop = true },
    { 2, 2, 2, 2, 2, 3, 3, 2 },
})
