-- Jen Mod Malice/Kosmos System
-- Contains malice tracking and operator progression

local maxfloat = 1.7976931348623157e308

-- Get Kosmos joker if present
function get_kosmos()
  return jl.fc('j_jen_kosmos')
end

-- Get current malice value
function get_malice()
  if not G.GAME then return to_big(0) end
  if not G.GAME.malice then G.GAME.malice = to_big(0) end
  if jl.invalid_number(number_format(G.GAME.malice)) then G.GAME.malice = to_big(maxfloat) end
  return (get_final_operator() >= (maxArrow + 1)) and to_big(0) or to_big(G.GAME.malice)
end

-- Get maximum malice for current operator level
function get_max_malice(offset)
  offset = offset or 0
  local mod = math.max(0, (get_final_operator(true) - 1) + offset)
  if get_final_operator(true) + offset > maxArrow then return to_big(0) end
  
  -- Safety check to prevent Event Manager overflow from extremely large calculations
  if mod > 100 then
    mod = 100
  end
  
  -- Cache table for previously computed max malice tiers
  G.GAME._malice_cache = G.GAME._malice_cache or {}
  local key = mod .. '|' .. Jen.config.malice_base .. '|' .. Jen.config.malice_increase
  local cached = G.GAME._malice_cache[key]
  if cached then return cached end
  
  local base = to_big(Jen.config.malice_base) * to_big(math.max(1, mod+1))
  local m = to_big(mod)
  local exp_cap = Jen.config.malice_exponent_cap
  local pow_component
  
  if exp_cap and Jen.config.malice_cap_approximate and mod > exp_cap then
    -- Approximate beyond cap to avoid runaway memory usage
    local capped_power = (to_big(Jen.config.malice_increase) ^ (m ^ to_big(exp_cap)))
    pow_component = capped_power * to_big(math.max(1, math.floor((mod * (mod+1)) / (2*exp_cap))))
  else
    pow_component = (to_big(Jen.config.malice_increase) ^ (m ^ (m + 1)))
  end
  
  local result = base * pow_component
  
  -- Store only a limited number of cache entries to bound memory
  G.GAME._malice_cache._order = G.GAME._malice_cache._order or {}
  table.insert(G.GAME._malice_cache._order, key)
  G.GAME._malice_cache[key] = result
  if #G.GAME._malice_cache._order > 128 then
    local old_key = table.remove(G.GAME._malice_cache._order, 1)
    G.GAME._malice_cache[old_key] = nil
  end
  return result
end

-- Check if malice threshold reached and upgrade operator
function check_malice(check)
  if get_final_operator(true) >= (maxArrow + 1) then return end
  if get_malice() ~= (check or to_big(0)) then return end
  local kosmos = get_kosmos()
  if check >= get_max_malice() then
    local maxmalice = get_max_malice()
    local increments = 0
    local safety_threshold = Jen.config.kosmos_safety_threshold or 50
    local gc_trigger = Jen.config.kosmos_gc_trigger_kb or 256000
    local max_iterations = 100
    
    while (not Jen.config.safer_kosmos or increments < safety_threshold) and increments < max_iterations do
      if collectgarbage("count") > gc_trigger then collectgarbage("collect") end
      if G.GAME.malice >= maxmalice and maxmalice > to_big(0) then
        G.GAME.malice = G.GAME.malice - maxmalice
        increments = increments + 1
        maxmalice = get_max_malice(increments)
      else
        break
      end
    end
    
    if maxmalice <= to_big(0) then G.GAME.malice = to_big(0) end
    play_sound('jen_enchant', 0.75, 1)
    jl.a('Operator Increased' .. (increments > 1 and (' x ' .. tostring(increments)) or ''), G.SETTINGS.GAMESPEED * 2, 1, G.C.SECONDARY_SET.Tarot)
    jl.rd(2)
    G.jokers:change_size_absolute(increments)
    change_final_operator(increments)
    
    if Jen.config.safer_kosmos then
      maxmalice = get_max_malice()
      local next_check = get_malice()
      if G.GAME.malice >= maxmalice and maxmalice > to_big(0) then
        Q(function() check_malice(next_check) return true end, 0.1, nil, 'after')
      end
    end
  end
