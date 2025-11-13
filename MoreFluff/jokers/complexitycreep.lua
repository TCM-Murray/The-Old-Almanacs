local effect_evals = {
  plusmult = function (effect)
    return {
      mult = effect[2]
    }
  end,
  pluschips = function (effect)
    return {
      chips = effect[2]
    }
  end,
  xmult = function (effect)
    return {
      xmult = effect[2]
    }
  end,
  xchips = function (effect)
    return {
      xchips = effect[2]
    }
  end,
  emult = function (effect)
    return {
      emult = effect[2]
    }
  end,
  echips = function (effect)
    return {
      echips = effect[2]
    }
  end,
  eemult = function (effect)
    return {
      eemult = effect[2]
    }
  end,
  eechips = function (effect)
    return {
      eechips = effect[2]
    }
  end,
  dollars = function (effect)
    return {
      dollars = effect[2]
    }
  end,
  swapchipmult = function (effect)
    return {
      swap = true
    }
  end,
  createtarot = function (effect)
    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local card_type = 'Tarot'
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
            local n_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'ccr')
            n_card:add_to_deck()
            G.consumeables:emplace(n_card)
            G.GAME.consumeable_buffer = 0
          return true
        end)}))
    end
    return {
      message = localize{message = localize('k_plus_tarot'), colour = G.C.PURPLE}
    }
  end,
  createplanet = function (effect)
    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local card_type = 'Planet'
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
            local n_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'ccr')
            n_card:add_to_deck()
            G.consumeables:emplace(n_card)
            G.GAME.consumeable_buffer = 0
          return true
        end)}))
    end
    return {
      message = localize{message = localize('k_plus_planet'), colour = G.C.BLUE}
    }
  end,
  copyconsumeable = function (effect)
    if G.consumeables.cards[1] then
      G.E_MANAGER:add_event(Event({
        func = function() 
          local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo')), nil)
          card:set_edition({negative = true}, true)
          card:add_to_deck()
          G.consumeables:emplace(card) 
          return true
        end}))
      return {
        message = localize{message = localize('k_duplicated_ex')}
      }
    end
  end,
}

local effect_guards = {
  handtype = function (context, effect, card)
    return context.poker_hands ~= nil and next(context.poker_hands[effect[6]]) 
  end,
  odds = function (context, effect, card)
    return SMODS.pseudorandom_probability("complexitycreep_odds", 'seed', 1, effect[6], 'ccreep')
  end,
}


