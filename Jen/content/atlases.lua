-- Jen Mod Atlases
-- Contains all SMODS.Atlas definitions

-- Mod icon atlas
SMODS.Atlas {
  key = "modicon",
  path = "almanac_avatar.png",
  px = 34,
  py = 34
}

-- Joker atlases list
local atlases = {
  'sigil',
  'rai',
  'agares',
  'spice',
  'kosmos',
  'lambert',
  'leshy',
  'heket',
  'kallamar',
  'shamura',
  'narinder',
  'aym',
  'baal',
  'clauneck',
  'kudaai',
  'chemach',
  'haro',
  'suzaku',
  'ayanami',
  'ratau',
  'jen',
  'math',
  'koslo',
  'peppino',
  'noise',
  'poppin',
  'godsmarble',
  'pawn',
  'knight',
  'jester',
  'arachnid',
  'reign',
  'feline',
  'amalgam',
  'fateeater',
  'foundry',
  'broken',
  'wondergeist',
  'wondergeist2',
  'survivor',
  'monk',
  'hunter',
  'spearmaster',
  'artificer',
  'saint',
  'gourmand',
  'rivulet',
  'rot',
  'guilduryn',
  'hydrangea',
  'heisei',
  'soryu',
  'shikigami',
  'leviathan',
  'behemoth',
  'inferno',
  'alexandra',
  'arin',
  'kyle',
  'johnny',
  'murphy',
  'roffle',
  'luke',
  '7granddad',
  'gamingchair',
  'aster',
  'rin',
  'astrophage',
  'landa',
  'bulwark',
  'urizyth',
  'lugia',
  'vacuum',
  'nyx',
  'paragon',
  'jimbo',
  'betmma',
  'watto',
  'kori',
  'apollo',
  'hephaestus',
  'p03',
  'oxy',
  'honey',
  'inhabited',
  'cracked',
  'alice',
  'nexus',
  'swabbie',
  'pickel',
  'jeremy',
  'cheese',
  'crimbo',
  'faceless',
  'maxie',
  'charred',
  'dandy',
  'goob',
  'goob_lefthand',
  'goob_righthand',
  'boxten',
  'astro',
  'razzledazzle',
  'cosmo',
  'toodles',
  'finn',
  'connie'
}

-- Create joker atlases
for k, v in pairs(atlases) do
  SMODS.Atlas {
    key = 'jen' .. v,
    px = 71,
    py = 95,
    path = Jen.config.texture_pack .. '/j_jen_' .. v .. '.png'
  }
end

-- Miscellaneous atlases
SMODS.Atlas {
  key = 'jenhuge',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_huge.png'
}

SMODS.Atlas {
  key = 'jenbooster',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/p_jen_boosters.png'
}

SMODS.Atlas {
  key = 'jenfuse',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_fuse.png'
}

SMODS.Atlas {
  key = 'jenuno',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_uno.png'
}

SMODS.Atlas {
  key = 'jendecks',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/b_jen_decks.png'
}

SMODS.Atlas {
  key = 'jentags',
  px = 34,
  py = 34,
  path = Jen.config.texture_pack .. '/tag_jen.png'
}

SMODS.Atlas {
  key = 'jenyawetag',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_yawetag.png'
}

SMODS.Atlas {
  key = 'jennyx_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_nyx.png'
}

SMODS.Atlas {
  key = 'jenswabbie_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_swabbie.png'
}

SMODS.Atlas {
  key = 'jenartificer_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_artificer.png'
}

SMODS.Atlas {
  key = 'jenfateeater_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_fateeater.png'
}

SMODS.Atlas {
  key = 'jenfoundry_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_foundry.png'
}

SMODS.Atlas {
  key = 'jenbroken_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_broken.png'
}

SMODS.Atlas {
  key = 'jenroffle_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_roffle.png'
}

SMODS.Atlas {
  key = 'jengoob_c',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_goob.png'
}

SMODS.Atlas {
  key = 'jenhoxxes',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_hoxxes.png'
}

SMODS.Atlas {
  key = 'jenrtarots',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_reversetarots.png'
}

SMODS.Atlas {
  key = 'jenacc',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_acc.png'
}

SMODS.Atlas {
  key = 'jenblanks',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_blanks.png'
}

SMODS.Atlas {
  key = 'jenblinds',
  atlas_table = 'ANIMATION_ATLAS',
  frames = 21,
  px = 34,
  py = 34,
  path = Jen.config.texture_pack .. '/bl_jen_blinds.png'
}

SMODS.Atlas {
  key = 'jenepicblinds',
  atlas_table = 'ANIMATION_ATLAS',
  frames = 21,
  px = 34,
  py = 34,
  path = Jen.config.texture_pack .. '/bl_jen_epic_blinds.png'
}

SMODS.Atlas {
  key = 'jentokens',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_tokens.png'
}

SMODS.Atlas {
  key = 'jenenhance',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/m_jen_enhancements.png'
}

SMODS.Atlas {
  key = 'jenomegaplanets',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_omegaplanets.png'
}

SMODS.Atlas {
  key = 'jenomegaspectrals',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_omegaspectrals.png'
}

SMODS.Atlas {
  key = 'jenomegatarots',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_omegatarots.png'
}

SMODS.Atlas {
  key = 'jenplanets',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/c_jen_planets.png'
}

SMODS.Atlas {
  key = 'jenvouchers',
  px = 71,
  py = 95,
  path = Jen.config.texture_pack .. '/v_jen_vouchers.png'
}

SMODS.Atlas {
  key = 'jenbuttons',
  px = 32,
  py = 32,
  path = Jen.config.texture_pack .. '/jen_ui_buttons.png'
}

