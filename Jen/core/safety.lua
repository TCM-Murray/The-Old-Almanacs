function Jen.init_safety_systems()
  -- Set up global lvcol function for Cryptid compatibility
  if not _G.lvcol then
    _G.lvcol = jl.lvcol
  end
  
  -- Initialize hand level color system when game loads
  if G and G.C and G.C.HAND_LEVELS then
    jl.init_hand_level_colors()
  end
  
  -- Initialize Gateway destruction flag for "The Saint" protection
  if G and G.GAME then
    G.GAME.gateway_destroying_jokers = false
  end

  -- Install highlight guard (avoid highlighting non-play cards when extra scoring areas are active)
  if _G.highlight_card and not Jen._wrapped_highlight then
    Jen._wrapped_highlight = true
    local _orig_highlight_card = _G.highlight_card
    _G.highlight_card = function(card, ...)
      local cache = (G and G.GAME and G.GAME._jen_tick_cache) or nil
      local has_extra_scoring = cache and (cache.crimbo or cache.faceless)
        or (next(SMODS.find_card('j_jen_crimbo')) or next(SMODS.find_card('j_jen_faceless')))
      if card and card.area ~= G.play and has_extra_scoring then
        return
      end
      return _orig_highlight_card(card, ...)
    end
  end
  
  -- Initialize Cryptid compatibility functions
  if jl and jl.init_all_cryptid_compat then
    jl.init_all_cryptid_compat()
  end

  -- Ensure Crimbo/Faceless extra scoring cards are injected even without TOML patch
  if SMODS and SMODS.calculate_main_scoring and not Jen._wrapped_calc_main then
    Jen._wrapped_calc_main = true
    local _orig_calc_main = SMODS.calculate_main_scoring
    SMODS.calculate_main_scoring = function(context, scoring_hand)
      local cache = (G and G.GAME and G.GAME._jen_tick_cache) or nil
      local has_extra_scoring = cache and (cache.crimbo or cache.faceless)
        or (next(SMODS.find_card('j_jen_crimbo')) or next(SMODS.find_card('j_jen_faceless')))
      if scoring_hand and has_extra_scoring then
        if not G.GAME._jen_added_crimbo then
          add_crimbo_cards(scoring_hand)
          G.GAME._jen_added_crimbo = true
          Q(function() G.GAME._jen_added_crimbo = nil return true end)
        end
      end
      return _orig_calc_main(context, scoring_hand)
    end
  end

  -- Crash Fix for nil ability on cards
  local function _jen_safe_tostring(v)
    local ok, s = pcall(tostring, v)
    return ok and s or '<unprintable>'
  end

  local function _jen_log_nil_ability(card, ctx)
    pcall(function()
      local area = card and card.area or nil
      local cfg = card and card.config or nil
      local center = cfg and cfg.center or nil
      local id = card and (card.id or card.guid or '<no-id>') or '<no-card>'
      print(('JEN: nil ability found (%s) — id=%s area=%s facing=%s config.center=%s role=%s'):format(
        ctx or '?',
        _jen_safe_tostring(id),
        _jen_safe_tostring(area),
        _jen_safe_tostring(card and card.facing),
        _jen_safe_tostring(center),
        _jen_safe_tostring(card and card.role)
      ))
    end)
  end

  -- Wrap Card.update to ensure ability exists and log when it's missing.
  local _orig_card_update = Card.update
  function Card:update(...)
    if not self then
      return _orig_card_update(self, ...)
    end
    if not self.ability then
      _jen_log_nil_ability(self, 'Card:update')
      self.ability = {}
    end
    return _orig_card_update(self, ...)
  end

  -- Wrap update_alert specifically to avoid crashes and keep existing behavior.
  local _orig_card_update_alert = Card.update_alert
  function Card:update_alert(...)
    if not self or not self.ability then
      if self then _jen_log_nil_ability(self, 'Card:update_alert') end
      return
    end
    return _orig_card_update_alert(self, ...)
  end
end

