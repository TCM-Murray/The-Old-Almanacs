-- Jen Mod Suit/Rank Leveling System
-- Contains suit and rank selection UI and controls

-- Check if a suit/rank combination is valid
function is_valid_suit_rank(s, r)
  return (not SMODS.Ranks[r].in_pool or SMODS.Ranks[r]:in_pool({suit = s})) and (not SMODS.Suits[s].in_pool or SMODS.Suits[s]:in_pool({rank = r}))
end

-- Get list of valid suits for current rank
function prune_valid_suits()
  local suits = {}
  for i = 1, #SMODS.Suit.obj_buffer do
    local v = SMODS.Suit.obj_buffer[i]
    if is_valid_suit_rank(v, G.suitrank.rank) then
      table.insert(suits, v)
    end
  end
  return suits
end

-- Get list of valid ranks for current suit
function prune_valid_ranks()
  local ranks = {}
  for i = 1, #SMODS.Rank.obj_buffer do
    local v = SMODS.Rank.obj_buffer[i]
    if is_valid_suit_rank(G.suitrank.suit, v) then
      table.insert(ranks, v)
    end
  end
  return ranks
end

-- Navigate to next suit
function G.FUNCS.inc_sr_suit()
  local suits = prune_valid_suits()
  local pos = 0
  for i = 1, #suits do
    if suits[i] == G.suitrank.suit then
      pos = i
      break
    end
  end
  G.suitrank.suit = suits[(pos % #suits) + 1]
  recalc_suitrank()
end

-- Navigate to previous suit
function G.FUNCS.dec_sr_suit()
  local suits = prune_valid_suits()
  local pos = 0
  for i = 1, #suits do
    if suits[i] == G.suitrank.suit then
      pos = i
      break
    end
  end
  G.suitrank.suit = suits[(pos - 2) % #suits + 1]
  recalc_suitrank()
end

-- Navigate to next rank
function G.FUNCS.inc_sr_rank()
  local ranks = prune_valid_ranks()
  local pos = 0
  for i = 1, #ranks do
    if ranks[i] == G.suitrank.rank then
      pos = i
      break
    end
  end
  G.suitrank.rank = ranks[(pos % #ranks) + 1]
  recalc_suitrank()
end

-- Navigate to previous rank
function G.FUNCS.dec_sr_rank()
  local ranks = prune_valid_ranks()
  local pos = 0
  for i = 1, #ranks do
    if ranks[i] == G.suitrank.rank then
      pos = i
      break
    end
  end
  G.suitrank.rank = ranks[(pos - 2) % #ranks + 1]
  recalc_suitrank()
end

-- Keyboard controls for suit/rank navigation
local ckpu = Controller.key_press_update
function Controller:key_press_update(key, dt)
  if Cryptid.safe_get(G, "suitrank", "card") then
    if key == 'left' or key == 'a' then
      G.FUNCS.dec_sr_suit()
    elseif key == 'right' or key == 'd' then
      G.FUNCS.inc_sr_suit()
    elseif key == 'down' or key == 's' then
      G.FUNCS.dec_sr_rank()
    elseif key == 'up' or key == 'w' then
      G.FUNCS.inc_sr_rank()
    end
  end
  return ckpu(self, key, dt)
end

-- Recalculate suit/rank display after selection change
function recalc_suitrank()
  SMODS.change_base(G.suitrank.card, G.suitrank.suit, G.suitrank.rank)
  G.suitrank.suitconfig.name = localize(G.suitrank.suit, 'suits_plural')
  G.suitrank.rankconfig.name = localize(G.suitrank.rank, 'ranks')
  for _, k in pairs({"color", "outline_color", "level_color", "text_color"}) do
    if not G.suitrank.suitconfig[k] then
      G.suitrank.suitconfig[k] = {}
    end
    if not G.suitrank.rankconfig[k] then
      G.suitrank.rankconfig[k] = {}
    end
  end
  for i = 1, 4 do
    G.suitrank.suitconfig.color[i] = G.C.SUITS[G.suitrank.suit][i]
    G.suitrank.suitconfig.outline_color[i] = darken(G.C.SUITS[G.suitrank.suit], 0.3)[i]
    G.suitrank.suitconfig.level_color[i] = G.C.HAND_LEVELS[number_format(G.GAME.suits[G.suitrank.suit].level)][i]
    G.suitrank.suitconfig.text_color[i] = lighten(G.C.SUITS[G.suitrank.suit], 0.6)[i]
    G.suitrank.rankconfig.color[i] = darken(G.C.SECONDARY_SET.Tarot, 0.3)[i]
    G.suitrank.rankconfig.outline_color[i] = darken(G.C.SECONDARY_SET.Tarot, 0.65)[i]
    G.suitrank.rankconfig.level_color[i] = G.C.HAND_LEVELS[number_format(G.GAME.ranks[G.suitrank.rank].level)][i]
    G.suitrank.rankconfig.text_color[i] = lighten(G.C.SECONDARY_SET.Tarot, 0.6)[i]
  end
  G.suitrank.suitconfig.level = localize('k_level_prefix')..number_format(G.GAME.suits[G.suitrank.suit].level)
  G.suitrank.suitconfig.count = jl.countsuit()[G.suitrank.suit] or 0
  G.suitrank.suitconfig.chips = "+"..number_format(G.GAME.suits[G.suitrank.suit].chips)
  G.suitrank.suitconfig.mult = "+"..number_format(G.GAME.suits[G.suitrank.suit].mult)
  G.suitrank.rankconfig.level = localize('k_level_prefix')..number_format(G.GAME.ranks[G.suitrank.rank].level)
  G.suitrank.rankconfig.count = jl.countrank()[G.suitrank.rank] or 0
  G.suitrank.rankconfig.chips = "+"..number_format(G.GAME.ranks[G.suitrank.rank].chips)
  G.suitrank.rankconfig.mult = "+"..number_format(G.GAME.ranks[G.suitrank.rank].mult)
end

-- UI Construction for Suit/Rank Display
function ui_suits_ranks()
  if not G.suitrank then
    G.suitrank = {}
  end
  if G.suitrank.card then
    G.suitrank.card:remove()
  end
  if not G.suitrank.rank or not G.suitrank.suit or not is_valid_suit_rank(G.suitrank.suit, G.suitrank.rank) then
    for i = 1, #SMODS.Rank.obj_buffer do
      local r = SMODS.Rank.obj_buffer[i]
      for j = 1, #SMODS.Suit.obj_buffer do
        local s = SMODS.Suit.obj_buffer[j]
        if is_valid_suit_rank(s, r) then
          G.suitrank.suit = s
          G.suitrank.rank = r
          break
        end
      end
    end
  end
  G.suitrank.card = Card(0,0,1.5*G.CARD_W,1.5*G.CARD_H,G.P_CARDS.S_A,G.P_CENTERS.c_base)
  G.suitrank.card.ambient_tilt = 0
  G.suitrank.card.states.hover.can = false
  G.suitrank.card.hover_tilt = 0
  G.suitrank.card.no_parallax = true
  G.suitrank.card.shadow = false
  if not G.suitrank.suitconfig then
    G.suitrank.suitconfig = {}
  end
  if not G.suitrank.rankconfig then
    G.suitrank.rankconfig = {}
  end
  recalc_suitrank()

  -- Local helper functions for UI nodes
  local function sr_name(type)
    return {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR, r = 0.2,}, nodes = {
      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.suitrank[type.."config"], ref_value = "name"}}, scale = 0.8, shadow = true, colours = {G.C.WHITE}})}},
    }}
  end
  local function sr_level(type)
    return {n=G.UIT.R, config={align = "cr", colour = G.C.CLEAR}, nodes={
      {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = G.suitrank[type.."config"].level_color, minw = 1.7, outline = 0.8, outline_colour = G.suitrank[type.."config"].outline_color}, nodes={
        {n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "level", scale = 0.5, colour = G.C.UI.TEXT_DARK}}
      }}
    }}
  end
  local function sr_count(type)
    return {{n=G.UIT.C, config={align = "cl"}, nodes={
      {n=G.UIT.T, config={text = '#', scale = 0.45, colour = G.C.WHITE, shadow = true}}
    }},
    {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.suitrank[type.."config"].outline_color,r = 0.1, minw = 0.9}, nodes={
      {n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "count", scale = 0.45, colour = G.suitrank[type.."config"].text_color, shadow = true}},
    }}}
  end

  local function sr_values(type)
    return {n=G.UIT.R, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.03, r = 0.1, colour = G.C.CHIPS, minw = 0.8}, nodes={
        {n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "chips", scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
      }},{n=G.UIT.B, config = {w=0.1,h=0.1}},
      {n=G.UIT.C, config={align = "cm", padding = 0.03, r = 0.1, colour = G.C.MULT, minw = 0.8}, nodes={
        {n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "mult", scale = 0.45, colour = G.C.UI.TEXT_LIGHT}}
      }},
    }}
  end

  local function sr_hand(type)
    return {n=G.UIT.R, config={align = "cm", colour = G.suitrank[type.."config"].color, minw = 7, minh = 2, r = 0.2, outline = 1, outline_colour = G.suitrank[type.."config"].outline_color, padding = 0.3}, nodes = {
      {n = G.UIT.C, config={align = "cl", colour = G.C.CLEAR, r = 0.2, padding = 0.03, minw = 3.5}, nodes = {
        sr_name(type),
        {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR, r = 0.2}, nodes = {
          sr_count(type)[1],
          sr_count(type)[2],
        }}
      }},
      {n = G.UIT.C, config={align = "cr", colour = G.C.CLEAR,  r = 0.2, padding = 0.03, minw = 3.5}, nodes = {
        sr_level(type),
        sr_values(type),
      }},
    }}
  end

  local function sr_card()
    return {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR, }, nodes={
      {n = G.UIT.R, config = {minw=2, minh=1.5, colour = G.C.CLEAR, padding = 0.15, align = "bm"}, nodes = {
        UIBox_button_w_sprite({
          colour = G.C.CLEAR,
          button = "inc_sr_rank",
          sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["jen_jenbuttons"], {x = 0, y = 0}),
          scale = 0.6,
          minw = 1,
        })
      }},
      {n = G.UIT.R, config = {minw=2, minh=1.5, colour = G.C.CLEAR, padding = 0.15}, nodes = {
        {n=G.UIT.C, config={align = "cr", colour = G.C.CLEAR, }, nodes={
          UIBox_button_w_sprite({
            colour = G.C.CLEAR,
            button = "dec_sr_suit",
            sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["jen_jenbuttons"], {x = 3, y = 0}),
            scale = 0.6,
            minw = 1,
          })
        }},
        {n=G.UIT.B, config = {w=0.15,h=0.15}},
        {n=G.UIT.C, config={minw=2.5, align = "cm", colour = G.C.CLEAR, }, nodes={
          {n=G.UIT.O, config={colour = G.C.BLUE, object = G.suitrank.card, hover = false, can_collide = false}},
        }},
        {n=G.UIT.C, config={align = "cl", colour = G.C.CLEAR, }, nodes={
          UIBox_button_w_sprite({
            colour = G.C.CLEAR,
            button = "inc_sr_suit",
            sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["jen_jenbuttons"], {x = 1, y = 0}),
            scale = 0.6,
            minw = 1,
          })
        }},
      }},
      {n = G.UIT.R, config = {minw=2, minh=1.5, colour = G.C.CLEAR, padding = 0.15, align = "tm"}, nodes = {
        UIBox_button_w_sprite({
          colour = G.C.CLEAR,
          button = "dec_sr_rank",
          sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["jen_jenbuttons"], {x = 2, y = 0}),
          scale = 0.6,
          minw = 1,
        })
      }},
    }}
  end

  return {
    n = G.UIT.ROOT,
    config = { align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR },
    nodes = {
      {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, }, nodes={
        sr_card(),
        {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR, minw = 6, padding = 0.3 }, nodes={
          sr_hand("suit"),
          sr_hand("rank"),
        }}
      }}
    }
  }
end

-- Open Suit/Rank UI
G.FUNCS.current_suits_ranks = function(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{definition = ui_suits_ranks()}
end
