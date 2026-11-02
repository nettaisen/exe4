--!strict
-- EXE4's backgrounds' definitions (the root's `backgrounds`): each background's music, the battle theme a round drawn
-- on it plays where the player picked none (docs/app.md §1, "The battle's music"). Each is the theme most of the
-- original's battles on it start (their settings' byte 3; a battle draws the background its settings state, or with
-- 0xFF its map's): the random encounters of the maps that draw it (0x080F5370; the encounter lists 0x08017FB8, all
-- virus battles) and the battles their scripts start (cutscene command 0x51, map-script command 0x23's cutscenes
-- 0x0809D618 and 0x0809D638). The homepages whose maps have no encounters (rate 7 at 0x080189E8) and start no battle
-- are drawn by link battles alone: theirs is a single link battle's, the virus battles'. A comp or dungeon that ends
-- in a story navi's battle has the boss battles' (the user's pick: by count every one would be the virus battles',
-- its encounters outnumbering them).

return {
    asset.background("acdc-area", { music = asset.sound("virus-battle") }),
    asset.background("air-stadium", { music = asset.sound("tournament-battle") }),
    -- BlackEarth2's seven navi battles (records 169 to 175).
    asset.background("black-earth", { music = asset.sound("boss-battle") }),
    asset.background("castillo-hp", { music = asset.sound("virus-battle") }),
    asset.background("colosseum", { music = asset.sound("tournament-battle") }),
    asset.background("comp", { music = asset.sound("virus-battle") }),
    -- No map's: the DarkSoul battle (record 58, on CastNBMComp) states it.
    asset.background("darksoul", { music = asset.sound("boss-battle") }),
    asset.background("dexs-hp", { music = asset.sound("virus-battle") }),
    -- No map's: Duo's two battles (records 93 and 94, on ControlArea) state it.
    asset.background("duo", { music = asset.sound("final-battle") }),
    -- ElTwrComp's navi battle (record 6) ends its dungeon.
    asset.background("eltwr-comp", { music = asset.sound("boss-battle") }),
    asset.background("hotel-hp", { music = asset.sound("virus-battle") }),
    asset.background("jomonelec-hp", { music = asset.sound("virus-battle") }),
    asset.background("lans-hp", { music = asset.sound("virus-battle") }),
    asset.background("mayls-hp", { music = asset.sound("virus-battle") }),
    -- MeteorComp's navi battles (records 91, MeteorComp4, and 92, ControlArea) end its dungeon.
    asset.background("meteor-comp", { music = asset.sound("boss-battle") }),
    asset.background("netfrica-area", { music = asset.sound("virus-battle") }),
    asset.background("netopia-area", { music = asset.sound("virus-battle") }),
    asset.background("park-area", { music = asset.sound("virus-battle") }),
    asset.background("sharo-area", { music = asset.sound("virus-battle") }),
    asset.background("spacectr-hp", { music = asset.sound("virus-battle") }),
    -- No map's: the tournament battles the venues' scripts start (maps 2:3, 3:3 and 4:4) state these, eight each.
    asset.background("stadium", { music = asset.sound("tournament-battle") }),
    asset.background("town-area", { music = asset.sound("virus-battle") }),
    asset.background("toyrobo-comp", { music = asset.sound("virus-battle") }),
    -- ToyRoboComp4's navi battle (record 57) ends ToyRoboComp's dungeon.
    asset.background("toyrobo-comp4", { music = asset.sound("boss-battle") }),
    asset.background("undernet", { music = asset.sound("virus-battle") }),
    asset.background("yais-hp", { music = asset.sound("virus-battle") }),
    asset.background("yumland-area", { music = asset.sound("virus-battle") }),
}
