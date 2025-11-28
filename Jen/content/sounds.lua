-- Jen Mod Sounds
-- Contains all SMODS.Sound and SMODS.Shader definitions

-- Music tracks
if Jen.config.wondrous_music then
  SMODS.Sound({
    key = "musicWondrous",
    path = "musicWondrous.ogg",
    volume = 1,
    select_music_track = function()
      return Jen.should_play_wondrous
    end,
  })
end

if Jen.config.extraordinary_music then
  SMODS.Sound({
    key = "musicExtraordinary",
    path = "musicExtraordinary.ogg",
    volume = 1,
    select_music_track = function()
      return Jen.should_play_extraordinary
    end,
  })
end

if Jen.config.icon_music then
  SMODS.Sound({
    key = "musicIcon",
    path = "musicIcon.ogg",
    pitch = 1,
    select_music_track = function()
      return ((SMODS.OPENED_BOOSTER or {}).ability or {}).icon_pack and G.booster_pack and not G.booster_pack.REMOVED
    end,
  })
end

-- Basic sounds
SMODS.Sound({key = 'uno', path = 'uno.ogg'})
SMODS.Sound({key = 'misc1', path = 'misc1.ogg'})
SMODS.Sound({key = 'done', path = 'done.ogg'})
SMODS.Sound({key = 'e_crystal', path = 'e_crystal.ogg'})
SMODS.Sound({key = 'grindstone', path = 'grindstone.ogg'})
SMODS.Sound({key = 'metalhit', path = 'metal_hit.ogg'})
SMODS.Sound({key = 'enlightened', path = 'enlightened.ogg'})
SMODS.Sound({key = 'omegacard', path = 'omega_card.ogg'})
SMODS.Sound({key = 'chime', path = 'chime.ogg'})
SMODS.Sound({key = 'enchant', path = 'enchant.ogg'})

-- Metal break sounds
for i = 1, 2 do
  SMODS.Sound({key = 'metalbreak' .. i, path = 'metal_break' .. i .. '.ogg'})
end

-- Ambient sounds
SMODS.Sound({key = 'ambientSinister', path = 'ambientSinister.ogg'})
SMODS.Sound({key = 'ambientDramatic', path = 'ambientDramatic.ogg'})

-- Crystal, hurt, and surreal sounds
for i = 1, 3 do
  SMODS.Sound({key = 'crystalhit' .. i, path = 'crystal_hit' .. i .. '.ogg'})
  SMODS.Sound({key = 'hurt' .. i, path = 'hurt' .. i .. '.ogg'})
  SMODS.Sound({key = 'ambientSurreal' .. i, path = 'ambientSurreal' .. i .. '.ogg'})
end

-- Gore sounds
for i = 1, 8 do
  SMODS.Sound({key = 'gore' .. i, path = 'gore' .. i .. '.ogg'})
end

-- Boost sounds
for i = 1, 4 do
  SMODS.Sound({key = 'boost' .. i, path = 'boost' .. i .. '.ogg'})
end

-- Misc sounds
SMODS.Sound({key = 'crystalbreak', path = 'crystal_break.ogg'})
SMODS.Sound({key = 'wererich', path = 'wererich.ogg'})
SMODS.Sound({key = 'tension', path = 'tension.ogg'})
SMODS.Sound({key = 'relief', path = 'relief.ogg'})
SMODS.Sound({key = 'straddle_tick', path = 'straddle_tick.ogg'})
SMODS.Sound({key = 'straddle_increase', path = 'straddle_increase.ogg'})
SMODS.Sound({key = 'mushroom1', path = 'mushroom1.ogg'})
SMODS.Sound({key = 'mushroom2', path = 'mushroom2.ogg'})
SMODS.Sound({key = 'draw', path = 'draw.ogg'})
SMODS.Sound({key = 'pop', path = 'pop.ogg'})
SMODS.Sound({key = 'gong', path = 'gong.ogg'})
SMODS.Sound({key = 'heartbeat', path = 'warning_heartbeat.ogg'})
SMODS.Sound({key = 'sin', path = 'e_sinned.ogg'})

-- Collapse sounds
for i = 1, 5 do
  SMODS.Sound({key = 'collapse' .. i, path = 'collapse_' .. i .. '.ogg'})
end

-- Grand dad sounds
for i = 1, 6 do
  SMODS.Sound({key = 'grand' .. i, path = 'grand_dad' .. i .. '.ogg'})
end

-- Edition shaders (with sounds)
local shaders = {
  'chromatic',
  'gilded',
  'laminated',
  'reversed',
  'sepia',
  'wavy',
  'dithered',
  'watered',
  'sharpened',
  'missingtexture',
  'prismatic',
  'polygloss',
  'ink',
  'strobe',
  'sequin',
  'blaze',
  'encoded',
  'misprint',
  'unreal',
  'ionized',
  'diplopia',
  'moire'
}

-- Shaders without sounds
local shaders2 = {
  'bloodfoil',
  'cosmic',
  'shaderpack_1',
  'shaderpack_4',
  'wtfwave'
}

-- Sounds without shaders
local shaders3 = {
  'wee',
  'jumbo'
}

-- Create shaders with sounds
for k, v in pairs(shaders) do
  SMODS.Shader({key = v, path = v .. '.fs'})
  SMODS.Sound({key = 'e_' .. v, path = 'e_' .. v .. '.ogg'})
end

-- Create shaders without sounds
for k, v in pairs(shaders2) do
  SMODS.Shader({key = v, path = v .. '.fs'})
end

-- Create sounds without shaders
for k, v in pairs(shaders3) do
  SMODS.Sound({key = 'e_' .. v, path = 'e_' .. v .. '.ogg'})
end

