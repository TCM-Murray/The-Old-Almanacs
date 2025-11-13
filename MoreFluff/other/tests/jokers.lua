local pseudorandom_pick_first = function(orig, _t, ...)
  if seed then math.randomseed(seed) end
  local keys = {}
  for k, v in pairs(_t) do
      keys[#keys+1] = {k = k,v = v}
  end

  if keys[1] and keys[1].v and type(keys[1].v) == 'table' and keys[1].v.sort_id then
    table.sort(keys, function (a, b) return a.v.sort_id < b.v.sort_id end)
  else
    table.sort(keys, function (a, b) return a.k < b.k end)
  end

  local key = keys[1].k
  return _t[key], key 
end

--#region All I Can't Do
Balatest.TestPlay {
  name = "allicantdo_debuffs_hand",
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.wait_for_input()
  end,
  assert = function()
    for i = 1,52 do
      Balatest.assert(G.hand.cards[i].debuff)
    end
  end,
}

Balatest.TestPlay {
  name = "allicantdo_one_high_card",
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(5, "round score")
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 1.1, "xmult")
  end,
}

Balatest.TestPlay {
  name = "allicantdo_five_high_cards",
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '6H' }
  end,
  assert = function()
    Balatest.assert_chips(7)
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 1.5, "xmult")
  end,
}

Balatest.TestPlay {
  name = "allicantdo_straight_flush",
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(1200)
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 1.5, "xmult")
  end,
}

Balatest.TestPlay {
  name = "allicantdo_scaling",
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '6H' }
    Balatest.play_hand { 'AC', '2C', '3C', '4C', '5C' }
  end,
  assert = function()
    Balatest.assert_chips(1607)
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 2, "xmult")
  end,
}

--#region Bad Legal Defence

Balatest.TestPlay {
  name = "badlegaldefence_smallblind",
  category = "badlegaldefence",

  jokers = {"j_mf_badlegaldefence"},
  execute = function() -- automatically enters blind
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should have no consumeable")
  end,
}

Balatest.TestPlay {
  name = "badlegaldefence_bossblind",
  category = "badlegaldefence",

  jokers = {"j_mf_badlegaldefence"},
  blind = "bl_wheel",
  execute = function() -- automatically enters blind
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have a consumeable")
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_death", "should have a death")
  end,
}

Balatest.TestPlay {
  name = "badlegaldefence_no_overflow",
  category = "badlegaldefence",

  jokers = {"j_mf_badlegaldefence"},
  consumeables = {"c_hermit", "c_hermit"},
  blind = "bl_wheel",
  execute = function() -- automatically enters blind
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have two consumeables")
    Balatest.assert(G.consumeables.cards[1].config.center.key ~= "c_death", "should not have a death")
    Balatest.assert(G.consumeables.cards[2].config.center.key ~= "c_death", "should not have a death")
  end,
}

--#region Basepaul Card

Balatest.TestPlay {
  name = "basepaul_not_paul",
  category = "basepaulcard",

  jokers = {"j_mf_basepaul_card"},
  execute = function()
    G.PROFILES[G.SETTINGS.profile].name = "chicken jockey"

    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(1250)
  end,
}

Balatest.TestPlay {
  name = "basepaul_paul",
  category = "basepaulcard",

  jokers = {"j_mf_basepaul_card"},
  execute = function()
    G.PROFILES[G.SETTINGS.profile].name = "paul"

    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(12500)
  end,
}

Balatest.TestPlay {
  name = "basepaul_long_name",
  category = "basepaulcard",

  jokers = {"j_mf_basepaul_card"},
  execute = function()
    G.PROFILES[G.SETTINGS.profile].name = "I am Paul"

    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(12500)
  end,
}

--#region Blade Dance

Balatest.TestPlay {
  name = "bladedance_functionality",
  category = "bladedance",

  jokers = {"j_mf_bladedance"},

  no_auto_start = true, -- so we can hook before it begins
  hand_size = 54,
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.start_round()

    Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
  end,
  assert = function()
    Balatest.assert_chips(120 * 8 * 1.5 * 1.5)
    Balatest.assert_eq(#G.deck.cards, 52, "should have 52 cards in deck when finished")
  end,
}


--#region Blahaj

Balatest.TestPlay {
  name = "blahaj_swaps_chips_and_mult",
  category = "blahaj",

  jokers = {"j_joker", "j_mf_blahaj", "j_joker", },
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 4) * (1 + 4))
  end,
}

--#region Blasphemy

