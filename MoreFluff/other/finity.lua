function init()
  SMODS.Rarity({
    key = "bossblind",
    loc_txt = {name = "Boss Blind"},
    badge_colour = HEX("690a0f"),
  })

  SMODS.Joker {
    key = "theneedle",
    name = "The Needle",
    atlas = 'mf_finity_crossmod',
    config = {
      extra = {discards_per = 2}
    },
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    rarity = "mf_bossblind",
    pos = { x = 0, y = 0 },
    cost = 10,
    soul_pos = { x = 1, y = 0 },
    calculate = function(self, card, context)
      if ((context.setting_blind and not card.getting_sliced) or context.forcetrigger) and not (context.blueprint_card or card).getting_sliced then
        G.E_MANAGER:add_event(Event({func = function()
          local lost = G.GAME.current_round.hands_left - 1
          ease_discard(lost * card.ability.extra.discards_per, nil, true)
          ease_hands_played(-lost)
        return true end }))
      end
    end,
    loc_vars = function(self, info_queue, center)
      return {
        vars = { center.ability.extra.discards_per }
      }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("finity")[1] }, badges)
    end,
  }
end

return init