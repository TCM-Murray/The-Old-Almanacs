-- Jen Mod Consumable Types
-- Contains all SMODS.ConsumableType and SMODS.Rarity definitions

-- Set default planet type
SMODS.ObjectTypes.Planet.default = 'c_jen_debris'

-- Custom consumable types
SMODS.ConsumableType {
  key = 'jen_tokens',
  collection_rows = {6, 6},
  primary_colour = G.C.CHIPS,
  secondary_colour = G.C.VOUCHER,
  default = 'c_jen_token_tag_standard',
  loc_txt = {
    collection = 'Tokens',
    name = 'Token'
  },
  shop_rate = 3
}

SMODS.ConsumableType {
  key = 'jen_uno',
  collection_rows = {7, 7, 7},
  primary_colour = G.C.CHIPS,
  secondary_colour = HEX('ff0000'),
  default = 'c_jen_uno_null',
  loc_txt = {
    collection = 'UNO Cards',
    name = 'UNO'
  },
  shop_rate = 2
}

SMODS.ConsumableType {
  key = 'jen_ability',
  collection_rows = {4, 4},
  primary_colour = G.C.CHIPS,
  secondary_colour = G.C.GREEN,
  loc_txt = {
    collection = 'Ability Cards',
    name = 'Ability Card'
  },
  shop_rate = 0
}

SMODS.ConsumableType {
  key = 'jen_omegaconsumable',
  collection_rows = {7, 7, 7},
  primary_colour = G.C.CHIPS,
  secondary_colour = G.C.BLACK,
  default = 'c_jen_pluto_omega',
  loc_txt = {
    collection = 'Omega Cards',
    name = 'Omega'
  },
  shop_rate = 0
}

-- Custom rarities
SMODS.Rarity {
  key = 'junk',
  loc_txt = {
    name = 'Junk'
  },
  badge_colour = G.C.JOKER_GREY
}

SMODS.Rarity {
  key = 'wondrous',
  loc_txt = {
    name = 'Wondrous'
  },
  badge_colour = G.C.CRY_EMBER
}

SMODS.Rarity {
  key = 'extraordinary',
  loc_txt = {
    name = 'Extraordinary'
  },
  badge_colour = G.C.CRY_AZURE
}

SMODS.Rarity {
  key = 'ritualistic',
  loc_txt = {
    name = 'Ritualistic'
  },
  badge_colour = G.C.BLACK
}

SMODS.Rarity {
  key = 'transcendent',
  loc_txt = {
    name = 'Transcendent'
  },
  badge_colour = G.C.jen_RGB
}

SMODS.Rarity {
  key = 'omegatranscendent',
  loc_txt = {
    name = 'Omegatranscendent'
  },
  badge_colour = G.C.CRY_ASCENDANT
}

SMODS.Rarity {
  key = 'omnipotent',
  loc_txt = {
    name = 'Omnipotent'
  },
  badge_colour = G.C.CRY_BLOSSOM
}

SMODS.Rarity {
  key = 'miscellaneous',
  loc_txt = {
    name = 'Miscellaneous'
  },
  badge_colour = G.C.JOKER_GREY
}