Balatest.TestPlay {
  name = "blasphemy_functionality",
  category = "blasphemy",

  jokers = {"j_mf_blasphemy"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(125 * 8 * 4)
    Balatest.assert_eq(G.GAME.current_round.hands_left, 0, "should have no hands left")
  end,
}

--#region Blood Pact

Balatest.TestPlay {
  name = "bloodpact_one_heart",
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
    Balatest.assert_eq(#G.jokers.cards, 1, "should not have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_hearts_flush",
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AH', "3H", "5H", "7H", "9H" }
  end,
  assert = function()
    Balatest.assert_chips(70 * 4 * 5)
    Balatest.assert_eq(#G.jokers.cards, 1, "should not have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_one_spade",
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_one_club",
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AC' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_one_diamond",
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AD' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_sneaky_spade",
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AH', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

--#region Blunder

Balatest.TestPlay {
  name = "blunder_autoselect",
  category = "blunder",

  jokers = {"j_mf_blunder"},

  no_auto_start = true, -- so we can hook before it begins
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.start_round()
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.highlighted, 1, "should have selected")
  end,
}

Balatest.TestPlay {
  name = "blunder_xmult",
  category = "blunder",

  jokers = {"j_mf_blunder"},

  no_auto_start = true, -- so we can hook before it begins
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.start_round()

    Balatest.play_hand({})
  end,
  assert = function()
    Balatest.assert_chips(7 * 3)
  end,
}

--#region Book Move

Balatest.TestPlay {
  name = "bookmove_no_rounds",
  category = "bookmove",

  jokers = {"j_mf_bookmove"},

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "bookmove_two_rounds",
  category = "bookmove",

  jokers = {"j_mf_bookmove"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "bookmove_three_rounds",
  category = "bookmove",

  jokers = {"j_mf_bookmove"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
  end,
}

Balatest.TestPlay {
  name = "bookmove_no_overflow",
  category = "bookmove",

  jokers = {"j_mf_bookmove","j_joker","j_joker","j_joker","j_joker"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
  end,
}

Balatest.TestPlay {
  name = "bookmove_fills_five",
  category = "bookmove",

  jokers = {"j_mf_bookmove","j_joker","j_joker","j_joker"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
  end,
}

--#region Bowling Ball

Balatest.TestPlay {
  name = "bowlingball_three_high",
  category = "bowlingball",

  jokers = {"j_mf_bowlingball"},

  execute = function()
    Balatest.play_hand { '3S' }
  end,
  assert = function()
    Balatest.assert_chips((60 + 5 + 3) * (11))
  end,
}

Balatest.TestPlay {
  name = "bowlingball_four_threes",
  category = "bowlingball",

  jokers = {"j_mf_bowlingball"},

  execute = function()
    Balatest.play_hand { '3S', '3H', '3C', '3D' }
  end,
  assert = function()
    Balatest.assert_chips((60 * 4 + 3 * 4 + 60) * (10 * 4 + 7))
  end,
}

--#region Brass Joker

Balatest.TestPlay {
  name = "brassjoker_no_destroyed",
  category = "brassjoker",

  jokers = {"j_mf_brass", "j_joker"},

  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
  end,
}

Balatest.TestPlay {
  name = "brassjoker_four_brass_none_destroyed",
  category = "brassjoker",

  jokers = {"j_mf_brass", "j_joker"},
  consumeables = {"c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice"},

  blind = "bl_big", -- for chip req.

  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '3S' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '3C' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '2S', '2C', '3S', '3C' } -- (20 + 2*6 + 3*6) * 6
    Balatest.play_hand { 'AS' } -- (16) * 5
  end,
  assert = function()
    Balatest.assert_chips((20 + 2*6 + 3*6 ) * 6 + 16 * 5)
  end,
}

Balatest.TestPlay {
  name = "brassjoker_four_brass_all_destroyed",
  category = "brassjoker",

  jokers = {"j_mf_brass", "j_joker"},
  consumeables = {"c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice"},
  
  blind = "bl_big", -- for chip req.

  execute = function()
    G.GAME.probabilities.normal = 99
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '3S' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '3C' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '2S', '2C', '3S', '3C' } -- (20 + 2*6 + 3*6) * 6
    Balatest.play_hand { 'AS' } -- (16) * 13
  end,
  assert = function()
    Balatest.assert_chips((20 + 2*6 + 3*6) * 6 + 16 * 13)
  end,
}

--#region Brilliant

Balatest.TestPlay {
  name = "brilliant_one_hand",
  category = "brilliant",

  jokers = {"j_mf_brilliant"},

  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert(#G.consumeables.cards, 1, "should have made a consumeable")
  end,
}

Balatest.TestPlay {
  name = "brilliant_two_hands",
  category = "brilliant",

  jokers = {"j_mf_brilliant"},

  execute = function()
    Balatest.play_hand { 'AH' }
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert(#G.consumeables.cards, 0, "should not have made a consumeable")
  end,
}

--#region Broom Closet

Balatest.TestPlay {
  name = "broomcloset_default",
  category = "broomcloset",

  jokers = {"j_mf_broomcloset"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 4)
  end,
}

Balatest.TestPlay {
  name = "broomcloset_purchase",
  category = "broomcloset",

  jokers = {"j_mf_broomcloset"},

  dollars = 99999,

  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_white', ...)
    end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "broomcloset_purchase_reset",
  category = "broomcloset",

  jokers = {"j_mf_broomcloset"},

  dollars = 99999,

  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_white', ...)
    end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.next_round()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 4)
  end,
}

--#region Card Buffer Advanced

Balatest.TestPlay {
  name = "cba_no_others",
  category = "cba",

  jokers = {"j_mf_cba"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "cba_no_editions",
  category = "cba",

  jokers = {"j_mf_cba", "j_joker"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
  end,
}

Balatest.TestPlay {
  name = "cba_edition_right",
  category = "cba",

  jokers = {"j_mf_cba", { id = 'j_joker', edition = 'foil' }},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 50) * (1 + 4 * 2))
  end,
}

Balatest.TestPlay {
  name = "cba_edition_left",
  category = "cba",

  jokers = {{ id = 'j_joker', edition = 'foil' }, "j_mf_cba"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 50) * (1 + 4 * 2))
  end,
}

Balatest.TestPlay {
  name = "cba_two_editions",
  category = "cba",

  jokers = {{ id = 'j_joker', edition = 'foil' }, "j_mf_cba", { id = 'j_mf_jester', edition = 'foil' }},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 50 + 50 + 40) * (1 + 4 * 2))
  end,
}

--#region Clipart Joker

Balatest.TestPlay {
  name = "clipart_creates",
  category = "clipart",

  jokers = {"j_mf_clipart"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "created one")
  end,
}

--#region Clownfish

Balatest.TestPlay {
  name = "clownfish_unenhanced",
  category = "clownfish",

  jokers = {"j_mf_clownfish"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "clownfish_one_enhanced",
  category = "clownfish",

  jokers = {"j_mf_clownfish"},
  consumeables = {"c_chariot"},

  execute = function()
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips((5 + 15 + 11) * 5)
  end,
}

Balatest.TestPlay {
  name = "clownfish_five_enhanced",
  category = "clownfish",

  jokers = {"j_mf_clownfish"},
  consumeables = {"c_chariot","c_chariot","c_chariot","c_chariot","c_chariot"},

  execute = function()
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { "2H" }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { "3H" }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { "4H" }
    Balatest.use(G.consumeables.cards[4])
    Balatest.highlight { "5H" }
    Balatest.use(G.consumeables.cards[5])
    Balatest.play_hand { "AH", "2H", "3H", "4H", "5H" }
  end,
  assert = function()
    Balatest.assert_chips((100 + 11 + 2 + 3 + 4 + 5 + 15*5) * (8 + 4*5))
  end,
}

--#region Complexity Creep

Balatest.TestPlay {
  name = "complexitycreep_initial_effect",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#(G.jokers.cards[1].ability.effects), 1)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_grows",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},
  blind = "bl_wheel",

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#(G.jokers.cards[1].ability.effects), 2)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_plusmult",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"plusmult", 4, "joker", nil, nil, nil, "cc_plusmult", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 4))
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_pluschips",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"pluschips", 50, "joker", nil, nil, nil, "cc_pluschips", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(66)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_xmult",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"xmult", 2, "joker", nil, nil, nil, "cc_xmult", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(32)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_xchips",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"xchips", 2, "joker", nil, nil, nil, "cc_xchips", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(32)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_emult",
  category = "complexitycreep",

  jokers = {"j_joker","j_mf_complexitycreep"},

  blind = "bl_wall",

  execute = function()
    G.jokers.cards[2].ability.effects = {{"emult", 2, "joker", nil, nil, nil, "cc_emult", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16*25)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_echips",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"echips", 2, "joker", nil, nil, nil, "cc_echips", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16*16)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_dollars",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "joker", nil, nil, nil, "cc_dollars", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_swapchipmult",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep","j_joker"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"swapchipmult", 0, "joker", nil, nil, nil, "cc_swapchipmult", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(20)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_createtarot",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"createtarot", 0, "joker", nil, nil, nil, "cc_createtarot", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have a consumeable")
    Balatest.assert(G.consumeables.cards[1].ability.set == "Tarot", "should have a tarot")
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_createplanet",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"createplanet", 0, "joker", nil, nil, nil, "cc_createplanet", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have a consumeable")
    Balatest.assert(G.consumeables.cards[1].ability.set == "Planet", "should have a planet")
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_copyconsumeable",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},
  consumeables = {"c_mf_black"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"copyconsumeable", 0, "joker", nil, nil, nil, "cc_copyconsumeable", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have a consumeable")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_mf_black")
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_copyconsumeable_empty",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  execute = function()
    G.jokers.cards[1].ability.effects = {{"copyconsumeable", 0, "joker", nil, nil, nil, "cc_copyconsumeable", nil, "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "complexitycreep_handtype_off",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "joker", nil, "handtype", "Pair", "cc_dollars", "cc_mf_handtype", "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_handtype_on",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "joker", nil, "handtype", "Pair", "cc_dollars", "cc_mf_handtype", "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH", "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_odds_off",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.GAME.probabilities.normal = 0
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "joker", nil, "odds", 2, "cc_dollars", "cc_mf_odds", "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_odds_on",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.GAME.probabilities.normal = 9999
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "joker", nil, "odds", 2, "cc_dollars", "cc_mf_odds", "cc_mf_joker_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}

Balatest.TestPlay {
  name = "complexitycreep_cardscored_one",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "cardscored", "chicken jockey", nil, nil, "cc_dollars", nil, "cc_mf_card_trigger" }}
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_cardscored_two",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "cardscored", "chicken jockey", nil, nil, "cc_dollars", nil, "cc_mf_card_trigger" }}
    Balatest.play_hand { "AH", "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 10)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_cardscored_one_fake",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "cardscored", "chicken jockey", nil, nil, "cc_dollars", nil, "cc_mf_card_trigger" }}
    Balatest.play_hand { "AH", "TS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_firstcard",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "firstscored", "chicken jockey", nil, nil, "cc_dollars", nil, "cc_mf_first_card_trigger" }}
    Balatest.play_hand { "AH", "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_facecard_one",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "facescored", "chicken jockey", nil, "cc_dollars", nil, nil, "cc_mf_face_card_trigger" }}
    Balatest.play_hand { "KS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_facecard_two",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "facescored", "chicken jockey", nil, "cc_dollars", nil, nil, "cc_mf_face_card_trigger" }}
    Balatest.play_hand { "KS", "KH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 10)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_facecard_none",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "facescored", "chicken jockey", nil, "cc_dollars", nil, nil, "cc_mf_face_card_trigger" }}
    Balatest.play_hand { "AS", "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_end_round",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "endofround", "chicken jockey", nil, "cc_dollars", nil, nil, "cc_mf_endofround" }}
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_cardsold",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep", "j_joker"},

  dollars = 0,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "cardsold", "chicken jockey", nil, "cc_dollars", nil, nil, "cc_mf_cardsold" }}
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 1 + 5)
  end,
}
Balatest.TestPlay {
  name = "complexitycreep_shoproll",
  category = "complexitycreep",

  jokers = {"j_mf_complexitycreep"},

  dollars = 6,

  execute = function()
    G.jokers.cards[1].ability.effects = {{"dollars", 5, "shoproll", "chicken jockey", nil, "cc_dollars", nil, nil, "cc_mf_shoproll" }}
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end,
}

