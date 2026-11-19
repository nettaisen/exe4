--!strict
-- EXE4's sparkles (effect object 0x11, 0x080E3328: the shared ones, @exelib/voodoo_doll/sparkles, EXE6's code but for where
-- they show), of EXE4's kind and sound (0x70): they stay where their object was as they started (0x080E3348 keeps its
-- position). SeekBom's bomb bursts in them (chips/seek_bomb).

local common = require("@exelib/voodoo_doll/sparkles")

return common.make { id = "sparkles", sound = asset.sound("hit_bomb_1"), stays = true }
