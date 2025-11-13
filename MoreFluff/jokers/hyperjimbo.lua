local joker = {
  name = "Hyperjimbo",
  config = {
    val = 1.04
  },
  pos = {x = 0, y = 0},
  display_size = { w = 95, h = 95 },
  -- pixel_size = { w = 95, h = 95 },
  rarity = 3,
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  immutable = true, -- pretty important
	pools = { ["Meme"] = true }, -- fuck it. jimball 2 goes in the meme packs
  loc_txt = {
    name = "Hyperjimbo",
    text = {
      "bla bla bla."
    }
  },
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = { key = "tetr_explainer", set="Other", specific_vars = { center.ability.val, center.ability.val - 1 } }
    return {vars = { center.ability.val } }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger or (context.initial_scoring_step and #G.play.cards == 4) then
      if Talisman and Big and Big.arrow then
        return {
          eechips = card.ability.val
        }
      else
        return {
          Xchip_mod = hand_chips ^ (hand_chips ^ 0.04 - 1),
          message = "^^1.04 Chips",
          colour = G.C.DARK_EDITION
        }
      end
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_hyperjimbo"] = {
    text = {
      {
        border_nodes = {
          { text = "^^" },
          { ref_table = "card.joker_display_values", ref_value = "tetr" },
        },
        border_colour = G.C.DARK_EDITION
      }
    },
    reminder_text = {
      {
        ref_table = "card.joker_display_values", ref_value = "reminder_text",
      },
    },
    calc_function = function(card)
      card.joker_display_values.reminder_text = localize("k_display_four_cards")

      if G.play then
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if #scoring_hand == 4 then
          card.joker_display_values.tetr = 1.04
        else
          card.joker_display_values.tetr = 1
        end
      else
        card.joker_display_values.tetr = 1.04
      end
    end,
  }
end

return joker