--#region Coupon Catalogue

Balatest.TestPlay {
  name = "couponcatalogue_no_vouchers",
  category = "couponcatalogue",

  jokers = {"j_mf_coupon_catalogue"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "couponcatalogue_one_voucher",
  category = "couponcatalogue",

  jokers = {"j_mf_coupon_catalogue"},

  dollars = 99999,

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 15))
  end,
}

Balatest.TestPlay {
  name = "couponcatalogue_three_vouchers",
  category = "couponcatalogue",

  jokers = {"j_mf_coupon_catalogue"},

  dollars = 99999,

  no_auto_start = true,

  execute = function()
    Balatest.skip_blind("tag_voucher")
    Balatest.skip_blind("tag_voucher")
    Balatest.start_round()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 15 * 3))
  end,
}

--#region CSS

Balatest.TestPlay {
  name = "css_high_card",
  category = "css",

  jokers = {"j_mf_css"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should not have made one")
  end,
}
Balatest.TestPlay {
  name = "css_flush",
  category = "css",

  jokers = {"j_mf_css"},

  execute = function()
    Balatest.play_hand { "2H", "3H", "4H", "5H", "7H" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have made one")
  end,
}
Balatest.TestPlay {
  name = "css_no_overflow",
  category = "css",

  jokers = {"j_mf_css"},
  consumeables = {"c_hermit", "c_hermit"},

  execute = function()
    Balatest.play_hand { "2H", "3H", "4H", "5H", "7H" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have not made one")
  end,
}

--#region Cue Ball

Balatest.TestPlay {
  name = "cueball_ranked_card",
  category = "cueball",

  jokers = {"j_mf_cueball"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should not have made one")
  end,
}

Balatest.TestPlay {
  name = "cueball_stone_rigged_off",
  category = "cueball",

  jokers = {"j_mf_cueball"},
  consumeables = {"c_tower"},

  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should not have made one")
  end,
}

Balatest.TestPlay {
  name = "cueball_stone_rigged_on",
  category = "cueball",

  jokers = {"j_mf_cueball"},
  consumeables = {"c_tower"},

  execute = function()
    G.GAME.probabilities.normal = 999
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have made one")
  end,
}

Balatest.TestPlay {
  name = "cueball_two_stones_rigged_on",
  category = "cueball",

  jokers = {"j_mf_cueball"},
  consumeables = {"c_tower", "c_tower"},

  execute = function()
    G.GAME.probabilities.normal = 999
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { "AS" }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { "AH", "AS" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have made two")
  end,
}

--#region Dramatic Entrance

Balatest.TestPlay {
  name = "dramatic_entrance_first_hand",
  category = "dramaticentrance",

  jokers = {"j_mf_dramaticentrance"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(166)
  end,
}

Balatest.TestPlay {
  name = "dramatic_entrance_second_hand",
  category = "dramaticentrance",

  jokers = {"j_mf_dramaticentrance"},

  execute = function()
    Balatest.play_hand { "AH" }
    Balatest.play_hand { "5S", "5C" }
  end,
  assert = function()
    Balatest.assert_chips(166 + 20 * 2)
  end,
}

--#region Dropkick

Balatest.TestPlay {
  name = "dropkick_non_straight",
  category = "dropkick",

  jokers = {"j_mf_dropkick"},

  hands = 2,

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
  end,
}

Balatest.TestPlay {
  name = "dropkick_straight",
  category = "dropkick",

  jokers = {"j_mf_dropkick"},

  hands = 1,

  execute = function()
    Balatest.play_hand { "AH", "2S", "3S", "4S", "5S" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
  end,
}

Balatest.TestPlay {
  name = "dropkick_several_straights",
  category = "dropkick",

  jokers = {"j_mf_dropkick"},

  hands = 1,

  blind = "bl_wall",

  execute = function()
    Balatest.play_hand { "AH", "2S", "3S", "4S", "5S" }
    Balatest.play_hand { "AS", "2C", "3C", "4C", "5C" }
    Balatest.play_hand { "AC", "2D", "3D", "4D", "5D" }
    Balatest.play_hand { "AD", "2H", "3H", "4H", "5H" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
  end,
}

--#region Expansion Pack

Balatest.TestPlay {
  name = "expansionpack_creates",
  category = "expansionpack",

  jokers = {"j_mf_expansion_pack"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
  end,
}

Balatest.TestPlay {
  name = "expansionpack_needs_room",
  category = "expansionpack",

  jokers = {"j_mf_expansion_pack", "j_joker","j_joker","j_joker","j_joker"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
  end,
}

-- #region Joke Merge Valley

Balatest.TestPlay {
  name = "farmmerge_junk",
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},

  execute = function()
    Balatest.discard{"AS", "2S", "3S", "4S", "5S"}
    Balatest.discard{"AC", "2C", "3C"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 8)
    Balatest.assert_eq(G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].added_to_deck)
    Balatest.assert_eq(G.discard.cards[4].added_to_deck)
    Balatest.assert_eq(G.discard.cards[5].added_to_deck)
    Balatest.assert_eq(G.discard.cards[6].added_to_deck)
    Balatest.assert_eq(G.discard.cards[7].added_to_deck)
    Balatest.assert_eq(G.discard.cards[8].added_to_deck)
  end,
}

Balatest.TestPlay {
  name = "farmmerge_merges",
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},

  execute = function()
    Balatest.discard{"AS", "AC", "AH"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 3)
    Balatest.assert_eq(not G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(not G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].ability.perma_bonus, 22)
    Balatest.assert(G.discard.cards[3]:is_suit("Hearts"))
  end,
}

Balatest.TestPlay {
  name = "farmmerge_merges_modifications",
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},
  consumeables = {"c_chariot", "c_trance", "c_aura"},

  execute = function()
    Balatest.highlight{"AS"}
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight{"AC"}
    Balatest.use(G.consumeables.cards[2])

    Balatest.hook(_G, 'poll_edition', function(old, ...)
      return "e_foil"
    end)

    Balatest.highlight{"AH"}
    Balatest.use(G.consumeables.cards[3])
    Balatest.unhighlight_all()
    Balatest.discard{"AS", "AC", "AH"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 3)
    Balatest.assert_eq(not G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(not G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].ability.perma_bonus, 22)
    Balatest.assert(G.discard.cards[3]:is_suit("Hearts"))
    Balatest.assert(G.discard.cards[3].edition.foil)
    Balatest.assert(G.discard.cards[3].seal == "Blue")
    Balatest.assert(G.discard.cards[3].config.center.key == "m_steel")
  end,
}

Balatest.TestPlay {
  name = "farmmerge_merges_priority",
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},
  consumeables = {"c_chariot", "c_justice", "c_trance", "c_talisman", "c_aura", "c_aura"},

  execute = function()
    Balatest.highlight{"AS"}
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight{"AC"}
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight{"AC"}
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight{"AH"}
    Balatest.use(G.consumeables.cards[4])

    Balatest.hook(_G, 'poll_edition', function(old, ...)
      return "e_foil"
    end)

    Balatest.highlight{"AS"}
    Balatest.use(G.consumeables.cards[5])
    Balatest.unhighlight_all()

    Balatest.hook(_G, 'poll_edition', function(old, ...)
      return "e_holo"
    end)
    Balatest.highlight{"AH"}
    Balatest.use(G.consumeables.cards[6])
    Balatest.unhighlight_all()

    Balatest.discard{"AS", "AC", "AH"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 3)
    Balatest.assert_eq(not G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(not G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].ability.perma_bonus, 22)
    Balatest.assert(G.discard.cards[3]:is_suit("Hearts"))
    Balatest.assert(G.discard.cards[3].edition.holo)
    Balatest.assert(G.discard.cards[3].seal == "Gold")
    Balatest.assert(G.discard.cards[3].config.center.key == "m_glass")
  end,
}

-- #region Flesh Prison

Balatest.TestPlay {
  name = "fleshprison_smallblind",
  category = "fleshprison",

  jokers = {"j_mf_fleshprison"},

  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0)
    Balatest.assert_eq(#G.jokers.cards, 1)
  end
}

Balatest.TestPlay {
  name = "fleshprison_bossblind",
  category = "fleshprison",

  jokers = {"j_mf_fleshprison", "j_cavendish", "j_cavendish", "j_cavendish", "j_cavendish"},

  blind = "bl_psychic",

  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_soul")
    Balatest.assert_eq(#G.jokers.cards, 4)
  end
}

-- #region Flint and Steel

Balatest.TestPlay {
  name = "flintandsteel_no_trigger",
  category = "flintandsteel",

  jokers = {"j_mf_flintandsteel"},

  execute = function()
    Balatest.play_hand { "AS" }
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * 2)
  end
}

Balatest.TestPlay {
  name = "flintandsteel_one_trigger",
  category = "flintandsteel",

  jokers = {"j_mf_flintandsteel"},
  consumeables = {"c_tower", "c_chariot"},

  blind = "bl_wall",

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { "2S", "2C" }
  end,
  assert = function()
    Balatest.assert_chips((15 + 2 + 50) * 2)
  end
}

Balatest.TestPlay {
  name = "flintandsteel_mixed_trigger",
  category = "flintandsteel",

  jokers = {"j_mf_flintandsteel"},
  consumeables = {"c_tower", "c_chariot"},

  blind = "bl_wall",

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { "2S", "2C", "2H", "3S", "3C" }
  end,
  assert = function()
    Balatest.assert_chips((40 + 2 + 2 + 50 + 3 + 3) * 3)
  end
}

-- #region Friend Inside Me

Balatest.TestPlay {
  name = "friendinsideme_common",
  category = "friendinsideme",

  jokers = {"j_mf_friendinsideme", "j_joker"},

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
    Balatest.assert_eq(G.jokers.cards[2].config.center.rarity, 2)
  end
}

Balatest.TestPlay {
  name = "friendinsideme_uncommon",
  category = "friendinsideme",

  jokers = {"j_mf_friendinsideme", "j_oops"},

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
    Balatest.assert_eq(G.jokers.cards[2].config.center.rarity, 3)
  end
}

Balatest.TestPlay {
  name = "friendinsideme_rare",
  category = "friendinsideme",

  jokers = {"j_mf_friendinsideme", "j_baron"},

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 1)
  end
}

Balatest.TestPlay {
  name = "friendinsideme_twosells",
  category = "friendinsideme",

  jokers = {"j_mf_friendinsideme", "j_joker", "j_joker"},

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
    Balatest.assert_eq(G.jokers.cards[2].config.center.rarity, 2)
  end
}

-- #region Gemstone Joker

Balatest.TestPlay {
  name = "gemstone_no_gemstones",
  category = "gemstonejoker",
  dollars = 0,
  jokers = {"j_mf_gemstonejoker"},
  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end
}

Balatest.TestPlay {
  name = "gemstone_four_gemstones",
  category = "gemstonejoker",
  dollars = 0,
  jokers = {"j_mf_gemstonejoker"},
  consumeables = {"c_mf_rot_tower","c_mf_rot_tower","c_mf_rot_tower","c_mf_rot_tower"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '2H' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '2D' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 4)
  end
}

--#region Globe

Balatest.TestPlay {
  name = "globe_one_reroll",
  category = "globe",
  dollars = 99999,
  jokers = {"j_mf_globe"},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1)
  end
}

Balatest.TestPlay {
  name = "globe_three_rerolls",
  category = "globe",
  dollars = 99999,
  jokers = {"j_mf_globe"},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
  end
}

Balatest.TestPlay {
  name = "globe_no_overflow", -- crustulum experience...
  category = "globe",
  dollars = 99999,
  jokers = {"j_mf_globe"},
  consumeables = {"c_soul","c_soul",},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Planet", "should not have a planet")
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Tarot", "should not have a tarot")
    Balatest.assert(G.consumeables.cards[2].ability.set ~= "Planet", "should not have a planet")
    Balatest.assert(G.consumeables.cards[2].ability.set ~= "Tarot", "should not have a tarot")
  end
}

-- #region Golden Carrot

Balatest.TestPlay {
  name = "golden_carrot_one_hand",
  category = "goldencarrot",
  dollars = 0,
  jokers = {"j_mf_goldencarrot"},
  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 9)
  end
}

Balatest.TestPlay {
  name = "golden_carrot_five_hands",
  category = "goldencarrot",
  dollars = 0,
  jokers = {"j_mf_goldencarrot"},
  execute = function()
    Balatest.play_hand { "2S" }
    Balatest.play_hand { "2C" }
    Balatest.play_hand { "2H" }
    Balatest.play_hand { "2D" }
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end
}

Balatest.TestPlay {
  name = "golden_carrot_eaten",
  category = "goldencarrot",
  dollars = 0,
  jokers = {"j_mf_goldencarrot"},
  execute = function()
    Balatest.play_hand { "2S" }
    Balatest.play_hand { "2C" }
    Balatest.play_hand { "2H" }
    Balatest.play_hand { "2D" }
    Balatest.play_hand { "3S" }
    Balatest.play_hand { "3C" }
    Balatest.play_hand { "3H" }
    Balatest.play_hand { "3D" }
    Balatest.play_hand { "4S" }
    Balatest.play_hand { "4C" }
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0)
  end
}

-- #region Hall of Mirrors

Balatest.TestPlay {
  name = "hall_of_mirrors_one_six",
  category = "hallofmirrors",
  jokers = {"j_mf_hallofmirrors"},
  execute = function()
    Balatest.play_hand { "6S" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 3)
  end
}

Balatest.TestPlay {
  name = "hall_of_mirrors_four_sixes",
  category = "hallofmirrors",
  jokers = {"j_mf_hallofmirrors"},
  execute = function()
    Balatest.play_hand { "6S" }
    Balatest.play_hand { "6H" }
    Balatest.play_hand { "6C" }
    Balatest.play_hand { "6D" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 3 * 4)
  end
}

Balatest.TestPlay {
  name = "hall_of_mirrors_reset",
  category = "hallofmirrors",
  jokers = {"j_mf_hallofmirrors"},
  execute = function()
    Balatest.play_hand { "6S" }
    Balatest.play_hand { "6H" }
    Balatest.play_hand { "6C" }
    Balatest.play_hand { "6D" }
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52)
  end
}

