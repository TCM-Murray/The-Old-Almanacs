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

local add_colour_rounds = function(n)
  for i = 1, n do
    colour_end_of_round_effects()
  end
end
--#region Colour Card Base

Balatest.TestPlay {
  name = "colourcard_tickup",
  category = "colour_base",
  consumeables = {"c_mf_black"},
  execute = function()
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 1)
  end
}

Balatest.TestPlay {
  name = "colourcard_fullround",
  category = "colour_base",
  consumeables = {"c_mf_pink"},
  execute = function()
    Balatest.next_round()
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 0)
    Balatest.assert_eq(G.consumeables.cards[1].ability.val, 1)
  end
}

Balatest.TestPlay {
  name = "colourcard_manyrounds",
  category = "colour_base",
  consumeables = {"c_mf_pink"},
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
    Balatest.end_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 0)
    Balatest.assert_eq(G.consumeables.cards[1].ability.val, 5)
  end
}

--#region Black

Balatest.TestPlay {
  name = "colourcard_black_one",
  category = "colour_black",
  jokers = {"j_joker"},
  consumeables = {"c_mf_black"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.jokers.config.card_limit, 6)
  end
}

Balatest.TestPlay {
  name = "colourcard_black_two",
  category = "colour_black",
  jokers = {"j_joker","j_joker"},
  consumeables = {"c_mf_black"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(8) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.jokers.config.card_limit, 7)
  end
}

Balatest.TestPlay {
  name = "colourcard_black_two_doesnt_doubleup",
  category = "colour_black",
  jokers = {"j_joker"},
  consumeables = {"c_mf_black"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(8) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.jokers.config.card_limit, 6)
  end
}

--#region Deep Blue

Balatest.TestPlay {
  name = "colourcard_deepblue_one",
  category = "colour_deepblue",
  consumeables = {"c_mf_deepblue"},

  deck = { cards = { 
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' }
  } },

  hand_size = 8,

  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(1) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Spades"))
    Balatest.assert(not G.hand.cards[2]:is_suit("Spades"))
  end
}

Balatest.TestPlay {
  name = "colourcard_deepblue_four",
  category = "colour_deepblue",
  consumeables = {"c_mf_deepblue"},

  deck = { cards = { 
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' },
    { r = 'A', s = 'H' }
  } },

  hand_size = 8,

  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Spades"))
    Balatest.assert(G.hand.cards[2]:is_suit("Spades"))
    Balatest.assert(G.hand.cards[3]:is_suit("Spades"))
    Balatest.assert(G.hand.cards[4]:is_suit("Spades"))
    Balatest.assert(not G.hand.cards[5]:is_suit("Spades"))
  end
}

--#region Crimson

