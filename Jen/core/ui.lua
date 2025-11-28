-- Jen Mod UI Helpers
-- Contains UI component builders and display utilities

-- Create a button with sprite
function UIBox_button_w_sprite(args)
  args = args or {}
  args.button = args.button or "exit_overlay_menu"
  args.func = args.func or nil
  args.colour = args.colour or G.C.RED
  args.choice = args.choice or nil
  args.chosen = args.chosen or nil
  args.minw = args.minw or 2.7
  args.maxw = args.maxw or (args.minw - 0.2)
  if args.minw < args.maxw then args.maxw = args.minw - 0.2 end
  args.minh = args.minh or 0.9
  args.scale = args.scale or 0.5
  args.focus_args = args.focus_args or nil
  args.text_colour = args.text_colour or G.C.UI.TEXT_LIGHT
  local but_UIT = args.col == true and G.UIT.C or G.UIT.R

  local but_UI_label = {}

  local button_pip = nil
  table.insert(but_UI_label, {n=G.UIT.R, config={align = "cm", padding = 0, minw = args.minw, maxw = args.maxw}, nodes={
    {n=G.UIT.O, config={object = args.sprite, scale = args.scale, shadow = args.shadow, focus_args = button_pip and args.focus_args or nil, func = button_pip, ref_table = args.ref_table}}
  }})
  if args.label then
    for k, v in ipairs(args.label) do 
      if k == #args.label and args.focus_args and args.focus_args.set_button_pip then 
        button_pip = 'set_button_pip'
      end
      table.insert(but_UI_label, {n=G.UIT.R, config={align = "cm", padding = 0, minw = args.minw, maxw = args.maxw}, nodes={
        {n=G.UIT.T, config={text = v, scale = args.scale, colour = args.text_colour, shadow = args.shadow, focus_args = button_pip and args.focus_args or nil, func = button_pip, ref_table = args.ref_table}}
      }})
    end
  end

  return 
  {n= but_UIT, config = {align = 'cm'}, nodes={
  {n= G.UIT.C, config={
    align = "cm",
    padding = args.padding or 0,
    r = 0.1,
    hover = true,
    colour = args.colour,
    one_press = args.one_press,
    button = (args.button ~= 'nil') and args.button or nil,
    choice = args.choice,
    chosen = args.chosen,
    focus_args = args.focus_args,
    minh = args.minh - 0.3*(args.count and 1 or 0),
    shadow = true,
    func = args.func,
    id = args.id,
    back_func = args.back_func,
    ref_table = args.ref_table,
    mid = args.mid
  }, nodes=
  but_UI_label
  }}}
end

-- Override Moveable parallax calculation
local mcp = Moveable.calculate_parrallax
function Moveable:calculate_parrallax()
  if self.no_parallax then
    self.shadow_parrallax = {x = 0, y = 0}
  end
  return mcp(self)
end

-- Text animation helpers
function G.FUNCS.text_super_juice(e, _amount, unlimited)
  if type(_amount) == "table" then
    if _amount > to_big(1e300) then
      _amount = 1e300
    else
      _amount = _amount:to_number()
    end
  end
  if e and e.config and e.config.object and next(e.config.object) then
    e.config.object:set_quiver(unlimited and (0.002*_amount) or math.min(1, 0.002*_amount))
    e.config.object:pulse(unlimited and (0.3 + 0.003*_amount) or math.min(10, 0.3 + 0.003*_amount))
    e.config.object:update_text()
    e.config.object:align_letters()
    e:update_object()
  end
end

function G.FUNCS.tsj_specific(e, quiver, pulse)
  if e and e.config and e.config.object and next(e.config.object) then
    e.config.object:set_quiver(quiver)
    e.config.object:pulse(pulse)
    e.config.object:update_text()
    e.config.object:align_letters()
    e:update_object()
  end
end

-- Booster skip button config
G.FUNCS.can_skip_booster = function(e)
  e.config.colour = G.C.GREY
  e.config.button = 'skip_booster'
end

-- Hand Mult UI update
G.FUNCS.hand_mult_UI_set = function(e)
  local new_mult_text = number_format(G.GAME.current_round.current_hand.mult)
  if new_mult_text ~= G.GAME.current_round.current_hand.mult_text then
    G.GAME.current_round.current_hand.mult_text = new_mult_text
    e.config.object.scale = 0.46 / (math.max(1, string.len(new_mult_text) - 8) ^ .2)
    e.config.object:update_text()
    if not G.TAROT_INTERRUPT_PULSE then
      G.FUNCS.text_super_juice(e, math.max(0,math.floor(math.log10((type(G.GAME.current_round.current_hand.mult) == 'number' or type(G.GAME.current_round.current_hand.mult) == 'table') and G.GAME.current_round.current_hand.mult or 0))))
    else
      G.FUNCS.text_super_juice(e, 0, 0)
    end
  end
end

-- Hand Chips UI update
G.FUNCS.hand_chip_UI_set = function(e)
  local new_chip_text = number_format(G.GAME.current_round.current_hand.chips)
  if new_chip_text ~= G.GAME.current_round.current_hand.chip_text then
    G.GAME.current_round.current_hand.chip_text = new_chip_text
    e.config.object.scale = 0.46 / (math.max(1, string.len(new_chip_text) - 8) ^ .2)
    e.config.object:update_text()
    if not G.TAROT_INTERRUPT_PULSE then
      G.FUNCS.text_super_juice(e, math.max(0,math.floor(math.log10((type(G.GAME.current_round.current_hand.chips) == 'number' or type(G.GAME.current_round.current_hand.chips) == 'table') and G.GAME.current_round.current_hand.chips or 0))))
    else
      G.FUNCS.text_super_juice(e, 0, 0)
    end
  end
end

-- Hand Chip Total UI update
G.FUNCS.hand_chip_total_UI_set = function(e)
  if to_big(G.GAME.current_round.current_hand.chip_total) < to_big(1) then
    G.GAME.current_round.current_hand.chip_total_text = ''
  else
    local new_chip_total_text = number_format(G.GAME.current_round.current_hand.chip_total)
    if new_chip_total_text ~= G.GAME.current_round.current_hand.chip_total_text then 
      e.config.object.scale = scale_number(G.GAME.current_round.current_hand.chip_total, 0.95, 1e8)
      
      G.GAME.current_round.current_hand.chip_total_text = new_chip_total_text
      if not G.ARGS.hand_chip_total_UI_set or to_big(G.ARGS.hand_chip_total_UI_set) < to_big(G.GAME.current_round.current_hand.chip_total) then
        G.FUNCS.text_super_juice(e, math.max(0,math.floor(math.log10((type(G.GAME.current_round.current_hand.chip_total) == 'number' or type(G.GAME.current_round.current_hand.chip_total) == 'table') and G.GAME.current_round.current_hand.chip_total or 0))))
      else
        G.FUNCS.text_super_juice(e, 0, 0)
      end
      G.ARGS.hand_chip_total_UI_set = G.GAME.current_round.current_hand.chip_total
    end
  end
end
