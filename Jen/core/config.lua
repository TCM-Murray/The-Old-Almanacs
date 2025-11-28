local CFG = SMODS.current_mod.config

Jen.overpowered_rarities = {
  'jen_wondrous',
  'jen_extraordinary',
  'jen_ritualistic',
  'jen_transcendent',
  'jen_omegatranscendent',
  'jen_omnipotent',
  'jen_miscellaneous',
  'jen_junk'
}

Jen.locale_colours = {
  pink = 'FFAAD9',
  fuchsia = 'FF00B0',
  caramel = 'FFC14F',
  pastel_yellow = 'FFFC75',
  stone = '7A8087',
  darkstone = '53575B',
  lore = '9E2A9F',
  caption = '009A9A',
  uno = 'FF0000',
  almanac = '0000FF',
  blood = '880808'
}

Jen.config = {
  texture_pack = 'default',
  show_credits = true,
  show_captions = true,
  show_lore = true,
  astro = {
    initial = 0.70,
    increment = 0.002,
    decrement = 0.04,
    retrigger_mod = 2
  },
  suit_leveling = {
    Hearts = { chips = 1, mult = 5 },
    Clubs = { chips = 5, mult = 1 },
    Diamonds = { chips = 2, mult = 4 },
    Spades = { chips = 4, mult = 2 }
  },
  rank_leveling = {
    ['2'] = { chips = 13, mult = 1 },
    ['3'] = { chips = 12, mult = 1 },
    ['4'] = { chips = 11, mult = 1 },
    ['5'] = { chips = 10, mult = 2 },
    ['6'] = { chips = 9, mult = 2 },
    ['7'] = { chips = 8, mult = 2 },
    ['8'] = { chips = 7, mult = 3 },
    ['9'] = { chips = 6, mult = 3 },
    ['10'] = { chips = 5, mult = 3 },
    Jack = { chips = 4, mult = 4 },
    Queen = { chips = 3, mult = 5 },
    King = { chips = 2, mult = 6 },
    Ace = { chips = 25, mult = 7 },
  },
  wondrous_music = CFG.wondrous,
  extraordinary_music = CFG.extraordinary,
  save_compression_level = 9,
  punish_reroll_abuse = CFG.punish_reroll_abuse,
  shop_size_buff = 3,
  shop_voucher_count_buff = 2,
  shop_booster_pack_count_buff = 2,
  consumable_slot_count_buff = 18,
  verbose_astronomicon = false,
  verbose_astronomicon_omega = false,
  mana_cost = 25,
  HQ_vanillashaders = CFG.hq_shaders,
  malice_base = 3000,
  malice_increase = 1.13,
  omega_chance = 300,
  soul_omega_mod = 5,
  wee_sizemod = 1.5,
  safer_kosmos = true,
  kosmos_safety_threshold = 50,
  kosmos_gc_trigger_kb = 256000,
  malice_exponent_cap = 20,
  malice_cap_approximate = true,
  ante_threshold = 20,
  ante_pow10 = 100,
  ante_pow10_2 = 250,
  ante_pow10_3 = 500,
  ante_pow10_4 = 1000,
  ante_exponentiate = 50,
  ante_tetrate = 2500,
  ante_pentate = 5000,
  ante_polytate = 10000,
  polytate_factor = 1000,
  polytate_decrement = 1,
  scalar_base = 1,
  scalar_increment = .13,
  scalar_additivedivisor = 50,
  scalar_exponent = 1,
  straddle = {
    enabled = CFG.straddle,
    acceleration = true,
    skip_animation = false,
    backwards_mod = 2,
    progress_min = 3,
    progress_max = 7,
    progress_increment = 10
  },
  disable_bans = CFG.disable_bans,
  bans = {
    '!j_cry_chocolate_dice',
    '!j_cry_curse_sob',
    '!j_cry_filler',
    'j_mf_colorem',
    'betm_jokers_j_balatro_mobile',
    'betm_jokers_j_gameplay_update',
    'betm_jokers_j_friends_of_jimbo',
    'c_ortalab_lot_hand',
    'j_cry_pity_prize',
    'j_cry_formidiulosus',
    'j_cry_oil_lamp',
    'j_cry_tropical_smoothie',
    '!j_cry_jawbreaker',
    'j_cry_necromancer',
    'j_cry_mask',
    'j_cry_exposed',
    'j_cry_equilib',
    'j_cry_error',
    'j_cry_ghost',
    'j_cry_spy',
    'j_cry_copypaste',
    'j_cry_flip_side',
    'j_cry_crustulum',
    'j_sdm_cupidon',
    'j_sdm_0',
    'p_mupack_favoritepack',
    'c_prism_spectral_djinn',
    'e_cry_double_sided',
    'c_cry_meld',
    'c_cry_crash',
    'c_cry_rework',
    'c_cry_multiply',
    'c_cry_ctrl_v',
    'c_cry_ritual',
    'c_cry_adversary',
    'c_cry_chambered',
    'v_cry_double_down',
    'v_cry_double_slit',
    'v_cry_double_vision',
    'v_cry_curate',
    'e_cry_fragile',
    'bl_cruel_daring',
    'bl_cruel_reach',
    'bl_cry_obsidian_orb',
    'b_cry_e_deck',
    'b_cry_et_deck',
    'b_cry_sk_deck',
    'b_cry_st_deck',
    'b_cry_sl_deck',
  }
}

-- Precompute blind scalars
Jen.blind_scalar = {}
for i = 1, Jen.config.ante_polytate do
  Jen.blind_scalar[i] = to_big(1 + (Jen.config.scalar_base + (i/Jen.config.scalar_additivedivisor))) ^ to_big(i * Jen.config.scalar_exponent)
end

-- Modifier badges configuration
Jen.modifierbadges = {
  unique = {
    text = { 'Unique', 'Can only own one copy' },
    col = HEX('8f00ff'),
    tcol = G.C.EDITION
  },
  fusable = {
    text = { 'Fusable', 'Can be combined' },
    col = G.C.GREEN,
    tcol = G.C.EDITION
  },
  immutable = {
    text = { 'Immutable', 'Unmodifiable values' },
    col = G.C.MONEY,
    tcol = G.C.CRY_TWILIGHT
  },
  dangerous = {
    text = { 'Dangerous', 'Unstable behaviour' },
    col = HEX('1a1a1a'),
    tcol = HEX('ff0000')
  },
  longful = {
    text = { 'Longful', 'Lengthy animations' },
    col = G.C.WHITE,
    tcol = G.C.JOKER_GREY
  },
  experimental = {
    text = { 'Experimental', 'May be very buggy' },
    col = G.C.FILTER,
    tcol = G.C.UI.TEXT_LIGHT
  },
  debuff_immune = {
    text = { 'Impervious', 'Cannot be debuffed' },
    col = G.C.JOKER_GREY,
    tcol = G.C.FILTER
  },
  permaeternal = {
    text = { 'Permaeternal', 'Has Eternal 24/7' },
    col = G.C.RED,
    tcol = G.C.UI.TEXT_LIGHT
  },
  dissolve_immune = {
    text = { 'Indestructible', 'Cannot dissolve' },
    col = G.C.CRY_AZURE,
    tcol = G.C.CRY_BLOSSOM
  },
  unhighlightable = {
    text = { 'Unplayable/Unhighlightable', 'Cannot select' },
    col = G.C.SECONDARY_SET.Tarot,
    tcol = G.C.SECONDARY_SET.Planet
  }
}

