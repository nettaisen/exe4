--!strict
-- EXE4's MegaMan (navi 0, NaviStats +0x23), from EXE4's tables: his battle sprite (00-00: 0x0800B90A's table by navi,
-- 0x08017F98, his soul's number added to the index), his move lag (4 after a move: 0x0800C208's table 0x0800C240, by
-- the actor's variant, the navi and NaviStats +0x25, every entry 4), his netbattle banner (the navi banner table
-- 0x08008548's entry 0, banner 8: the loser's console shows it; no netbattle shows a win's, the flow's
-- `navi_win_banner`), his weapons (weapons/: the buster and the charged shot, EXE4's own actions), his fresh stats
-- (0x0800D6BE: HP 100 at +0x30, +0x32 and +0x34; the Mega and Giga limits 5 and 1 at +0x13 and +0x14), and his
-- identity: a player (the actor table 0x08003A24's kind 0).
--
-- Not yet (docs/design/exe4-map.md §18): his element and its weakness, the buster's own bonus (EXE4's buster is Attack
-- + 1 whatever the navi), what each soul does (§18 item 74) and the rest of his identity (actor record, AI index, aura).

local buster = require("@self/weapons/buster")
local charged_shot = require("@self/weapons/charged_shot")
local aqua_soul = require("@self/forms/aqua_soul").aqua_soul
local dark_soul = require("@self/forms/dark_soul").dark_soul
local fire_soul = require("@self/forms/fire_soul").fire_soul
local guts_soul = require("@self/forms/guts_soul").guts_soul
local junk_soul = require("@self/forms/junk_soul").junk_soul
local metal_soul = require("@self/forms/metal_soul").metal_soul
local number_soul = require("@self/forms/number_soul").number_soul
local proto_soul = require("@self/forms/proto_soul").proto_soul
local roll_soul = require("@self/forms/roll_soul").roll_soul
local search_soul = require("@self/forms/search_soul").search_soul
local thunder_soul = require("@self/forms/thunder_soul").thunder_soul
local wind_soul = require("@self/forms/wind_soul").wind_soul
local wood_soul = require("@self/forms/wood_soul").wood_soul
local megaman_portrait_sprite = asset.sprite("megaman_portrait")
local megaman_sprite = asset.sprite("megaman")

local navi: NaviDef = {
    sprite = megaman_sprite,
    element = Element.null,
    -- (EXE4's buster adds 1 to Attack itself: ./weapons/buster.)
    buster_bonus = 0,
    move_lag = { 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 },
    banners = { win = asset.banner("megaman_deleted"), lose = asset.banner("megaman_deleted") },
    -- The no-running message, L on the custom screen in a netbattle (0x080205C6: the script archive 0x08749294's entry
    -- 3; its words are locales/<lang>.toml's). Its script is EXE6's shape: the portrait (F4 00 40: the chatbox's
    -- mugshot 0x40), the box opening (E7 00), the two lines, the wait for A or B (E6 00), the end (E5). (Its first
    -- command, EE 01, would jump to entry 0x38 at the save's progress 0x7C, whose words are the same.)
    run_message = {
        portrait = megaman_portrait_sprite,
    },
    weapons = { buster = buster.weapon, charge_shot = charged_shot.weapon },
    fresh = { hp = 100, mega_level = 5, giga_level = 1 },
    -- His forms (he is MegaMan: the rules ask whether a navi has them where the original asks whether it is
    -- MegaMan), and so his faces are his forms' (forms/base's `mugshot`): the souls Double Soul gives, in their
    -- numbers' order (rules/souls; a side's `souls` are those it has), and the dark soul a dark MegaMan falls into
    -- (rules/souls/dark: soul 15).
    forms = {
        souls = {
            dark_soul = dark_soul,
            form_list = {
                roll_soul,
                guts_soul,
                wind_soul,
                search_soul,
                fire_soul,
                thunder_soul,
                proto_soul,
                number_soul,
                metal_soul,
                junk_soul,
                aqua_soul,
                wood_soul,
            },
        },
    },
    identity = new.identity {
        class = IdentityClass.player,
        version = 0,
        actor_type = ActorType.player,
        ai_index = 0,
        -- The Full Synchro aura's animation (0x080CD180, EXE5's code: its owner's AI index).
        aura_anim = 0,
        -- The chip icons over him, from his place on the screen: navi 0's of 0x0800B9E4 (rules/effects' `chip_icons`).
        chip_icons_at = { 0, -55 },
        -- His status visual's place: his actor record's +6 and +7 (0x08011888's row 0).
        status_mark = { 8, 50 },
    },
}

return { megaman = navi }
