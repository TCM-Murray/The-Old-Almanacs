-- Jen Mod Voucher System
-- Contains voucher definitions and related overrides

-- Common strings used in voucher descriptions
local mayoverflow = '{C:inactive,s:0.65}(Does not require room, but may overflow)'
local redeemprev = '{s:0.75}Also redeems {C:attention,s:0.75}previous tier for free{s:0.75} if not yet acquired'

-- Check if voucher tier is owned
function Jen.hv(key, level)
  return G.GAME.used_vouchers['v_jen_' .. key .. (level == 13 and '_omega' or level)]
end

-- Voucher definitions
local vchrs = {
  colour = {
    depend = 'MoreFluff',
    n = 'Palettalium',
    p = { x = 5, y = 0 },
    tiers = 13,
    price = 5,
    increment = 3,
    multiplier = 1.1,
    tiers_desc = {
      { --1
        '{C:attention}Playing ("CCD") {C:colourcard}Colour{} cards will',
        '{C:attention}gain a round{} when they score'
      },
      { --2
        '{C:attention}Leftover rounds{} on used {C:colourcard}Colour{} cards',
        'are {C:attention}randomly redistributed{} to other {C:colourcard}Colour{} cards',
        ' ',
        redeemprev
      },
      { --3
        '{C:dark_edition}Polychrome {C:colourcard}Colour{} cards',
        'add {C:attention}half of their max rounds',
        'to {C:attention}all other {C:colourcard}Colour{} cards when used',
        ' ',
        redeemprev
      },
      { --4
        '{C:colourcard}Colour{} cards increase the {C:planet}level',
        'of {C:attention}all poker hands{} by the following equation when used:',
        '{X:attention,C:white}(Current Rounds / 2) + (Max Rounds / 4) + (Current Charges * 5)',
        ' ',
        redeemprev
      },
      { --5
        'At the end of round,',
        '{C:colourcard}Colour{} cards in the consumable tray',
        '{C:attention}gain a round{} for every {C:attention}round of progress they already have',
        ' ',
        redeemprev
      },
      { --6
        'At the end of round,',
        '{C:colourcard}Colour{} cards in the consumable tray',
        '{C:attention}gain progress equal to their maximum progress',
        ' ',
        redeemprev
      },
      { --7
        'Adds {C:attention}cycles{} to the end-of-round progression process',
        'of all {C:colourcard}Colour{} cards in the consumable tray, starting at {C:attention}one cycle',
        'Multiply number of cycles by {C:attention}the amount of progress{} they currently have {C:attention}plus one',
        ' ',
        redeemprev
      },
      { --8
        'Number of {C:attention}cycles{} from {C:attention}Palettalium VII',
        'is {C:attention}multiplied{} by the {C:colourcard}Colour{} card\'s',
        '{C:attention}maximum amount of progress',
        ' ',
        redeemprev
      },
      { --9
        'Number of {C:attention}cycles{} that {C:attention}Palettalium VII',
        'starts at is {C:attention}increased{} from one cycle to {C:attention}three cycles',
        ' ',
        redeemprev
      },
      { --10
        'Removes the {C:dark_edition}Polychrome',
        'requirement from {C:attention}Palettalium III',
        ' ',
        redeemprev
      },
      { --11
        '{C:colourcard}Colour{} cards add their',
        '{C:attention}current charges{} as {C:attention}rounds',
        'to {C:attention}all other {C:colourcard}Colour{} cards when used',
        ' ',
        redeemprev
      },
      { --12
        '{C:dark_edition}Negative {C:colourcard}Colour{} cards add',
        'rounds to {C:attention}all other {C:colourcard}Colour{} cards',
        'based on the following equation:',
        '{X:attention,C:white}((A+B+1)*(C+D+1))*(E^F)',
        '{C:inactive}A = Negative\'s maximum progress',
        '{C:inactive}B = Negative\'s current progress',
        '{C:inactive}C = Target\'s maximum progress',
        '{C:inactive}D = Target\'s current progress',
        '{C:inactive}E = Negative\'s current charges + 1',
        '{C:inactive}F = (Number of Colour cards / 10) + 1, max 1.5',
        '{C:inactive}Result is rounded up, max of 100,000 iterations per card',
        redeemprev
      },
      { --Omega
        '{C:attention}Palettalium II through XII{} now',
        'trigger when {C:attention}adding {C:colourcard}Colours',
        'to the consumable tray',
        redeemprev
      },
    }
  },
  astronomy = {
    n = 'Astronomicon',
    p = { x = 3, y = 0 },
    tiers = 13,
    price = 10,
    increment = 3,
    multiplier = 1.15,
    tiers_desc = {
      { --1
        '{C:attention}Specific-hand {C:planet}Planets{} will also',
        'upgrade {C:attention}adjacent{} poker hands',
        '{C:inactive}(ex. using Mercury to upgrade Pair will also upgrade High Card and Two Pair)'
      },
      { --2
        '{C:attention}Specific-hand {C:planet}Planets{} will also',
        'upgrade {C:attention}non-adjacent{} poker hands by {C:attention}one-tenth',
        ' ',
        redeemprev
      },
      { --3
        '{C:attention}Specific-hand {C:planet}Planets{} will',
        '{C:attention}repeat{} for every held {C:planet}Planet{} consumable',
        '{C:inactive}(ex. using Mercury while there are 3 other Planet cards will level up Pair 3 extra times)',
        ' ',
        redeemprev
      },
      { --4
        '{C:attention}Specific-hand {C:planet}Planets{} will',
        '{C:attention}repeat at half strength{} for every held {C:attention}non-{C:planet}Planet{} consumable',
        '{C:inactive}(ex. using Mercury while there are 3 Spectrals will level up Pair 1.5 extra times)',
        ' ',
        redeemprev
      },
      { --5
        '{C:money}Selling{} any card that is',
        '{C:red}not{} a {C:dark_edition}Negative{}, a {C:planet}Planet{} and/or a {C:attention}playing card',
        'will generate a {C:planet}Planet{} card',
        mayoverflow,
        '{C:inactive}(Black Hole excluded)',
        ' ',
        redeemprev
      },
      { --6
        '{C:money}Selling{} any card will',
        '{C:planet}level up{} a {C:green}random',
        '{C:attention}discovered poker hand{} by',
        'a {C:attention}fourth{} of its {C:money}sell value',
        ' ',
        redeemprev
      },
      { --7
        '{C:attention}Removing cards{} in most ways',
        'will {C:planet}level up{} a {C:green}random',
        '{C:attention}discovered poker hand{} by',
        'an {C:attention}eighth{} of its {C:money}sell value',
        '{C:inactive}(Applies on top of Astronomicon VI)',
        ' ',
        redeemprev
      },
      { --8
        'Hand levelups are {C:attention}twice as strong',
        '{C:inactive}(ex. what would be 3 level-ups is now 6)',
        ' ',
        redeemprev
      },
      { --9
        'If a hand {C:red}levels down{} from a card that has an {C:dark_edition}edition{},',
        'that edition\'s effect is applied by the {C:attention}absolute value{} of the level change',
        '{C:inactive}(ex. if a Polychrome levels down a hand, it will still give {X:mult,C:white}x1.5{C:inactive} Mult instead of {X:mult,C:white}/1.5{C:inactive})',
        ' ',
        redeemprev
      },
      { --10
        'Hand levelups are {C:attention}five times as strong',
        '{C:inactive}(ex. what would be 3 level-ups is now 15)',
        ' ',
        redeemprev
      },
      { --11
        'Whenever hand levels are {C:red}lost{},',
        '{C:attention}25% of those levels{} are',
        'instead {C:attention}redirected to the most played hand',
        '{C:inactive}(Does not trigger joker effects or Astronomicon)',
        ' ',
        redeemprev
      },
      { --12
        '{C:attention}Most-played hand{} gains a {C:attention}10% dividend',
        'whenever {C:attention}any other hand{} levels up',
        '{C:inactive}(Does not trigger joker effects or Astronomicon)',
        '{C:attention}Astronomicon I and II{} now also',
        'extend to {C:attention}second-adjacent{} hands',
        ' ',
        redeemprev
      },
      { --Omega
        'Whenever a hand {C:attention}gains levels{},',
        'the hand that comes {C:attention}before{} it',
        'will {C:attention}upgrade by half of that amount',
        'if the amount is {C:attention}at least 1 or more',
        '{C:inactive}(ex. if Straight leveled up 4 times,',
        '{C:inactive}then Three of a Kind levels up 2 times, which',
        '{C:inactive}then levels up Two Pair 1 time, which',
        '{C:inactive}then levels up Pair 0.5 times, and stops there)',
        ' ',
        redeemprev
      },
    }
  },
  singularity = {
    n = 'Singularium',
    p = { x = 6, y = 0 },
    tiers = 9,
    price = 10,
    increment = 5,
    multiplier = 1.15,
    tiers_desc = {
      { --1
        'Create a {C:dark_edition}Negative {C:spectral}Black Hole',
        'when opening a {C:planet}Celestial Pack',
        mayoverflow
      },
      { --2
        'Create a {C:dark_edition}Negative {C:spectral}Black Hole',
        'when a {C:attention}non-{C:dark_edition}Negative {C:planet}Planet{} is used',
        mayoverflow,
        redeemprev
      },
      { --3
        '{C:spectral}Black Holes{} level up',
        '{C:attention}all suits and ranks{} as well',
        redeemprev
      },
      { --4
        '{C:spectral}Black Holes{} are',
        '{C:attention}25 times{} as strong',
        redeemprev
      },
      { --5
        '{C:spectral}Black Holes{} have a',
        '{C:green}10% chance{} to create',
        'a random {C:planet}Planet{} when used',
        '{C:inactive,s:0.8}(Limited to 100 successful rolls in a single stack)',
        mayoverflow,
        redeemprev
      },
      { --6
        '{C:spectral}Black Holes{} are',
        '{C:attention}300 times{} as strong',
        '{C:inactive,s:0.8}(Overwrites Singularium IV)',
        redeemprev
      },
      { --7
        '{C:spectral}Black Holes{} multiply',
        '{C:chips}Chips-per-Level{} and {C:mult}Mult-per-Level',
        'of all hands by {C:attention}2{} when used',
        redeemprev
      },
      { --8
        '{C:attention}Singularium VII{} now',
        'applies to {C:attention}ranks and suits',
        redeemprev
      },
      { --9
        '{C:attention}Singularium I and II{} create',
        '{C:attention}three times{} as many {C:spectral}Black Holes',
        redeemprev
      }
    }
  },
  reserve = {
    n = 'Reservia',
    p = { x = 7, y = 0 },
    tiers = 6,
    price = 6,
    increment = 8,
    multiplier = 1.2,
    tiers_desc = {
      { --1
        'You may {C:attention}reserve {C:planet}Planets{} from',
        '{C:attention}Boosters{} and add them to',
        'your consumable tray without using them'
      },
      { --2
        'You may {C:attention}reserve {C:tarot}Tarots{} from',
        '{C:attention}Boosters{} and add them to',
        'your consumable tray without using them',
        redeemprev
      },
      { --3
        'You may {C:attention}reserve {C:spectral}Spectrals{} from',
        '{C:attention}Boosters{} and add them to',
        'your consumable tray without using them',
        redeemprev
      },
      { --4
        'When using a {C:attention}Booster{} consumable,',
        'a {C:attention}copy of the used card',
        'is added to your consumable tray',
        mayoverflow,
        redeemprev
      },
      { --5
        'When using a {C:attention}Booster{} consumable,',
        'there is a {C:green}~33.33% chance',
        'that a {C:attention}new random card of the same type',
        'will appear in the {C:attention}Booster{} choices and',
        '{C:attention}not subtract 1{} from the number of choices you can choose',
        redeemprev
      },
      { --6
        '{C:attention}Reservia IV{} now also gives a',
        '{C:attention}random consumable of the same type',
        mayoverflow,
        redeemprev
      }
    }
  }
}

