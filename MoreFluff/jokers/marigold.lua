if not mf_config["45 Degree Rotated Tarot Cards"] then
  return nil
end
local joker = {
  name = "Marigold",
  config = {
    extra = {
      retriggers = 2,
    }
  },
  pos = {x = 5, y = 4},
  soul_pos = {x = 0, y = 5},
  rarity = 4,
  cost = 20,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  enhancement_gate = "m_mf_marigold",
  loc_txt = {
    name = "Marigold",
    text = {
      "{C:attention}Retriggers{} played and held",
      "{C:attention}Marigold Cards{} #1# time#<s>1#"
    },
  },
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mf_marigold
    
    return {
      vars = { center.ability.extra.retriggers }
    }
  end,
  calculate = function(self, card, context)
    if context.repetition and context.other_card.config.center.key == "m_mf_marigold" then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_marigold"] = {
    reminder_text = {
      {
        ref_table = "card.joker_display_values", ref_value = "reminder_text",
      },
    },
    calc_function = function(card)
      card.joker_display_values.reminder_text = localize("k_display_marigold_card")
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
      if playing_card.config.center.key ~= "m_mf_marigold" then return 0 end
      return playing_card:is_face() and joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
  }
end

return joker
