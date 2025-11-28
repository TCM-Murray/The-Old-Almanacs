--[[
  Jen Mod (Almanac) - Main Entry Point
  Brought to you by the same person who made the quote "The Dark Ages of smods"
  Re-brought to you by some guy who restored this modpack from the ashes.
  
  This file loads all mod components from the modular structure.
  The mod is organized as follows:
  
  Jen/
  ├── Jen.lua                 # This file (main entry point)
  ├── core/
  │   ├── init.lua            # Globals, safety patches, Jen table setup
  │   ├── utils.lua           # Helper functions
  │   ├── hooks.lua           # Game hooks and overrides
  │   ├── operator.lua        # Operator display system
  │   ├── malice.lua          # Malice/Kosmos system
  │   ├── straddle.lua        # Straddle mechanics
  │   ├── economy.lua         # Dollar/tension/relief system
  │   ├── suits_ranks.lua     # Suit/Rank leveling UI
  │   └── ui.lua              # UI helpers
  └── content/
      ├── atlases.lua         # SMODS.Atlas definitions
      ├── sounds.lua          # SMODS.Sound definitions
      ├── consumable_types.lua # SMODS.ConsumableType definitions
      ├── editions.lua        # SMODS.Edition definitions
      ├── decks.lua           # SMODS.Back definitions
      ├── enhancements.lua    # SMODS.Enhancement definitions
      ├── jokers.lua          # SMODS.Joker definitions
      ├── consumables.lua     # SMODS.Consumable definitions (+ Boosters)
      └── blinds.lua          # SMODS.Blind definitions
]]

-- Get the mod path for requiring modules
local mod_path = SMODS.current_mod.path

-- Load a file using Steamodded's official API
local function safe_load(path)
  local f, err = SMODS.load_file(path)
  if err then
    print('[JEN ERROR] Failed to load: ' .. path .. ' - ' .. tostring(err))
    return nil
  end
  if f then
    return f()
  end
  return nil
end

-- ============================================
-- LOADING 1: Core Initialization
-- ============================================

-- Load core initialization (Jen table setup, globals)
safe_load('core/init.lua')

-- Load configuration (Jen.config, locale_colours, etc.)
safe_load('core/config.lua')

-- Load fusion system
safe_load('core/fusion.lua')

-- Load safety patches
safe_load('core/safety.lua')

-- Load bans system
safe_load('core/bans.lua')

-- Load utility functions
safe_load('core/utils.lua')

-- Load game hooks and overrides
safe_load('core/hooks.lua')

-- Load operator display system
safe_load('core/operator.lua')

-- Load malice/kosmos system
safe_load('core/malice.lua')

-- Load straddle mechanics
safe_load('core/straddle.lua')

-- Load economy system (dollars, tension, relief)
safe_load('core/economy.lua')

-- Load suit/rank leveling UI
safe_load('core/suits_ranks.lua')

-- Load UI helpers
safe_load('core/ui.lua')

-- ============================================
-- LOADING 2: Assets (Atlases, Sounds, Shaders)
-- ============================================

-- Load atlases
safe_load('content/atlases.lua')

-- Load sounds and shaders
safe_load('content/sounds.lua')

-- ============================================
-- LOADING 3: Game Object Types
-- ============================================

-- Load consumable types and rarities
safe_load('content/consumable_types.lua')

-- Load editions
safe_load('content/editions.lua')

-- ============================================
-- LOADING 4: Content (Decks, Enhancements, Jokers, Consumables, Blinds, Large etc...)
-- ============================================

-- Load decks
safe_load('content/decks.lua')

-- Load enhancements
safe_load('content/enhancements.lua')

-- Load jokers
safe_load('content/jokers.lua')

-- Load consumables (includes Boosters)
safe_load('content/consumables.lua')

-- Load blinds
safe_load('content/blinds.lua')

-- Load vouchers
safe_load('content/vouchers.lua')

-- ============================================
-- LOADING 5: Configuration Tab
-- ============================================

local CFG = SMODS.current_mod.config

local function almanac_toggle(name, value, col)
  return {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
    {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
      create_toggle{ active_colour = G.C.almanac, col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = CFG, ref_value = value }
    }},
    {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
      { n = G.UIT.T, config = { text = name, scale = 0.35, colour = col or G.C.UI.TEXT_LIGHT }}
    }}
  }}
end

-- Omega Wheel config adjust functions
if not G.FUNCS.inc_omega_wheel then
  local function omega_step()
    local safe_isDown = (love and love.keyboard and type(love.keyboard.isDown) == 'function') and love.keyboard.isDown or function() return false end
    local shift = safe_isDown('lshift') or safe_isDown('rshift')
    local ctrl = safe_isDown('lctrl') or safe_isDown('rctrl')
    return shift and 50 or ctrl and 5 or 25
  end
  G.FUNCS.inc_omega_wheel = function(e)
    CFG.omega_wheel_count = math.min(500, (CFG.omega_wheel_count or 0) + omega_step())
    CFG.omega_wheel_string = 'Omega Wheel Count: '..tostring(CFG.omega_wheel_count)
    if e and e.config and e.config.object and e.config.object.update_text then e.config.object:update_text() end
  end
