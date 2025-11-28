-- Jen Mod Utility Functions
-- Contains helper functions used throughout the mod

local CFG = SMODS.current_mod.config

-- Text formatting helpers (global, used in content files)
function checkerboard_text(txt)
  local str = ''
  local chars = jl.string_to_table(txt)
  local osc = false
  for i = 1, #chars do
    osc = not osc
    str = str .. '{X:' .. (osc and 'black' or 'inactive') .. ',C:' .. (osc and 'white' or 'black') .. '}' .. chars[i]
    if i == #chars then
      str = str .. '{}'
    end
  end
  return str
end

function suit_to_uno(suit)
  suit = string.lower(suit)
  return suit == 'hearts' and 'red' or suit == 'spades' and 'blue' or suit == 'clubs' and 'green' or suit == 'diamonds' and 'yellow' or 'n/a'
end

-- Credit/caption display helpers (global, used extensively in content files)
function faceart(artist)
  return (Jen.config.texture_pack == 'default' and Jen.config.show_credits) and ('{C:dark_edition,s:0.7,E:2}Floating sprite by : ' .. artist) or ''
end

function origin(world)
  return (Jen.config.texture_pack == 'default' and Jen.config.show_credits) and ('{C:cry_exotic,s:0.7,E:2}Origin : ' .. world)
end

-- Credit/caption helpers (global, used extensively in content files)
function au(world)
  return (Jen.config.texture_pack == 'default' and Jen.config.show_credits) and ('{C:cry_blossom,s:0.7,E:2}A.U. : ' .. world)
end

function spriter(artist)
  return (Jen.config.texture_pack == 'default' and Jen.config.show_credits) and ('{C:dark_edition,s:0.7,E:2}Sprite by : ' .. artist)
end

function caption(cap)
  return Jen.config.show_captions and ('{C:caption,s:0.7,E:1}' .. cap) or ''
end

function lore(txt)
  return Jen.config.show_lore and ('{C:lore,s:0.7,E:2}' .. txt) or ''
end

