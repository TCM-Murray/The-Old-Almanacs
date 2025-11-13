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
  name = "the_ticket",
  category = "superboss",

  blind = "bl_wheel", -- to increase ante
  dollars = 0,
  execute = function()
    G.GAME.win_ante = 2
    Balatest.hook(_G, 'get_new_boss', function(...)
      return "bl_final_vessel"
    end)
    Balatest.hook(G, 'get_new_superboss', function(...)
      return "bl_mf_violet_vessel_dx"
    end)
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 10)
    Balatest.assert(G.GAME.superboss_active)
    Balatest.assert_eq(G.GAME.modifiers.scaling, 4)
    Balatest.assert(G.GAME.round_resets.blind_choices.Small == "bl_mf_bigger_blind")
    Balatest.assert(G.GAME.round_resets.blind_choices.Big == "bl_final_vessel")
    Balatest.assert(G.GAME.round_resets.blind_choices.Boss == "bl_mf_violet_vessel_dx")
  end,
}

Balatest.TestPlay {
  name = "violet_vessel_dx_size",
  category = "superboss",

  blind = "bl_mf_violet_vessel_dx",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.blind.chips, 300 * 24)
  end,
}

Balatest.TestPlay {
  name = "cerulean_bell_dx_force_select",
  category = "superboss",

  blind = "bl_mf_cerulean_bell_dx",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.highlighted, 3, "should have selected")
  end,
}

Balatest.TestPlay {
  name = "needle_dx_hands_and_discards",
  category = "superboss",

  blind = "bl_mf_needle_dx",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
    Balatest.assert_eq(G.GAME.current_round.discards_left, 1)
  end,
}

Balatest.TestPlay {
  name = "manacle_dx_hand_size",
  category = "superboss",

  blind = "bl_mf_manacle_dx",
  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 49)
  end,
}

Balatest.TestPlay {
  name = "pillar_dx_debuff_rigged_on",
  category = "superboss",

  blind = "bl_mf_pillar_dx",
  no_auto_start = true,

  execute = function()
    Balatest.hook(_G, 'pseudorandom', function(...)
      return 1
    end)
    Balatest.q(function() for _, c in pairs(G.playing_cards) do c.ability.mf_played_this_game = true end end)
    Balatest.start_round()
  end,
  assert = function()
    for i = 1,52 do
      Balatest.assert(G.hand.cards[i].debuff)
    end
  end,
}

Balatest.TestPlay {
  name = "pillar_dx_debuff_rigged_off",
  category = "superboss",

  blind = "bl_mf_pillar_dx",
  no_auto_start = true,

  execute = function()
    Balatest.hook(_G, 'pseudorandom', function(...)
      return 0
    end)
    Balatest.q(function() for _, c in pairs(G.playing_cards) do c.ability.mf_played_this_game = true end end)
    Balatest.start_round()
  end,
  assert = function()
    for i = 1,52 do
      Balatest.assert(not G.hand.cards[i].debuff)
    end
  end,
}

Balatest.TestPlay {
  name = "pillar_dx_tracks_debuff",
  category = "superboss",

  blind = "bl_mf_pillar_dx",

  execute = function()
    Balatest.hook(_G, 'pseudorandom', function(...)
      return 1
    end)
    Balatest.play_hand{'2S', '2C'}
    Balatest.next_round()
    Balatest.highlight{'2S', '2C'}
  end,
  assert = function()
    Balatest.assert(G.hand.highlighted[1].debuff)
    Balatest.assert(G.hand.highlighted[2].debuff)
  end,
}

Balatest.TestPlay {
  name = "serpent_dx_redraw_blocked",
  category = "superboss",

  blind = "bl_mf_serpent_dx",
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
    Balatest.discard{'AS'}
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.cards, 4)
  end,
}

Balatest.TestPlay {
  name = "serpent_dx_redraw_when_empty",
  category = "superboss",

  blind = "bl_mf_serpent_dx",
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
    Balatest.discard{'AS'}
    Balatest.discard{'AS'}
    Balatest.discard{'AS'}
    Balatest.discard{'AS'}
    Balatest.discard{'AS'}
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.cards, 5)
    Balatest.assert_eq(#G.deck.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "club_dx_debuff",
  category = "superboss",

  blind = "bl_mf_club_dx",
  hand_size = 4,

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'C' },
    { r = 'A', s = 'D' },
    { r = 'A', s = 'H' },
  } },

  execute = function()
    Balatest.highlight{'AS', 'AC', 'AD', 'AH'}
  end,
  assert = function()
    Balatest.assert(G.hand.highlighted[1].debuff)
    Balatest.assert(not G.hand.highlighted[2].debuff)
    Balatest.assert(G.hand.highlighted[3].debuff)
    Balatest.assert(G.hand.highlighted[4].debuff)
  end,
}

