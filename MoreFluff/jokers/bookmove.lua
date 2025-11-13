local joker = {
  name = "Treasure Map",
  config = {
    extra = {
      c_rounds = 0,
      rounds = 3,
    }
  },
  pos = {x = 4, y = 7},
  rarity = 3,
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = false,
  perishable_compat = true,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.j_hanging_chad
    info_queue[#info_queue + 1] = G.P_CENTERS.j_photograph
    return {vars = { center.ability.extra.c_rounds, center.ability.extra.rounds } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not context.individual and not context.repetition  and not context.blueprint then
      card.ability.extra.c_rounds = card.ability.extra.c_rounds + 1
      if card.ability.extra.c_rounds >= card.ability.extra.rounds and (card.ability.extra.c_rounds - 1) < card.ability.extra.rounds then 
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end
      return {
        message = (card.ability.extra.c_rounds < card.ability.extra.rounds) and (card.ability.extra.c_rounds..'/'..card.ability.extra.rounds) or localize('k_active_ex'),
        colour = G.C.FILTER
      }
    end
    if context.forcetrigger or (context.selling_self and (card.ability.extra.c_rounds >= card.ability.extra.rounds) and not context.blueprint) then
      local gained_slots = 1
      if card.edition and card.edition.card_limit then gained_slots = 1 - card.edition.card_limit end
      if context.forcetrigger then gained_slots = gained_slots - 1 end
      if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit + gained_slots then
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
        G.E_MANAGER:add_event(Event({
          func = (function()
            G.E_MANAGER:add_event(Event({
              func = function() 
                local n_card = create_card('Joker',G.consumeables, nil, nil, nil, nil, 'j_hanging_chad', nil)
                n_card:add_to_deck()
                G.jokers:emplace(n_card)
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                return true
              end}))                   
            return true
          end)}))
      end
      if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit + gained_slots then
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
        G.E_MANAGER:add_event(Event({
          func = (function()
            G.E_MANAGER:add_event(Event({
              func = function() 
                local n_card = create_card('Joker',G.consumeables, nil, nil, nil, nil, 'j_photograph', nil)
                n_card:add_to_deck()
                G.jokers:emplace(n_card)
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                return true
              end}))                   
            return true
          end)}))
      end
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_bookmove"] = {
    reminder_text = {
      { text = "(" },
      { ref_table = "card.ability.extra", ref_value = "c_rounds" },
      { text = "/" },
      { ref_table = "card.ability.extra", ref_value = "rounds" },
      { text = ")" },
    }
  }
end

return joker