-- Roman numeral conversion (https://gist.github.com/efrederickson/4080372)
local map = { 
  I = 1,
  V = 5,
  X = 10,
  L = 50,
  C = 100, 
  D = 500, 
  M = 1000,
}
local numbers_roman = { 1, 5, 10, 50, 100, 500, 1000 }
local chars_roman = { "I", "V", "X", "L", "C", "D", "M" }

function roman(s)
  s = tonumber(s)
  if not s or s ~= s then error"Unable to convert to number" end
  if s == math.huge then error"Unable to convert infinity" end
  s = math.floor(s)
  if s <= 0 then return s end
  local ret = ""
  for i = #numbers_roman, 1, -1 do
    local num = numbers_roman[i]
    while s - num >= 0 and s > 0 do
      ret = ret .. chars_roman[i]
      s = s - num
    end
    for j = 1, i - 1 do
      local n2 = numbers_roman[j]
      if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
        ret = ret .. chars_roman[j] .. chars_roman[i]
        s = s - (num - n2)
        break
      end
    end
  end
  return ret
end

function unroman(s)
  s = s:upper()
  local ret = 0
  local i = 1
  while i <= s:len() do
    local c = s:sub(i, i)
    if c ~= " " then
      local m = map[c] or error("Unknown Roman Numeral '" .. c .. "'")
      local next = s:sub(i + 1, i + 1)
      local nextm = map[next]
      if next and nextm then
        if nextm > m then 
          ret = ret + (nextm - m)
          i = i + 1
        else
          ret = ret + m
        end
      else
        ret = ret + m
      end
    end
    i = i + 1
  end
  return ret
end

-- Straddle system
function start_straddle()
  if Jen.config.straddle.enabled then
    G.GAME.straddle_active = true
    G.GAME.straddle = G.GAME.straddle or 0
    G.GAME.straddle_progress = G.GAME.straddle_progress or 0
  end
end

-- UI scale factor calculation (global, used in content files)
function calculate_scalefactor(text)
  local size = 0.9
  local font = G.LANG.font
  local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
  local calced_text_width = 0
  for _, c in utf8.chars(text) do
    local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE + 2.7 * 1 * G.TILESCALE * font.FONTSCALE
    calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
  end
  local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
  return scale_fac
end

-- Card fusion helper
function fuse_cards(cards, output, fast)
  if fast then
    Q(function()
      play_sound('whoosh')
      for k, v in ipairs(cards) do
        G['jen_merge' .. k] = CardArea(G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, {type = 'play', card_limit = 5})
        if v.area then
          v.area:remove_card(v)
        end
        G['jen_merge' .. k]:emplace(v)
      end
    return true end)
    delay(1.5)
    Q(function()
      play_sound('explosion_release1')
      for k, v in ipairs(cards) do
        v:flip()
        if G['jen_merge' .. k] then
          G['jen_merge' .. k]:remove_card(v)
          G['jen_merge' .. k]:remove()
          G['jen_merge' .. k] = nil
        end
        v:destroy(nil, true, nil, true)
      end
    return true end)
    Q(function() if output then
      if type(output) == 'function' then
        output()
      elseif type(output) == 'string' then
        local new_card = create_card(G.P_CENTERS[output].set,G.P_CENTERS[output].set == 'Joker' and G.jokers or G.consumeables, nil, nil, nil, nil, output, 'fusion')
        G.play:emplace(new_card)
        delay(1.5)
        Q(function()
          G.play:remove_card(new_card)
          new_card:add_to_deck()
          if new_card.ability.set == 'Joker' then
            G.jokers:emplace(new_card)
          else
            G.consumeables:emplace(new_card)
          end
        return true end)
      end
    end return true end)
  else
    Q(function()
      play_sound('whoosh')
      for k, v in ipairs(cards) do
        G['jen_merge' .. k] = CardArea(G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, {type = 'play', card_limit = 5})
        if v.area then
          v.area:remove_card(v)
        end
        G['jen_merge' .. k]:emplace(v)
      end
    return true end)
    delay(1.5)
    Q(function()
      for k, v in ipairs(cards) do
        v:flip()
        if k ~= 1 then
          if G['jen_merge' .. k] then
            G['jen_merge' .. k]:remove_card(v)
            G['jen_merge' .. k]:remove()
            G['jen_merge' .. k] = nil
          end
          v:destroy(nil, true, nil, true)
        end
      end
    return true end)
    delay(0.5)
    local card
    Q(function()
      card = G.jen_merge1.cards[1]
      card:explode()
      Q(function() if card then card:remove() end if G.jen_merge1 then G.jen_merge1:remove(); G.jen_merge1 = nil; end return true end)
      Q(function() if output then
        if type(output) == 'function' then
          output()
        elseif type(output) == 'string' then
          local new_card = create_card(G.P_CENTERS[output].set,G.P_CENTERS[output].set == 'Joker' and G.jokers or G.consumeables, nil, nil, nil, nil, output, 'fusion')
          G.play:emplace(new_card)
          delay(1.5)
          Q(function()
            G.play:remove_card(new_card)
            new_card:add_to_deck()
            if new_card.ability.set == 'Joker' then
              G.jokers:emplace(new_card)
            else
              G.consumeables:emplace(new_card)
            end
          return true end)
        end
      end return true end)
    return true end)
  end
end

-- Game over function
function gameover()
  remove_save()

  if G.GAME.round_resets.ante <= G.GAME.win_ante then
    if not G.GAME.seeded and not G.GAME.challenge then
      inc_career_stat('c_losses', 1)
      set_deck_loss()
      set_joker_loss()
    end
  end

  play_sound('negative', 0.5, 0.7)
  play_sound('whoosh2', 0.9, 0.7)

  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = create_UIBox_game_over(),
    config = {no_esc = true}
  }
  G.ROOM.jiggle = G.ROOM.jiggle + 3

  if G.GAME.round_resets.ante <= G.GAME.win_ante then
    local Jimbo = nil
    Q(function()
      if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then 
        Jimbo = Card_Character({x = 0, y = 5})
        local spot = G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot')
        spot.config.object:remove()
        spot.config.object = Jimbo
        Jimbo.ui_object_updated = true
        Jimbo:add_speech_bubble('lq_'..math.random(1,10), nil, {quip = true})
        Jimbo:say_stuff(5)
      end
      return true
    end, 2.5, nil, 'after', false, false)
  end
  G.STATE_COMPLETE = true
end

-- HSV to RGB conversion (global, used by jokers.lua and hooks.lua)
function hsv(h, s, v)
  if s <= 0 then return v,v,v end
  h = h*6
  local c = v*s
  local x = (1-math.abs((h%2)-1))*c
  local m,r,g,b = (v-c), 0, 0, 0
  if h < 1 then
    r, g, b = c, x, 0
  elseif h < 2 then
    r, g, b = x, c, 0
  elseif h < 3 then
    r, g, b = 0, c, x
  elseif h < 4 then
    r, g, b = 0, x, c
  elseif h < 5 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end
  return r+m, g+m, b+m
