function progressbar(val, max)
  if max > 12 then
    return val, "/"..max
  end
  return string.rep("#", val), string.rep("#", max - val)
end

local joker = {
  name = "Fast-Growing Sapling",
  config = {
    extra = {
      c_rounds = 0,
      rounds = 6,
    }
  },
  pos = {x = 7, y = 8},
  rarity = 2,
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = false,
  perishable_compat = false,
  demicoloncompat = true,
  loc_vars = function(self, info_queue, center)
    local val, max = progressbar(center.ability.extra.c_rounds, center.ability.extra.rounds)
    return {vars = { val, max, center.ability.extra.rounds, center.ability.extra.c_rounds } }
  end,
  calculate = function(self, card, context)
    if not card.self_sold and context.end_of_round and not context.individual and not context.repetition  and not context.blueprint then
      card.ability.extra.c_rounds = card.ability.extra.c_rounds + 1
      if card.ability.extra.c_rounds >= card.ability.extra.rounds and (card.ability.extra.c_rounds - 1) < card.ability.extra.rounds then 
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end
      return {
        message = (card.ability.extra.c_rounds < card.ability.extra.rounds) and (card.ability.extra.c_rounds..'/'..card.ability.extra.rounds) or localize('k_active_ex'),
        colour = G.C.FILTER
      }
    end
    if (G.GAME.blind and G.GAME.blind.in_blind) and (context.forcetrigger or (context.selling_self and (card.ability.extra.c_rounds >= card.ability.extra.rounds) and not context.blueprint)) then
      if not context.forcetrigger then
        card.self_sold = true
      end
      return {
        message = localize("k_equals_tree_three"),
        colour = G.C.DARK_EDITION,
        func = function()
          if Entropy and Entropy.IsEE() then
            play_sound("mf_treethree")
            play_sound("mf_buzzer")
            G.ee_nuhuh = {1}
          else
            play_sound("mf_treethree")
            G.GAME.mf_tree_three = true
            G.GAME.chips = G.GAME.blind.chips
            G.GAME.blind:calculate()
            if not context.forcetrigger then
              G.GAME.blind:defeat()
              G.STATE = G.STATES.NEW_ROUND
              G.STATE_COMPLETE = false
            end
          end
        end
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_sapling"] = {
    reminder_text = {
      { text = "(" },
      { ref_table = "card.ability.extra", ref_value = "c_rounds" },
      { text = "/" },
      { ref_table = "card.ability.extra", ref_value = "rounds" },
      { text = ")" },
    }
  }
end

return joker
