if not Kino then
  return {
    init = function(self)
      --this function runs after the file is loaded, but before items are registered
    end,
    items = {
    }
  }
end

local joker = {
  name = "I Survive in Farm Merge Civilisation",
  key = "farmmergecivilisation",
  atlas = "mf_jokers",
  object_type = "Joker",
  dependencies = {
    items = {
      "set_cry_exotic",
    }
  },
  k_genre = {"Adventure", "Comedy"},
  config = {},
  pos = {x = 9, y = 9},
  rarity = "cry_exotic",
  cost = 50,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  generate_ui = Kino.generate_info_ui,
  calculate = function(self, card, context)
    if (context.end_of_round and context.cardarea == G.jokers) then
      if #G.hand.cards > 1 then

        last_card = G.hand.cards[#G.hand.cards]

        local new_stats = {
          perma_bonus = 0,
          perma_mult = 0,
          perma_x_chips = 0,
          perma_x_mult = 0,

          perma_h_chips = 0,
          perma_h_mult = 0,
          perma_h_x_chips = 0,
          perma_h_x_mult = 0,
          
          perma_p_dollars = 0,
          perma_h_dollars = 0,
        }

        local enhancement = nil
        local edition = nil
        local seal = nil

        for _, v in pairs(G.hand.cards) do
          for k, _ in pairs(new_stats) do -- the devious reverse iterator?
            new_stats[k] = new_stats[k] + v.ability[k]
          end

          if v ~= last_card then new_stats.perma_bonus = new_stats.perma_bonus + v.base.nominal end

          if v.config.center ~= G.P_CENTERS.c_base then enhancement = v.config.center end
          if v.seal then seal = v.seal end
          if v.edition then edition = v.edition end
        end

        for _, other_card in pairs(G.hand.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() other_card:flip();play_sound('card1', 1);other_card:juice_up(0.3, 0.3);return true end }))
        end

        for _, other_card in pairs(G.hand.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.0,func = function() if enhancement and enhancement ~= last_card.config.center then
            other_card:set_ability(enhancement)
          end
          if edition and edition ~= last_card.edition then
            other_card:set_edition(edition)
          end
          if seal and seal ~= last_card.seal then
            other_card:set_seal(seal)
          end
          for k, _ in pairs(new_stats) do
            other_card.ability[k] = new_stats[k]
          end

          if other_card ~= last_card then
            SMODS.change_base(other_card, last_card.base.suit, last_card.base.value)
          end
          return true end }))
          
        end

        for _, other_card in pairs(G.hand.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() other_card:flip();play_sound('tarot2', 1);other_card:juice_up(0.3, 0.3);return true end }))
        end

        return {
          message = localize("k_merged_ex")
        }
      end
    end
  end
}

return {
  init = function(self)
    --this function runs after the file is loaded, but before items are registered
  end,
  items = {
    joker
  }
}