-- #region Hollow Joker

Balatest.TestPlay {
  name = "hollow_joker_eight_hand_size",
  category = "hollow",
  jokers = {"j_mf_hollow"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' }
  } },

  hand_size = 8,
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 7)
    Balatest.assert_chips(16 * (1 + 10 * (9 - 7)))
  end
}

Balatest.TestPlay {
  name = "hollow_joker_two_hand_size",
  category = "hollow",
  jokers = {"j_mf_hollow"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },

  hand_size = 2,
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 1)
    Balatest.assert_chips(16 * (1 + 10 * (9 - 1)))
  end
}

-- #region Huge Joker

Balatest.TestPlay {
  name = "huge_joker_functionality",
  category = "hugejoker",
  jokers = {"j_mf_hugejoker"},

  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 50)
    Balatest.assert_chips(16 * 3)
  end
}

-- #region Hyper Beam

Balatest.TestPlay {
  name = "hyper_beam_functionality",
  category = "hyperbeam",
  jokers = {"j_mf_hyperbeam"},

  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.discards_left, 0)
    Balatest.assert_chips(16 * 3)
  end
}

-- #region Hyperjimbo

Balatest.TestPlay {
  name = "hyperjimbo_five_cards",
  category = "hyperjimbo",

  jokers = {"j_mf_hyperjimbo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(1000)
  end,
}

Balatest.TestPlay {
  name = "hyperjimbo_two_pair",
  category = "hyperjimbo",

  jokers = {"j_mf_hyperjimbo"},
  execute = function()
    Balatest.play_hand { '2C', '2S', '3S', '3C' }
  end,
  assert = function()
    Balatest.assert_chips(78)
  end,
}

Balatest.TestPlay {
  name = "hyperjimbo_four_of_a_kind",
  category = "hyperjimbo",

  jokers = {"j_mf_hyperjimbo"},
  execute = function()
    Balatest.play_hand { '2C', '2S', '2H', '2D' }
  end,
  assert = function()
    Balatest.assert_chips(926)
  end,
}

-- #region Impostor

Balatest.TestPlay {
  name = "impostor_no_reds",
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "impostor_one_red",
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 3)
  end,
}

Balatest.TestPlay {
  name = "impostor_two_red",
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AH', 'AD' }
  end,
  assert = function()
    Balatest.assert_chips((10 + 11 + 11) * 2)
  end,
}

Balatest.TestPlay {
  name = "impostor_sneaky_red",
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AS', '10H' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 3)
  end,
}

