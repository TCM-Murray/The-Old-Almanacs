if not mf_config["45 Degree Rotated Tarot Cards"] then
  return nil
end
local joker = {
  name = "Yucky Rat",
  config = {
    extra = {
      x_mult = 1,
      x_mult_mod = 0.05
    }
  },
  pos = {x = 1, y = 5},
  rarity = 2,
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mf_yucky
    
    return {
      vars = { center.ability.extra.x_mult_mod, center.ability.extra.x_mult }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and card.ability.extra.x_mult > 1.0 then
      return {
        xmult = card.ability.extra.x_mult -- steamodded has this now??
      }
    end
    if context.cardarea == G.jokers and context.before then
      local gain = 0
      local cards = {}
      for _, other_card in pairs(G.play.cards) do
        if other_card.config.center ~= G.P_CENTERS.c_base then goto continue end

        cards[#cards + 1] = other_card

        gain = gain + card.ability.extra.x_mult_mod
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() other_card:flip();play_sound('card1', 1);other_card:juice_up(0.3, 0.3);return true end }))
        ::continue::
      end
      for _, other_card in pairs(cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() other_card:flip();play_sound('card1', 1);other_card:set_ability(G.P_CENTERS["m_mf_yucky"]);return true end }))
        card:juice_up(0.3, 0.5)
      end
      if gain > 0 then
        card.ability.extra.x_mult = card.ability.extra.x_mult + gain
        return {
          message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
          colour = G.C.RED
        }
      end
    end
    if context.forcetrigger then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
      return {
        xmult = card.ability.extra.x_mult -- steamodded has this now??
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_yuckyrat"] = {
    text = {
      {
        border_nodes = {
          { text = "X" },
          { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" },
        },
      }
    },
    reminder_text = {
      {
        ref_table = "card.joker_display_values", ref_value = "reminder_text",
        colour = G.C.RED,
      },
    },
    calc_function = function(card)
      card.joker_display_values.reminder_text = localize("k_display_yucky")
    end,
  }
end

return joker