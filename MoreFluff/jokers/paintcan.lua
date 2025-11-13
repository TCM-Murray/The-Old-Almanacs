if not mf_config["Colour Cards"] then
  return nil
end
local joker = {
  name = "Paint Can",
  config = {
    extra = {
      odds = 2
    }
  },
  pos = {x = 1, y = 7},
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    local new_numerator, new_denominator = SMODS.get_probability_vars(center, 1, center.ability.extra.odds, 'paintcan')
    return {
      vars = { new_numerator, new_denominator }
    }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger then
      colour_end_of_round_effects()
    end 
  end
}

return joker