end

-- Add malice points
function add_malice(mod, now, unscaled)
  if jl.invalid_number(number_format(mod)) then return end
  if now or not Jen.config.safer_kosmos then
    if get_final_operator(true) >= (maxArrow + 1) then return end
    local kosmos = get_kosmos()
    if not kosmos then return end
    if not G.GAME.malice then G.GAME.malice = to_big(0) end
    local orig_malice = G.GAME.malice * to_big(1)
    local orig_maxmalice = get_max_malice()
    mod = to_big(mod)
    if not unscaled then
      mod = (math.abs(mod) * (to_big(Jen.config.malice_increase) ^ to_big(G.GAME.round_resets.ante)))
    end
    G.GAME.malice = G.GAME.malice + mod
    if jl.invalid_number(number_format(G.GAME.malice)) then G.GAME.malice = to_big(maxfloat) end
    if not kosmos.cumulative_malice then
      kosmos.cumulative_malice = (kosmos.cumulative_malice or to_big(0)) + mod
      Q(function() if kosmos then
        card_status_text(kosmos, '+' .. number_format(kosmos.cumulative_malice or to_big(0)), nil, 0.05*kosmos.T.h, G.C.RED, 0.6, 0.6, 0.4, 0.4, 'bm', 'jen_enchant', 0.5, 1)
        jl.a('Malice : ' .. number_format(orig_malice + (kosmos.cumulative_malice or to_big(0))) .. ' / ' .. number_format(orig_maxmalice), 3, 0.75, G.C.RED)
        kosmos.cumulative_malice = nil
        check_malice(G.GAME.malice)
      end return true end, 0.1, nil, 'after')
    else
      kosmos.cumulative_malice = (kosmos.cumulative_malice or to_big(0)) + mod
    end
  else
    Q(function() add_malice(mod, true, unscaled) return true end)
  end
end

-- Get malice value for amalgam based on rarity
function get_amalgam_value(rarity)
  rarity = tostring(rarity) or ''
  local malice = to_big(0)
  local op = get_final_operator(true)
  
  if rarity == '3' and op < 25 then
    malice = get_max_malice() * .1
  elseif rarity == 'cry_epic' and op < 100 then
    malice = get_max_malice() * (op < 50 and 1 or .25)
  elseif rarity == '4' and op < 1000 then
    malice = get_max_malice(op < 300 and 2 or op < 400 and 1 or 0) * (op < 500 and 1 or .25)
  elseif rarity == 'cry_exotic' and op < 3000 then
    malice = get_max_malice(op < 1500 and 4 or op < 1800 and 3 or op < 2100 and 2 or op < 2400 and 1 or 0)
  elseif rarity == 'jen_ritualistic' and op < 8000 then
    malice = get_max_malice(op < 5000 and 9 or op < 5500 and 4 or op < 6000 and 3 or op < 6500 and 2 or op < 7000 and 1 or 0)
  elseif rarity == 'jen_wondrous' and op < 20000 then
    malice = get_max_malice(op < 10000 and 24 or op < 12000 and 14 or op < 14000 and 9 or op < 16000 and 4 or op < 18000 and 2 or 0)
  elseif rarity == 'jen_extraordinary' then
    malice = get_max_malice(op < 21000 and 49 or op < 21500 and 29 or op < 22000 and 14 or op < 22500 and 7 or 0)
  elseif rarity == 'jen_transcendent' then
    malice = get_max_malice(op < 22500 and 99 or op < 23000 and 49 or op < 23500 and 24 or op < 24000 and 11 or 4)
  end
  return malice
end

