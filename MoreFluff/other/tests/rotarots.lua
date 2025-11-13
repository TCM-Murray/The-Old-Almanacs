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

Balatest.TestPlay {
  name = "rotarot_fool_nothingbefore",
  category = "rotarot",
  consumeables = {"c_mf_rot_fool"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 0 )
  end
}

Balatest.TestPlay {
  name = "rotarot_fool_copies_colour",
  category = "rotarot",
  consumeables = {"c_mf_rot_fool","c_mf_yellow"},
  execute = function()
    Balatest.use(G.consumeables.cards[2])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_yellow")
  end
}

Balatest.TestPlay {
  name = "rotarot_fool_copies_rotarot",
  category = "rotarot",
  consumeables = {"c_mf_rot_fool","c_mf_rot_hermit"},
  execute = function()
    Balatest.use(G.consumeables.cards[2])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_rot_hermit")
  end
}

Balatest.TestPlay {
  name = "rotarot_fool_copies_most_recent",
  category = "rotarot",
  consumeables = {"c_mf_rot_fool","c_mf_rot_hermit","c_mf_yellow"},
  execute = function()
    Balatest.use(G.consumeables.cards[2])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[3])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_yellow")
  end
}

Balatest.TestPlay {
  name = "rotarot_magician_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_yucky") )
  end
}

Balatest.TestPlay {
  name = "rotarot_magician_five",
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    Balatest.highlight { '2S', '3S', '4S', '5S', '6S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S', '4S', '5S', '6S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[3], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[4], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[5], "m_mf_yucky") )
  end
}

Balatest.TestPlay {
  name = "yucky_rigged_off",
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { '2S', '3S', '4S', '5S', '6C' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '2S', '3S', '4S', '5S', '6C' }
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 5)
  end
}

Balatest.TestPlay {
  name = "yucky_rigged_on",
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.highlight { '2S', '3S', '4S', '5S', '6C' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '2S', '3S', '4S', '5S', '6C' }
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 0)
  end
}

Balatest.TestPlay {
  name = "rotarot_high_priestess",
  category = "rotarot",
  consumeables = {"c_mf_rot_high_priestess"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Colour")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Colour")
  end
}

Balatest.TestPlay {
  name = "rotarot_high_priestess_one_left",
  category = "rotarot",
  consumeables = {"c_mf_rot_high_priestess", "c_death"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Colour")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Colour")
  end
}

Balatest.TestPlay {
  name = "rotarot_empress_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_empress"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_cult") )
  end
}

