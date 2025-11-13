local joker = {
  name = "Big Win",
  config = {
    extra = {
      retriggers = 7,
      odds = 7,
    }
  },
  pos = {x = 2, y = 7},
  rarity = 2,
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_vars = function(self, info_queue, center)
    local new_numerator, new_denominator = SMODS.get_probability_vars(center, 1, center.ability.extra.odds, 'slotmachine')
    return {
      vars = { new_numerator, new_denominator, center.ability.extra.retriggers }
    }
  end,
  calculate = function(self, card, context)
    if context.repetition and context.other_card:get_id() == 7 then
      if SMODS.pseudorandom_probability(card, 'slotmachine', 1, card.ability.extra.odds, 'slotmachine') then
        return {
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.retriggers,
          card = card
        }
      end
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
