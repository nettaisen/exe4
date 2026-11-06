--!strict
-- EXE4's move bug (NaviStats +0x0D, the rules' stat `move_bug`, which `effects.steps.bug` names), by what it does: with no
-- key held, the key it holds steps the navi (the joypad's KEYINPUT bits: right 0x10, left 0x20); confused (0xFF), the
-- navi is confused for 720 ticks as the round starts; none, no bug.

return {
    none = 0,
    right = 0x10,
    left = 0x20,
    confused = 0xFF,
}
