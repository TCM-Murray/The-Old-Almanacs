-- Jen Mod Game Hooks
-- Contains game lifecycle hooks and overrides

local CFG = SMODS.current_mod.config

-- Hook into game initialization
local original_game_start_run = Game.start_run
function Game:start_run(args)
  Jen.init_safety_systems()
  -- Initialize Jen game defaults (migrated from lovely.toml patches)
  G.GAME.straddle = G.GAME.straddle or 0
  G.GAME.relief = G.GAME.relief or 0
  G.GAME.tension = G.GAME.tension or 0
  G.GAME.life = G.GAME.life or 100
  G.GAME.max_life = G.GAME.max_life or 100
  G.GAME.shield = G.GAME.shield or 0
  G.GAME.max_shield = G.GAME.max_shield or 0
  G.GAME.straddle_disp = G.GAME.straddle_disp or 0
  G.GAME.life_disp = G.GAME.life_disp or G.GAME.life
  G.GAME.max_life_disp = G.GAME.max_life_disp or G.GAME.max_life
  G.GAME.shield_disp = G.GAME.shield_disp or G.GAME.shield
  G.GAME.max_shield_disp = G.GAME.max_shield_disp or G.GAME.max_shield
  G.GAME.suits = G.GAME.suits or {}
  G.GAME.ranks = G.GAME.ranks or {}
  
  local result = original_game_start_run(self, args)
  
  -- P03 exotic control: check if P03 is in deck and update exotic blacklist
  G.E_MANAGER:add_event(Event({
    func = function()
      if Cryptid and Cryptid.pointerblistifytype then
        local has_p03 = false
        if G and G.jokers and G.jokers.cards then
          for _, card in ipairs(G.jokers.cards) do
            if card and card.config and card.config.center and card.config.center.key == 'j_jen_p03' then
              has_p03 = true
              break
            end
          end
        end
        Cryptid.pointerblistifytype("rarity", "cry_exotic", has_p03)
      end
      return true
    end
  }))
  
  return result
end

-- Wondergeist leveling job processor (global, used by jokers.lua)
function jen_start_wg_job(args)
  G.GAME._wg_jobs = G.GAME._wg_jobs or {}
  local key = tostring(args.hand_key) .. '|' .. tostring(args.op) .. '|' .. tostring(args.operand)
  local job = G.GAME._wg_jobs[key]
  if job then
    job.remaining = job.remaining + args.iterations
    job.total = (job.total or 0) + args.iterations
  else
    job = {
      hand_key = args.hand_key,
      op = args.op,
      operand = args.operand,
      remaining = args.iterations,
      total = args.iterations,
      chips = to_big(G.GAME.hands[args.hand_key].chips),
      mult = to_big(G.GAME.hands[args.hand_key].mult),
      batch_size = args.batch_size or 25,
      card = args.card,
      lv_instant = args.lv_instant,
      label = args.label,
    }
    G.GAME._wg_jobs[key] = job
  end
end

-- Screen wipe init flag: set during start_run to mirror TOML behavior safely
do
  local _orig_start_run = G and G.FUNCS and G.FUNCS.start_run
  if _orig_start_run and not Jen._wrapped_start_run then
    Jen._wrapped_start_run = true
    G.FUNCS.start_run = function(e, args)
      Jen.initialising = true
      local result = _orig_start_run(e, args)
      Q(function() Jen.initialising = nil return true end)
      return result
    end
  end
end

-- Also initialize when cards are first loaded
local original_init_game_object = Game.init_game_object  
function Game:init_game_object()
  local result = original_init_game_object(self)
  Jen.init_safety_systems()
  return result
end

-- UI Safety patch: Prevent UIElement color crashes
local original_uielement_draw_self = UIElement.draw_self
function UIElement:draw_self()
  -- Jen mod safety: ensure colour config is valid before drawing
  if self.config and self.config.colour == nil then
    self.config.colour = jl.safe_color(nil)
  end
  return original_uielement_draw_self(self)
end

-- Replace score intensity earned_score calculation safely (mirrors TOML patch)
local _orig_update_score_intensity = update_score_intensity
function update_score_intensity()
  local bigzero = to_big(0)
  if not G.GAME.blind or to_big(G.GAME.blind.chips or 0) <= bigzero then
    G.ARGS.score_intensity.earned_score = 0
  else
    G.ARGS.score_intensity.earned_score = get_chipmult_sum(G.GAME.current_round.current_hand.chips, G.GAME.current_round.current_hand.mult)
  end
  bigzero = nil
  local ret = _orig_update_score_intensity()
  -- Recalculate ambient and organ fields with OmegaNum safety when enabled
  if Big and Big.arrow and G.GAME.blind and to_big(G.GAME.blind.chips or 0) > to_big(0) then
    local notzero = to_big(G.ARGS.score_intensity.required_score) > to_big(0)
    local e_s = to_big(G.ARGS.score_intensity.earned_score)
    local r_s = to_big(G.ARGS.score_intensity.required_score+1)
    local googol = to_big(1e100)
    local requirement5 = to_big(math.max(math.min(1, 0.1*(math.log(e_s/(r_s:arrow(8, googol)), 5))),0.))
    local requirement4 = to_big(math.max(math.min(1, 0.1*(math.log(e_s/(r_s:arrow(3, googol)), 5))),0.))
    local requirement3 = to_big(math.max(math.min(1, 0.1*(math.log(e_s/(r_s:arrow(2, googol)), 5))),0.))
    local requirement2 = to_big(math.max(math.min(1, 0.1*(math.log(e_s/(r_s^googol), 5))),0.))
    local requirement1 = math.max(math.min(1, 0.1*math.log(e_s/(r_s*1e100), 5)),0.)
    if not G.ARGS.score_intensity.ambientDramatic then G.ARGS.score_intensity.ambientDramatic = 0 end
    if not G.ARGS.score_intensity.ambientSinister then G.ARGS.score_intensity.ambientSinister = 0 end
    if not G.ARGS.score_intensity.ambientSurreal3 then G.ARGS.score_intensity.ambientSurreal3 = 0 end
    if not G.ARGS.score_intensity.ambientSurreal2 then G.ARGS.score_intensity.ambientSurreal2 = 0 end
    if not G.ARGS.score_intensity.ambientSurreal1 then G.ARGS.score_intensity.ambientSurreal1 = 0 end
    G.ARGS.score_intensity.ambientDramatic = notzero and requirement5:to_number() or 0
    G.ARGS.score_intensity.ambientSinister = ((G.ARGS.score_intensity.ambientDramatic or 0) <= 0.05 and notzero) and requirement4:to_number() or 0
    if Jen and type(Jen) == 'table' then
      Jen.dramatic = G.ARGS.score_intensity.ambientDramatic > 0
      Jen.sinister = G.ARGS.score_intensity.ambientSinister > 0 or Jen.dramatic
    end
    G.ARGS.score_intensity.ambientSurreal3 = (not Jen.dramatic and not Jen.sinister) and requirement3:to_number() or 0
    G.ARGS.score_intensity.ambientSurreal2 = ((not Jen.dramatic and not Jen.sinister) and (G.ARGS.score_intensity.ambientSurreal3 or 0) <= 0.05 and notzero) and requirement2:to_number() or 0
    G.ARGS.score_intensity.ambientSurreal1 = ((not Jen.dramatic and not Jen.sinister) and (G.ARGS.score_intensity.ambientSurreal3 or 0) <= 0.05 and (G.ARGS.score_intensity.ambientSurreal2 or 0) <= 0.05 and notzero) and requirement1 or 0
    G.ARGS.score_intensity.organ = (G.video_organ or ((G.ARGS.score_intensity.ambientSurreal3 or 0) <= 0.05 and (G.ARGS.score_intensity.ambientSurreal2 or 0) <= 0.05 and (G.ARGS.score_intensity.ambientSurreal1 or 0) <= 0.05 and notzero)) and math.max(math.min(1, 0.1*math.log(G.ARGS.score_intensity.earned_score/(G.ARGS.score_intensity.required_score+1), 5)),0.) or 0
    notzero = nil
    e_s = nil
    r_s = nil
    googol = nil
    requirement5 = nil
    requirement4 = nil
    requirement3 = nil
    requirement2 = nil
    requirement1 = nil
  end
  return ret