Balatest.TestPlay {
  name = "goad_dx_debuff",
  category = "superboss",

  blind = "bl_mf_goad_dx",
  hand_size = 4,

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'C' },
    { r = 'A', s = 'D' },
    { r = 'A', s = 'H' },
  } },

  execute = function()
    Balatest.highlight{'AS', 'AC', 'AD', 'AH'}
  end,
  assert = function()
    Balatest.assert(not G.hand.highlighted[1].debuff)
    Balatest.assert(G.hand.highlighted[2].debuff)
    Balatest.assert(G.hand.highlighted[3].debuff)
    Balatest.assert(G.hand.highlighted[4].debuff)
  end,
}

Balatest.TestPlay {
  name = "window_dx_debuff",
  category = "superboss",

  blind = "bl_mf_window_dx",
  hand_size = 4,

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'C' },
    { r = 'A', s = 'D' },
    { r = 'A', s = 'H' },
  } },

  execute = function()
    Balatest.highlight{'AS', 'AC', 'AD', 'AH'}
  end,
  assert = function()
    Balatest.assert(G.hand.highlighted[1].debuff)
    Balatest.assert(G.hand.highlighted[2].debuff)
    Balatest.assert(not G.hand.highlighted[3].debuff)
    Balatest.assert(G.hand.highlighted[4].debuff)
  end,
}

Balatest.TestPlay {
  name = "head_dx_debuff",
  category = "superboss",

  blind = "bl_mf_head_dx",
  hand_size = 4,

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'C' },
    { r = 'A', s = 'D' },
    { r = 'A', s = 'H' },
  } },

  execute = function()
    Balatest.highlight{'AS', 'AC', 'AD', 'AH'}
  end,
  assert = function()
    Balatest.assert(G.hand.highlighted[1].debuff)
    Balatest.assert(G.hand.highlighted[2].debuff)
    Balatest.assert(G.hand.highlighted[3].debuff)
    Balatest.assert(not G.hand.highlighted[4].debuff)
  end,
}

Balatest.TestPlay {
  name = "arm_dx_from_lv1",
  category = "superboss",

  blind = "bl_mf_arm_dx",

  execute = function()
    Balatest.play_hand{'AS'}
  end,
  assert = function()
    Balatest.assert_chips(11)
  end,
}

Balatest.TestPlay {
  name = "arm_dx_from_lv4",
  category = "superboss",

  blind = "bl_mf_arm_dx",
  consumeables = {"c_pluto","c_pluto","c_pluto"},

  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.use(G.consumeables.cards[2])
    Balatest.use(G.consumeables.cards[3])
    Balatest.play_hand{'AS'}
  end,
  assert = function()
    Balatest.assert_chips(11)
  end,
}

Balatest.TestPlay {
  name = "wheel_dx_one_faceup",
  category = "superboss",

  blind = "bl_mf_wheel_dx",

  execute = function()
  end,
  assert = function()
    local face_up_count = 0
    for i = 1,52 do
      if G.hand.cards[i].facing == "front" then
        face_up_count = face_up_count + 1
      end
    end
    Balatest.assert_eq(face_up_count, 1)
  end,
}

Balatest.TestPlay {
  name = "wheel_dx_faceup_refresh",
  category = "superboss",

  blind = "bl_mf_wheel_dx",

  hand_size = 1,

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
    Balatest.discard{'AS'}
  end,
  assert = function()
    Balatest.assert(G.hand.cards[1].facing == "front")
  end,
}

Balatest.TestPlay {
  name = "house_dx_discards",
  category = "superboss",

  blind = "bl_mf_house_dx",

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
  end,
  assert = function()
    Balatest.assert_eq(#G.deck.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "psychic_dx_four_cards",
  category = "superboss",

  blind = "bl_mf_psychic_dx",

  execute = function()
    Balatest.play_hand{'TS','TC','TH','TD'}
  end,
  assert = function()
    Balatest.assert_chips(700)
  end,
}

Balatest.TestPlay {
  name = "psychic_dx_five_cards",
  category = "superboss",

  blind = "bl_mf_psychic_dx",

  execute = function()
    Balatest.play_hand{'AS','KS','QS','JS','TS'}
  end,
  assert = function()
    Balatest.assert_chips(0)
  end,
}

Balatest.TestPlay {
  name = "psychic_dx_five_cards_sneaky",
  category = "superboss",

  blind = "bl_mf_psychic_dx",

  execute = function()
    Balatest.play_hand{'AS','KS','QS','JS','5C'}
  end,
  assert = function()
    Balatest.assert_chips(0)
  end,
}

Balatest.TestPlay {
  name = "hook_dx_discards",
  category = "superboss",

  blind = "bl_mf_hook_dx",
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
    Balatest.play_hand{'AS'}
  end,
  assert = function()
    Balatest.assert_eq(#G.deck.cards, 0)
  end,
}