end

-- Card status text helper
function card_status_text(card, text, xoffset, yoffset, colour, size, DELAY, juice, jiggle, align, sound, volume, pitch, trig, F)
  if (DELAY or 0) <= 0 then
    if F and type(F) == 'function' then F(card) end
    attention_text({
      text = text,
      scale = size or 1, 
      hold = 0.7,
      backdrop_colour = colour or (G.C.FILTER),
      align = align or 'bm',
      major = card,
      offset = {x = xoffset or 0, y = yoffset or (-0.05*G.CARD_H)}
    })
    if sound then
      play_sound(sound, pitch or (0.9 + (0.2*math.random())), volume or 1)
    end
    if juice then
      if type(juice) == 'table' then
        card:juice_up(juice[1], juice[2])
      elseif type(juice) == 'number' and juice ~= 0 then
        card:juice_up(juice, juice / 6)
      end
    end
    if jiggle then
      G.ROOM.jiggle = G.ROOM.jiggle + jiggle
    end
  else
    Q(function()
      if F and type(F) == 'function' then F(card) end
      attention_text({
        text = text,
        scale = size or 1, 
        hold = 0.7 + (DELAY or 0),
        backdrop_colour = colour or (G.C.FILTER),
        align = align or 'bm',
        major = card,
        offset = {x = xoffset or 0, y = yoffset or (-0.05*G.CARD_H)}
      })
      if sound then
        play_sound(sound, pitch or (0.9 + (0.2*math.random())), volume or 1)
      end
      if juice then
        if type(juice) == 'table' then
          card:juice_up(juice[1], juice[2])
        elseif type(juice) == 'number' and juice ~= 0 then
          card:juice_up(juice, juice / 6)
        end
      end
      if jiggle then
        G.ROOM.jiggle = G.ROOM.jiggle + jiggle
      end
      return true
    end, DELAY, nil, trig)
  end
end

-- Bulk sell cards helper
function bulk_sell_cards(cards, include_eternal, doublesell)
  local value = 0
  for k, v in pairs(cards) do
    if include_eternal or not (v.ability or {}).eternal then
      if doublesell and (v.edition or {}).jen_diplopia then
        v:sell_card()
        Q(function() if v then v:sell_card() end return true end, 0.1, nil, 'after')
      else
        v:sell_card()
      end
    end
  end
end

-- Fast level up helper
function fastlv(card, hand, instant, amount, no_astronomy, no_astronomy_omega, no_jokers)
  if instant then
    level_up_hand(card, hand, instant, amount, no_astronomy, no_astronomy_omega, no_jokers)
  else
    jl.h(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips + (G.GAME.hands[hand].l_chips * amount), G.GAME.hands[hand].mult + (G.GAME.hands[hand].l_mult * amount), G.GAME.hands[hand].level + amount, true)
    level_up_hand(card, hand, true, amount, no_astronomy, no_astronomy_omega, no_jokers)
    delay(0.1)
  end
end

-- Level up all hands helper
function lvupallhands(amnt, card, fast)
  if not amnt then return end
  if amnt == 0 then return end
  if (G.SETTINGS.FASTFORWARD or 0) > 1 then fast = true end
  if fast then
    Q(function() if card then
      card:juice_up(0.8, 0.5)
    end return true end)
    jl.h(localize('k_all_hands'), (amnt > 0 and '+' or '-'), (amnt > 0 and '+' or '-'), (amnt > 0 and '+' or '-') .. number_format(math.abs(amnt)), true)
  else
    jl.th('all')
    Q(function()
      play_sound('tarot1')
      if card then card:juice_up(0.8, 0.5) end
      return true
    end, 0.2, nil, 'after')
    jl.h(localize('k_all_hands'), (amnt > 0 and '+' or '-'), (amnt > 0 and '+' or '-'), (amnt > 0 and '+' or '-') .. number_format(math.abs(amnt)), true)
    delay(0.5)
  end
  for k, v in pairs(G.GAME.hands) do
    level_up_hand(card, k, true, amnt)
  end
  jl.ch()
end

