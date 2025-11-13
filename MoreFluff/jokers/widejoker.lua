local huger = SMODS.current_mod.config["Huger Joker"]
local scale = 1.5
if huger then
  scale = 2
end

local joker = {
  name = "Wide Joker",
  config = {
    extra = {
      powmult = 1.14
    }
  },
  pos = {x = 3, y = 3},
  rarity = 3,
  cost = 9,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  display_size = { w = 71.0 * scale, h = 95 / scale },
	pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.powmult }
    }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger or (context.cardarea == G.jokers and context.joker_main) then
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
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_widejoker"] = {
    text = {
      {
        border_nodes = {
          { text = "^" },
          { ref_table = "card.ability.extra", ref_value = "powmult",
            retrigger_type = function (base_number, triggers)
                local num = base_number
                for i=1, triggers-1 do
                    num = num ^ base_number
                end
                return num
            end
          },
        },
        border_colour = G.C.DARK_EDITION
      }
    },
  }
end

return joker
