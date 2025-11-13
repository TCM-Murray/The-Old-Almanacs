function init()
  SMODS.Atlas({ 
    key = "mf_yahi_rotarots", 
    atlas_table = "ASSET_ATLAS", 
    path = "mf_yahi_rotarots.png", 
    px = 107, 
    py = 107
  })
  
  SMODS.Sound({key = "e_faithful", path = "e_faithful.ogg",})

  SMODS.Shader({ key = 'faithful', path = 'faithful.fs' })
  
  SMODS.Consumable({
    key = "rot_puke",
    set = "Rotarot",
    name = "rot_puke",
    loc_txt = {
      name = "Puke!",
      text={
        "Debuffs blind",
        "{C:inactive}(If in a Pack, is added to consumeable slots instead){}",
      },
    },
    
    config = {},
    pos = {x=0, y= 0},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      play_sound("yahimod_catvomit")
      if G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss')) then 
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
        G.GAME.blind:disable()
      end
    end,

    can_use = function(self, card)
      if G.GAME.blind:get_type() then
        return true
      end
    end,
  })

  SMODS.Consumable({
    key = "rot_cashouttf",
    set = "Rotarot",
    name = "rot_cashouttf",
    loc_txt = {
      name = "Cashout.tf!",
      text={
        "Doubles all sell values",
        "of all Jokers",
        "{C:inactive}(this one's an ad too){}",
      },
    },
    
    config = {},
    pos = {x=1, y= 0},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for k, v in ipairs(G.jokers.cards) do
        if v.set_cost then 
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
              v.ability.extra_value = (v.ability.extra_value or 0) + v.cost
              v:set_cost()
              v:juice_up(0.3, 0.5)
              used_tarot:juice_up(0.3, 0.5)
              play_sound('timpani')
              return true
            end
          }))
        end
      end
    end,

    can_use = function(self, card)
      return true
    end,
  })

  SMODS.Consumable({
    key = "rot_sponsor",
    set = "Rotarot",
    name = "rot_sponsor",
    loc_txt = {
      name = "Sponsor!",
      text={
        "Earn {C:money}$1{} for every",
        "{C:money}$5{} you have",
      },
    },
    
    config = {},
    pos = {x=2, y= 0},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      ease_dollars(math.floor(G.GAME.dollars / 5))
    end,

    can_use = function(self, card)
      return true
    end,
  })

  SMODS.Consumable({
    key = "rot_fish",
    set = "Rotarot",
    name = "rot_fish",
    loc_txt = {
      name = "Fish!",
      text={
        "Fish...",
      },
    },
    
    config = {},
    pos = {x=3, y= 0},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      G.showfish = 4000
      play_sound("yahimod_fish")
    end,

    can_use = function(self, card)
      return true
    end,
  })

  SMODS.Consumable({
    key = "rot_cardboardbox",
    set = "Rotarot",
    name = "rot_cardboardbox",
    loc_txt = {
      name = "Cardboardbox!",
      text={
        "Duplicates your held",
        "{C:attention}Cat Jokers{}",
        "{C:inactive}(does not require room){}",
      },
    },
    
    config = {},
    pos = {x=0, y= 1},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.Cat then
          local card = create_card("Cat", G.Jokers, nil, nil, nil, nil, G.jokers.cards[i].config.center.key, 'cardboardbox')
          card:add_to_deck()
          G.jokers:emplace(card)
          play_sound("yahimod_mariopaintmeow")
        end
      end
      G.GAME.joker_buffer = 0
    end,

    can_use = function(self, card)
      return true
    end,
  })

  SMODS.Consumable({
    key = "rot_yahiworld",
    set = "Rotarot",
    name = "rot_yahiworld",
    loc_txt = {
      name = "Yahiworld!",
      text={
        "Duplicates your held",
        "{C:attention}Yahimod Jokers{}",
        "{C:inactive}(does not require room){}",
      },
    },
    
    config = {},
    pos = {x=1, y= 1},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.Yahimodaddition then
          local card = create_card("Yahimodaddition", G.Jokers, nil, nil, nil, nil, G.jokers.cards[i].config.center.key, 'cardboardbox')
          card:add_to_deck()
          G.jokers:emplace(card)
          play_sound("yahimod_mariopaintmeow")
        end
      end
      G.GAME.joker_buffer = 0
    end,

    can_use = function(self, card)
      return true
    end,
  })

  SMODS.Consumable({
    set = "Rotarot",
    key = "rot_instantwin",
    name = "rot_instantwin",
    loc_txt = {
      name = "Instant Win!",
      text={
        "{C:red,s:1.2}KILL{} target {C:attention}Horse{}......",
      },
    },
    
    pos = {x=2, y= 1},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    cost = 3,

    use = function(self, card, area, copier)
      if #G.jokers.highlighted == 1 or #G.hand.highlighted == 1 then
        if not (#G.jokers.highlighted == 1 and #G.hand.highlighted == 1) then
          if #G.jokers.highlighted == 1 and G.jokers.highlighted[1].ability.name == "j_yahimod_horsewalksin" then
            play_sound("mf_gun")
            play_sound("yahimod_horsedeath")

            G.jokers.highlighted[1].ability.eternal = false
            G.E_MANAGER:add_event(Event({func = function()
              G.jokers.highlighted[1]:start_dissolve({G.C.RED}, nil, 1.6)
            return true end }))

          elseif #G.hand.highlighted == 1 and G.hand.highlighted[1].seal == "yahimod_horse_seal" then
            play_sound("mf_gun")
            play_sound("yahimod_horsedeath")

            G.hand.highlighted[1]:set_seal()
            G.hand.highlighted[1]:juice_up(0.5, 0.5)
          end
        end
      end
    end,

    can_use = function(self, card)
      local joker_horse = #G.jokers.highlighted == 1 and G.jokers.highlighted[1].ability.name == "j_yahimod_horsewalksin"
      local horseseal = #G.hand.highlighted == 1 and G.hand.highlighted[1].seal == "yahimod_horse_seal"

      return joker_horse or horse_seal
    end,

    can_use = function(self, card)
      return true
    end,
  })
  
  SMODS.Consumable {
    set = "Rotarot",
    key = "rot_hispanicgathering",
    config = {
      -- How many cards can be selected.
      max_highlighted = 1,
      -- the key of the seal to change to
      extra = 'mf_screencap_seal',
    },
    loc_vars = function(self, info_queue, card)
      -- Handle creating a tooltip with seal args.
      info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
      -- Description vars
      return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    loc_txt = {
      name = 'Hispanic Family Gathering!',
      text = {
        "Select {C:attention}#1#{} card to",
        "apply a {C:blue}Screencap Seal{} to"
      }
    },
    cost = 3,
    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },
    pos = {x=3, y=1},
    use = function(self, card, area, copier)
      for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
          G.hand.highlighted[i].seal = "mf_screencap_seal"
          return true end }))
        
        delay(0.5)
      end
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
  }
  
  SMODS.Seal {
    name = "screencap_seal",
    key = "screencap_seal",
    badge_colour = HEX("6bf8ee"),
    loc_txt = {
      label = 'Screencap Seal',
      name = 'Screencap Seal',
      text = {
        "Always drawn first"
      }
    },
    atlas = "mf_stickers",
    pos = {x=1, y=0},
  }
  
  SMODS.Consumable {
    set = "Rotarot",
    key = "rot_vampire",
    config = {
      max_highlighted = 1,
      extra = 'vampire',
    },
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_CENTERS.e_mf_faithful
      -- Description vars
      return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    loc_txt = {
      name = 'Vampire!',
      text = {
        "Select {C:attention}#1#{} card to",
        "turn {C:blue}Faithful{}"
      }
    },
    cost = 3,
    pos = {x=0, y=2},

    unlocked = true,
    discovered = true,
    
    atlas = "mf_yahi_rotarots",
    display_size = { w = 107, h = 107 },

    can_use = function(self, card)
      if #G.hand.highlighted == 1 then
        return true
      end
    end,

    use = function(self, card, area, copier)
      for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
          play_sound('mf_e_faithful', 1.0, 3.0)
          G.hand.highlighted[1]:set_edition({ mf_faithful = true })
          G.hand.highlighted[1]:juice_up(0.3, 0.5)
          return true end }))
      
        delay(0.5)
      end
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end,
    
    -- set_badges = function (self, card, badges)
    --   SMODS.create_mod_badges({ mod = SMODS.find_mod("Yahimod")[1] }, badges)
    -- end,
  }

  SMODS.Edition{
    key = "faithful",
    order = 99,
    loc_txt = {
      name = "Faithful",
      label = "Faithful",
      text = {
        "{X:dark_edition,C:white}^^1.01{} Chips",
      }
    },
    weight = 2, -- idk what number this would be
    shader = "faithful",
    in_shop = true,
    extra_cost = 7,
    config = { ee_chips = 1.01 },
    sound = {
      sound = "mf_e_faithful",
      per = 1,
      vol = 0.,
    },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue+1] = { key = "tetr_explainer", set="Other", specific_vars = { center.ability.val, center.ability.val - 1 } }
      return {vars = { } }
    end,

    get_weight = function(self)
      return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
      return { vars = { self.config.e_chips } }
    end,
    calculate = function(self, card, context)
      if
        (
          context.edition -- for when on jonklers
          and context.cardarea == G.jokers -- checks if should trigger
          and card.config.trigger -- fixes double trigger
        ) or (
          context.main_scoring -- for when on playing cards
          and context.cardarea == G.play
        )
      then
        if Talisman then
          return {
            eechips = self.config.ee_chips,
          }
        else
          return {
            Xchips_mod = hand_chips ^ hand_chips ^ (self.config.ee_chips - 1),
            message = "^^"..self.config.ee_chips.." Chips",
            colour = G.C.DARK_EDITION
          }
        end
      end
      if context.joker_main then
        card.config.trigger = true -- context.edition triggers twice, this makes it only trigger once (only for jonklers)
      end

      if context.after then
        card.config.trigger = nil
      end
    end,
  }

  local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
  function G.UIDEF.use_and_sell_buttons(card)
    if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
      if card.ability.name == "rot_puke" then
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
end

return init