-- Black hole effect helper
function black_hole_effect(card, amnt)
  if (G.SETTINGS.FASTFORWARD or 0) > 0 then
    lvupallhands(amnt, card)
  else
    jl.h(localize('k_all_hands'), '...', '...', '')
    Q(function()
      play_sound("tarot1")
      card:juice_up(0.8, 0.5)
      G.TAROT_INTERRUPT_PULSE = true
      return true
    end, 0.1, nil, 'after')
    jl.hm('+', true)
    jl.hc('+', true)
    jl.hlv('+' .. amnt)
    G.GAME._black_hole_processing = true
    for k, v in pairs(G.GAME.hands) do
      level_up_hand(card, k, true, amnt)
    end
    G.TAROT_INTERRUPT_PULSE = nil
    G.GAME._black_hole_processing = nil
    jl.ch()
  end
end

-- Blind size change helper (global, used in content files)
function change_blind_size(newsize, instant, silent)
  newsize = to_big(newsize)
  G.GAME.blind.chips = newsize
  local chips_UI = G.hand_text_area.blind_chips
  if instant then
    G.GAME.blind.chip_text = number_format(newsize)
    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
    if G.HUD_blind then G.HUD_blind:recalculate() end
    chips_UI:juice_up()
    if not silent then play_sound('chips2') end
  else
    Q(function()
      G.GAME.blind.chip_text = number_format(newsize)
      G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
      if G.HUD_blind then G.HUD_blind:recalculate() end
      chips_UI:juice_up()
      if not silent then play_sound('chips2') end
      return true
    end)
  end
end

-- Ante multiplier helper (global, used in content files)
function multante(number)
  if G.GAME.round_resets.ante < 1 then
    ease_ante(math.abs(G.GAME.round_resets.ante) + 1)
  else
    ease_ante(math.min(1e308, G.GAME.round_resets.ante * (2 ^ (number or 1)) - G.GAME.round_resets.ante))
  end
end

-- Win ante ease helper
function ease_winante(mod)
  Q(function()
    local ante_UI = G.hand_text_area.ante
    mod = mod or 0
    local text = 'Max'
    local col = G.C.PURPLE
    if mod < 0 then
      text = text .. ' -'
      col = G.C.GREEN
    else
      text = text .. ' +'
    end
    ante_UI.config.object:update()
    G.GAME.win_ante=G.GAME.win_ante+mod
    G.HUD:recalculate()
    attention_text({
      text = text..tostring(math.abs(mod)),
      scale = 0.6, 
      hold = 0.9,
      cover = ante_UI.parent,
      cover_colour = col,
      align = 'cm',
    })
    play_sound('highlight2', 0.4, 0.2)
    play_sound('generic1')
    return true
  end, nil, nil, 'immediate')
end

-- Play sound with queue helper (global, used in content files)
function play_sound_q(sound, per, vol)
  Q(function()
    play_sound(sound, per, vol)
    return true
  end)
end

-- Card speak method
function Card:speak(text, col)
  if type(text) == 'table' then text = text[math.random(#text)] end
  card_eval_status_text(self, 'extra', nil, nil, nil, {message = text, colour = col or G.C.FILTER})
end

-- Card blackhole method
function Card:blackhole(amnt)
  black_hole_effect(self, amnt)
end

-- Card cumulative levels method
function Card:apply_cumulative_levels(hand)
  Q(function()
    Q(function()
      if self then
        if hand and G.GAME.hands[hand] then
          jl.th(hand)
          level_up_hand(self, hand, false, (self.cumulative_lvs or 1))
          self.cumulative_lvs = nil
          jl.ch()
        else
          lvupallhands(self.cumulative_lvs, self)
          self.cumulative_lvs = nil
        end
      end
      return true
    end, 0.2, nil, 'after')
    return true
  end, 0.2, nil, 'after')
end

-- Omega Num UI Check
G.FUNCS.isomeganumenabled = function(e)
  if Big and Big.arrow then
    return true
  end
  return false
end

-- Jen utility functions
local function hiddencard(card)
  if type(card) ~= 'table' then return false end
  if not G.GAME then return false end
  return (((card.name or '') == 'Black Hole' or (card.name or '') == 'The Soul' or card.hidden) and not G.GAME.obsidian) or card.hidden2
end

local function overpowered(rarity)
  if type(rarity) == 'number' then return false end
  return jl.bf(rarity, Jen.overpowered_rarities)
end

local function gods()
  return #SMODS.find_card('j_jen_godsmarble') > 0
end

-- Assign directly to Jen table for functions called as Jen.X()
Jen.gods = gods
Jen.overpowered = overpowered
Jen.hiddencard = hiddencard