end

if not G.FUNCS.dec_omega_wheel then
  G.FUNCS.dec_omega_wheel = function(e)
    local safe_isDown = (love and love.keyboard and type(love.keyboard.isDown) == 'function') and love.keyboard.isDown or function() return false end
    local shift = safe_isDown('lshift') or safe_isDown('rshift')
    local ctrl = safe_isDown('lctrl') or safe_isDown('rctrl')
    local step = shift and 50 or ctrl and 5 or 25
    CFG.omega_wheel_count = math.max(1, (CFG.omega_wheel_count or 0) - step)
    CFG.omega_wheel_string = 'Omega Wheel Count: '..tostring(CFG.omega_wheel_count)
    if e and e.config and e.config.object and e.config.object.update_text then e.config.object:update_text() end
  end
end

SMODS.current_mod.config_tab = function()
  CFG.omega_wheel_count = CFG.omega_wheel_count or 200
  CFG.omega_wheel_string = 'Omega Wheel Count: '..tostring(CFG.omega_wheel_count)
  return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 4}, nodes = {
    {n = G.UIT.R, config = { padding = 0.05 }, nodes = {
      {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
        { n = G.UIT.T, config = { text = 'A game restart is required for changes to apply', scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
      }}
    }},
    almanac_toggle('Enable banned items', 'disable_bans', G.C.RED),
    {n = G.UIT.R, config = { padding = 0.05 }, nodes = {
      {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
        { n = G.UIT.T, config = { text = 'Almanac is intended to be played with banned items turned off', scale = 0.25, colour = G.C.UI.TEXT_LIGHT }},
      }}
    }},
    almanac_toggle('Straddle mechanics', 'straddle'),
    almanac_toggle('Smoother background & score flames', 'hq_shaders'),
    almanac_toggle('Curb reroll abuse (Tension + Relief)', 'punish_reroll_abuse'),
    almanac_toggle('Wondrous Joker music (by mthd2023)', 'wondrous'),
    almanac_toggle('Extraordinary+ Joker music (by mthd2023)', 'extraordinary'),
    create_slider({label = 'Omega Wheel Count', w = 6, h = 0.5, text_scale = 0.32, label_scale = 0.35, ref_table = CFG, ref_value = 'omega_wheel_count', min = 1, max = 500, callback = 'omega_wheel_slider_cb', decimal_places = 0}),
  }}
end

-- Validation for text input apply
if not G.FUNCS.apply_omega_wheel_input then
  G.FUNCS.apply_omega_wheel_input = function(e)
    local val = tonumber(CFG.omega_wheel_count)
    if not val then val = 200 end
    val = math.floor(math.max(1, math.min(500, val)))
    CFG.omega_wheel_count = val
    CFG.omega_wheel_string = 'Omega Wheel Count: '..tostring(val)
    if jl and jl.a then jl.a('Set to '..val, G.SETTINGS.GAMESPEED, 0.6, G.C.GREEN) end
  end
end

-- Slider callback
if not G.FUNCS.omega_wheel_slider_cb then
  G.FUNCS.omega_wheel_slider_cb = function(e)
    local v = tonumber(CFG.omega_wheel_count) or 200
    v = math.max(1, math.min(500, math.floor(v + 0.5)))
    CFG.omega_wheel_count = v
    CFG.omega_wheel_string = 'Omega Wheel Count: '..v
  end
end

-- ============================================
-- PHASE 6: Localization
-- ============================================

function SMODS.current_mod.process_loc_text()
  G.localization.descriptions.Other["card_suitstats"] = {
    text = {
      "{s:0.8,C:inactive}({s:0.8,V:2}#4# {s:0.8,C:inactive}| {s:0.8,V:1}lvl.#1#{s:0.8,C:inactive}) {s:0.8,C:white,X:chips}+#2#{s:0.8} & {C:white,X:mult,s:0.8}+#3#{s:0.8}",
    }
  }
  G.localization.descriptions.Other["card_rankstats"] = {
    text = {
      "{s:0.8,C:inactive}({s:0.8,V:2}#4#s {s:0.8,C:inactive}| {s:0.8,V:1}lvl.#1#{s:0.8,C:inactive}) {s:0.8,C:white,X:chips}+#2#{s:0.8} & {C:white,X:mult,s:0.8}+#3#{s:0.8}",
    }
  }
  G.localization.misc.dictionary["b_suits"] = "Suits"
  G.localization.misc.dictionary["b_ranks"] = "Ranks"
  
  -- Initialize Cryptid Encoded deck
  if jl and jl.setup_encoded_deck then
    jl.setup_encoded_deck()
  end
end

print('PLEASE LET THIS WORK.')