Balatest.TestPlay {
  name = "impostor_sneaky_two_red",
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AS', '10H', '9D' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

-- #region Jack of All Trades

Balatest.TestPlay {
  name = "joat_scores",
  category = "joat",

  jokers = {"j_mf_jackofalltrades"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( (16 + 10 * 4) * (1 + 2 * 4) )
    Balatest.assert_eq(G.GAME.dollars, 4)
  end,
}

Balatest.TestPlay {
  name = "joat_nojacks",
  category = "joat",
  
  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  jokers = {"j_mf_jackofalltrades"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

-- #region Jankman

Balatest.TestPlay {
  name = "jankman_solo",
  category = "jankman",

  jokers = {"j_mf_jankman"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 20 )
  end,
}

Balatest.TestPlay {
  name = "jankman_unmodded",
  category = "jankman",

  jokers = {"j_mf_jankman","j_joker","j_joker","j_joker","j_joker"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 356 )
  end,
}

Balatest.TestPlay {
  name = "jankman_modded",
  category = "jankman",

  jokers = {"j_mf_jankman","j_mf_globe","j_mf_globe","j_mf_globe","j_mf_globe"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 61 )
  end,
}

Balatest.TestPlay {
  name = "jankman_love_that_janker",
  category = "jankman",

  jokers = {"j_mf_jankman","j_mf_jankman","j_mf_jankman","j_mf_jankman","j_mf_jankman"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 13674 )
  end,
}

-- #region Jester

Balatest.TestPlay {
  name = "jester_chips",
  category = "jester",

  jokers = {"j_mf_jester"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 56 )
  end,
}

-- #region Junk Mail

Balatest.TestPlay {
  name = "junkmail_adds_correctly_priced_voucher",
  category = "jester",

  dollars = 15,

  jokers = {"j_mf_junkmail"},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

-- #region Less Fluff

Balatest.TestPlay {
  name = "lessfluff_vanilla",
  category = "lessfluff",

  jokers = {"j_mf_lessfluff", "j_joker", "j_joker"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * 9 )
  end,
}

Balatest.TestPlay {
  name = "lessfluff_modded",
  category = "lessfluff",

  jokers = {"j_mf_lessfluff", "j_mf_jester", "j_mf_jester"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 22 )
  end,
}

Balatest.TestPlay {
  name = "lessfluff_mixed",
  category = "lessfluff",

  jokers = {"j_joker", "j_joker", "j_mf_lessfluff", "j_mf_jester", "j_mf_jester"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 201 )
  end,
}

-- #region Lightning Strikes Thrice
Balatest.TestPlay {
  name = "lightningstrikesthrice_retriggers_purple_seal",
  category = "lightningstrikesthrice",

  jokers = {"j_mf_lightningstrikesthrice"},
  consumeables = {"c_medium"},
  vouchers = {"v_crystal_ball"},

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
    Balatest.discard { '2S' }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 3)
  end,
}

-- #region Loaded Disk

Balatest.TestPlay {
  name = "loadeddisk_sell",
  category = "loadeddisk",

  jokers = {"j_mf_loadeddisk"},
  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_pink")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_mf_yellow")
  end,
}

Balatest.TestPlay {
  name = "loadeddisk_sell_one_remaining",
  category = "loadeddisk",

  jokers = {"j_mf_loadeddisk"},
  consumeables = {"c_death"},
  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_death")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_mf_pink")
  end,
}

Balatest.TestPlay {
  name = "loadeddisk_sell_no_slots",
  category = "loadeddisk",

  jokers = {"j_mf_loadeddisk"},
  consumeables = {"c_death","c_death"},
  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_death")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_death")
  end,
}

-- #region Lollipop

Balatest.TestPlay {
  name = "lollipop_base_x_mult",
  category = "lollipop",

  jokers = {"j_mf_lollipop"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 28 )
  end,
}

Balatest.TestPlay {
  name = "lollipop_two_rounds_after",
  category = "lollipop",

  jokers = {"j_mf_lollipop"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 23 )
  end,
}

Balatest.TestPlay {
  name = "lollipop_eaten",
  category = "lollipop",

  jokers = {"j_mf_lollipop"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
    Balatest.assert_eq(#G.jokers.cards, 0)
  end,
}

-- #region Lucky Charm

Balatest.TestPlay {
  name = "lucky_charm_nope_mult",
  category = "luckycharm",
  dollars = 0,
  jokers = {"j_mf_luckycharm"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

Balatest.TestPlay {
  name = "lucky_charm_nope_cash",
  category = "luckycharm",
  dollars = 0,
  jokers = {"j_mf_luckycharm"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

Balatest.TestPlay {
  name = "lucky_charm_yep",
  category = "luckycharm",
  dollars = 0,
  jokers = {"j_mf_luckycharm"},
  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16*21 )
    Balatest.assert_eq(G.GAME.dollars, 20)
  end,
}

-- #region Marigold

Balatest.TestPlay {
  name = "marigold_doesnt_retrigger_not_marigold",
  category = "marigold",
  dollars = 0,
  jokers = {"j_mf_marigold", "j_photograph"},
  consumeables = {"c_devil"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( (100 + 11 + 10 + 10 + 10 + 10) * 8 * 2 )
    Balatest.assert_eq(G.GAME.dollars, 3)
  end,
}

Balatest.TestPlay {
  name = "marigold_retriggers_marigold",
  category = "marigold",
  dollars = 0,
  jokers = {"j_mf_marigold", "j_photograph"},
  consumeables = {"c_mf_rot_devil","c_mf_rot_devil"},
  execute = function()
    Balatest.highlight { '2S', 'AS', 'KS' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { 'QS', 'JS', 'TS' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( (100 + (11 + 10 + 10 + 10 + 10) * 3) * 8 * 8 )
    Balatest.assert_eq(G.GAME.dollars, 3)
  end,
}

-- #region Mashup Album

Balatest.TestPlay {
  name = "mashup_album_base_score",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( (5+11+15) * (1 + 4) )
  end,
}

Balatest.TestPlay {
  name = "mashup_album_bunch_of_junk",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { '2C', '2D' }
    Balatest.play_hand { '2H', '3C', '4C', '5C', '6C' }
  end,
  assert = function()
    Balatest.assert_chips( (5+11+15) * (1 + 4) + (10+2+2+15) * (2 + 4) + (30 + 2 + 3 + 4 + 5 + 6 + 15) * (4 + 4) )
  end,
}

Balatest.TestPlay {
  name = "mashup_album_red_flush",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '2H', '3H', '4H', '6H', '7H' }
  end,
  assert = function()
    Balatest.assert_chips( (35 + 2 + 3 + 4 + 6 + 7 + 15) * (4 + 8) )
  end,
}

Balatest.TestPlay {
  name = "mashup_album_black_flush",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '2C', '3C', '4C', '6C', '7C' }
  end,
  assert = function()
    Balatest.assert_chips( (35 + 2 + 3 + 4 + 6 + 7 + 30) * (4 + 4) )
  end,
}

Balatest.TestPlay {
  name = "mashup_album_red_black",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '2H', '3H', '4H', '6H', '7H' }
    Balatest.play_hand { '2C', '3C', '4C', '6C', '7C' }
  end,
  assert = function()
    Balatest.assert_chips( 
      (35 + 2 + 3 + 4 + 6 + 7 + 15) * (4 + 8) +
      (35 + 2 + 3 + 4 + 6 + 7 + 30) * (4 + 8)
    )
  end,
}

Balatest.TestPlay {
  name = "mashup_album_black_red",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '2C', '3C', '4C', '6C', '7C' }
    Balatest.play_hand { '2H', '3H', '4H', '6H', '7H' }
  end,
  assert = function()
    Balatest.assert_chips( 
      (35 + 2 + 3 + 4 + 6 + 7 + 30) * (4 + 4) +
      (35 + 2 + 3 + 4 + 6 + 7 + 30) * (4 + 8)
    )
  end,
}

Balatest.TestPlay {
  name = "mashup_album_persists",
  category = "mashupalbum",
  jokers = {"j_mf_mashupalbum"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '2C', '3C', '4C', '6C', '7C' }
    Balatest.play_hand { '2H', '3H', '4H', '6H', '7H' }
    Balatest.cash_out()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 
      (5 + 11 + 30) * (1 + 8)
    )
  end,
}

-- #region Missing Joker

Balatest.TestPlay {
  name = "missing_joker_transforms",
  category = "missingjoker",
  jokers = {"j_mf_missingjoker"},
  execute = function()
  end,
  assert = function()
    Balatest.assert(G.jokers.cards[1].config.center.key ~= "j_mf_missingjoker")
  end,
}

Balatest.TestPlay {
  name = "missing_joker_reverts",
  category = "missingjoker",
  jokers = {"j_mf_missingjoker"},
  execute = function()
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.jokers.cards[1].config.center.key == "j_mf_missingjoker")
  end,
}

-- #region Monochrome Joker

Balatest.TestPlay {
  name = "monochrome_joker_one_round",
  category = "monochrome",
  jokers = {"j_mf_monochrome"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
  end,
}

Balatest.TestPlay {
  name = "monochrome_joker_three_rounds",
  category = "monochrome",
  jokers = {"j_mf_monochrome"},

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 8))
  end,
}

Balatest.TestPlay {
  name = "monochrome_joker_resets_rounds",
  category = "monochrome",
  jokers = {"j_mf_monochrome"},

  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_white', ...)
    end)
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 2))
  end,
}