end

-- Hook update_hand_text to ensure hand level colors are initialized
local original_update_hand_text = update_hand_text
function update_hand_text(config, vals)
  -- Ensure hand level colors are properly initialized for big numbers
  if G and G.C and G.C.HAND_LEVELS and not G.C.HAND_LEVELS_JEN_POPULATED then
    jl.init_hand_level_colors()
  end
  return original_update_hand_text(config, vals)
end

-- Win game hook for straddle
local win_game_ref = win_game
function win_game()
  start_straddle()
  win_game_ref()
end

-- Get starting params override
local gsp = get_starting_params
function get_starting_params()
  newTable = gsp()
  newTable.consumable_slots = newTable.consumable_slots + Jen.config.consumable_slot_count_buff
  return newTable
end

-- Eval card override for wee edition
local evalcard_ref = eval_card
function eval_card(card, context)
  if card.playing_card and jl.sc(context) then
    if card.edition and card.edition.jen_wee then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.FILTER})
      card.ability.wee_upgrades = (card.ability.wee_upgrades or 0) + (G.GAME.weeck and 3 or 1)
      card.ability.perma_bonus = (card.ability.perma_bonus or 0) + ((((card.ability.name or '') == 'Stone Card' or card.config.center.no_rank) and 25 or card:get_id() == 2 and 60 or (card:get_id() * 3)) * (G.GAME.weeck and 3 or 1))
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = number_format(card.ability.perma_bonus), colour = G.C.CHIPS})
    end
    if card.gc and card:gc().set == 'Colour' and Jen.hv('colour', 1) then
      trigger_colour_end_of_round(card)
    end
  end
  return evalcard_ref(card, context)
end

-- Card sell override
local scr = Card.sell_card
function Card:sell_card()
  local CEN = self.gc and self:gc()
  if CEN and CEN.set ~= 'Planet' and CEN.key ~= 'c_black_hole' and Jen.hv('astronomy', 5) and not (self.edition or {}).negative and not (self.base or {}).value and not (self.base or {}).suit then
    for i = 1, self:getEvalQty() do
      Q(function()
        local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'astronomy5_planet')
        card2.no_omega = true
        play_sound('jen_draw')
        card2:add_to_deck()
        G.consumeables:emplace(card2)
      return true end)
    end
  end
  if Jen.hv('astronomy', 6) and CEN and not CEN.cant_astronomy then
    local hand = jl.rndhand()
    jl.th(hand)
    fastlv(self, hand, nil, self.sell_cost / 4)
    jl.ch()
  end
  if CEN and (CEN.key == 'j_cry_altgoogol' or CEN.key == 'j_blueprint') then
    for k, v in ipairs(G.jokers.cards) do
      if v.gc and v ~= self then
        local key = v:gc().key
        if key == 'j_cry_altgoogol' or key == 'j_blueprint' or key == 'c_cry_pointer' then
          v:remove_from_deck()
          v.area:remove_card(v)
          Q(function() if v then v:add_to_deck() G.jokers:emplace(v) end return true end, 0.1, nil, 'after')
        end
        key = nil
      end
    end
  end
  if CEN and CEN.set == 'Joker' and #SMODS.find_card('j_jen_amalgam') > 0 and get_kosmos() then
    local rare = tostring(CEN.rarity)
    local value = get_amalgam_value(rare)
    if value and to_big(value) > to_big(0) then
      add_malice(value, nil, true)
    end
  end
  scr(self)
end

function Card:sell_card_jokercalc()
  jl.jokers({selling_card = true, card = self})
  self:sell_card()
end

-- Card draw override for special effects
local random_editions = {
  'foil',
  'holo',
  'polychrome',
  'jen_chromatic',
  'jen_polygloss',
  'jen_gilded',
  'jen_sequin',
  'jen_laminated',
  'jen_ink',
  'jen_prismatic',
  'jen_watered',
  'jen_sepia',
  'jen_reversed',
  'jen_diplopia',
  'cry_gold',
  'cry_mosaic',
  'cry_oversat',
  'cry_astral',
  'cry_blur'
}

