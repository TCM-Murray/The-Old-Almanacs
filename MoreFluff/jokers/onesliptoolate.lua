local joker = {
  name = "One Slip Too Late",
  config = {
    extra = {}
  },
  pos = {x = 5, y = 5},
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { (G.GAME.current_round.hands_played or 0) + 1 }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and (context.scoring_hand and #context.scoring_hand == (G.GAME.current_round.hands_played or 0) + 1) then
      return {
        xmult = (G.GAME.current_round.hands_played or 0) + 1
      }
    end
    if context.forcetrigger then
      return {
        xmult = (G.GAME.current_round.hands_played or 0) + 1
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_onesliptoolate"] = {
    text = {
      {
        border_nodes = {
          { text = "X" },
          { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" },
        },
      }
    },
    reminder_text = {
      {
        ref_table = "card.joker_display_values", ref_value = "hand_count",
      },
    },
    calc_function = function(card)
      card.joker_display_values.hand_count = (G.GAME.current_round.hands_played or 0) + 1
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if #scoring_hand == card.joker_display_values.hand_count then
        card.joker_display_values.xmult = (G.GAME.current_round.hands_played or 0) + 1
      else
        card.joker_display_values.xmult = 1
      end
    end,
  }
end

return joker