-- #region MS Paint Joker

Balatest.TestPlay {
  name = "mspaint_joker_initial_handsize",
  category = "mspaint",
  jokers = {"j_mf_mspaint"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 4)
  end,
}

Balatest.TestPlay {
  name = "mspaint_joker_second_hand",
  category = "mspaint",
  jokers = {"j_mf_mspaint"},

  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52)
  end,
}

Balatest.TestPlay {
  name = "mspaint_joker_goes_back_up",
  category = "mspaint",
  jokers = {"j_mf_mspaint"},

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 56)
  end,
}

-- #region One Slip Too Late
-- 
Balatest.TestPlay {
  name = "onesliptoolate_nevertriggers",
  category = "onesliptoolate",
  jokers = {"j_mf_onesliptoolate"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
  end,
}
Balatest.TestPlay {
  name = "onesliptoolate_triggersontwo",
  category = "onesliptoolate",
  jokers = {"j_mf_onesliptoolate"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS', 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 1 + 32 * 4)
  end,
}
Balatest.TestPlay {
  name = "onesliptoolate_triggersonthree",
  category = "onesliptoolate",
  jokers = {"j_mf_onesliptoolate"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS', 'AS', 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 2 + 63 * 9)
  end,
}
Balatest.TestPlay {
  name = "onesliptoolate_triggersonfour",
  category = "onesliptoolate",
  jokers = {"j_mf_onesliptoolate"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS', 'AS', 'AS', 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 3 + 104 * 28)
  end,
}
Balatest.TestPlay {
  name = "onesliptoolate_triggersonfive",
  category = "onesliptoolate",
  jokers = {"j_mf_onesliptoolate"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { 'AS', 'AS', 'AS', 'AS', 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 4 + 215 * 80)
  end,
}

-- #region Paint Can

Balatest.TestPlay {
  name = "paintcan_one_rigged_off",
  category = "paintcan",
  jokers = {"j_mf_paintcan"},
  consumeables = {"c_mf_black"},

  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 1)
  end,
}

Balatest.TestPlay {
  name = "paintcan_one_rigged_on",
  category = "paintcan",
  jokers = {"j_mf_paintcan"},
  consumeables = {"c_mf_black"},

  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 2)
  end,
}

Balatest.TestPlay {
  name = "paintcan_three_rigged_on",
  category = "paintcan",
  jokers = {"j_mf_paintcan","j_mf_paintcan","j_mf_paintcan"},
  consumeables = {"c_mf_black"},

  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 0)
    Balatest.assert_eq(G.consumeables.cards[1].ability.val, 1)
  end,
}

-- #region Philosophical Joker

Balatest.TestPlay {
  name = "philosophical_joker_slots",
  category = "philosophical",
  jokers = {"j_mf_philosophical"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(G.jokers.config.card_limit, 6)
  end,
}

Balatest.TestPlay {
  name = "philosophical_joker_sell",
  category = "philosophical",
  jokers = {"j_mf_philosophical"},

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.jokers.config.card_limit, 5)
  end,
}

Balatest.TestPlay {
  name = "philosophical_buy_with_full_slots",
  category = "philosophical",
  jokers = {"j_joker","j_joker","j_joker","j_joker","j_joker"},

  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'j_mf_philosophical', ...)
    end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
  end,
  assert = function()
    Balatest.assert_eq(G.jokers.config.card_limit, 6)
  end,
}

-- #region Pixel Joker

Balatest.TestPlay {
  name = "pixel_joker_junk",
  category = "pixeljoker",
  jokers = {"j_mf_pixeljoker"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '2S' }
    Balatest.play_hand { '2C', '2D' }
    Balatest.play_hand { '3H', '3C', '5S', '5C', '5D' }
  end,
  assert = function()
    Balatest.assert_chips( 
      (5 + 2) + (10 + 2 + 2) * 2 + (3 + 3 + 5 + 5 + 5 + 40) * 4
    )
  end,
}

Balatest.TestPlay {
  name = "pixel_joker_fullhouse",
  category = "pixeljoker",
  jokers = {"j_mf_pixeljoker"},
  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { '9H', '9C', '9D', 'AS', 'AH' }
  end,
  assert = function()
    Balatest.assert_chips( 
      math.floor((40 + 9 + 9 + 9 + 11 + 11) * (4 * 1.5 * 1.5 * 1.5 * 1.5 * 1.5))
    )
  end,
}

-- #region Rainbow Joker

Balatest.TestPlay {
  name = "rainbow_no_colours",
  category = "rainbowjoker",
  jokers = {"j_mf_rainbowjoker"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
  end,
}

Balatest.TestPlay {
  name = "rainbow_two_colours",
  category = "rainbowjoker",
  jokers = {"j_mf_rainbowjoker"},
  consumeables = {"c_mf_white", "c_mf_white"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 36 )
  end,
}

Balatest.TestPlay {
  name = "rainbow_ten_colours",
  category = "rainbowjoker",
  jokers = {"j_mf_rainbowjoker"},
  consumeables = {"c_mf_white", "c_mf_white","c_mf_white", "c_mf_white","c_mf_white", "c_mf_white","c_mf_white", "c_mf_white","c_mf_white", "c_mf_white"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 922 )
  end,
}

-- #region Recycling

Balatest.TestPlay {
  name = "recycling_skip",
  category = "recycling",
  jokers = {"j_mf_recycling"},
  execute = function()
    Balatest.hook(_G, 'get_pack', function() return { key = 'p_buffoon_normal_1' } end)
    Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
        return set == 'Joker' and orig(set, a, l, r, k, s, 'j_joker', ...) or orig(set, a, l, r, k, s, f, ...)
    end)
    Balatest.hook(_G, 'poll_edition', function() end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.use(function() return G.shop_booster.cards[2] end)
    Balatest.q(function() G.FUNCS.skip_booster() end)
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
  end,
}

Balatest.TestPlay {
  name = "recycling_no_overflow",
  category = "recycling",
  jokers = {"j_mf_recycling"},
  consumeables = {"c_ouija","c_ouija"},
  execute = function()
    Balatest.hook(_G, 'get_pack', function() return { key = 'p_buffoon_normal_1' } end)
    Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
        return set == 'Joker' and orig(set, a, l, r, k, s, 'j_joker', ...) or orig(set, a, l, r, k, s, f, ...)
    end)
    Balatest.hook(_G, 'poll_edition', function() end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.use(function() return G.shop_booster.cards[2] end)
    Balatest.q(function() G.FUNCS.skip_booster() end)
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Planet", "should not have a planet")
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Tarot", "should not have a tarot")
    Balatest.assert(G.consumeables.cards[2].ability.set ~= "Planet", "should not have a planet")
    Balatest.assert(G.consumeables.cards[2].ability.set ~= "Tarot", "should not have a tarot")
  end,
}

-- #region Rose-Tinted Glasses

Balatest.TestPlay {
  name = "rosetinted_one_two",
  category = "rosetinted",
  jokers = {"j_mf_rosetinted"},
  execute = function()
    Balatest.play_hand { "2S" } 
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 1 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_double" )
    Balatest.assert_eq(#G.playing_cards, 51)
  end,
}

Balatest.TestPlay {
  name = "rosetinted_random_hand",
  category = "rosetinted",
  jokers = {"j_mf_rosetinted"},
  execute = function()
    Balatest.play_hand { "3S" } 
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 0 )
    Balatest.assert_eq(#G.playing_cards, 52)
  end,
}

Balatest.TestPlay {
  name = "rosetinted_two_on_second",
  category = "rosetinted",
  jokers = {"j_mf_rosetinted"},
  execute = function()
    Balatest.play_hand { "3S" } 
    Balatest.play_hand { "2S" } 
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 0 )
    Balatest.assert_eq(#G.playing_cards, 52)
  end,
}

-- #region Cartomancer!

Balatest.TestPlay {
  name = "rot_cartomancer_creates",
  category = "rot_cartomancer",

  jokers = {"j_mf_rot_cartomancer"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "created one")
  end,
}

-- #region Simplified Joker

Balatest.TestPlay {
  name = "simplified_solo",
  category = "simplified",

  jokers = {"j_mf_simplified"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * 5 )
  end,
}

Balatest.TestPlay {
  name = "simplified_two",
  category = "simplified",

  jokers = {"j_mf_simplified","j_mf_simplified"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+4*4) )
  end,
}

Balatest.TestPlay {
  name = "simplified_other_commons",
  category = "simplified",

  jokers = {"j_mf_simplified","j_mf_clownfish","j_mf_clownfish","j_mf_clownfish","j_mf_clownfish"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+4*5) )
  end,
}

Balatest.TestPlay {
  name = "simplified_other_uncommons",
  category = "simplified",

  jokers = {"j_mf_simplified","j_mf_globe","j_mf_globe","j_mf_globe","j_mf_globe"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+4) )
  end,
}

