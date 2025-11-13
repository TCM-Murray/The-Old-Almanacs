local joker = {
  name = "Unregisted Hypercam 2",
  config = {
    val = 1.04
  },
  pos = {x = 7, y = 6},
  rarity = 1,
  cost = 4,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  immutable = true,
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = { key = "tetr_explainer", set="Other", specific_vars = { center.ability.val, center.ability.val - 1 } }
    return {vars = { center.ability.val } }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger or context.initial_scoring_step then
      if Talisman and Big and Big.arrow then
        return {
          eemult = card.ability.val
        }
      else
        return {
          Xmult_mod = mult ^ (mult ^ 0.04 - 1),
          message = "^^1.04 Mult",
          colour = G.C.DARK_EDITION
        }
      end
    end
  end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_unregistedhypercam"] = {
    text = {
      {
        border_nodes = {
          { text = "^^" },
          { ref_table = "card.ability", ref_value = "val" },
        },
        border_colour = G.C.DARK_EDITION
      }
    },
  }
end

return joker
