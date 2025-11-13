-- why is this necessary...
-- actually i know why but like... ugh

local magenta = {
    object_type = "Consumable",
    set = "Colour",
    dependencies = {
      items = {
        "set_cry_epic",
      }
    },
    name = "col_Purple",
    key = "purple",
    pos = { x = 0, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
display_size = { w = 71, h = 87 },
pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local tag_type = "tag_cry_epic"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag_type))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = Cryptid }, badges)
    end,
  }

local moonstone = {
    object_type = "Consumable",
    set = "Colour",
    name = "col_Moonstone",
    key = "moonstone",
    dependencies = {
      items = {
        "set_cry_m",
      }
    },
    pos = { x = 1, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 2,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
display_size = { w = 71, h = 87 },
pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(nil,G.jokers, nil, nil, nil, nil, 'j_jolly', 'sup')
          n_card:add_to_deck()
          G.jokers:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = Cryptid }, badges)
    end,
  }

local mutare = {
    object_type = "Consumable",
    set = "Colour",
    name = "col_Gold",
    key = "gold",
    dependencies = {
      items = {
        "set_cry_exotic",
      }
    },
    pos = { x = 2, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 9,
    },
    hidden = true,
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_cry_gateway', 'sup')
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = Cryptid }, badges)
    end,
  }

local ooffoo = {
    object_type = "Consumable",
    set = "Colour",
    name = "col_ooffoo",
    key = "ooffoo",
    dependencies = {
      items = {
        "set_cry_code",
      }
    },
    pos = { x = 3, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
display_size = { w = 71, h = 87 },
pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local card_type = "Code"
      local rng_seed = "ooffoo"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, nil, rng_seed)
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = Cryptid }, badges)
    end,
  }

local colorem = {
  name = "Colorem",
  key = "colorem",
  object_type = "Joker",
  dependencies = {
    items = {
      "set_cry_exotic",
    }
  },
  atlas = "mf_jokers",
  config = {
    extra = { odds = 3 }
  },
  pos = {x = 6, y = 5},
  soul_pos = {x = 8, y = 5, extra = {x = 7, y = 5}},
  rarity = "cry_exotic",
  cost = 50,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_txt = {
    name = "Colorem",
    text = {
      "When a {C:colourcard}Colour{} card is used,",
      "{C:green}#1# in #2#{} chance to add a copy",
      "to your consumable area",
      "{C:inactive}(Must have room)",
    },
  },
  loc_vars = function(self, info_queue, center)
    local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, center.ability.extra.odds, 'identifier')
    return {
      vars = { new_numerator, new_denominator }
    }
  end,
  calculate = function(self, card, context)
		if
			context.using_consumeable
			and context.consumeable.ability.set == "Colour"
			and not context.consumeable.beginning_end
		then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if SMODS.pseudorandom_probability(card, 'colorem', 1, card.ability.extra.odds, 'colorem') then
					G.E_MANAGER:add_event(Event({
						func = function()
							local cards = copy_card(context.consumeable)
							cards:add_to_deck()
							G.consumeables:emplace(cards)
							return true
						end,
					}))
					card_eval_status_text(
						context.blueprint_cards or card,
						"extra",
						nil,
						nil,
						nil,
						{ message = localize("k_copied_ex") }
					)
				end
			end
		end
  end
}

if not MoreFluff.config["Colour Cards"] then
  return {
    init = function(self)
      --this function runs after the file is loaded, but before items are registered
    end,
    items = {
    }
  }
end

return {
  init = function(self)
    --this function runs after the file is loaded, but before items are registered
  end,
  items = {
    magenta,
    moonstone,
    mutare,
    ooffoo,
    colorem,
  }
}