local joker = {
  name = "Wild Draw Four",
  config = {
    h_size = 0,
    extra = 4,
  },
  pos = {x = 9, y = 6},
  rarity = 2,
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = false,
  demicoloncompat = true,
  enhancement_gate = "m_wild",
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.h_size, center.ability.extra }
    }
  end,
  calculate = function(self, card, context)
    if (context.forcetrigger or (context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_wild"))) and not context.blueprint then
      card.ability.h_size = card.ability.h_size + card.ability.extra
      G.hand:change_size(card.ability.extra)
      
      return {
        message = localize("k_upgrade_ex"),
        colour = G.C.MONEY
      }
    end
    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
      G.hand:change_size(-card.ability.h_size)
      card.ability.h_size = 0
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_wilddrawfour"] = {
    text = {
      { text = "+", colour = G.C.ORANGE },
      { ref_table = "card.ability", ref_value = "h_size", colour = G.C.ORANGE },
    },
    reminder_text = {
      { text = "(Wild Cards)" },
    },
  }
end

return joker
