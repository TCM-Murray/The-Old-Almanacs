
SMODS.Rarity {
  key = "superlegendary",
  loc_txt = {
    name = "Superlegendary"
  },
  badge_colour = HEX("2852FF")
}

local joker = {
  config = {
    extra = {}
  },
  pos = {x = 3, y = 9},
  soul_pos = {x = 4, y = 9},
  rarity = "mf_superlegendary",
  cost = 50,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,

  planeswalker = false,
  planeswalker_costs = {},
  pronouns = "she_her",
  loc_txt = {
  },
  loc_vars = function(self, info_queue, center)
  end,
  calculate = function(self, card, context)
    if context.forcetrigger or context.initial_scoring_step then
      if Talisman then
        return {
          emult = card.ability.extra.powmult
        }
      else
        return {
          Xmult_mod = mult,
          message = "^2 Mult",
          colour = G.C.DARK_EDITION
        }
      end
    end
  end
}

return joker