Balatest.TestPlay {
  name = "simplified_five_copies",
  category = "simplified",

  jokers = {"j_mf_simplified","j_mf_simplified","j_mf_simplified","j_mf_simplified","j_mf_simplified"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+4*25) )
  end,
}

-- #region Slot Machine

Balatest.TestPlay {
  name = "slotmachine_rigged_off",
  category = "slotmachine",

  jokers = {"j_mf_slotmachine","j_pareidolia","j_photograph"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.play_hand { '7S' }
  end,
  assert = function()
    Balatest.assert_chips( 12 * 2 )
  end,
}

Balatest.TestPlay {
  name = "slotmachine_rigged_on",
  category = "slotmachine",

  jokers = {"j_mf_slotmachine","j_pareidolia","j_photograph"},
  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.play_hand { '7S' }
  end,
  assert = function()
    Balatest.assert_chips( (5+7*8) * 2^8 )
  end,
}

-- #region Snake

Balatest.TestPlay {
  name = "snake_discard_one",
  category = "snake",

  jokers = {"j_mf_snake"},
  hand_size = 5,

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.discard { 'AS' }
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.cards, 7)
  end,
}

Balatest.TestPlay {
  name = "snake_discard_five",
  category = "snake",

  jokers = {"j_mf_snake"},
  hand_size = 5,

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } },

  execute = function()
    Balatest.discard { 'AS','AS','AS','AS','AS' }
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.cards, 3)
  end,
}

-- #region Spiral Joker

Balatest.TestPlay {
  name = "spiral_zero_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 0,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+17) )
  end,
}

Balatest.TestPlay {
  name = "spiral_one_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 1,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+16) )
  end,
}

Balatest.TestPlay {
  name = "spiral_two_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 2,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+15) )
  end,
}

Balatest.TestPlay {
  name = "spiral_three_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 3,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+13) )
  end,
}

Balatest.TestPlay {
  name = "spiral_four_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 4,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+10) )
  end,
}

Balatest.TestPlay {
  name = "spiral_five_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 5,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+7) )
  end,
}

Balatest.TestPlay {
  name = "spiral_six_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 6,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+5) )
  end,
}

Balatest.TestPlay {
  name = "spiral_seven_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 7,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+4) )
  end,
}

Balatest.TestPlay {
  name = "spiral_eight_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 8,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+3) )
  end,
}

Balatest.TestPlay {
  name = "spiral_nine_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 9,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+4) )
  end,
}

Balatest.TestPlay {
  name = "spiral_ten_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 10,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+5) )
  end,
}

Balatest.TestPlay {
  name = "spiral_eleven_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 11,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+7) )
  end,
}

Balatest.TestPlay {
  name = "spiral_twelve_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 12,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+10) )
  end,
}

Balatest.TestPlay {
  name = "spiral_thirteen_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 13,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+13) )
  end,
}

Balatest.TestPlay {
  name = "spiral_fourteen_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 14,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+15) )
  end,
}

Balatest.TestPlay {
  name = "spiral_fifteen_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 15,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+16) )
  end,
}

Balatest.TestPlay {
  name = "spiral_sixteen_money",
  category = "spiral",

  jokers = {"j_mf_spiral"},
  dollars = 16,
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * (1+17) )
  end,
}

-- #region StoneJoker Joker

Balatest.TestPlay {
  name = "stonejokerjoker_one_round",
  category = "stonejokerjoker",

  jokers = {"j_mf_stonejokerjoker"},
  execute = function()
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
    Balatest.assert(G.jokers.cards[2].config.center.key == "j_marble")
    Balatest.assert(G.jokers.cards[2].ability.eternal)
    Balatest.assert(G.jokers.cards[2].edition.negative)
  end,
}

Balatest.TestPlay {
  name = "stonejokerjoker_ten_rounds",
  category = "stonejokerjoker",

  jokers = {"j_mf_stonejokerjoker"},
  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 11)
  end,
}

-- #region StoneJoker Joker

Balatest.TestPlay {
  name = "stylemeter_no_skips",
  category = "stylemeter",

  jokers = {"j_mf_stylemeter"},
  dollars = 0,
  execute = function()
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

Balatest.TestPlay {
  name = "stylemeter_two_skips",
  category = "stylemeter",

  jokers = {"j_mf_stylemeter"},
  dollars = 0,
  no_auto_start = true,
  execute = function()
    Balatest.skip_blind("tag_voucher")
    Balatest.skip_blind("tag_voucher")
    Balatest.start_round()
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 6)
  end,
}

-- #region Sudoku Joker

Balatest.TestPlay {
  name = "sudoku_base",
  category = "sudoku",

  jokers = {"j_mf_sudoku"},
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
  end,
}

Balatest.TestPlay {
  name = "sudoku_triggers",
  category = "sudoku",

  jokers = {"j_mf_sudoku"},
  execute = function()
    Balatest.play_hand { "AS", "2S", "3S", "4S", "5C" }
    Balatest.play_hand { "6S", "7S", "8S", "9S", "TC" }
    Balatest.cash_out()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 80 )
  end,
}

Balatest.TestPlay {
  name = "sudoku_resets",
  category = "sudoku",

  jokers = {"j_mf_sudoku"},
  blind = "bl_wheel",
  execute = function()
    Balatest.play_hand { "AS", "2S", "3S", "4S", "5C" }
    Balatest.play_hand { "6S", "7S", "8S", "9S", "TC" }
    Balatest.cash_out()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
  end,
}

-- #region Tall Joker

Balatest.TestPlay {
  name = "talljoker_gives_mult",
  category = "talljoker",

  jokers = {"j_mf_talljoker"},
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 16 * 45 )
  end,
}

-- #region Teal Joker

Balatest.TestPlay {
  name = "tealjoker_base",
  category = "tealjoker",

  jokers = {"j_mf_tealjoker"},
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
  end,
}

Balatest.TestPlay {
  name = "tealjoker_one_teal",
  category = "tealjoker",

  jokers = {"j_mf_tealjoker"},
  consumeables = {"c_mf_rot_chariot"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.discard { "2S" }
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 19 )
  end,
}

Balatest.TestPlay {
  name = "tealjoker_five_teal",
  category = "tealjoker",

  jokers = {"j_mf_tealjoker"},
  consumeables = {"c_mf_rot_chariot","c_mf_rot_chariot","c_mf_rot_chariot","c_mf_rot_chariot","c_mf_rot_chariot"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '3S' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '4S' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.highlight { '6S' }
    Balatest.use(G.consumeables.cards[5])
    Balatest.discard { "2S", "3S", "4S", "5S", "6S" }
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 32 )
  end,
}

-- #region The Solo

Balatest.TestPlay {
  name = "thesolo_one_highcard",
  category = "thesolo",

  jokers = {"j_mf_the_solo"},

  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_chips( 17 )
  end,
}

Balatest.TestPlay {
  name = "thesolo_five_cards",
  category = "thesolo",

  jokers = {"j_mf_the_solo"},

  blind = "bl_wall",
  execute = function()
    Balatest.play_hand { "AS", "KD", "QS", "JS", "TS" }
  end,
  assert = function()
    Balatest.assert_chips( 324 )
  end,
}

