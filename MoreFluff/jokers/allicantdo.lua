local joker = {
  name = "All I Can't Do",
  config = {
    extra = {
      x_mult = 1,
      x_mult_mod = 0.1,
    }
  },
  pos = {x = 3, y = 5},
  soul_pos = {x = 6, y = 4},
  rarity = 3,
  cost = 9,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.x_mult_mod, center.ability.extra.x_mult }
    }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger then
      -- card.ability.extra.x_mult = card.ability.extra.x_mult + center.ability.extra.x_mult_mod
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = "x_mult",
        scalar_value = "x_mult_mod"
      })
      
      for _, c in pairs(G.hand.cards) do
        G.E_MANAGER:add_event(Event({
          trigger = "before",
          delay = 0.1,
          func = function()
            c:juice_up()
            card:juice_up()
            SMODS.debuff_card(c, true, "allicantdo")
            play_sound('cancel', 0.8+ (0.9 + 0.2*math.random())*0.2, 1)
            -- ease_dollars(card.ability.cash)
            return true
          end,
        }))
      end
      return {
        xmult = card.ability.extra.x_mult
      }
    end
    if context.first_hand_drawn and not context.blueprint then
      for _, c in pairs(G.hand.cards) do
        G.E_MANAGER:add_event(Event({
          trigger = "before",
          delay = 0.1,
          func = function()
            c:juice_up()
            card:juice_up()
            SMODS.debuff_card(c, true, "allicantdo")
            play_sound('cancel', 0.8+ (0.9 + 0.2*math.random())*0.2, 1)
            -- ease_dollars(card.ability.cash)
            return true
          end,
        }))
      end
    end
    if context.before and not context.blueprint then
      local mod = 0
      for _, c in pairs(G.play.cards) do
        if c.debuff then
          mod = mod + card.ability.extra.x_mult_mod
        end
      end
      if mod > 0 then
        card.ability.extra.x_mult = card.ability.extra.x_mult + mod
        return {
          message = "X"..card.ability.extra.x_mult.." Mult",
          colour = G.C.MULT
        }
      end
    end
    if context.cardarea == G.jokers and context.joker_main then
      return {
        xmult = card.ability.extra.x_mult, -- oh my god i see why bettercalc is good now
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_allicantdo"] = {
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
      card.joker_display_values.reminder_text = localize("k_display_play_debuffed")
    end,
  }
end

return joker
