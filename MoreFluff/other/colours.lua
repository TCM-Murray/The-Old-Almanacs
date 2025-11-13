function init()
  -- for the funny progress bar.
  function progressbar(val, max)
    if max > 10 then
      return val, "/"..max
    end
    return string.rep("#", val), string.rep("#", max - val)
  end

  SMODS.ConsumableType({
    key = "Colour",
    primary_colour = HEX("4f6367"),
    secondary_colour = HEX("4f6367"),
    collection_rows = { 4, 4 },
    shop_rate = 1.0, -- originally it was zero because implementing shop items used to be jank but now it isnt so it isnt
    loc_txt = {},
    default = "c_mf_deepblue",
    can_stack = false,
    can_divide = false,
  })

  SMODS.UndiscoveredSprite({
    key = "Colour",
    atlas = "mf_colours",
    path = "mf_colours_refresh.png", -- uh. 
    pos = { x = 0, y = 0 },
    px = 71,
    py = 95,
  })
  
  SMODS.Booster({
    key = "colour_normal_1",
    kind = "Colour",
    atlas = "mf_packs",
    pos = { x = 0, y = 0 },
    config = { extra = 2, choose = 1 },
    cost = 4,
    weight = 0.96,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
      local n_card = create_card("Colour", G.pack_cards, nil, nil, true, true, nil, "mf_colour")
      local ed_roll = pseudorandom('colour_editionroll')
      if ed_roll < 0.4 and G.GAME.used_vouchers.v_mf_colourtheory then
        n_card:set_edition({polychrome = true}, true)
      elseif ed_roll >= 0.4 and ed_roll < 0.766666 and G.GAME.used_vouchers.v_mf_artprogram then
        n_card:set_edition({negative = true}, true)
      end
      return n_card
    end,
    ease_background_colour = function(self)
      ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Colour)
      ease_background_colour({ new_colour = G.C.SECONDARY_SET.Colour, special_colour = G.C.BLACK, contrast = 2 })
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.config and card.config.center.config.choose or 1, card.ability and card.ability.extra or 2} }
    end,
    group_key = "k_colour_pack",
  })
  SMODS.Booster({
    key = "colour_normal_2",
    kind = "Colour",
    atlas = "mf_packs",
    pos = { x = 1, y = 0 },
    config = { extra = 2, choose = 1 },
    cost = 4,
    weight = 0.96,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
      local n_card = create_card("Colour", G.pack_cards, nil, nil, true, true, nil, "mf_colour")
      local ed_roll = pseudorandom('colour_editionroll')
      if ed_roll < 0.4 and G.GAME.used_vouchers.v_mf_colourtheory then
        n_card:set_edition({polychrome = true}, true)
      elseif ed_roll >= 0.4 and ed_roll < 0.766666 and G.GAME.used_vouchers.v_mf_artprogram then
        n_card:set_edition({negative = true}, true)
      end
      return n_card
    end,
    ease_background_colour = function(self)
      ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Colour)
      ease_background_colour({ new_colour = G.C.SECONDARY_SET.Colour, special_colour = G.C.BLACK, contrast = 2 })
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.config.center.config.choose, card.ability.extra } }
    end,
    group_key = "k_colour_pack",
  })
  SMODS.Booster({
    key = "colour_jumbo_1",
    kind = "Colour",
    atlas = "mf_packs",
    pos = { x = 2, y = 0 },
    config = { extra = 4, choose = 1 },
    cost = 6,
    weight = 0.48,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
      local n_card = create_card("Colour", G.pack_cards, nil, nil, true, true, nil, "mf_colour")
      local ed_roll = pseudorandom('colour_editionroll')
      if ed_roll < 0.4 and G.GAME.used_vouchers.v_mf_colourtheory then
        n_card:set_edition({polychrome = true}, true)
      elseif ed_roll >= 0.4 and ed_roll < 0.766666 and G.GAME.used_vouchers.v_mf_artprogram then
        n_card:set_edition({negative = true}, true)
      end
      return n_card
    end,
    ease_background_colour = function(self)
      ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Colour)
      ease_background_colour({ new_colour = G.C.SECONDARY_SET.Colour, special_colour = G.C.BLACK, contrast = 2 })
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.config.center.config.choose, card.ability.extra } }
    end,
    group_key = "k_colour_pack",
  })
  SMODS.Booster({
    key = "colour_mega_1",
    kind = "Colour",
    atlas = "mf_packs",
    pos = { x = 3, y = 0 },
    config = { extra = 4, choose = 2 },
    cost = 8,
    weight = 0.12,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
      local n_card = create_card("Colour", G.pack_cards, nil, nil, true, true, nil, "mf_colour")
      local ed_roll = pseudorandom('colour_editionroll')
      if ed_roll < 0.4 and G.GAME.used_vouchers.v_mf_colourtheory then
        n_card:set_edition({polychrome = true}, true)
      elseif ed_roll >= 0.4 and ed_roll < 0.766666 and G.GAME.used_vouchers.v_mf_artprogram then
        n_card:set_edition({negative = true}, true)
      end
      return n_card
    end,
    ease_background_colour = function(self)
      ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Colour)
      ease_background_colour({ new_colour = G.C.SECONDARY_SET.Colour, special_colour = G.C.BLACK, contrast = 2 })
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.config.center.config.choose, card.ability.extra } }
    end,
    group_key = "k_colour_pack",
  })

  SMODS.Tag({
    key = "colour",
    atlas = "mf_tags",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue)
      info_queue[#info_queue + 1] = { set = "Other", key = "p_mf_colour_jumbo_1", specific_vars = { 1, 4 } }
      return { vars = {} }
    end,
    apply = function(self, tag, context)
      if context.type == "new_blind_choice" then
        tag:yep("+", G.C.SECONDARY_SET.Code, function()
          local key = "p_mf_colour_jumbo_1"
          local card = Card(
            G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
            G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
            G.CARD_W * 1.27,
            G.CARD_H * 1.27,
            G.P_CARDS.empty,
            G.P_CENTERS[key],
            { bypass_discovery_center = true, bypass_discovery_ui = true }
          )
          card.cost = 0
          card.from_tag = true
          G.FUNCS.use_card({ config = { ref_table = card } })
          -- uh. should this be here??
          if G.GAME.modifiers.cry_force_edition and not G.GAME.modifiers.cry_force_random_edition then
            card:set_edition(nil, true, true)
          elseif G.GAME.modifiers.cry_force_random_edition then
            local edition = Cryptid.poll_random_edition()
            card:set_edition(edition, true, true)
          end
          card:start_materialize()
          return true
        end)
        tag.triggered = true
        return true
      end
    end,
  })

  if Entropy then
    Entropy.AscendedTags["tag_mf_colour"] = "tag_entr_ascendant_twisted"
  end

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Black",
    key = "black",
    pos = { x = 0, y = 1 },
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
      for k, v in pairs(G.jokers.cards) do
        if v.ability.set == 'Joker' and ((not v.edition) or (v.edition and not v.edition.egative)) then
          return true
        end
      end
      return false
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          local temp_pool = {}
          local backup_pool = {}
          for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
              table.insert(temp_pool, v)
            end
            if v.ability.set == 'Joker' and (v.edition and not v.edition.negative) then
              table.insert(backup_pool, v)
            end
          end
          if #temp_pool > 0 then
            local over = false
            local eligible_card = pseudorandom_element(temp_pool, pseudoseed("black"))
            local edition = {negative = true}
            eligible_card:set_edition(edition, true)
            check_for_unlock({type = 'have_edition'})
            card:juice_up(0.3, 0.5)
          elseif #backup_pool > 0 then
            local over = false
            local eligible_card = pseudorandom_element(backup_pool, pseudoseed("black"))
            local edition = {negative = true}
            eligible_card:set_edition(edition, true)
            check_for_unlock({type = 'have_edition'})
            card:juice_up(0.3, 0.5)
          end
        return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Deep Blue",
    key = "deepblue",
    pos = { x = 1, y = 1 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 1,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
      local suit = "Spades"
      local rng_seed = "deepblue"
      local blacklist = {}
      for i = 1, card.ability.val do
        local temp_pool = {}
        for k, v in pairs(G.hand.cards) do
          if not v:is_suit(suit) and not blacklist[v] then
            table.insert(temp_pool, v)
          end
        end
        local over = false
        if #temp_pool == 0 then
          break
        end
        local eligible_card = pseudorandom_element(temp_pool, pseudoseed(rng_seed))
        blacklist[eligible_card] = true
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() eligible_card:flip();play_sound('card1', 1);eligible_card:juice_up(0.3, 0.3);return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() eligible_card:flip();play_sound('tarot2', percent);eligible_card:change_suit(suit);return true end }))
        card:juice_up(0.3, 0.5)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Crimson",
    key = "crimson",
    pos = { x = 2, y = 1 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
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
      local tag_type = "tag_rare"
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
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Seaweed",
    key = "seaweed",
    pos = { x = 3, y = 1 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 1,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
      local suit = "Clubs"
      local rng_seed = "seaweed"
      local blacklist = {}
      for i = 1, card.ability.val do
        local temp_pool = {}
        for k, v in pairs(G.hand.cards) do
          if not v:is_suit(suit) and not blacklist[v] then
            table.insert(temp_pool, v)
          end
        end
        local over = false
        if #temp_pool == 0 then
          break
        end
        local eligible_card = pseudorandom_element(temp_pool, pseudoseed(rng_seed))
        blacklist[eligible_card] = true
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() eligible_card:flip();play_sound('card1', 1);eligible_card:juice_up(0.3, 0.3);return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() eligible_card:flip();play_sound('tarot2', percent);eligible_card:change_suit(suit);return true end }))
        card:juice_up(0.3, 0.5)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Brown",
    key = "brown",
    pos = { x = 0, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 1,
      cash_per = 2
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
      local temp_hand = {}
      local destroyed_cards = {}
      for k, v in ipairs(G.hand.cards) do temp_hand[#temp_hand+1] = v end
      table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
      pseudoshuffle(temp_hand, pseudoseed('brown'))

      for i = 1, math.min(#temp_hand, card.ability.val) do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end

      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        return true end }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function() 
          for i=#destroyed_cards, 1, -1 do
            local card = destroyed_cards[i]
            SMODS.destroy_cards({card})
          end
          return true end }))
      delay(0.5)
      ease_dollars(card.ability.cash_per * card.ability.val)
      delay(0.3)
      for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds, card.ability.cash_per} }
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Grey",
    key = "grey",
    pos = { x = 1, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
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
      local tag_type = "tag_double"
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
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Silver",
    key = "silver",
    pos = { x = 2, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
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
      local tag_type = "tag_polychrome"
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
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_White",
    key = "white",
    pos = { x = 3, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
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
      local card_type = "Colour"
      local rng_seed = "white"
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
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Red",
    key = "red",
    pos = { x = 0, y = 3 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 1,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
      local suit = "Hearts"
      local rng_seed = "red"
      local blacklist = {}
      for i = 1, card.ability.val do
        local temp_pool = {}
        for k, v in pairs(G.hand.cards) do
          if not v:is_suit(suit) and not blacklist[v] then
            table.insert(temp_pool, v)
          end
        end
        local over = false
        if #temp_pool == 0 then
          break
        end
        local eligible_card = pseudorandom_element(temp_pool, pseudoseed(rng_seed))
        blacklist[eligible_card] = true
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() eligible_card:flip();play_sound('card1', 1);eligible_card:juice_up(0.3, 0.3);return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() eligible_card:flip();play_sound('tarot2', percent);eligible_card:change_suit(suit);return true end }))
        card:juice_up(0.3, 0.5)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Orange",
    key = "orange",
    pos = { x = 1, y = 3 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 1,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return #G.hand.cards > 1
    end,
    use = function(self, card, area, copier)
      local suit = "Diamonds"
      local rng_seed = "orange"
      local blacklist = {}
      for i = 1, card.ability.val do
        local temp_pool = {}
        for k, v in pairs(G.hand.cards) do
          if not v:is_suit(suit) and not blacklist[v] then
            table.insert(temp_pool, v)
          end
        end
        local over = false
        if #temp_pool == 0 then
          break
        end
        local eligible_card = pseudorandom_element(temp_pool, pseudoseed(rng_seed))
        blacklist[eligible_card] = true
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() eligible_card:flip();play_sound('card1', 1);eligible_card:juice_up(0.3, 0.3);return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() eligible_card:flip();play_sound('tarot2', percent);eligible_card:change_suit(suit);return true end }))
        card:juice_up(0.3, 0.5)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Yellow",
    key = "yellow",
    pos = { x = 2, y = 3 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
      value_per = 8,
    },
    cost = 4,
    atlas = "mf_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return false
    end,
    use = function(self, card, area, copier)
      
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds, card.ability.value_per} }
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Green",
    key = "green",
    pos = { x = 3, y = 3 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
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
        local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'j_mf_oopsallfives', 'sup')
        n_card:add_to_deck()
        n_card:set_edition({negative = true}, true)
        G.jokers:emplace(n_card)
        card:juice_up(0.3, 0.5)
        return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS["j_mf_oopsallfives"]
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Blue",
    key = "blue",
    pos = { x = 0, y = 4 },
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
      local card_type = "Planet"
      local rng_seed = "blue"
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
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Lilac",
    key = "lilac",
    pos = { x = 1, y = 4 },
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
      local card_type = "Tarot"
      local rng_seed = "blue"
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
    end
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Pink",
    key = "pink",
    pos = { x = 2, y = 4 },
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
      n_random_colour_rounds(card.ability.val)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })
  
  if mf_config["45 Degree Rotated Tarot Cards"] then
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_Peach",
      key = "peach",
      pos = { x = 3, y = 4 },
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
        local card_type = "Rotarot"
        local rng_seed = "peach"
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
      end
    })
  end
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Colour",
    name = "col_Gold",
    key = "new_gold",
    pos = { x = 1, y = 6 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
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
          local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_soul', 'sup')
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
    end
  })

  if next(SMODS.find_mod("aikoyorisshenanigans")) then
    -- hell yeah 2
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_WordleGreen",
      key = "wordlegreen",
      pos = { x = 0, y = 6 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 1,
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
        local card_type = "Alphabet"
        local rng_seed = "wordle"
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
      in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
      end,
      loc_vars = function(self, info_queue, card)
        local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
        return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
      end,
      set_badges = function (self, card, badges)
        SMODS.create_mod_badges({ mod = SMODS.find_mod("aikoyorisshenanigans")[1] }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("LuckyRabbit")) then
    -- hell yeah 3
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_PastelPink",
      key = "pastelpink",
      pos = { x = 2, y = 6 },
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
        local card_type = "Silly"
        local rng_seed = "pastel"
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
        return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds, colours = {HEX("ff98e2")}} }
      end,
      set_badges = function (self, card, badges)
        SMODS.create_mod_badges({ mod = SMODS.find_mod("LuckyRabbit")[1] }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("sillyseals")) then
    -- the rest of them are still hell yeahs i just cant be bothered writing it every time
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_RoyalBlue",
      key = "royalblue",
      pos = { x = 3, y = 6 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 4,
      },
      cost = 4,
      atlas = "mf_colours",
      unlocked = true,
      discovered = true,
      hidden = true,
      soul_rate = 0.03,
      display_size = { w = 71, h = 87 },
      pixel_size = { w = 71, h = 87 },
      can_use = function(self, card)
        return true
      end,
      use = function(self, card, area, copier)
        for i = 1, card.ability.val do
          local key = nil
          if jl.chance('sealspectralpack_legendary', 20, true) then
            key = pseudorandom_element(Seals.legendary_seal_spectrals, pseudoseed('sealspectrals'))
          elseif jl.chance('sealspectralpack_epic', 5, true) then
            key = pseudorandom_element(Seals.epic_seal_spectrals, pseudoseed('sealspectrals'))
          else
            key = pseudorandom_element(Seals.rare_seal_spectrals, pseudoseed('sealspectrals'))
          end
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, key, "royalblue")
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("sillyseals")[1] }, badges)
      end,
    })
    
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_RespicePerPrisma",
      key = "respiceperprisma",
      pos = { x = 3, y = 7 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 12,
      },
      cost = 4,
      atlas = "mf_colours",
      unlocked = true,
      discovered = true,
      hidden = true,
      soul_rate = 0.0003,
      display_size = { w = 71, h = 87 },
      pixel_size = { w = 71, h = 87 },
      can_use = function(self, card)
        return true
      end,
      use = function(self, card, area, copier)
        for i = 1, card.ability.val do
          local key = "c_sillyseals_ringularity"
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, key, "royalblue")
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("sillyseals")[1] }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("Tsunami")) then
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_Teal",
      key = "teal",
      pos = { x = 0, y = 7 },
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
            local n_card = create_card(nil,G.jokers, nil, nil, nil, nil, 'j_splash', 'sup')
            n_card:add_to_deck()
            n_card:set_edition({negative = true}, true)
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("Tsunami")[1]  }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("egjs")) then
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_Blank",
      key = "blank",
      pos = { x = 1, y = 7 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 3,
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
            local n_card = create_card(nil,G.jokers, nil, nil, nil, nil, 'c_egjs_js_basic', 'sup')
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("egjs")[1]  }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("sarcpot")) then
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_Amber",
      key = "amber",
      pos = { x = 2, y = 7 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 3,
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
        local card_type = "Travel"
        local rng_seed = "amber"
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("sarcpot")[1] }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("Prism")) then
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_Moss",
      key = "moss",
      pos = { x = 0, y = 8 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 3,
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
        local card_type = "Myth"
        local rng_seed = "moss"
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("Prism")[1] }, badges)
      end,
    })
  end

  if next(SMODS.find_mod("sdm0sstuff")) then
    if SDM_0s_Stuff_Config and SDM_0s_Stuff_Config.sdm_bakery then
      SMODS.Consumable({
        object_type = "Consumable",
        set = "Colour",
        name = "col_Caramel",
        key = "caramel",
        pos = { x = 1, y = 8 },
        config = {
          val = 0,
          partial_rounds = 0,
          upgrade_rounds = 3,
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
          local card_type = "Bakery"
          local rng_seed = "caramel"
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
          SMODS.create_mod_badges({ mod = SMODS.find_mod("sdm0sstuff")[1] }, badges)
        end,
      })
    end
  end

  if next(SMODS.find_mod("finity")) then
    SMODS.Consumable({
      object_type = "Consumable",
      set = "Colour",
      name = "col_Violet",
      key = "violet",
      pos = { x = 2, y = 8 },
      config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 4,
      },
      cost = 4,
      atlas = "mf_colours",
      unlocked = true,
      discovered = true,
      hidden = true,
      display_size = { w = 71, h = 87 },
      pixel_size = { w = 71, h = 87 },
      can_use = function(self, card)
        return true
      end,
      use = function(self, card, area, copier)
        for i = 1, card.ability.val do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_finity_finity', 'sup')
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
        SMODS.create_mod_badges({ mod = SMODS.find_mod("finity")[1] }, badges)
      end,
    })
  end

  SMODS.Voucher({
    object_type = "Voucher",
    key = "paintroller",
    atlas = "mf_vouchers",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue)
      local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, 2, 'paintroller')
      return { vars = { new_numerator, new_denominator } }
    end,
  })
  SMODS.Voucher({
    object_type = "Voucher",
    key = "colourtheory",
    atlas = "mf_vouchers",
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue)
      return { vars = {} }
    end,
    requires = { "v_mf_paintroller" },
  })
  if next(SMODS.find_mod("Cryptid")) then
    SMODS.Voucher({
      object_type = "Voucher",
      key = "artprogram",
      atlas = "mf_vouchers",
      pos = { x = 2, y = 0 },
      unlocked = true,
      discovered = true,
      loc_vars = function(self, info_queue)
        return { vars = {} }
      end,
      requires = { "v_mf_colourtheory" },
    })
  end

  -- hooks
  local game_updateref = Game.update
  function Game:update(dt)
    game_updateref(self, dt)
    
    self.C.SECONDARY_SET.Colour[1] = 0.4+0.2*(1+math.sin(self.TIMERS.REAL*1.5 + 0))
    self.C.SECONDARY_SET.Colour[3] = 0.4+0.2*(1+math.sin(self.TIMERS.REAL*1.5 + math.pi * 2 / 3))
    self.C.SECONDARY_SET.Colour[2] = 0.4+0.2*(1+math.sin(self.TIMERS.REAL*1.5 + math.pi * 4 / 3))
    
    if G.ARGS.LOC_COLOURS ~= nil then
      G.ARGS.LOC_COLOURS["colourcard"] = G.C.SECONDARY_SET.Colour
    end
  end

  function colour_end_of_round_effects()
    for i=1, #G.consumeables.cards do
      trigger_colour_end_of_round(G.consumeables.cards[i])
    end
  end

  function n_random_colour_rounds(n, seed)
    for i=1, n do
      local temp_pool = {}
      for k, v in pairs(G.consumeables.cards) do
        if v.ability.set == 'Colour' or v.ability.set == "Shape" then
          table.insert(temp_pool, v)
        end
      end
      if #temp_pool == 0 then
        break
      end
      local _card = pseudorandom_element(temp_pool, pseudoseed(seed or "pink"))
      trigger_colour_end_of_round(_card)
    end
  end

  function trigger_colour_end_of_round(_card)
    if _card.ability.mf_halted then return false end
    if _card.ability.set == "Colour" or _card.ability.set == "Shape" then

      local base_count = 1
      if G.GAME.used_vouchers.v_mf_paintroller and SMODS.pseudorandom_probability(G.P_CENTERS["v_mf_paintroller"], 'paintroller', 1, 2, 'paintroller') then
        base_count = base_count + 1
      end

      -- it's back !!
      for _, jkr in pairs(SMODS.find_card("j_mf_paintcan")) do
        if SMODS.pseudorandom_probability(jkr, 'paintcan', 1, jkr.ability.extra.odds, 'paintcan') then
          base_count = base_count + 1
        end
      end
      
      base_count = base_count + #SMODS.find_card("j_akyrs_aikoyori")

      for j=1, base_count do
        -- all of them that go up over time
        if _card.ability.upgrade_rounds then
          _card.ability.partial_rounds = _card.ability.partial_rounds + 1
          local upgraded = false
          while _card.ability.partial_rounds >= _card.ability.upgrade_rounds do
            upgraded = true
            _card.ability.val = _card.ability.val + 1
            if _card.ability.val >= 10 then
              check_for_unlock({type = 'mf_ten_colour_rounds'})
            end
            _card.ability.partial_rounds = _card.ability.partial_rounds - _card.ability.upgrade_rounds
            
            if _card.ability.name == "col_Yellow" then
                  _card.ability.extra_value = _card.ability.extra_value + _card.ability.value_per
                  _card:set_cost()
                  card_eval_status_text(_card, 'extra', nil, nil, nil, {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY,
                    card = _card
                  }) 
            else
                  card_eval_status_text(_card, 'extra', nil, nil, nil, {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.SECONDARY_SET.ColourCard,
                    card = _card
                  }) 
            end
          end
          if not upgraded then
            local str = _card.ability.partial_rounds..'/'.._card.ability.upgrade_rounds
              card_eval_status_text(_card, 'extra', nil, nil, nil, {
                message = str,
                colour = G.C.SECONDARY_SET.ColourCard,
                card = _card
              }) 
          end
        end
      end
    end
  end
  
  -- special thanks to John Cryptid for this
  -- and Betmma, apparently
  G.FUNCS.can_reserve_card = function(e)
    if #G.consumeables.cards < G.consumeables.config.card_limit then
      e.config.colour = G.C.GREEN
      e.config.button = "reserve_card"
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
  end
  G.FUNCS.reserve_card = function(e)
    local c1 = e.config.ref_table
    G.E_MANAGER:add_event(Event({
      trigger = "after",
      delay = 0.1,
      func = function()
        c1.area:remove_card(c1)
        c1:add_to_deck()
        if c1.children.price then
          c1.children.price:remove()
        end
        c1.children.price = nil
        if c1.children.buy_button then
          c1.children.buy_button:remove()
        end
        c1.children.buy_button = nil
        remove_nils(c1.children)
        G.consumeables:emplace(c1)
        G.GAME.pack_choices = G.GAME.pack_choices - 1
        if G.GAME.pack_choices <= 0 then
          G.FUNCS.end_consumeable(nil, delay_fac)
        end
        return true
      end,
    }))
  end

  local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
  function G.UIDEF.use_and_sell_buttons(card)
    if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
      if card.ability.set == "Colour" or card.ability.set == "Shape" then
        return {
          n = G.UIT.ROOT,
          config = { padding = -0.1, colour = G.C.CLEAR },
          nodes = {
            {
              n = G.UIT.R,
              config = {
                ref_table = card,
                r = 0.08,
                padding = 0.1,
                align = "bm",
                minw = 0.5 * card.T.w - 0.15,
                minh = 0.7 * card.T.h,
                maxw = 0.7 * card.T.w - 0.15,
                hover = true,
                shadow = true,
                colour = G.C.UI.BACKGROUND_INACTIVE,
                one_press = true,
                button = "use_card",
                func = "can_reserve_card",
              },
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    text = localize("b_take"),
                    colour = G.C.UI.TEXT_LIGHT,
                    scale = 0.55,
                    shadow = true,
                  },
                },
              },
            },
          },
        }
      end
    end
    return G_UIDEF_use_and_sell_buttons_ref(card)
  end

  -- Joker Display

  if JokerDisplay then
    local cols = {
      "c_mf_black",
      "c_mf_deepblue",
      "c_mf_crimson",
      "c_mf_seaweed",
      "c_mf_brown",
      "c_mf_grey",
      "c_mf_silver",
      "c_mf_white",
      "c_mf_red",
      "c_mf_orange",
      "c_mf_yellow",
      "c_mf_green",
      "c_mf_blue",
      "c_mf_lilac",
      "c_mf_pink",
      "c_mf_peach",
      "c_mf_new_gold",

      "c_mf_purple",
      "c_mf_moonstone",
      "c_mf_gold",
      "c_mf_ooffoo",
      "c_mf_wordlegreen",
      "c_mf_pastelpink",
      "c_mf_royalblue",
      "c_mf_respiceperprisma",
      "c_mf_teal",
      "c_mf_blank",
      "c_mf_amber",
      "c_mf_moss",
      "c_mf_caramel",
      "c_mf_finity",
    }

    for _, col in pairs(cols) do
      if JokerDisplay then
        JokerDisplay.Definitions[col] = {
          text = {
            { ref_table = "card.ability", ref_value = "val", colour = G.C.DARK_EDITION  },
            { text = " (", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability", ref_value = "partial_rounds", colour = G.C.UI.TEXT_INACTIVE },
            { text = "/", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability", ref_value = "upgrade_rounds", colour = G.C.UI.TEXT_INACTIVE },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
          }
        }
      end
    end
  end
end

return init
