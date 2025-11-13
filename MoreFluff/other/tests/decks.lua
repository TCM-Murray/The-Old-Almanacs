Balatest.TestPlay {
  name = "gros_michel_deck",
  category = "decks",
  back = "Gros Michel Deck",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 1)
    Balatest.assert(G.jokers.cards[1].config.center.key == "j_gros_michel")
  end
}

Balatest.TestPlay {
  name = "philosophical_deck",
  category = "decks",
  back = "Philosophical Deck",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
    Balatest.assert(G.jokers.cards[1].config.center.key == "j_mf_philosophical")
    Balatest.assert(G.jokers.cards[2].config.center.key == "j_mf_philosophical")
    Balatest.assert(G.jokers.cards[3].config.center.key == "j_mf_philosophical")
    Balatest.assert(G.jokers.cards[4].config.center.key == "j_mf_philosophical")
    Balatest.assert(G.jokers.cards[5].config.center.key == "j_mf_philosophical")
  end
}

Balatest.TestPlay {
  name = "rainbow_deck",
  category = "decks",
  back = "Rainbow Deck",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_white")
    Balatest.assert_eq(#G.vouchers.cards, 1)
    Balatest.assert(G.vouchers.cards[1].config.center.key == "v_mf_paintroller")
  end
}

Balatest.TestPlay {
  name = "blasphemous_deck",
  category = "decks",
  back = "Blasphemous Deck",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 1)
    Balatest.assert(G.jokers.cards[1].config.center.key == "j_mf_blasphemy")
    Balatest.assert(G.jokers.cards[1].edition.negative)
    Balatest.assert(G.jokers.cards[1].ability.eternal)
  end
}