-- Jen Mod Core Initialization
-- Contains global setup, safety patches, and Jen table configuration

-- Ensure global Jen table exists even if TOML init patch is absent
Jen = Jen or {}

maxArrow = 2.5e4
local maxfloat = 1.7976931348623157e308

-- Provide Jen color globals normally injected via lovely.toml
if not G then G = {} end
if not G.C then G.C = {} end
G.C.jen_RGB = G.C.jen_RGB or {0,0,0,1}
G.C.jen_RGB_HUE = G.C.jen_RGB_HUE or 0
G.C.almanac = G.C.almanac or {0,0,1,1}

-- from cryptid.lua
SMODS.current_mod.optional_features = {
  retrigger_joker = true,
  post_trigger = true,
}

-- COMMON STRINGS
mayoverflow = '{C:inactive,s:0.65}(Does not require room, but may overflow)'
redeemprev = '{s:0.75}Also redeems {C:attention,s:0.75}previous tier for free{s:0.75} if not yet acquired'

-- Note: config.lua, fusion.lua, safety.lua, and bans.lua are loaded
-- by the main Jen.lua entry point using safe_load()

-- Initialize Incantation addons if not present
if not IncantationAddons then
  IncantationAddons = {
    Stacking = {},
    Dividing = {},
    BulkUse = {},
    StackingIndividual = {},
    DividingIndividual = {},
    BulkUseIndividual = {}
  }
end

if not AurinkoAddons then
  AurinkoAddons = {}
end

-- Stackable/Usable configurations
AllowStacking('jen_ability')
AllowStacking('jen_omegaconsumable')
AllowStacking('jen_tokens')
AllowDividing('jen_uno')
AllowDividing('jen_ability')
AllowDividing('jen_omegaconsumable')
AllowDividing('jen_tokens')
AllowMassUsing('jen_uno')
AllowBulkUse('jen_tokens')

