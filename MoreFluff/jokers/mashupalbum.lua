local joker = {
  name = "Mashup Album",
  config = {
    extra = {
      mult = 4,
      chips = 15,
      mult_gain = 4,
      chips_gain = 15,
    }
  },
  pos = {x = 8, y = 2},
  rarity = 3,
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  demicoloncompat = true,
  display_size = { w = 71, h = 71 },
  pixel_size = { w = 71, h = 71 },
  loc_txt = {
    name = "Mashup Album",
    text = {
      "Gains {C:mult}+#3#{} Mult if played",
      "hand contains a {C:hearts}red{} flush",
      "Gains {C:chips}+#4#{} Chips if played",
      "hand contains a {C:spades}black{} flush",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} and {C:chips}+#2#{C:inactive})"
    },
  },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.mult, center.ability.extra.chips, center.ability.extra.mult_gain, center.ability.extra.chips_gain }
    }
  end,
  calculate = function(self, card, context)
    if not context.repetition and not context.other_joker and context.cardarea == G.jokers and context.before and next(context.poker_hands['Flush']) then
      local _, cards = next(context.poker_hands['Flush'])
      local h_card = cards[1]

      if h_card:is_suit("Hearts") or h_card:is_suit("Diamonds") then
        -- card.ability.extra.mult = card.ability.extra.mult + 4
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "mult",
          scalar_value = "mult_gain"
        })
        return {
          message = localize('k_upgrade_ex'),
          card = card,
          colour = G.C.RED
        }
      else
        -- card.ability.extra.chips = card.ability.extra.chips + 15
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "chips",
          scalar_value = "chips_gain"
        })
        return {
          message = localize('k_upgrade_ex'),
          card = card,
          colour = G.C.CHIPS
        }
      end
    end
    if context.cardarea == G.jokers and context.joker_main then
      if card.ability.extra.mult > 0 and card.ability.extra.chips > 0 then
        return {
          mult = card.ability.extra.mult,
          chips = card.ability.extra.chips
        }
      elseif card.ability.extra.mult > 0 then
        return {
          mult = card.ability.extra.mult,
        }
      elseif card.ability.extra.chips > 0 then
        return {
          chips = card.ability.extra.chips,
        }
      end
    end
    if context.forcetrigger then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "mult",
          scalar_value = "mult_gain"
        })
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "chips",
          scalar_value = "chips_gain"
        })
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_mashupalbum"] = {
    text = {
      { text = "+", colour = G.C.CHIPS },
      { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
      { text = ", ", colour = G.C.INACTIVE },
      { text = "+", colour = G.C.MULT },
      { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
  }
end

return joker