-- Card:open override for Singularium voucher
local cor = Card.open
function Card:open()
  if self.ability.set == "Booster" and string.find(string.lower(self.ability.name), 'celestial') and Jen.hv('singularity', 1) then
    Q(function()
      local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'singularity1_blackhole')
      card2.no_omega = true
      if Jen.hv('singularity', 9) then
        card2:setQty(3)
        card2:create_stack_display()
      end
      card2:set_edition({negative = true}, true)
      play_sound('jen_draw')
      card2:add_to_deck()
      G.consumeables:emplace(card2)
    return true end)
  end
  return cor(self)
end

-- Register all vouchers
for k, v in pairs(vchrs) do
  if not v.depend or (SMODS.Mods[v.depend] or {}).can_load then
    for i = 1, math.min(v.tiers, 13) do
      local RED = {}
      if i > 1 then
        RED[1] = 'v_jen_' .. k .. i-1
      else
        RED = nil
      end
      SMODS.Voucher {
        key = k .. (i == 13 and '_omega' or i),
        loc_txt = {
          name = v.n .. ' ' .. (i == 13 and 'Omega' or roman(i)),
          text = v.tiers_desc[i]
        },
        pos = { x = 0, y = i == 13 and 14 or 0 },
        soul_pos = { x = v.p.x, y = v.p.y, extra = {x = 0, y = i} },
        cost = math.ceil((v.price + (v.increment * (i-1))) * (i == 13 and 3 or 1) * ((v.multiplier or 1)^(i-1))),
        unlocked = true,
        discovered = true,
        autoredeem = RED,
        atlas = 'jenvouchers',
        in_pool = function() return (((G.GAME or {}).round_resets or {}).ante or 0) > (i-2) end
      }
    end
  end
