-- Jen Mod Economy System
-- Contains dollar, tension, and relief management

-- Set dollars to specific value
function set_dollars(mod)
  mod = to_big(mod or 0)
  Q(function()
    local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
    local text = '='..localize('$')
    local col = G.C.FILTER
    G.GAME.dollars = mod
    dollar_UI.config.object:update()
    G.HUD:recalculate()
    attention_text({
      text = text..number_format(mod),
      scale = 0.8, 
      hold = 0.7,
      cover = dollar_UI.parent,
      cover_colour = col,
      align = 'cm',
    })
    play_sound('coin1')
  return true end)
end

-- Override ease_dollars with safety clamps
local edr = ease_dollars
function ease_dollars(mod, instant, force_update)
  if to_big((G.GAME.dollars + mod ~= G.GAME.dollars and math.abs(mod))) > to_big((G.GAME.dollars / 1e6)) or force_update then
    edr(mod, instant)
    local should_clamp = jl.invalid_number(number_format(G.GAME.dollars)) or to_big(G.GAME.dollars) > to_big(1e100) or to_big(G.GAME.dollars) < to_big(-1e100)
    if should_clamp then
      G.GAME.dollars = jl.invalid_number(number_format(G.GAME.dollars)) and to_big(1e100) or to_big(math.min(math.max(G.GAME.dollars, -1e100), 1e100))
      ease_dollars(0, true, true)
    end
  end
end

-- Modify tension (reroll abuse counter)
function ease_tension(mod)
  Q(function()
    local tension_UI = G.HUD:get_UIE_by_ID('tension_UI_count')
    mod = mod or 0
    local text = '+'
    local col = G.C.CRY_TWILIGHT
    if mod < 0 then
      text = ''
      col = G.C.CRY_VERDANT
    end
    G.GAME.tension = G.GAME.tension + mod
    tension_UI.config.object:update()
    G.HUD:recalculate()
    attention_text({
      text = text..mod,
      scale = 0.8, 
      hold = 0.7,
      cover = tension_UI.parent,
      cover_colour = col,
      align = 'cm',
    })
    play_sound('jen_tension', mod < 0 and .6 or 1)
    play_sound('generic1')
  return true end)
  delay(.2)
end

-- Modify relief (tension relief counter)
function ease_relief(mod)
  Q(function()
    local relief_UI = G.HUD:get_UIE_by_ID('relief_UI_count')
    mod = mod or 0
    local text = '+'
    local col = G.C.CRY_EXOTIC
    if mod < 0 then
      text = ''
      col = G.C.CRY_EMBER
    end
    G.GAME.relief = G.GAME.relief + mod
    relief_UI.config.object:update()
    G.HUD:recalculate()
    attention_text({
      text = text..mod,
      scale = 0.8, 
      hold = 0.7,
      cover = relief_UI.parent,
      cover_colour = col,
      align = 'cm',
    })
    play_sound('jen_relief', mod < 0 and .6 or 1)
    play_sound('generic1')
  return true end)
  delay(.2)
end

-- Cash out hook for tension/relief
local gfcor = G.FUNCS.cash_out
G.FUNCS.cash_out = function(e)
  if (G.GAME.relief or 0) > 0 then
    local mod = math.min(5, G.GAME.relief)
    if mod > G.GAME.tension then mod = G.GAME.tension end
    if mod > 0 then
      ease_tension(-mod)
    end
  end
  Q(function()
    if G.GAME.tension > 0 then
      ease_relief(1)
    elseif G.GAME.relief > 0 then
      ease_relief(-G.GAME.relief)
    end
  return true end)
  if #SMODS.find_card('j_jen_arin') > 0 then
    for k, v in pairs(SMODS.find_card('j_jen_arin')) do v:juice_up(0.6, 1) end
    for i = 1, #SMODS.find_card('j_jen_arin') * 3 do
      Q(function()
        local duplicate = create_card('Booster', G.consumeables, nil, nil, nil, nil, k, 'arin_pack')
        if duplicate.gc and duplicate:gc().set ~= 'Booster' then
          duplicate:set_ability(jl.rnd('arin_booster_equilibrium', nil, G.P_CENTER_POOLS.Booster), true, nil)
          duplicate:set_cost()
        end
        duplicate:add_to_deck()
        G.consumeables:emplace(duplicate)
        return true
      end, 0.2/(#SMODS.find_card('j_jen_arin')/3), nil, 'after')
    end
  end
  if #SMODS.find_card('j_jen_lugia') > 0 then
    for k, v in pairs(SMODS.find_card('j_jen_lugia')) do v:juice_up(0.6, 1) end
    for i = 1, #SMODS.find_card('j_jen_lugia') * 2 do
      Q(function()
        local duplicate = create_card('Voucher', G.consumeables, nil, nil, nil, nil, k, 'lugia_voucher')
        if duplicate.gc and duplicate:gc().set ~= 'Voucher' then
          duplicate:set_ability(jl.rnd('lugia_voucher_equilibrium', nil, G.P_CENTER_POOLS.Voucher), true, nil)
          duplicate:set_cost()
        end
        duplicate:add_to_deck()
        G.consumeables:emplace(duplicate)
        return true
      end, 0.2/(#SMODS.find_card('j_jen_lugia')/3), nil, 'after')
    end
  end
  QR(function()
    if Jen.config.punish_reroll_abuse then
      local numrolls = G.GAME.tension or 0
      if numrolls > 1 then
        G.GAME.current_round.reroll_cost = math.min(math.ceil(G.GAME.current_round.reroll_cost * (1.13 ^ (numrolls-1))), 1e100)
      end
    end
  return true end, 99)
  gfcor(e)
end

-- Reroll shop hook for tension/relief
local gfrsr = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
  if Jen.config.punish_reroll_abuse then
    if G.GAME.relief > 0 then
      ease_relief(-G.GAME.relief)
    end
    ease_tension(jl.round((3 ^ #SMODS.find_card('j_jen_aym')) / (G.GAME.current_round.reroll_cost <= 0 and 4 or 1), 2)) 
    if Jen.config.straddle.enabled and Jen.config.punish_reroll_abuse and G.GAME.tension >= 20 then
      if not G.GAME.straddle_active then start_straddle() end
      progress_straddle(math.ceil((2 ^ math.min(1000, G.GAME.tension - 20))))
    end
  end
  gfrsr(e)
end
