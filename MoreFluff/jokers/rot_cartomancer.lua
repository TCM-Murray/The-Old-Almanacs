if not mf_config["45 Degree Rotated Tarot Cards"] then
  return nil
end
local joker = {
  name = "Cartomancer!",
  config = {},
  pos = {x = 0, y = 0},
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  display_size = { w = 112, h = 112 },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { }
    }
  end,
  calculate = function(self, card, context)
    if (context.setting_blind or context.forcetrigger) and not (context.blueprint_card or self).getting_sliced then
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
          trigger = 'before',
          delay = 0.0,
          func = (function()
              local n_card = create_card("Rotarot",G.consumeables, nil, nil, nil, nil, nil, 'car')
              n_card:add_to_deck()
              G.consumeables:emplace(n_card)
              G.GAME.consumeable_buffer = 0
            return true
          end)}))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_plus_rotarot"), colour = G.C.PURPLE})
      end
    end
  end
}

return joker