Balatest.TestPlay {
  name = "rotarot_empress_two",
  category = "rotarot",
  consumeables = {"c_mf_rot_empress"},
  execute = function()
    Balatest.highlight { '2S', '3S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_cult") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_cult") )
  end
}

Balatest.TestPlay {
  name = "cult_lv_1",
  category = "rotarot",
  consumeables = {"c_mf_rot_empress"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( 20 )
  end
}

Balatest.TestPlay {
  name = "cult_lv_4",
  category = "rotarot",
  consumeables = {"c_mf_rot_empress","c_pluto","c_pluto","c_pluto"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.use(G.consumeables.cards[2])
    Balatest.use(G.consumeables.cards[3])
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( (35 + 5) * (4 + 4) )
  end
}

Balatest.TestPlay {
  name = "rotarot_emperor",
  category = "rotarot",
  consumeables = {"c_mf_rot_emperor"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Rotarot")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Rotarot")
  end
}

Balatest.TestPlay {
  name = "rotarot_emperor_one_left",
  category = "rotarot",
  consumeables = {"c_mf_rot_emperor", "c_death"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Rotarot")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Rotarot")
  end
}

Balatest.TestPlay {
  name = "rotarot_heirophant_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_monus") )
  end
}

Balatest.TestPlay {
  name = "rotarot_heirophant_two",
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant"},
  execute = function()
    Balatest.highlight { '2S', '3S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_monus") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_monus") )
  end
}

Balatest.TestPlay {
  name = "monus_lv_1",
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( 20 )
  end
}

Balatest.TestPlay {
  name = "monus_lv_4",
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant","c_pluto","c_pluto","c_pluto"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.use(G.consumeables.cards[2])
    Balatest.use(G.consumeables.cards[3])
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( (35 + 5 + 40) * 4 )
  end
}

Balatest.TestPlay {
  name = "rotarot_lovers_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_lovers"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_styled") )
  end
}

Balatest.TestPlay {
  name = "rotarot_lovers_two",
  category = "rotarot",
  consumeables = {"c_mf_rot_lovers"},
  execute = function()
    Balatest.highlight { '2S', '3S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_styled") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_styled") )
  end
}

Balatest.TestPlay {
  name = "styled_seal",
  category = "rotarot",
  consumeables = {"c_mf_rot_lovers"},

  deck = { cards = { 
    { r = '2', s = 'S' },
  } },

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.next_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert( G.hand.cards[1].seal ~= nil )
  end
}

Balatest.TestPlay {
  name = "rotarot_chariot",
  category = "rotarot",
  consumeables = {"c_mf_rot_chariot"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_teal") )
  end
}

Balatest.TestPlay {
  name = "teal_xchips",
  category = "rotarot",
  consumeables = {"c_mf_rot_chariot"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5C' }
  end,
  assert = function()
    Balatest.assert_chips( 15 )
  end
}

Balatest.TestPlay {
  name = "rotarot_justice",
  category = "rotarot",
  consumeables = {"c_mf_rot_justice"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_brass") )
  end
}

Balatest.TestPlay {
  name = "rotarot_brass_retriggers",
  category = "rotarot",
  consumeables = {"c_mf_rot_justice"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips(20)
  end
}

Balatest.TestPlay {
  name = "rotarot_brass_destroy_rigged_off",
  category = "rotarot",
  consumeables = {"c_mf_rot_justice"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 1)
  end
}

Balatest.TestPlay {
  name = "rotarot_brass_destroy_rigged_on",
  category = "rotarot",
  consumeables = {"c_mf_rot_justice"},
  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 0)
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_zero",
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 0,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 0 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_five",
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 5,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 25 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_twenty_four",
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 24,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 25 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_twenty_five",
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 25,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 25 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_twenty_six",
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 26,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 50 )
  end
}

Balatest.TestPlay {
  name = "rotarot_wheel_off",
  category = "rotarot",
  jokers = {"j_joker"},
  consumeables = {"c_mf_rot_wheel"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.jokers.cards[1].edition == nil )
  end
}

Balatest.TestPlay {
  name = "rotarot_wheel_on",
  category = "rotarot",
  jokers = {"j_joker"},
  consumeables = {"c_mf_rot_wheel"},
  execute = function()
    G.GAME.probabilities.normal = 99999
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.jokers.cards[1].edition ~= nil )
  end
}

Balatest.TestPlay {
  name = "rotarot_strength_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_strength"},
  deck = { cards = { 
    { r = '5', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.hand.cards[1]:get_id(), 10 )
  end
}

Balatest.TestPlay {
  name = "rotarot_strength_three",
  category = "rotarot",
  consumeables = {"c_mf_rot_strength"},
  deck = { cards = { 
    { r = '5', s = 'S' },
    { r = '5', s = 'S' },
    { r = '5', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.highlight { '5S','5S','5S' }
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.hand.cards[1]:get_id(), 10 )
    Balatest.assert_eq( G.hand.cards[2]:get_id(), 10 )
    Balatest.assert_eq( G.hand.cards[3]:get_id(), 10 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hanged_man",
  category = "rotarot",
  consumeables = {"c_mf_rot_hanged_man"},
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( #G.hand.cards, 49 )
  end
}

Balatest.TestPlay {
  name = "rotarot_death",
  category = "rotarot",
  consumeables = {"c_mf_rot_death"},
  deck = { cards = { 
    { r = '5', s = 'S' },
    { r = '6', s = 'S' },
    { r = '7', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.highlight { '5S','6S','7S' }
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.hand.cards[1]:get_id(), 5 )
    Balatest.assert_eq( G.hand.cards[2]:get_id(), 5 )
    Balatest.assert_eq( G.hand.cards[3]:get_id(), 5 )
  end
}

Balatest.TestPlay {
  name = "rotarot_temperance_joker",
  category = "rotarot",
  jokers = {"j_joker"},
  consumeables = {"c_mf_rot_temperance"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 4 )
  end
}

Balatest.TestPlay {
  name = "rotarot_temperance_consumeable",
  category = "rotarot",
  consumeables = {"c_mf_rot_temperance","c_mf_rot_temperance"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.consumeables.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 4 )
  end
}

Balatest.TestPlay {
  name = "rotarot_temperance_many_things",
  category = "rotarot",
  jokers = {"j_joker","j_joker"},
  consumeables = {"c_mf_rot_temperance","c_mf_rot_temperance","c_mf_rot_temperance"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[2] } } end)
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.consumeables.cards[1] } } end)
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.consumeables.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 16 )
  end
}

Balatest.TestPlay {
  name = "rotarot_devil_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_devil"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_marigold") )
  end
}

Balatest.TestPlay {
  name = "rotarot_devil_three",
  category = "rotarot",
  consumeables = {"c_mf_rot_devil"},
  execute = function()
    Balatest.highlight { '2S', '3S', '4S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S', '4S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_marigold") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_marigold") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[3], "m_mf_marigold") )
  end
}

Balatest.TestPlay {
  name = "marigold_one",
  category = "rotarot",
  consumeables = {"c_mf_rot_devil"},
  dollars = 0,
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.end_round()
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 1 )
  end
}

Balatest.TestPlay {
  name = "marigold_three",
  category = "rotarot",
  consumeables = {"c_mf_rot_devil"},
  dollars = 0,
  execute = function()
    Balatest.highlight { '2S', '3S', '4S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.end_round()
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 9 )
  end
}

Balatest.TestPlay {
  name = "rotarot_tower",
  category = "rotarot",
  consumeables = {"c_mf_rot_tower"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_gemstone") )
  end
}

Balatest.TestPlay {
  name = "gemstone_money_and_chips",
  category = "rotarot",
  consumeables = {"c_mf_rot_tower"},
  dollars = 0,
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '2S' }
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 3 )
    Balatest.assert_chips( 5 )
  end
}

Balatest.TestPlay {
  name = "rotarot_star",
  category = "rotarot",
  consumeables = {"c_mf_rot_star"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.hand.cards[2]:is_suit("Diamonds") )
    Balatest.assert( G.hand.cards[2].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[3]:is_suit("Diamonds") )
    Balatest.assert( G.hand.cards[3].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[4]:is_suit("Diamonds") )
    Balatest.assert( G.hand.cards[4].config.center ~= G.P_CENTERS.c_base )
  end
}

Balatest.TestPlay {
  name = "rotarot_moon",
  category = "rotarot",
  consumeables = {"c_mf_rot_moon"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.hand.cards[2]:is_suit("Clubs") )
    Balatest.assert( G.hand.cards[2].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[3]:is_suit("Clubs") )
    Balatest.assert( G.hand.cards[3].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[4]:is_suit("Clubs") )
    Balatest.assert( G.hand.cards[4].config.center ~= G.P_CENTERS.c_base )
  end
}

Balatest.TestPlay {
  name = "rotarot_sun",
  category = "rotarot",
  consumeables = {"c_mf_rot_sun"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.hand.cards[2]:is_suit("Hearts") )
    Balatest.assert( G.hand.cards[2].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[3]:is_suit("Hearts") )
    Balatest.assert( G.hand.cards[3].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[4]:is_suit("Hearts") )
    Balatest.assert( G.hand.cards[4].config.center ~= G.P_CENTERS.c_base )
  end
}

Balatest.TestPlay {
  name = "rotarot_judgement",
  category = "rotarot",
  consumeables = {"c_mf_rot_judgement"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },
  execute = function()
    -- Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first) -- this is commented out because it hangs. it probably tries continuously picking jimbo or smth
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( #G.jokers.cards, 1 )
  end
}

Balatest.TestPlay {
  name = "rotarot_world",
  category = "rotarot",
  consumeables = {"c_mf_rot_world"},
  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.hand.cards[2]:is_suit("Spades") )
    Balatest.assert( G.hand.cards[2].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[3]:is_suit("Spades") )
    Balatest.assert( G.hand.cards[3].config.center ~= G.P_CENTERS.c_base )
    Balatest.assert( G.hand.cards[4]:is_suit("Spades") )
    Balatest.assert( G.hand.cards[4].config.center ~= G.P_CENTERS.c_base )
  end
}