Balatest.TestPlay {
  name = "thesolo_four_highcards",
  category = "thesolo",

  jokers = {"j_mf_the_solo"},

  execute = function()
    Balatest.play_hand { "5S" }
    Balatest.play_hand { "5D" }
    Balatest.play_hand { "5H" }
    Balatest.play_hand { "5C" }
  end,
  assert = function()
    Balatest.assert_chips( 11 + 12 + 13 + 14 )
  end,
}

-- #region I Sip Toner Soup

Balatest.TestPlay {
  name = "tonersoup_played_hand",
  category = "tonersoup",

  jokers = {"j_mf_tonersoup"},

  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have a consumeable")
    Balatest.assert(G.consumeables.cards[1].ability.set == "Tarot", "should have a tarot")
  end,
}

Balatest.TestPlay {
  name = "tonersoup_eaten",
  category = "tonersoup",

  jokers = {"j_mf_tonersoup"},

  execute = function()
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0, "should have eaten")
  end,
}

-- #region Top 10 Jokers From One Through Ten

Balatest.TestPlay {
  name = "top10_one_digit",
  category = "top10",

  dollars = 1,

  jokers = {"j_mf_top10"},

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 6)
  end,
}

Balatest.TestPlay {
  name = "top10_two_digit",
  category = "top10",

  dollars = 10,

  jokers = {"j_mf_top10"},

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 20)
  end,
}

Balatest.TestPlay {
  name = "top10_three_digit",
  category = "top10",

  dollars = 123,

  jokers = {"j_mf_top10"},

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 123 + 15)
  end,
}

Balatest.TestPlay {
  name = "top10_three_rep_digit",
  category = "top10",

  dollars = 111,

  jokers = {"j_mf_top10"},

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 111 + 5)
  end,
}

Balatest.TestPlay {
  name = "top10_four_digit",
  category = "top10",

  dollars = 1234,

  jokers = {"j_mf_top10"},

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 1234 + 20)
  end,
}

-- #region Treasure Map

Balatest.TestPlay {
  name = "treasuremap_no_rounds",
  category = "treasuremap",

  jokers = {"j_mf_treasuremap"},
  dollars = 0,

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 2)
  end,
}

Balatest.TestPlay {
  name = "treasuremap_one_round",
  category = "treasuremap",

  jokers = {"j_mf_treasuremap"},
  dollars = 0,

  execute = function()
    Balatest.next_round()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 2)
  end,
}

Balatest.TestPlay {
  name = "treasuremap_two_rounds",
  category = "treasuremap",

  jokers = {"j_mf_treasuremap"},
  dollars = 0,

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 15)
  end,
}

-- #region Triangle

Balatest.TestPlay {
  name = "triangle_junk",
  category = "triangle",

  jokers = {"j_mf_triangle"},

  execute = function()
    Balatest.play_hand { 'AS' }
    Balatest.play_hand { '2C', '2D' }
    Balatest.play_hand { '2H', '3C', '4C', '5C', '6C' }
  end,
  assert = function()
    Balatest.assert_chips( (5+11) * (1) + (10+2+2) * (2) + (30 + 2 + 3 + 4 + 5 + 6) * (4) )
  end,
}

Balatest.TestPlay {
  name = "triangle_3oak",
  category = "triangle",

  jokers = {"j_mf_triangle"},

  execute = function()
    Balatest.play_hand { '2C', '2D', '2H' }
  end,
  assert = function()
    Balatest.assert_chips( 36 * 3*3*3*3 )
  end,
}

Balatest.TestPlay {
  name = "triangle_3oak_splash",
  category = "triangle",

  jokers = {"j_mf_triangle","j_splash"},

  execute = function()
    Balatest.play_hand { '2C', '2D', '2H', '3S', '4D' }
  end,
  assert = function()
    Balatest.assert_chips( (30 + 6 + 7) * 3*3*3*3*3*3 )
  end,
}

-- #region Unpleasant Card

Balatest.TestPlay {
  name = "unpleasantcard_xchips",
  category = "unpleasantcard",

  jokers = {"j_mf_unpleasantcard"},

  execute = function()
    Balatest.play_hand { '5D' }
  end,
  assert = function()
    Balatest.assert_chips( 27 )
  end,
}

Balatest.TestPlay {
  name = "unpleasantcard_skips_pack",
  category = "unpleasantcard",

  jokers = {"j_mf_unpleasantcard"},

  no_auto_start = true,

  execute = function()
    Balatest.skip_blind("tag_mf_colour")
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED)
  end,
}

-- #region Unpleasant Card

Balatest.TestPlay {
  name = "unregisteredhypercam_straight",
  category = "unregisteredhypercam",

  jokers = {"j_mf_unregisteredhypercam"},

  execute = function()
    Balatest.play_hand { 'AD', 'KS', 'QS', 'JS', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( 350 )
  end,
}

Balatest.TestPlay {
  name = "unregisteredhypercam_lv_ten_highcard",
  category = "unregisteredhypercam",

  jokers = {"j_mf_unregisteredhypercam"},
  consumeables = {"c_pluto","c_pluto","c_pluto","c_pluto","c_pluto","c_pluto","c_pluto","c_pluto","c_pluto",},

  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.use(G.consumeables.cards[2])
    Balatest.use(G.consumeables.cards[3])
    Balatest.use(G.consumeables.cards[4])
    Balatest.use(G.consumeables.cards[5])
    Balatest.use(G.consumeables.cards[6])
    Balatest.use(G.consumeables.cards[7])
    Balatest.use(G.consumeables.cards[8])
    Balatest.use(G.consumeables.cards[9])
    Balatest.play_hand { 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( 1311 )
  end,
}

-- #region Virtual Joker

Balatest.TestPlay {
  name = "virtualjoker_solo",
  category = "virtual",

  jokers = {"j_mf_virtual"},

  execute = function()
    Balatest.play_hand { 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( 45 )
    Balatest.assert( G.jokers.cards[1].facing == "back" )
  end,
}

-- #region Wide Joker

Balatest.TestPlay {
  name = "widejoker_highcard",
  category = "widejoker",

  jokers = {"j_mf_widejoker"},

  execute = function()
    Balatest.play_hand { 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( 15 )
  end,
}

Balatest.TestPlay {
  name = "widejoker_sflush",
  category = "widejoker",

  jokers = {"j_mf_widejoker"},

  execute = function()
    Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( 1616 )
  end,
}

-- #region Wild Draw Four

Balatest.TestPlay {
  name = "wilddrawfour_one_wild",
  category = "wilddrawfour",
  jokers = {"j_mf_wilddrawfour"},
  consumeables = {"c_lovers"},
  execute = function()
    Balatest.highlight { '6S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "6S" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 4)
  end
}

Balatest.TestPlay {
  name = "wilddrawfour_four_wild",
  category = "wilddrawfour",
  jokers = {"j_mf_wilddrawfour"},
  consumeables = {"c_lovers","c_lovers","c_lovers","c_lovers"},
  execute = function()
    Balatest.highlight { '6S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '6H' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '6C' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '6D' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { "6S" }
    Balatest.play_hand { "6H" }
    Balatest.play_hand { "6C" }
    Balatest.play_hand { "6D" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 4 * 4)
  end
}

Balatest.TestPlay {
  name = "wilddrawfour_reset",
  category = "wilddrawfour",
  jokers = {"j_mf_wilddrawfour"},
  consumeables = {"c_lovers","c_lovers","c_lovers","c_lovers"},
  execute = function()
    Balatest.highlight { '6S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '6H' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '6C' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '6D' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { "6S" }
    Balatest.play_hand { "6H" }
    Balatest.play_hand { "6C" }
    Balatest.play_hand { "6D" }
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52)
  end
}

-- #region Yucky Rat

Balatest.TestPlay {
  name = "yuckyrat_straight",
  category = "yuckyrat",
  jokers = {"j_mf_yuckyrat"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5C' }
  end,
  assert = function()
    Balatest.assert_chips(275)
  end
}

Balatest.TestPlay {
  name = "yuckyrat_two_straights",
  category = "yuckyrat",
  jokers = {"j_mf_yuckyrat"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5C' }
    Balatest.play_hand { 'AC', '2C', '3C', '4C', '5H' }
  end,
  assert = function()
    Balatest.assert_chips(605)
  end
}