end

-- Card:redeem override for auto-redeem feature
local crr = Card.redeem
function Card:redeem()
  crr(self)
  if self and self.gc and self:gc().autoredeem then
    for k, v in ipairs(self:gc().autoredeem) do
      if not G.GAME.used_vouchers[v] then
        jl.voucher(v)
      end
    end
  end
end

-- Omega card replacement chance calculation
local function chance_for_omega(is_soul)
  if is_soul and type(is_soul) == 'string' then
    is_soul = (is_soul or '') == 'soul'
  end
  local chance = (Jen.config.omega_chance * (is_soul and Jen.config.soul_omega_mod or 1)) - 1
  if #SMODS.find_card('j_jen_apollo') > 0 then
    for _, claunecksmentor in ipairs(SMODS.find_card('j_jen_apollo')) do
      if is_soul then
        chance = chance / (((claunecksmentor.ability.omegachance_amplifier < Jen.config.soul_omega_mod and 1 or 0) + claunecksmentor.ability.omegachance_amplifier) / Jen.config.soul_omega_mod)
      else
        chance = chance / claunecksmentor.ability.omegachance_amplifier
      end
    end
  end
  if G.GAME and G.GAME.obsidian then chance = chance / 2 end
  return chance + 1
end

local omegas_found = 0