Balatest.TestPlay {
  name = "colourcard_crimson_one",
  category = "colour_crimson",
  consumeables = {"c_mf_crimson"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 1 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_rare" )
  end
}

Balatest.TestPlay {
  name = "colourcard_crimson_two",
  category = "colour_crimson",
  consumeables = {"c_mf_crimson"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(6) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 2 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_rare" )
    Balatest.assert_eq( G.GAME.tags[2].key == "tag_rare" )
  end
}

--#region Seaweed

Balatest.TestPlay {
  name = "colourcard_seaweed_one",
  category = "colour_seaweed",
  consumeables = {"c_mf_seaweed"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
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
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(1) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Clubs"))
    Balatest.assert(not G.hand.cards[2]:is_suit("Clubs"))
  end
}

Balatest.TestPlay {
  name = "colourcard_seaweed_four",
  category = "colour_seaweed",
  consumeables = {"c_mf_seaweed"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
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
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Clubs"))
    Balatest.assert(G.hand.cards[2]:is_suit("Clubs"))
    Balatest.assert(G.hand.cards[3]:is_suit("Clubs"))
    Balatest.assert(G.hand.cards[4]:is_suit("Clubs"))
    Balatest.assert(not G.hand.cards[5]:is_suit("Clubs"))
  end
}

--#region Brown

Balatest.TestPlay {
  name = "colourcard_brown_one",
  category = "colour_brown",
  consumeables = {"c_mf_brown"},
  dollars = 0,
  execute = function()
    Balatest.q(function() return add_colour_rounds(1) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.hand.cards, 51 )
    Balatest.assert_eq( G.GAME.dollars, 2 )
  end
}

Balatest.TestPlay {
  name = "colourcard_brown_three",
  category = "colour_brown",
  consumeables = {"c_mf_brown"},
  dollars = 0,
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.hand.cards, 49 )
    Balatest.assert_eq( G.GAME.dollars, 6 )
  end
}

--#region Grey

Balatest.TestPlay {
  name = "colourcard_grey_one",
  category = "colour_grey",
  consumeables = {"c_mf_grey"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 1 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_double" )
  end
}

Balatest.TestPlay {
  name = "colourcard_grey_two",
  category = "colour_grey",
  consumeables = {"c_mf_grey"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(6) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 2 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_double" )
    Balatest.assert_eq( G.GAME.tags[2].key == "tag_double" )
  end
}

--#region Silver

Balatest.TestPlay {
  name = "colourcard_silver_one",
  category = "colour_silver",
  consumeables = {"c_mf_silver"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 1 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_polychrome" )
  end
}

Balatest.TestPlay {
  name = "colourcard_silver_two",
  category = "colour_silver",
  consumeables = {"c_mf_silver"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(6) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.GAME.tags, 2 )
    Balatest.assert_eq( G.GAME.tags[1].key == "tag_polychrome" )
    Balatest.assert_eq( G.GAME.tags[2].key == "tag_polychrome" )
  end
}

--#region White

Balatest.TestPlay {
  name = "colourcard_white_one",
  category = "colour_white",
  consumeables = {"c_mf_white"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Colour")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_white_two",
  category = "colour_white",
  consumeables = {"c_mf_white"},
  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_white', ...)
    end)
    Balatest.q(function() return add_colour_rounds(6) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Colour")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
    Balatest.assert(G.consumeables.cards[2].ability.set == "Colour")
    Balatest.assert(G.consumeables.cards[2].edition.negative)
  end
}

--#region Red

Balatest.TestPlay {
  name = "colourcard_red_one",
  category = "colour_red",
  consumeables = {"c_mf_red"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
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
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(1) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Hearts"))
    Balatest.assert(not G.hand.cards[2]:is_suit("Hearts"))
  end
}

Balatest.TestPlay {
  name = "colourcard_red_four",
  category = "colour_red",
  consumeables = {"c_mf_red"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
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
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Hearts"))
    Balatest.assert(G.hand.cards[2]:is_suit("Hearts"))
    Balatest.assert(G.hand.cards[3]:is_suit("Hearts"))
    Balatest.assert(G.hand.cards[4]:is_suit("Hearts"))
    Balatest.assert(not G.hand.cards[5]:is_suit("Hearts"))
  end
}

--#region Orange

Balatest.TestPlay {
  name = "colourcard_orange_one",
  category = "colour_orange",
  consumeables = {"c_mf_orange"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
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
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(1) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Diamonds"))
    Balatest.assert(not G.hand.cards[2]:is_suit("Diamonds"))
  end
}

Balatest.TestPlay {
  name = "colourcard_orange_four",
  category = "colour_orange",
  consumeables = {"c_mf_orange"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
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
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1]:is_suit("Diamonds"))
    Balatest.assert(G.hand.cards[2]:is_suit("Diamonds"))
    Balatest.assert(G.hand.cards[3]:is_suit("Diamonds"))
    Balatest.assert(G.hand.cards[4]:is_suit("Diamonds"))
    Balatest.assert(not G.hand.cards[5]:is_suit("Diamonds"))
  end
}

--#region Yellow

Balatest.TestPlay {
  name = "colourcard_yellow_one",
  category = "colour_yellow",
  consumeables = {"c_mf_yellow"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.consumeables.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 10)
  end
}

Balatest.TestPlay {
  name = "colourcard_yellow_two",
  category = "colour_yellow",
  consumeables = {"c_mf_yellow"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(6) end)
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.consumeables.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 18)
  end
}

--#region Green

Balatest.TestPlay {
  name = "colourcard_green_one",
  category = "colour_green",
  consumeables = {"c_mf_green"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 1)
    Balatest.assert(G.jokers.cards[1].config.center.key == "j_mf_oopsallfives")
  end
}

Balatest.TestPlay {
  name = "colourcard_green_two",
  category = "colour_green",
  consumeables = {"c_mf_green"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(6) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
    Balatest.assert(G.jokers.cards[1].config.center.key == "j_mf_oopsallfives")
    Balatest.assert(G.jokers.cards[2].config.center.key == "j_mf_oopsallfives")
  end
}

--#region Blue

Balatest.TestPlay {
  name = "colourcard_blue_one",
  category = "colour_blue",
  consumeables = {"c_mf_blue"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(2) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Planet")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_blue_two",
  category = "colour_blue",
  consumeables = {"c_mf_blue"},
  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_pluto', ...)
    end)
    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Planet")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
    Balatest.assert(G.consumeables.cards[2].ability.set == "Planet")
    Balatest.assert(G.consumeables.cards[2].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_lilac_one",
  category = "colour_lilac",
  consumeables = {"c_mf_lilac"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(2) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Tarot")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_lilac_two",
  category = "colour_lilac",
  consumeables = {"c_mf_lilac"},
  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_death', ...)
    end)
    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Tarot")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
    Balatest.assert(G.consumeables.cards[2].ability.set == "Tarot")
    Balatest.assert(G.consumeables.cards[2].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_pink_one",
  category = "colour_pink",
  consumeables = {"c_mf_pink"},
  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_white', ...)
    end)
    Balatest.q(function() return add_colour_rounds(1) end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 1)
  end
}

Balatest.TestPlay {
  name = "colourcard_pink_two",
  category = "colour_pink",
  consumeables = {"c_mf_pink"},
  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_white', ...)
    end)
    Balatest.q(function() return add_colour_rounds(3) end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.consumeables.cards[1].ability.partial_rounds, 2)
  end
}

Balatest.TestPlay {
  name = "colourcard_peach_one",
  category = "colour_peach",
  consumeables = {"c_mf_peach"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(2) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Rotarot")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_peach_two",
  category = "colour_peach",
  consumeables = {"c_mf_peach"},
  execute = function()
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
      return orig(t, a, l, r, k, s, 'c_mf_rot_death', ...)
    end)
    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Rotarot")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
    Balatest.assert(G.consumeables.cards[2].ability.set == "Rotarot")
    Balatest.assert(G.consumeables.cards[2].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_gold_one",
  category = "colour_gold",
  consumeables = {"c_mf_new_gold"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(4) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_soul")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
  end
}

Balatest.TestPlay {
  name = "colourcard_gold_two",
  category = "colour_gold",
  consumeables = {"c_mf_new_gold"},
  execute = function()
    Balatest.q(function() return add_colour_rounds(8) end)
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_soul")
    Balatest.assert(G.consumeables.cards[1].edition.negative)
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_soul")
    Balatest.assert(G.consumeables.cards[2].edition.negative)
  end
}
