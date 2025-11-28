-- Jen Mod Straddle System
-- Contains straddle progression mechanics

-- Update straddle display in HUD
function ease_straddle_display(mod)
  local should_update_to_straddle = false
  if not mod then
    if not tonumber(G.GAME.straddle_disp) then G.GAME.straddle_disp = 0 end
    mod = G.GAME.straddle - G.GAME.straddle_disp
    should_update_to_straddle = true
  end
  Q(function()
    local straddle_UI = G.HUD:get_UIE_by_ID('straddle_UI_count')
    mod = mod or 0
    local text = '+'
    local col = G.C.CRY_BLOSSOM
    if mod < 0 then
      text = ''
      col = G.C.CRY_AZURE
    end
    G.GAME.straddle_disp = should_update_to_straddle and G.GAME.straddle or ((tonumber(G.GAME.straddle_disp) or 0) + mod)
    straddle_UI.config.object:update()
    G.HUD:recalculate()
    attention_text({
      text = text..mod,
      scale = 0.8, 
      hold = 0.7,
      cover = straddle_UI.parent,
      cover_colour = col,
      align = 'cm',
    })
    play_sound('highlight2', 0.5, 0.2)
    play_sound('generic1')
  return true end)
  delay(.2)
end

-- Progress straddle meter
function progress_straddle(add)
  if not G.GAME.straddle_active or not Jen.config.straddle.enabled then return end
  local length_multiplier = 1
  if #SMODS.find_card('j_jen_pickel') > 0 then
    length_multiplier = length_multiplier * 2
  end
  if G.GAME.tortoise then
    length_multiplier = length_multiplier * 2
  end
  local MIN = Jen.config.straddle.progress_min * length_multiplier
  local MAX = Jen.config.straddle.progress_max * length_multiplier
  local spd = math.min(4, 1 + (G.GAME.straddle / 100))
  local spd_additive = .1 * spd
  local orig_straddle = G.GAME.straddle
  local to_next = math.min(MAX, MIN + math.floor(G.GAME.straddle / Jen.config.straddle.progress_increment))
  local progressbar = {}
  
  for i = 1, MAX do
    progressbar[i] = jl.rawcard(i > to_next and 'm_stone' or G.GAME.straddle >= 100 and 'm_gold' or 'c_base', 1 / ((1 + (MAX/10)) ^ .5), (2/MAX) * i)
    progressbar[i].states.drag.can = false
    progressbar[i].no_ui = true
    if i <= G.GAME.straddle_progress then
      progressbar[i]:set_edition({negative = true}, true, true)
    end
  end
  
  if (progressbar or {})[1] then progressbar[1]:add_dynatext('Straddle ' .. number_format(G.GAME.straddle)) end
  if (progressbar or {})[to_next] then progressbar[to_next]:add_dynatext(nil, 'Straddle ' .. number_format(G.GAME.straddle + 1)) end
  jl.rd(0.5)
  
  while add > 0 and (spd < 8 or to_next < MAX) and not Jen.config.straddle.skip_animation do
    add = add - 1
    G.GAME.straddle_progress = G.GAME.straddle_progress + 1
    local target = progressbar[math.min(G.GAME.straddle_progress, MAX)]
    local silent_increase = spd > 4
    local should_gold = G.GAME.straddle >= 100
    local pitch_mod = .9 + (G.GAME.straddle_progress / 10)
    Q(function() if target then target:set_edition({negative = true}, true, true) target:juice_up(0.8,0.5) end if not silent_increase then play_sound('generic1', pitch_mod) play_sound('jen_straddle_tick', pitch_mod) end return true end)
    
    if G.GAME.straddle_progress >= to_next then
      G.GAME.straddle_progress = 0
      G.GAME.straddle = G.GAME.straddle + 1
      orig_straddle = orig_straddle + 1
      if target then target:remove_dynatext() end
      if (progressbar or {})[1] then progressbar[1]:remove_dynatext() end
      local new_next = math.min(MAX, MIN + math.floor(G.GAME.straddle / Jen.config.straddle.progress_increment))
      to_next = new_next
      if spd < 4 then jl.rd(1/spd) end
      jl.a('Straddle ' .. number_format(G.GAME.straddle), G.SETTINGS.GAMESPEED * 2, 1, mix_colours(G.C.RED, G.C.UI.TEXT_LIGHT, math.min(1 + (Jen.config.straddle.progress_increment / 10), G.GAME.straddle / Jen.config.straddle.progress_increment) - (Jen.config.straddle.progress_increment / 10)))
      Q(function()
        for i = 1, MAX do
          if (progressbar or {})[i] then
            progressbar[i]:juice_up(1,1)
            progressbar[i]:set_edition({jen_prismatic = true}, true, true)
          end
        end
        play_sound('jen_straddle_increase')
        play_sound('generic1')
      return true end)
      if spd < 4 then jl.rd(1/spd) end
      for i = 1, MAX do
        Q(function() if (progressbar or {})[i] then progressbar[i]:fake_dissolve() end return true end, spd < 4 and 0.1 or 0)
      end
      if spd < 4 then jl.rd(1/spd) end
      Q(function()
        for i = 1, MAX do
          if (progressbar or {})[i] then
            progressbar[i]:start_materialize()
            progressbar[i]:set_ability(G.P_CENTERS[i > new_next and 'm_stone' or should_gold and 'm_gold' or 'c_base'])
            progressbar[i]:set_edition(nil, true, true)
          end
        end
      return true end, spd < 4 and 0.1 or 0)
      for i = 1, MAX do
        if i == 1 or i == to_next then
          if (progressbar or {})[i] then
            progressbar[i]:add_dynatext(i == 1 and ('Straddle ' .. number_format(G.GAME.straddle)), i == to_next and ('Straddle ' .. number_format(G.GAME.straddle + 1)))
          end
        end
      end
      ease_straddle_display(1)
      spd = spd + spd_additive
      spd_additive = math.min(spd_additive * 1.5, 4)
    end
    if spd < 4 then jl.rd(.25/spd) end
  end
  
  if spd >= 8 or Jen.config.straddle.skip_animation then
    G.GAME.straddle_progress = G.GAME.straddle_progress + add
    local mass_add = math.floor(G.GAME.straddle_progress / to_next)
    G.GAME.straddle_progress = G.GAME.straddle_progress - (to_next * mass_add)
    G.GAME.straddle = G.GAME.straddle + mass_add
    local nxt = math.min(MAX, MIN + math.floor(G.GAME.straddle / Jen.config.straddle.progress_increment))
    Q(function()
      for i = 1, MAX do
        if (progressbar or {})[i] then
          progressbar[i]:remove_dynatext()
          if i == 1 or i == to_next then
            progressbar[i]:add_dynatext(i == 1 and ('Straddle ' .. number_format(G.GAME.straddle)), i == to_next and ('Straddle ' .. number_format(G.GAME.straddle + 1)))
          end
          progressbar[i]:set_ability(G.P_CENTERS[i > nxt and 'm_stone' or G.GAME.straddle >= 100 and 'm_gold' or 'c_base'])
          if i <= G.GAME.straddle_progress then
            progressbar[i]:set_edition({negative = true}, true, true)
          else
            progressbar[i]:set_edition(nil, true, true)
          end
        end
      end
    return true end)
    if orig_straddle ~= G.GAME.straddle then jl.a('Straddle ' .. number_format(G.GAME.straddle), G.SETTINGS.GAMESPEED * 2, 1, mix_colours(G.C.RED, G.C.UI.TEXT_LIGHT, math.min(1 + (Jen.config.straddle.progress_increment / 10), G.GAME.straddle / Jen.config.straddle.progress_increment) - (Jen.config.straddle.progress_increment / 10))) end
    Q(function()
      play_sound('jen_straddle_increase')
      play_sound('generic1')
    return true end)
    ease_straddle_display()
  end
  
  jl.rd(1)
  if (progressbar or {})[1] then progressbar[1]:remove_dynatext() end
  if (progressbar or {})[to_next] then progressbar[to_next]:remove_dynatext() end
  Q(function() for i = 1, #progressbar do if (progressbar or {})[i] then progressbar[i]:destroy() end end return true end)
end

-- Override reroll cost calculation for tension system
local crcr = calculate_reroll_cost
function calculate_reroll_cost(final_free)
  crcr(final_free)
  local numrolls = G.GAME.tension or 0
  if Jen.config.punish_reroll_abuse then
    if numrolls > 1 then
      G.GAME.current_round.reroll_cost = math.min(math.ceil(G.GAME.current_round.reroll_cost * (1.13 ^ (numrolls-1))), 1e100)
    end
  end
end