local card_draw_ref = Card.draw
function Card:draw(layer)
  local CEN = self.gc and self:gc()
  if CEN then
    self.was_in_pack_area = G.pack_cards and self.area and self.area == G.pack_cards
    if (self.facing or '') == 'front' then
      if self.config then
        local should_scare = not CEN.cant_scare and ((Jen.gods() and CEN.fusable) or Jen.sinister)
        local should_scare2 = not CEN.cant_scare and ((Jen.gods() and CEN.fusable) or Jen.dramatic)
        if CEN.key == 'j_jen_dandy' and math.random(800) == 1 then
          self.dandy_glitch = math.random(10, 80)
          if self.children then
            if self.children.center then
              self.children.center:set_sprite_pos({x = 0, y = 1})
            end
            if self.children.floating_sprite then
              self.children.floating_sprite:set_sprite_pos({x = 1, y = 1})
            end
          end
        elseif self.dandy_glitch then
          if self.dandy_glitch <= 1 then
            if self.children then
              if self.children.center then
                self.children.center:set_sprite_pos({x = 0, y = 0})
              end
              if self.children.floating_sprite then
                self.children.floating_sprite:set_sprite_pos({x = 1, y = 0})
              end
            end
            self.dandy_glitch = nil
          else
            self.dandy_glitch = self.dandy_glitch - 1
          end
        end
        if not CEN.update and self.children.floating_sprite then
          if ((CEN.drama and should_scare2) or (CEN.sinis and should_scare)) and (CEN.sinis or CEN.drama) and not self.in_drama_state then
            self.in_drama_state = true
            self.children.floating_sprite:set_sprite_pos(CEN.drama or CEN.sinis)
          elseif not ((CEN.drama and should_scare2) or (CEN.sinis and should_scare)) and self.in_drama_state then
            self.in_drama_state = nil
            self.children.floating_sprite:set_sprite_pos(CEN.soul_pos)
          end
        end
        if self.in_drama_state then
          self:juice_up(0, math.random()/(Jen.dramatic and 3 or 6))
        end
        if self.area and next(self.area) then
          if self.ability then 
            if CEN.permaeternal and G.jokers and self.area == G.jokers then
              self.ability.eternal = true
            end
            if CEN.debuff_immune or Jen.dandy_active then
              self.ability.perishable = false
              self.ability.perish_tally = 1e9
            end
          end
          if CEN.key == 'c_cry_pointer' and G.hand and self.area == G.hand and not self.lolnocryptidingpointerforyou then
            self.lolnocryptidingpointerforyou = true
            self:destroy()
            local pointer = create_card('Code', G.consumeables, nil, nil, nil, nil, 'c_cry_pointer', 'fuck_cryptiding_pointer_because_there_is_no_need_for_a_budget_creative_mode_please_come_the_fuck_on')
            pointer.no_omega = true
            pointer:add_to_deck()
            G.consumeables:emplace(pointer)
          end
        end
        if CEN.gloss then
          if CEN.gloss_contrast then
            for i = 1, CEN.gloss_contrast do
              self.children.center:draw_shader(type(CEN.gloss) == 'string' and CEN.gloss or 'voucher', nil, self.ARGS.send_to_shader)
            end
          else
            self.children.center:draw_shader(type(CEN.gloss) == 'string' and CEN.gloss or 'voucher', nil, self.ARGS.send_to_shader)
          end
        end
        if (self.added_to_deck or (self.area and self.area == G.hand)) and not self.edition then
          if not CEN.ignore_kudaai and Jen.kudaai_active and (CEN.set ~= 'Booster' or self.area == G.consumeables) and not CEN.cannot_edition then
            self:set_edition({[random_editions[pseudorandom('kudaai_edition', 1, #random_editions)]] = true}, true)
          end
        end
        if Jen.luke_active and self.ability and CEN.key ~= 'j_jen_hunter' and CEN.key ~= 'j_jen_luke' and CEN.set ~= 'jen_ability' then
          self.ability.cry_rigged = true
        end
      end
    else
      if CEN.key == 'c_cry_pointer' and G.hand and self.area == G.hand and not self.lolnocryptidingpointerforyou then
        self.lolnocryptidingpointerforyou = true
        self:destroy()
        local pointer = create_card('Code', G.consumeables, nil, nil, nil, nil, 'c_cry_pointer', 'fuck_cryptiding_pointer_because_there_is_no_need_for_a_budget_creative_mode_please_come_the_fuck_on')
        pointer.no_omega = true
        pointer:add_to_deck()
        G.consumeables:emplace(pointer)
      end
    end
  end
  CEN = nil
  card_draw_ref(self, layer)
end

-- CardArea change_size override
local cacsr = CardArea.change_size
function CardArea:change_size(mod, silent)
  cacsr(self, mod)
  if not silent then self:announce_sizechange(mod) end
end

function CardArea:announce_sizechange(mod, set)
  if (mod or 0) ~= 0 then
    Q(function()
      mod = mod or 0
      local text = 'Max +'
      local col = G.C.GREEN
      if set then
        text = 'Max ='
        col = G.C.FILTER
      elseif mod < 0 then
        text = 'Max -'
        col = G.C.RED
      end
      attention_text({
        text = text..tostring(math.abs(mod)),
        scale = 1, 
        hold = 1,
        cover = self,
        cover_colour = col,
        align = 'cm',
      })
      play_sound('highlight2', 0.715, 0.2)
      play_sound('generic1')
      return true
    end, nil, nil, 'immediate')
    delay(0.5)
  end
end

function CardArea:change_size_absolute(mod, silent)
  self.config.card_limit = self.config.card_limit + (mod or 0)
  if not silent then self:announce_sizechange(mod) end
end

function CardArea:set_size_absolute(mod, silent)
  self.config.card_limit = (mod or self.config.card_limit)
  if not silent then self:announce_sizechange(mod, true) end
end

function CardArea:announce_highlightchange(mod)
  if (mod or 0) ~= 0 then
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
        mod = mod or 0
        local text = 'Highlights +'
        local col = G.C.PURPLE
        if mod < 0 then
          text = 'Highlights -'
          col = G.C.FILTER
        end
        attention_text({
          text = text..tostring(math.abs(mod)),
          scale = 1, 
          hold = 1,
          cover = self,
          cover_colour = col,
          align = 'cm',
        })
        play_sound('highlight2', 0.715, 0.2)
        play_sound('generic1')
        return true
      end
    }))
    delay(0.5)
  end
end

function CardArea:change_max_highlight(mod, silent)
  self.config.highlighted_limit = self.config.highlighted_limit + (mod or 0)
  if not silent then self:announce_highlightchange(mod) end
end

-- Card set_debuff override
local csdr = Card.set_debuff
function Card:set_debuff(should_debuff)
  if self.ability.perishable then
    if not self.ability.perish_tally then self.ability.perish_tally = 5 end
  end
  csdr(self, should_debuff)
end

-- Card calculate_seal override
local cs = Card.calculate_seal
function Card:calculate_seal(context)
  local tbl = cs(self, context)
  if tbl then
    if context.repetition and ((self.ability or {}).set or 'Joker') ~= 'Joker' then
      if self.edition then
        if self.edition.retriggers then
          tbl.repetitions = (tbl.repetitions or 0) + self.edition.retriggers
          tbl.message = tbl.message or localize('k_again_ex')
          tbl.card = tbl.card or self
          return {
            message = localize('k_again_ex'),
            repetitions = self.edition.retriggers,
            card = self
          }
        end
      end
    end
    return tbl
  end
end

-- SMODS create_mod_badges override for Jen badges
local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
  smcmb(obj, badges)
  if obj and obj.misc_badge then
    local calculate_scalefactor = function(text)
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
    local scale_fac = {}
    local scale_fac_len = 1
    if obj.misc_badge and obj.misc_badge.text then
      for i = 1, #obj.misc_badge.text do
        local calced_scale = calculate_scalefactor(obj.misc_badge.text[i])
        scale_fac[i] = calced_scale
        scale_fac_len = math.min(scale_fac_len, calced_scale)
      end
    end
    local ct = {}
    for i = 1, #obj.misc_badge.text do
      ct[i] = {
        string = obj.misc_badge.text[i]
      }
    end
    badges[#badges + 1] = {
      n = G.UIT.R,
      config = { align = "cm" },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = "cm",
            colour = obj.misc_badge and obj.misc_badge.colour or G.C.RED,
            r = 0.1,
            minw = 2/scale_fac_len,
            minh = 0.36,
            emboss = 0.05,
            padding = 0.03 * 0.9,
          },
          nodes = {
            { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
            {
              n = G.UIT.O,
              config = {
                object = DynaText({
                  string = ct or "ERROR",
                  colours = { obj.misc_badge and obj.misc_badge.text_colour or G.C.WHITE },
                  silent = true,
                  float = true,
                  shadow = true,
                  offset_y = -0.03,
                  spacing = 1,
                  scale = 0.33 * 0.9,
                }),
              },
            },
            { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
          },
        },
      },
    }
  end
  if obj then
    for k, v in pairs(Jen.modifierbadges) do
      if obj[k] then
        local calculate_scalefactor = function(text)
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
        local scale_fac = {}
        local scale_fac_len = 1
        if v.text then
          for i = 1, #v.text do
            local calced_scale = calculate_scalefactor(v.text[i])
            scale_fac[i] = calced_scale
            scale_fac_len = math.min(scale_fac_len, calced_scale)
          end
        end
        local ct = {}
        for i = 1, #v.text do
          ct[i] = {
            string = v.text[i]
          }
        end
        badges[#badges + 1] = {
          n = G.UIT.R,
          config = { align = "cm" },
          nodes = {
            {
              n = G.UIT.R,
              config = {
                align = "cm",
                colour = v and v.col or G.C.RED,
                r = 0.1,
                minw = 2/scale_fac_len,
                minh = 0.36,
                emboss = 0.05,
                padding = 0.03 * 0.9,
              },
              nodes = {
                { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                {
                  n = G.UIT.O,
                  config = {
                    object = DynaText({
                      string = ct or "ERROR",
                      colours = { v and v.tcol or G.C.WHITE },
                      silent = true,
                      float = true,
                      shadow = true,
                      offset_y = -0.03,
                      spacing = 1,
                      scale = 0.33 * 0.9,
                    }),
                  },
                },
                { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
              },
            },
          },
        }
      end
    end
  end
end

-- Blind disable override
local disblref = Blind.disable
function Blind:disable()
  local obj = self.config.blind
  if obj then
    if obj.immunity then
      play_sound('cancel', 0.8, 1)
      jl.a(obj.immunity_quote or 'Blind is immune!', G.SETTINGS.GAMESPEED * 2, 0.8, obj.boss_colour or G.C.RED)
      G.GAME.blind:wiggle()
      return true
    end
  end
  return disblref(self)
end

-- Reroll boss override
local gfrb = G.FUNCS.reroll_boss
G.FUNCS.reroll_boss = function(e)
  local obj = G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss]
  if obj.boss.epic then
    play_sound('cancel', 0.8, 1)
    jl.a(localize('k_nope_ex'), G.SETTINGS.GAMESPEED * 2, 0.8, obj.boss_colour or G.C.RED)
  else
    return gfrb(e)
  end
end

-- Override ease_ante
local vanilla_ease_ante = ease_ante

-- Initialize crash monitoring system from JenLib
if jl and jl.crash_monitor then
  jl.crash_monitor:setup()
else
  print("[JEN WARNING] JenLib crash monitoring not available - falling back to basic monitoring")
end

-- Override the global ease_ante function to ensure ALL calls go through our version
_G.ease_ante = function(mod, no_straddle, no_ante_boost, safe_rewind)
  -- Always log when our function is called
  -- Store original mod for vanilla function call to prevent crashes from astronomical values
  local original_mod = mod
  local total_mod = mod  -- This will be the total including straddle bonus
  
  if mod > 0 then
    if G.GAME.tortoise then
      mod = mod / 2
    end
    -- Safety check for ante-based malice calculations to prevent Event Manager overflow
    -- This doesn't limit the final malice value, just prevents overwhelming the event system
    local malice_mod = mod
    if malice_mod > 100 then
      malice_mod = 100  -- Cap the exponent to prevent Event Manager crashes
    end
    add_malice(to_big(Jen.config.malice_base / 8) * (to_big(Jen.config.malice_increase) ^ malice_mod))
  end
  if Jen.config.straddle.enabled then
    if mod < 0 and not safe_rewind then
      G.GAME.cumulative_ante_rewind = (G.GAME.cumulative_ante_rewind or 0) + mod
    end
    if G.GAME.straddle_active and mod > 0 and not no_ante_boost then
      local straddle_bonus = (G.GAME.tortoise and (G.GAME.straddle / 2) or G.GAME.straddle)
      mod = mod + straddle_bonus
      total_mod = total_mod + straddle_bonus  -- Add straddle bonus to total for vanilla function
    elseif not no_straddle and not G.GAME.straddle_active and ((G.GAME.round_resets.ante + mod) < 0 or (G.GAME.cumulative_ante_rewind or 0) > Jen.config.ante_threshold) then
      start_straddle()
    end
  end
  
  -- Cap the mod passed to vanilla function to prevent crashes from astronomical values
  local safe_mod = total_mod  -- Use total_mod (including straddle bonus) instead of original_mod
  if math.abs(safe_mod) > 1000 then
    safe_mod = safe_mod > 0 and 1000 or -1000
  end
  
  -- Safely call the vanilla function with error handling
  local success, error_msg = pcall(function()
    vanilla_ease_ante(safe_mod)
  end)
  if not success then
    print("[JEN ERROR] Vanilla ease_ante crashed:", tostring(error_msg))
    -- Fallback: manually increment the Ante if vanilla function fails
    G.GAME.round_resets.ante = G.GAME.round_resets.ante + safe_mod
  end
  if jl.invalid_number(G.GAME.round_resets.ante) then
    G.GAME.round_resets.ante = maxfloat
  end
  local ANTE = G.GAME.round_resets.ante
  
  -- Ultra-aggressive memory management: process straddle immediately and force cleanup
  Q(function()
    -- Force immediate memory cleanup before heavy operations
    collectgarbage("collect")
    
    if Jen.config.straddle.enabled and G.GAME.straddle_active and mod ~= 0 and not no_straddle then
      if math.ceil(mod) > 1 then mod = mod - G.GAME.straddle end
      local add = (math.abs(mod) * (Jen.config.straddle.acceleration and math.ceil(math.max(1, (G.GAME.straddle - (Jen.config.straddle.progress_max ^ 2))) / Jen.config.straddle.progress_increment) or 1) * (mod < 0 and Jen.config.straddle.backwards_mod or 1))
      if ANTE < 0 then
        add = add + math.ceil(math.abs(ANTE) ^ 2)
      end
      if G.GAME.nitro then add = add * Jen.config.straddle.progress_min end
      add = math.min(add, 9e15)
      
      -- Process straddle with additional safety
      local success, error_msg = pcall(function()
        progress_straddle(add)
      end)
      if not success then
        print("[JEN ERROR] progress_straddle crashed:", tostring(error_msg))
      end
    end 
    
    -- Force aggressive memory cleanup after heavy operation
    collectgarbage("collect")
    collectgarbage("collect")  -- Double cleanup for safety
    return true
  end, 0.05, nil, 'immediate')  -- Even faster processing
  
  -- Memory-efficient: update blind_ante immediately instead of scheduling event
  G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante
  
  -- Emergency memory cleanup and monitoring
  local memory_before = collectgarbage("count")
  if memory_before > 100000 then  -- If memory usage > 100MB
    print("[JEN WARNING] High memory usage detected:", math.floor(memory_before/1024), "KB")
    -- Force aggressive cleanup
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    local memory_after = collectgarbage("count")
    print("[JEN INFO] Memory cleaned up:", math.floor((memory_before - memory_after)/1024), "KB")
  end
  
  -- Schedule periodic memory cleanup to prevent future crashes
  Q(function()
    collectgarbage("collect")
    return true
  end, 1.0, nil, 'after')  -- Clean up every second
  
  -- Event Manager protection: limit event queue size
  if G.E_MANAGER and G.E_MANAGER.event_queue then
    local queue_size = #G.E_MANAGER.event_queue
    if queue_size > 1000 then  -- If event queue gets too large
      print("[JEN WARNING] Large event queue detected:", queue_size, "events - forcing cleanup!")
      -- Force process some events to reduce queue
      for i = 1, math.min(100, queue_size) do
        if G.E_MANAGER.event_queue[1] then
          table.remove(G.E_MANAGER.event_queue, 1)
        end
      end
      print("[JEN INFO] Event queue reduced to:", #G.E_MANAGER.event_queue, "events")
    end
  end
end

-- Real-time crash handler monitoring
local crash_monitor_active = false
local function start_crash_monitoring()
  if crash_monitor_active then return end
  crash_monitor_active = true
  
  print("[JEN DEBUG] 🔍 Starting real-time crash handler monitoring...")
  
  -- Monitor every frame for crash handler activation
  Q(function()
    -- Check if we're in a crash state
    if G and G.E_MANAGER then
      local memory = collectgarbage("count")
      if memory > 200000 then  -- If memory spikes above 200MB
        print("[JEN DEBUG] 🚨 HIGH MEMORY SPIKE DETECTED!")
        print("[JEN DEBUG] 💾 Current memory:", memory, "KB")
        print("[JEN DEBUG] 🕒 Time:", os.date("%H:%M:%S"))
        print("[JEN DEBUG] ⚠️ Crash handler may activate soon...")
      end
    end
    return true
  end, 0.1, nil, 'after')  -- Check every 0.1 seconds
end

-- Start crash monitoring after a delay
Q(function()
  start_crash_monitoring()
  return true
end, 3.0, nil, 'after')  -- Start after 3 seconds

-- Initialize Maxie things
local maxie_desc = {
  'Create {C:attention}2 {C:green}random {C:attention}Boosters{}, and a fixed',
  '{C:green}~15% chance{} to also create a {C:green}random {C:attention}Voucher',
  'whenever you use any {C:attention}non-{C:dark_edition}Negative{}',
  ''
}

local maxie_consumables = {
  Temperance = 'c_temperance',
  ['The Hermit'] = 'c_hermit',
  ['The Magician'] = 'c_magician',
  ['The Centurion'] = 'c_jen_centurion',
  Enceladus = 'c_jen_enceladus',
  Cryptid = 'c_cryptid',
  Infirmity = 'c_jen_reverse_strength',
  ['The Low Laywoman'] = 'c_jen_reverse_high_priestess',
  Cunctation = 'c_jen_reverse_judgement'
}

local maxie_added = 0
local misc_done = false

-- Game update override
local game_updateref = Game.update
function Game:update(dt)
  -- Safely wrap the original update call to prevent crashes
  local success, error_msg = pcall(function()
    -- Per-tick memo: cache expensive find_card scans used multiple times this frame
    G.GAME._jen_tick_cache = G.GAME._jen_tick_cache or {}
    local cache = G.GAME._jen_tick_cache
    cache.faceless = cache.faceless or (next(SMODS.find_card('j_jen_faceless')) and true or false)
    cache.crimbo = cache.crimbo or (next(SMODS.find_card('j_jen_crimbo')) and true or false)
    cache.kudaai_or_foundry = cache.kudaai_or_foundry or ((#SMODS.find_card('j_jen_kudaai') + #SMODS.find_card('j_jen_foundry')) > 0)
    cache.bulwark_count = cache.bulwark_count or #SMODS.find_card('j_jen_bulwark')
    -- Process Wondergeist jobs if queued
    if G.GAME._wg_jobs then
      for k, job in pairs(G.GAME._wg_jobs) do
        if (job.remaining or 0) > 0 then
          local handstats = G.GAME.hands[job.hand_key]
          local cnt = math.min(job.batch_size, job.remaining)
          
          -- Optimized batch processing for better performance
          if cnt > 10 then
            -- For large batches, use exponential operations when possible
            if job.op == 2 and job.operand == 2 then
              -- ^^2 operation: use power of 2 for large batches
              local power = math.min(cnt, 100) -- Cap at reasonable power
              job.chips = job.chips:arrow(2, 2):arrow(2, power - 1)
              job.mult = job.mult:arrow(2, 2):arrow(2, power - 1)
              job.remaining = job.remaining - power
            elseif job.op == 3 and job.operand == 3 then
              -- ^^^3 operation: use power of 3 for large batches
              local power = math.min(cnt, 50) -- Cap at reasonable power for ^^^3
              job.chips = job.chips:arrow(3, 3):arrow(3, power - 1)
              job.mult = job.mult:arrow(3, 3):arrow(3, power - 1)
              job.remaining = job.remaining - power
            else
              -- Fallback to regular batch processing
              for i = 1, cnt do
                job.chips = job.chips:arrow(job.op, job.operand)
                job.mult = job.mult:arrow(job.op, job.operand)
              end
              job.remaining = job.remaining - cnt
            end
          else
            -- For small batches, use regular processing
            for i = 1, cnt do
              job.chips = job.chips:arrow(job.op, job.operand)
              job.mult = job.mult:arrow(job.op, job.operand)
            end
            job.remaining = job.remaining - cnt
          end
          
          handstats.chips = job.chips
          handstats.mult = job.mult
          if job.remaining <= 0 then
            if not job.lv_instant and job.card and job.label then
              delay(0.5)
              Q(function() job.card:juice_up(job.op - 1, job.op - 1) return true end)
              if job.op == 2 then
                play_sound_q('talisman_eechip'); play_sound_q('talisman_eemult')
              else
                play_sound_q('talisman_eeechip'); play_sound_q('talisman_eeemult')
              end
              jl.hcm(job.label .. ' (x' .. tostring(job.total or 0) .. ')', job.label .. ' (x' .. tostring(job.total or 0) .. ')', true)
              jl.hcm(handstats.chips, handstats.mult)
              delay(0.5)
            end
            G.GAME._wg_jobs[k] = nil
          end
        end
      end
    end
    if not Jen.bans_done then
      init_cardbans()
      Jen.bans_done = true
    end
    if not misc_done then
      if G.P_CENTERS.j_jen_maxie then
        for k, v in pairs(maxie_consumables) do
          local cen = G.P_CENTERS[v]
          if cen and Jen.config.disable_bans or (not jl.bf(v, Jen.config.bans) and not jl.bf('!' .. v, Jen.config.bans)) then
            if maxie_added >= 3 then
              maxie_desc[#maxie_desc] = maxie_desc[#maxie_desc] .. ','
              maxie_desc[#maxie_desc + 1] = ''
              maxie_added = 0
            end
            if maxie_desc[#maxie_desc] ~= '' then
              maxie_desc[#maxie_desc] = maxie_desc[#maxie_desc] .. ', {C:' .. string.lower(cen.set) .. '}' .. k .. '{}'
            else
              maxie_desc[#maxie_desc] = '{C:' .. string.lower(cen.set) .. '}' .. k .. '{}'
            end
            maxie_added = maxie_added + 1
          end
        end
        maxie_desc[#maxie_desc + 1] = ' '
        maxie_desc[#maxie_desc + 1] = caption('#1#')
        maxie_desc[#maxie_desc + 1] = faceart('Maxie')
        G.P_CENTERS.j_jen_maxie.loc_txt.text = maxie_desc
        init_localization()
      end
      G.P_CENTERS.c_soul.fusable = true
      G.P_CENTERS.c_black_hole.fusable = true
      if G.P_CENTERS.c_cry_white_hole then G.P_CENTERS.c_cry_white_hole.fusable = true end
      misc_done = true
    end
  end)
  
  if not success then

  end
  
  -- Always call the original update, even if our stuff failed
  game_updateref(self, dt)
  if G.ARGS.LOC_COLOURS then
  
    if not Jen.initialised_locale_colours then
      for k, v in pairs(Jen.locale_colours) do
        G.ARGS.LOC_COLOURS[k] = HEX(v)
        self.C[k] = HEX(v)
        Jen.initialised_locale_colours = true
      end
    end

    local r, g, b = hsv(self.C.jen_RGB_HUE / 360, .5, 1)

    self.C.jen_RGB[1] = r
    self.C.jen_RGB[3] = g
    self.C.jen_RGB[2] = b

    self.C.jen_RGB_HUE = (self.C.jen_RGB_HUE + 0.5) % 360
    G.ARGS.LOC_COLOURS.jen_RGB = self.C.jen_RGB
    
  end
  if G.GAME then
    if G.ARGS.score_intensity.earned_score then
      if not to_big(G.ARGS.score_intensity.earned_score):isFinite() then
        G.ARGS.score_intensity.earned_score = to_big(G.ARGS.score_intensity.required_score)
      end
    end
    if not Jen.config.disable_bans and G.GAME.banned_keys then
      for k, v in ipairs(Jen.config.bans) do
        if string.sub(v, 1, 1) == '!' then
          G.GAME.banned_keys[string.sub(v, 2, string.len(v))] = true
        else
          G.GAME.banned_keys[v] = true
        end
      end
    end
    if G.GAME.modifiers then
      if not G.GAME.modifiers.jen_initialise_buffs then
        G.GAME.modifiers.jen_initialise_buffs = true
        G.GAME.modifiers.cry_booster_packs = (G.GAME.modifiers.cry_booster_packs or 2) + Jen.config.shop_booster_pack_count_buff
        change_shop_size(Jen.config.shop_size_buff)
        SMODS.change_voucher_limit(Jen.config.shop_voucher_count_buff)
      end
    end
    if G.GAME.orrery then
      local reference = ''
      local should_rebalance = false
      for k, v in pairs(G.GAME.hands) do
        if k ~= 'cry_WholeDeck' then
          if reference == '' then
            reference = k
          elseif v.chips ~= G.GAME.hands[reference].chips or v.mult ~= G.GAME.hands[reference].mult or v.level ~= G.GAME.hands[reference].level then
            should_rebalance = true
            break
          end
        end
      end
      if should_rebalance then
        local handcount = (#G.handlist - 1)
        local pools = {
          chips = to_big(0),
          mult = to_big(0),
          level = 0
        }
        for k, v in pairs(G.GAME.hands) do
          if k ~= 'cry_WholeDeck' then
            pools.chips = pools.chips + v.chips
            pools.mult = pools.mult + v.mult
            pools.level = pools.level + v.level
          end
        end
        for k, v in pairs(G.GAME.hands) do
          if k ~= 'cry_WholeDeck' then
            v.chips = pools.chips / handcount
            v.mult = pools.mult / handcount
            v.level = pools.level / handcount
          end
        end
        jl.h(localize('k_all_hands'), pools.chips / handcount, pools.mult / handcount, pools.level / handcount)
        delay(1)
        jl.ch()
      end
    end
    Jen.kudaai_active = (#SMODS.find_card('j_jen_kudaai') + #SMODS.find_card('j_jen_foundry')) > 0
    Jen.luke_active = #SMODS.find_card('j_jen_luke') > 0
    Jen.dandy_active = #SMODS.find_card('j_jen_dandy') > 0
    
    -- Ensure Gateway destruction flag is properly initialized
    if G.GAME.gateway_destroying_jokers == nil then
      G.GAME.gateway_destroying_jokers = false
    end
    
    Jen.should_play_extraordinary = #Cryptid.advanced_find_joker(nil, "jen_extraordinary", nil, nil, true) ~= 0 or get_kosmos() or #Cryptid.advanced_find_joker(nil, "jen_transcendent", nil, nil, true) ~= 0 or #Cryptid.advanced_find_joker(nil, "jen_omegatranscendent", nil, nil, true) ~= 0
    Jen.should_play_wondrous = not Jen.should_play_extraordinary and #Cryptid.advanced_find_joker(nil, "jen_wondrous", nil, nil, true) ~= 0
  end
end

-- Main menu override
local edited_default_colours = false
local mainmenuref = Game.main_menu
Game.main_menu = function(change_context)
  if not edited_default_colours then
    for i = 1, 7 do manage_level_colour(i, true) end
    edited_default_colours = true
  end
  --if not G.PROFILES[G.SETTINGS.profile].all_unlocked then
    G.PROFILES[G.SETTINGS.profile].all_unlocked = true
    for k, v in pairs(G.P_CENTERS) do
      if not v.demo and not v.wip then 
      v.alerted = true
      v.discovered = true
      v.unlocked = true
      end
    end
    for k, v in pairs(G.P_BLINDS) do
      if not v.demo and not v.wip then 
      v.alerted = true
      v.discovered = true
      v.unlocked = true
      end
    end
    for k, v in pairs(G.P_TAGS) do
      if not v.demo and not v.wip then 
      v.alerted = true
      v.discovered = true
      v.unlocked = true
      end
    end
    set_profile_progress()
    set_discover_tallies()
    G:save_progress()
    G.FILE_HANDLER.force = true
  --end
  local ret = mainmenuref(change_context)
  local newcard = create_card("Joker", G.title_top, nil, nil, nil, nil, "j_jen_jen", "almanac_title")
  G.title_top:emplace(newcard)
  newcard:start_materialize()
  newcard:resize(1.1 * 1.2)
  newcard.no_ui = true
  -- make the title screen use different background colors
  G.SPLASH_BACK:define_draw_steps({
    {
      shader = "splash",
      send = {
        { name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
        { name = "vort_speed", val = 0.4 },
        { name = "colour_1", ref_table = G.C, ref_value = "CRY_TWILIGHT" },
        { name = "colour_2", ref_table = G.C, ref_value = "CRY_EMBER" },
      },
    },
  })
  Jen.dramatic = false
  Jen.sinister = false
  return ret
end

-- Aurinko Addons
AurinkoAddons.jen_wee = function(card, hand, instant, amount)
  if card and not card.playing_card then
    local twos = {}
    local editioned_twos = {}
    for k, v in pairs(G.playing_cards) do
      if v:get_id() == 2 then
        table.insert(v.edition and editioned_twos or twos, v)
      end
    end
    if #twos > 0 or #editioned_twos > 0 then
      if not card.already_announced_message then
        card.already_announced_message = true
        Q(function()
          play_sound('gong', 0.94, 0.3)
          play_sound('gong', 0.94*1.5, 0.2)
          play_sound('tarot1', 1.5)
        return true end)
        jl.a(#twos + #editioned_twos .. 'x Twos', G.SETTINGS.GAMESPEED, 1.4, G.C.GREEN)
        jl.rd(1)
        QR(function() if card then card.already_announced_message = nil end return true end, 3)
      end
      if #twos > 0 then
        level_up_hand(nil, hand, true, #twos * amount, true, true, true)
      end
      for k, two in pairs(editioned_twos) do
        level_up_hand(two, hand, true, amount, true, true, true)
      end
      Q(function() twos = nil;editioned_twos = nil;return true end)
    end
  end
end

AurinkoAddons.jen_jumbo = function(card, hand, instant, amount)
  if card and not card.playing_card then
    local akqjs = {}
    local editioned_akqjs = {}
    for k, v in pairs(G.playing_cards) do
      if v:get_id() > 10 then
        table.insert(v.edition and editioned_akqjs or akqjs, v)
      end
    end
    if #akqjs > 0 or #editioned_akqjs > 0 then
      if not card.already_announced_message then
        card.already_announced_message = true
        Q(function()
          play_sound('gong', 0.94, 0.3)
          play_sound('gong', 0.94*1.5, 0.2)
          play_sound('tarot1', 1.5)
        return true end)
        jl.a(#akqjs + #editioned_akqjs .. 'x AKQJs', G.SETTINGS.GAMESPEED, 1.4, G.C.GREEN)
        jl.rd(1)
        QR(function() if card then card.already_announced_message = nil end return true end, 3)
      end
      if #akqjs > 0 then
        level_up_hand(nil, hand, true, #akqjs * amount, true, true, true)
      end
      for k, akqj in pairs(editioned_akqjs) do
        level_up_hand(akqj, hand, true, amount, true, true, true)
      end
      Q(function() akqjs = nil;editioned_akqjs = nil;return true end)
    end
  end
end

local caer = CardArea.emplace

function CardArea:emplace(card, location, stay_flipped)
	if G.jokers and G.hand and G.deck and G.consumeables and (self == G.jokers or self == G.hand or self == G.deck or self == G.consumeables) and G.GAME.mysterious and card.ability and not card.ability.mysterious_created and not card.created_from_split then
		card.ability.mysterious_created = true
		local cen = card.gc and card:gc()
		if cen and not cen.no_mysterious then
			--Q(function()
			if self == G.jokers then
				Q(function()
					if card then
						if card.added_to_deck then
							card:remove_from_deck()
							card.added_to_deck = nil
						end
						card:flip()
						card:juice_up(0.3, 0.3)
						play_sound('card1', 1, 0.6)
					end
				return true end, 1.5)
				delay(1.5)
				Q(function()
					if card then
						card:flip()
						card:juice_up(0.3, 0.3)
						play_sound('card3', 1, 0.6)
						card:set_ability(jl.rnd('mysterious_deck_joker', {'no_mysterious'}, G.P_CENTER_POOLS.Joker))
						if not card.added_to_deck then
							card:add_to_deck()
							Q(function()
								if card then
									local newcen = card.gc and card:gc()
									if newcen then
										if newcen.abilitycard and #SMODS.find_card(newcen.abilitycard) <= 0 then
											Q(function()
												local traysize = G.consumeables.config.card_limit + 1
												G.consumeables.config.card_limit = #G.consumeables.cards + 1
												local abi = create_card('jen_ability', G.consumeables, nil, nil, nil, nil, newcen.abilitycard, nil)
												abi.no_forced_edition = true
												abi:add_to_deck()
												G.consumeables:emplace(abi)
												abi.ability.eternal = true
												G.consumeables.config.card_limit = traysize
												Q(function() if abi then check_ability_card_validity(abi) end return true end)
											return true end)
										end
									end
								end
							return true end)
						end
					end
				return true end, 1.5)
			elseif self == G.consumeables and cen.set ~= 'jen_ability' then
				Q(function()
					if card then
						if card.added_to_deck then
							card:remove_from_deck()
							card.added_to_deck = nil
						end
						card:flip()
						card:juice_up(0.3, 0.3)
						play_sound('card1', 1, 0.6)
					end
				return true end, 1.5)
				delay(1.5)
				Q(function()
					if card then
						card:flip()
						card:juice_up(0.3, 0.3)
						play_sound('card3', 1, 0.6)
						card:set_ability(jl.rnd('mysterious_deck_consumable', cen.hidden and {'no_doe', 'no_grc'} or {'hidden', 'no_doe', 'no_grc'}, G.P_CENTER_POOLS[cen.set]))
						if not card.added_to_deck then
							card:add_to_deck()
						end
					end
				return true end, 1.5)
			elseif (card.base or {}).value or (card.base or {}).suit then
				jl.randomise({card})
			end
			--return true end)
			--delay(1)
		end
		Q(function() if card and self then caer(self, card, location, stay_flipped) end return true end)
	else
		caer(self, card, location, stay_flipped)
	end
end

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
	local cen = self.gc and self:gc()
    if not from_debuff then
		if cen then
			if cen.unique then
				for k, v in ipairs(G.jokers.cards) do
					if v ~= self and v:gc().key == cen.key then
						ease_dollars(self.sell_cost or 0)
						self:destroy()
						return --blocked
					end
				end
			end
			if not G.GAME.mysterious and G.consumeables and cen and cen.abilitycard and type(cen.abilitycard) == 'string' and #SMODS.find_card(cen.abilitycard) <= 0 then
				Q(function()
					if #SMODS.find_card(cen.abilitycard) <= 0 then
						local traysize = G.consumeables.config.card_limit + 1
						G.consumeables.config.card_limit = #G.consumeables.cards + 1
						local abi = create_card('jen_ability', G.consumeables, nil, nil, nil, nil, cen.abilitycard, nil)
						abi.no_forced_edition = true
						abi:add_to_deck()
						G.consumeables:emplace(abi)
						abi.ability.eternal = true
						G.consumeables.config.card_limit = traysize
						Q(function() if abi then check_ability_card_validity(abi) end return true end)
					end
				return true end)
			end
			if G.consumeables and cen and cen.fusable and #SMODS.find_card('c_jen_fuse') <= 0 then
				local traysize = G.consumeables.config.card_limit + 1
				G.consumeables.config.card_limit = #G.consumeables.cards + 1
				local abi = create_card('jen_ability', G.consumeables, nil, nil, nil, nil, 'c_jen_fuse', nil)
				abi.no_forced_edition = true
				abi:add_to_deck()
				G.consumeables:emplace(abi)
				abi.ability.eternal = true
				G.consumeables.config.card_limit = traysize
			end
			if cen.set == 'Colour' and Jen.hv('colour', 13) then
				n_random_colour_rounds(math.max(0, self.ability.partial_rounds or 0))
				for k, v in ipairs(G.consumeables.cards) do
					if v:gc().set == 'Colour' then
						for i = 1, math.ceil(math.max(self.ability.upgrade_rounds or 1, 1) / 2) do
							trigger_colour_end_of_round(v)
						end
					end
				end
				for k, v in ipairs(G.consumeables.cards) do
					if v:gc().set == 'Colour' then
						for i = 1, (math.max(self.ability.upgrade_rounds or 1, 1) + math.max(self.ability.partial_rounds or 0, 0)) * 3 * math.max(self.ability.partial_rounds or 1, 1) * math.max(self.ability.upgrade_rounds or 1, 1) do
							trigger_colour_end_of_round(v)
						end
					end
				end
				local no_colours = 1
				for k, v in ipairs(G.consumeables.cards) do
					if v:gc().set == 'Colour' then
						no_colours = no_colours + 1
					end
				end
				for k, v in ipairs(G.consumeables.cards) do
					if v:gc().set == 'Colour' then
						for i = 1, math.min(1e5, math.ceil(((math.max(self.ability.upgrade_rounds or 1, 1) + math.max(self.ability.partial_rounds or 0, 0) + 1) * (math.max(v.ability.upgrade_rounds or 1, 1) + math.max(v.ability.partial_rounds or 0, 0) + 1)) * (((self.ability.val or 0) + 1)^math.min(1.5, (1 + (no_colours/20)))))) do
							trigger_colour_end_of_round(v)
						end
					end
				end
				self:blackhole(((self.ability.partial_rounds or 0) * 0.5) + ((self.ability.upgrade_rounds or 0) * 0.25) + ((self.ability.val or 0) * ((self.ability.upgrade_rounds or 0) * 5)))
			end
		end
        jl.jokers({jen_adding_card = true, card = self})
	elseif cen then
		if cen.unique then
			for k, v in ipairs(G.jokers.cards) do
				if v ~= self and v:gc().key == cen.key then
					ease_dollars(self.sell_cost or 0)
					self:destroy()
					return --blocked
				end
			end
		end
    end
    add_to_deckref(self, from_debuff)
	if cen then
		if cen.unique then
			QR(function()
				if self then
					for k, v in ipairs(G.jokers.cards) do
						if v ~= self and v:gc().key == cen.key then
							ease_dollars(self.sell_cost or 0)
							self:remove_from_deck()
							self:destroy()
							self = nil
							break
						end
					end
				end
			return true end, 199)
		end
	end
end

function check_ability_card_validity(card)
	if not card or not G.jokers then return end
	local cen = card.gc and card:gc()
	if not cen then return end
	local should_remove = true
	for i = 1, #G.jokers.cards do
		local cur = G.jokers.cards[i]
		local curcen = cur.gc and cur:gc()
		if curcen then
			if (curcen.abilitycard or 'n/a') == cen.key then
				should_remove = false
				break
			end
		end
	end
	if should_remove then
		for k, v in pairs(SMODS.find_card(cen.key, true)) do
			if not (v.edition or {}).negative then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
			end
			v.no_malice = true
			v:destroy()
		end
	end
end

local rfd = Card.remove_from_deck
function Card.remove_from_deck(self, from_debuff)
	if G.jokers and G.consumeables then
		if self.added_to_deck and self.config and self.gc and self:gc() and self:gc().abilitycard and type(self:gc().abilitycard) == 'string' then
			local cen = self:gc()
			Q(function()
				if #SMODS.find_card(cen.key, true) <= 0 then
					for k, v in pairs(SMODS.find_card(cen.abilitycard)) do
						check_ability_card_validity(v)
					end
				end
			return true end)
		end
		if self.added_to_deck and self.config and self.gc and self:gc() and self:gc().fusable then
			local can_still_fuse = false
			for k, v in ipairs(G.jokers.cards) do
				if v.gc and v:gc().fusable then
					can_still_fuse = true
					break
				end
			end
			if not can_still_fuse then
				for k, v in ipairs(G.consumeables.cards) do
					if v.gc and v:gc().fusable then
						can_still_fuse = true
						break
					end
				end
			end
			if not can_still_fuse then
				for k, v in pairs(SMODS.find_card('c_jen_fuse')) do
					if not (v.edition or {}).negative then
						G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
					end
					v:destroy()
				end
			end
		end
	end
	rfd(self, from_debuff)
end

local ten = to_big(10)
local gbar = get_blind_amount
local defaultblindsize = to_big(100)
function get_blind_amount(ante)
	-- Ensure we operate on a primitive number for the base game function to avoid table< comparisons
	ante = to_number(ante)
	local amnt
	if math.floor(ante) ~= ante then
		-- fractional ante interpolation (proper fractional part)
		local frac = ante - math.floor(ante)
		local lower, upper = math.floor(ante), math.ceil(ante)
		-- delegate to original function with numeric args only
		local lower_amt = gbar(lower)
		local upper_amt = gbar(upper)
		amnt = (lower_amt * (1 - frac)) + (upper_amt * frac)
	else
		amnt = gbar(ante)
	end
	local overante = math.max(0, ante - Jen.config.ante_threshold)
	if not amnt then amnt = defaultblindsize end
	if type(amnt) ~= 'table' then amnt = to_big(amnt) end
	if overante > 0 then
		local scalar = Jen.blind_scalar[math.min(overante, #Jen.blind_scalar)] or 1
		amnt = amnt * scalar
		-- If the amount has already blown up to an invalid/infinite value, cap and exit early
		if jl.invalid_number(number_format(amnt)) then return to_big(maxfloat) end
		if overante >= Jen.config.ante_pow10_4 then
			amnt = ten^ten^ten^ten^amnt
		elseif overante >= Jen.config.ante_pow10_3 then
			amnt = ten^ten^ten^amnt
		elseif overante >= Jen.config.ante_pow10_2 then
			amnt = ten^ten^amnt
		elseif overante >= Jen.config.ante_pow10 then
			amnt = ten^amnt
		end
		-- Recheck after exponentiation to avoid unsafe arrow operations on NaN/Infinity
		if jl.invalid_number(number_format(amnt)) then return to_big(maxfloat) end
		if overante >= Jen.config.ante_exponentiate then
			amnt = amnt ^ amnt
		end
		-- Only apply arrow operations if value remains valid; recheck before each step
		if overante >= Jen.config.ante_tetrate then
			if jl.invalid_number(number_format(amnt)) then return to_big(maxfloat) end
			amnt = amnt:arrow(2, 2)
		end
		if overante >= Jen.config.ante_pentate then
			if jl.invalid_number(number_format(amnt)) then return to_big(maxfloat) end
			amnt = amnt:arrow(3, 2)
		end
		if overante >= Jen.config.ante_polytate then
			if jl.invalid_number(number_format(amnt)) then return to_big(maxfloat) end
			local arrows = 4 + math.floor((overante - Jen.config.ante_polytate + 1) / Jen.config.polytate_factor)
			local operand = 2 + math.max(0, arrows - 4 - Jen.config.polytate_factor)
			amnt = amnt:arrow(math.min(maxArrow, arrows), operand)
		end
	end
	return amnt
end

local ignorelimit_playingcards = {'m_jen_surreal', 'm_jen_exotic'}
local athr=CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
	if card and card.gc then
		if card:gc().unhighlightable then
			return false
		end
	end
	if self.config.type ~= 'shop' and self.config.type ~= 'joker' and self.config.type ~= 'consumeable' then
		local surreals = 0
		for k, v in ipairs(self.highlighted) do
			if jl.bf(v.ability.name, ignorelimit_playingcards) then surreals = surreals + 1 end
		end
		local exception = false
		if #SMODS.find_card('j_jen_honey') > 0 then
			local ID = card:get_id()
			local prevcard = self.highlighted[#self.highlighted]
			if prevcard then
				local honeys = SMODS.find_card('j_jen_honey')
				local prevcardID = prevcard:get_id()
				for i = 1, #honeys do
					if (ID == (prevcardID - i) or ID == (prevcardID + i)) then exception = true honeys[i]:juice_up(0.5, 0.5) break end
				end
			end
		end
		if #SMODS.find_card('j_jen_cosmo') > 0 and not exception then
			local cosmos = SMODS.find_card('j_jen_cosmo')
			for i = 1, #cosmos do
				if card.config.center.key ~= 'c_base' then
					exception = true
					cosmos[i]:juice_up(0.5, 0.5)
					break
				end
			end
		end
		if #self.highlighted < surreals + self.config.highlighted_limit or jl.bf(card.ability.name, ignorelimit_playingcards) or exception then
			self.highlighted[#self.highlighted+1] = card
			card:highlight(true)
			if not silent then play_sound('cardSlide1') end
			if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
				self:parse_highlighted()
			end
			return
		end
	end
	athr(self,card,silent)
end

local csar = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
	if self and self.gc then
		if self.added_to_deck and self:gc().unchangeable and not self.jen_ignoreunchangeable then
			return false
		end
	end
	csar(self, center, initial, delay_sprites)
end

function check_for_unlock(args)
	return
end

function unlock_achievement(achievement_name)
	return
end

-- ============================================
-- Cryptid Compatibility
-- ============================================

if Cryptid and jl then
  -- Update POINTER:// card description if it exists
  if G and G.P_CENTERS and G.P_CENTERS.c_cry_pointer then
    G.P_CENTERS.c_cry_pointer.config.extra = "(Exotic Jokers and OMEGA consumables excluded)"
  end
  
  -- Setup pointer blacklist and aliases if functions exist
  if Cryptid.pointerblistifytype and Cryptid.pointeraliasify then
    if jl.setup_pointer_blacklist then
      jl.setup_pointer_blacklist()
    end
    if jl.setup_pointer_aliases then
      jl.setup_pointer_aliases()
    end
  end
end