-- Override create_card for omega consumable replacement
local ccr = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  local card = ccr(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  if G.STAGE ~= G.STAGES.MAIN_MENU and card.gc then
    local cen = card:gc()
    for k, v in ipairs(omegaconsumables) do
      if cen.key == ('c_' .. v) and G.P_CENTERS['c_jen_' .. v .. '_omega'] and not G.GAME.banned_keys['c_jen_' .. v .. '_omega'] and jl.chance('omega_replacement', chance_for_omega(v), true) then
        G.E_MANAGER:add_event(Event({trigger = 'after', blockable = false, blocking = false, func = function()
          if card and not card.no_omega then
            card:set_ability(G.P_CENTERS['c_jen_' .. v .. '_omega'])
            card:set_cost()
            if chance_for_omega(v) > 10 then play_sound('jen_omegacard', 1, 0.4) end
            card:juice_up(1.5, 1.5)
            if omegas_found <= 0 then
              Q(function() play_sound_q('jen_chime', 1, 0.65); jl.a('Omega!' .. (omegas_found > 1 and (' x ' .. number_format(omegas_found)) or ''), G.SETTINGS.GAMESPEED, 1, G.C.jen_RGB); jl.rd(1); omegas_found = 0; return true end)
            end
            omegas_found = omegas_found + 1
          end
          return true
        end }))
        break
      end
    end
  end
  return card
end

-- Card:set_ability override for unchangeable cards and Ratau joker
local csar = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
  if self and self.gc then
    if self.added_to_deck and self:gc().unchangeable and not self.jen_ignoreunchangeable then
      return false
    end
  end
  -- Ensure we always pass a valid center to the original setter
  local safe_center = center
  if not safe_center then
    safe_center = (G and G.P_CENTERS and G.P_CENTERS['c_base']) or nil
  end
  if not safe_center then
    safe_center = {
      set = 'Default',
      name = '',
      effect = '',
      consumeable = false,
      unlocked = true,
      pos = { x = 0, y = 0 },
    }
  end
  csar(self, safe_center, initial, delay_sprites)
  if #SMODS.find_card('j_jen_ratau') > 0 and self.gc and self:gc().key ~= 'c_base' and string.sub(self:gc().key, 1, 2) == 'c_' and not self:gc().no_ratau then
    local mod = 1
    for k, ratsmakemecrazy in pairs(SMODS.find_card('j_jen_ratau')) do
      mod = mod * (ratsmakemecrazy.ability.modifier or 3)
    end
    local tbl = {min = mod, max = mod}
    Cryptid.misprintize(self, tbl, nil, true)
  end
end


