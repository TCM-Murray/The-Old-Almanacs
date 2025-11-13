local joker = {
  name = "Flint and Steel",
  config = {},
  pos = {x = 4, y = 6},
  rarity = 2,
  cost = 4,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  demicoloncompat = true,
	pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
    return {
      vars = { }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers then
      if context.before then
        local flint = false
        local steel = false

        for i = 1, #context.scoring_hand do
          local c_card = context.scoring_hand[i]
          if SMODS.has_enhancement(c_card, "m_stone") then flint = true end
          if SMODS.has_enhancement(c_card, "m_steel") then steel = true end
        end

        if flint and steel then -- PEAK CINEMA
          local text,disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
          card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
          update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
          level_up_hand(context.blueprint_card or card, text, nil, 1)
        end
      end
    end

    if context.forcetrigger then
      local text,disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
      card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
      update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
      level_up_hand(context.blueprint_card or card, text, nil, 1)
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_flintandsteel"] = {
    text = {
      {
        ref_table = "card.joker_display_values", ref_value = "inactive_text",
        colour = G.C.UI.TEXT_INACTIVE,
      },
      {
        ref_table = "card.joker_display_values", ref_value = "active_text",
        colour = G.C.ORANGE,
      }
    },
    reminder_text = {
      {
        ref_table = "card.joker_display_values", ref_value = "reminder_text",
      },
    },
    calc_function = function(card)
      card.joker_display_values.reminder_text = localize("k_display_flint_and_steel")
      local flint = false
      local steel = false

      if G.play then
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
          for _, scoring_card in pairs(scoring_hand) do
            if SMODS.has_enhancement(scoring_card, "m_stone") then flint = true end
            if SMODS.has_enhancement(scoring_card, "m_steel") then steel = true end
          end
        end
      end

      if flint and steel then -- PEAK CINEMA
        card.joker_display_values.inactive_text = ""
        card.joker_display_values.active_text = localize("k_display_upgrade_ex")
      else
        card.joker_display_values.inactive_text = localize("k_display_inactive")
        card.joker_display_values.active_text = ""
      end
    end,
  }
end

return joker
