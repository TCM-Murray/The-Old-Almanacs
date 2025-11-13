local joker = {
  name = "Self Insert",
  config = {},
  pos = {x = 6, y = 6},
  rarity = 3,
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { }
    }
  end,
  add_to_deck = function(self, card, from_debuff)
    local name = string.lower(G.PROFILES[G.SETTINGS.profile].name)
    local replacement_joker = nil

    if name == "paul" then
      replacement_joker = "j_mf_basepaul_card"
    elseif name == "triangle" or name == "notmario" then
      replacement_joker = "j_mf_triangle"
    end

    if replacement_joker then
      card:set_ability(G.P_CENTERS[replacement_joker])
    end
  end,
  calculate = function(self, card, context)
  end
}

return joker