local joker = {
  name = "Complexity Creep",
  config = {
    effects = {}
  },
  pos = {x = 5, y = 6},
  rarity = 3,
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  set_ability = function(self, card, initial, delay_sprites)
    card.ability.effects = {}
    grow_complexity_creep(card.ability.effects)
  end,
  loc_vars = function(self, info_queue, center)
    -- info_queue[#info_queue+1] = { key = "cc_plusmult", set="ComplexityCreep", specific_vars = { 4 } }
    for _, effect in pairs(center.ability.effects) do
      local numerator = G.GAME.probabilities.normal
      local denominator = effect[6]
      if effect[8] == "cc_mf_odds" then
        numerator, denominator = SMODS.get_probability_vars(card, numerator, demoninator, 'ccreep')
      end
      local thunk = effect[8] and localize({key=effect[8], type="variable", vars = { effect[2], effect[4], denominator, numerator }})[1] or ""
      local thunk2 = effect[9] and localize({key=effect[9], type="variable", vars = { effect[2], effect[4], denominator, numerator }})[1] or ""
      local cond = effect[8] ~= nil
      info_queue[#info_queue+1] = { key = effect[7] .. (cond and "_if" or ""), set="ComplexityCreep", specific_vars = { effect[2], thunk2, thunk } }
    end
    return { }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and context.blind.boss and not context.blueprint then
      grow_complexity_creep(card.ability.effects)
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_effect_added_ex"), colour = G.C.PURPLE})
    end

    local effect_list = {}

    for _, effect in pairs(card.ability.effects) do
      if effect[3] == "joker" then
        if context.cardarea == G.jokers and context.joker_main then
          local guard = effect[5] and effect_guards[effect[5]](context, effect, card)
          if not effect[5] then guard = true end
          if guard then
            effect_list[#effect_list + 1] = effect_evals[effect[1]](effect)
          end
        end
      elseif effect[3] == "cardscored" or effect[3] == "firstscored" or effect[3] == "facescored" then
        if context.individual and context.cardarea == G.play then
          local guard = effect[5] and effect_guards[effect[5]](context, effect, card)
          if not effect[5] then guard = true end
          if effect[3] == "firstscored" then
            if context.other_card ~= context.scoring_hand[1] then guard = false end
          end
          if effect[3] == "facescored" then
            if not context.other_card:is_face() then guard = false end
          end
          if guard then
            effect_list[#effect_list + 1] = effect_evals[effect[1]](effect)
          end
        end
      elseif effect[3] == "endofround" then
        if context.end_of_round and not context.individual and not context.repetition then
          local guard = effect[5] and effect_guards[effect[5]](context, effect, card)
          if not effect[5] then guard = true end
          if guard then
            effect_list[#effect_list + 1] = effect_evals[effect[1]](effect)
          end
        end
      elseif effect[3] == "cardsold" then
        if context.selling_card then
          local guard = effect[5] and effect_guards[effect[5]](context, effect, card)
          if not effect[5] then guard = true end
          if guard then
            effect_list[#effect_list + 1] = effect_evals[effect[1]](effect)
          end
        end
      elseif effect[3] == "shoproll" then
        if context.reroll_shop then
          local guard = effect[5] and effect_guards[effect[5]](context, effect, card)
          if not effect[5] then guard = true end
          if guard then
            effect_list[#effect_list + 1] = effect_evals[effect[1]](effect)
          end
        end
      end
    end

    if #effect_list > 0 then
      -- who up linking they list
      local root = effect_list[1]
      local add = effect_list[1]
      for i, eff in ipairs(effect_list) do
        if i > 1 then
          add["extra"] = eff
          add = eff
        end
      end

      return root
    end
  end
}

function grow_complexity_creep (effects)
  local effect = {nil, nil, nil, nil, nil, nil, nil, nil, nil}

  local scoring_trigger = pseudorandom("ccreep_grow") < 0.8

  -- scoring_trigger = false -- when the sus

  if scoring_trigger then
    local effect_pool = { -- effect, base, steps, step size, loc | there's gotta be a better way to do this
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"plusmult", 1, 9, 1, "cc_plusmult"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"pluschips", 10, 190, 1, "cc_pluschips"},
      {"xmult", 1, 20, 0.1, "cc_xmult"},
      {"xmult", 1, 20, 0.1, "cc_xmult"},
      {"xmult", 1, 20, 0.1, "cc_xmult"},
      {"xmult", 1, 20, 0.1, "cc_xmult"},
      {"xmult", 1, 20, 0.1, "cc_xmult"},
      {"xchips", 1, 20, 0.1, "cc_xchips"},
      {"xchips", 1, 20, 0.1, "cc_xchips"},
      {"xchips", 1, 20, 0.1, "cc_xchips"},
      {"xchips", 1, 20, 0.1, "cc_xchips"},
      {"xchips", 1, 20, 0.1, "cc_xchips"},
      {"emult", 1, 25, 0.01, "cc_emult"},
      {"echips", 1, 25, 0.01, "cc_echips"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"swapchipmult", 0, 0, 0, "cc_swapchipmult"},
      {"swapchipmult", 0, 0, 0, "cc_swapchipmult"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"copyconsumeable", 0, 0, 0, "cc_copyconsumeable"},
      -- {"eemult", 1, 10, 0.001, "cc_eemult"},
      -- {"eechips", 1, 10, 0.001, "cc_eechips"},
    }
    local gate_pool = { -- effect, values, loc
      {"handtype", {"Two Pair", "Three of a Kind", "Straight Flush", "Full House", "Flush Five", "High Card", "Pair"}, "cc_mf_handtype"},
      {"odds", {2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 10, 100}, "cc_mf_odds"},
    }
    local trigger_pool = { -- effect, values, loc
      {"cardscored", {"chicken jockey"}, "cc_mf_card_trigger"},
      {"firstscored", {"chicken jockey"}, "cc_mf_first_card_trigger"},
      {"firstscored", {"chicken jockey"}, "cc_mf_first_card_trigger"},
      {"firstscored", {"chicken jockey"}, "cc_mf_first_card_trigger"},
      {"facescored", {"chicken jockey"}, "cc_mf_face_card_trigger"},
      {"facescored", {"chicken jockey"}, "cc_mf_face_card_trigger"},
      -- {"lowcardscored", {"chicken jockey"}, "cc_mf_face_card_trigger"},
      -- {"lowcardscored", {"chicken jockey"}, "cc_mf_face_card_trigger"},
      -- {"rankscored", {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, "cc_mf_rank_trigger"},
    }
    local chosen_effect = pseudorandom_element(effect_pool, pseudoseed("ccreep_grow"))

    local value_roll = pseudorandom("ccreep_grow")
    local value = chosen_effect[2] + math.floor(pseudorandom("ccreep_grow") * (chosen_effect[3] + 1)) * chosen_effect[4]

    effect[1] = chosen_effect[1]
    effect[2] = value
    effect[7] = chosen_effect[5]

    local needs_gate = pseudorandom("ccreep_grow") < 0.3
    if needs_gate then
      local gate = pseudorandom_element(gate_pool, pseudoseed("ccreep_grow"))
      local gate_value = pseudorandom_element(gate[2], pseudoseed("ccreep_grow"))
      effect[5] = gate[1]
      effect[6] = gate_value
      effect[8] = gate[3]
    end

    local needs_trigger = pseudorandom("ccreep_grow") < 0.3
    -- needs_trigger = true
    if needs_trigger then
      local trigger = pseudorandom_element(trigger_pool, pseudoseed("ccreep_grow"))
      local trigger_value = pseudorandom_element(trigger[2], pseudoseed("ccreep_grow"))
      effect[3] = trigger[1]
      effect[4] = trigger_value
      effect[9] = trigger[3]
    else
      effect[3] = "joker"
      effect[9] = "cc_mf_joker_trigger"
    end
  else
    local effect_pool = { -- effect, base, steps, step size, loc | there's gotta be a better way to do this
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"dollars", 1, 3, 1, "cc_dollars"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createtarot", 0, 0, 0, "cc_createtarot"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"createplanet", 0, 0, 0, "cc_createplanet"},
      {"copyconsumeable", 0, 0, 0, "cc_copyconsumeable"},
      -- {"eemult", 1, 10, 0.001, "cc_eemult"},
      -- {"eechips", 1, 10, 0.001, "cc_eechips"},
    }
    local gate_pool = { -- effect, values, loc
      {"odds", {2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 10, 100}, "cc_mf_odds"},
    }
    local trigger_pool = { -- effect, values, loc
      {"endofround", {"chicken jockey"}, "cc_mf_endofround"},
      {"cardsold", {"chicken jockey"}, "cc_mf_cardsold"},
      {"shoproll", {"chicken jockey"}, "cc_mf_shoproll"},
    }
    local chosen_effect = pseudorandom_element(effect_pool, pseudoseed("ccreep_grow"))

    local value_roll = pseudorandom("ccreep_grow")
    local value = chosen_effect[2] + math.floor(pseudorandom("ccreep_grow") * (chosen_effect[3] + 1)) * chosen_effect[4]

    effect[1] = chosen_effect[1]
    effect[2] = value
    effect[7] = chosen_effect[5]

    local needs_gate = pseudorandom("ccreep_grow") < 0.3
    if needs_gate then
      local gate = pseudorandom_element(gate_pool, pseudoseed("ccreep_grow"))
      local gate_value = pseudorandom_element(gate[2], pseudoseed("ccreep_grow"))
      effect[5] = gate[1]
      effect[6] = gate_value
      effect[8] = gate[3]
    end

    local trigger = pseudorandom_element(trigger_pool, pseudoseed("ccreep_grow"))
    local trigger_value = pseudorandom_element(trigger[2], pseudoseed("ccreep_grow"))
    effect[3] = trigger[1]
    effect[4] = trigger_value
    effect[9] = trigger[3]
  end

  -- effect = {"pluschips", 100, "joker", nil, nil, nil, "cc_pluschips", nil, "cc_mf_joker_trigger" }

  if effect then
    effects[#effects + 1] = effect
  end
end

return joker
