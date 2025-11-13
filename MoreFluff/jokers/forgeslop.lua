local joker = {
  name = "Token",
  config = {
  },
  pos = {x = 9, y = 8},
  rarity = "mf_token",
  cost = 0,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = false,
  loc_vars = function(self, info_queue, center)
  end,
  calculate = function(self, card, context)
  end
}

return joker
