if not mf_config["Colour Cards"] then
  return nil
end
local joker = {
  name = "Monochrome Joker",
  config = {
    extra = {
      mult_per = 2,
      mult = 2
    }
  },
  pos = {x = 4, y = 4},
  rarity = 1,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    return {vars = { center.ability.extra.mult_per, center.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint and not self.getting_sliced and not (context.blueprint_card or self).getting_sliced then
      local okay = true
      for i= 1,#G.consumeables.cards do
        if G.consumeables.cards[i].ability.set == "Colour" then
          okay = false
          break
        end
      end
      if okay then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "mult",
          scalar_value = "mult_per",
        })
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.PURPLE})                       
      elseif card.ability.extra.mult > card.ability.extra.mult_per then
        card.ability.extra.mult = card.ability.extra.mult_per
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.PURPLE})
      end
    end
    if context.cardarea == G.jokers and context.joker_main then
      return {
        message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult} },
        mult_mod = card.ability.extra.mult
      }
    end
    if context.forcetrigger then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_per
      return {
        message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult} },
        mult_mod = card.ability.extra.mult
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_monochrome"] = {
    text = {
      { text = "+", colour = G.C.MULT },
      { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
  }
end

return joker
