local joker = {
  name = "Unpleasant Card",
  config = {
    extra = {
      x_chips = 2.7
    }
  },
  pos = {x = 0, y = 7},
  rarity = 2,
  cost = 6.5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
	pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.x_chips }
    }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger or (context.cardarea == G.jokers and context.joker_main) then
      return {
        xchips = card.ability.extra.x_chips
      }
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_unpleasantcard"] = {
    text = {
      {
        border_nodes = {
          { text = "X" },
          { ref_table = "card.ability.extra", ref_value = "x_chips", retrigger_type = "exp" },
        },
        border_colour = G.C.CHIPS
      }
    },
  }
end

return joker
