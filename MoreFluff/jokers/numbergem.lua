local joker = {
  name = "Numbergem",
  config = {
    extra = {
      powmult = 3
    }
  },
  pos = {x = 0, y = 0},
  rarity = 3,
  cost = 11,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
	pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.powmult }
    }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger or (context.cardarea == G.jokers and context.joker_main) then
      local should_trigger = false
      if context.forcetrigger then
        should_trigger = true
      else
        local score_thing = 0
        for card in  do
        end
      end
      if should_trigger then
        if Talisman then
          return {
            emult = card.ability.extra.powmult
          }
        else
          return {
            Xmult_mod = mult ^ (card.ability.extra.powmult - 1),
            message = "^"..card.ability.extra.powmult.." Mult",
            colour = G.C.DARK_EDITION
          }
        end
      end
    end
  end
}

return joker
