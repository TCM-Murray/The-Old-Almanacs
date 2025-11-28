-- Jen Mod Operator Display System
-- Contains final operator management and chip/mult sum calculation

-- Operator display symbols and colors
local final_operations = {
  [-2] = {'/', 'IMPORTANT'},
  [-1] = {'-', 'GREY'},
  [0] = {'+', 'UI_CHIPS'},
  [1] = {'X', 'UI_MULT'},
  [2] = {'^', {0.8, 0.45, 0.85, 1}},
  [3] = {'^^', 'DARK_EDITION'},
  [4] = {'^^^', 'CRY_EXOTIC'},
  [5] = {'^^^^', 'CRY_EMBER'},
  [6] = {'^^^^^', 'CRY_ASCENDANT'},
}

-- Cache for chip*mult calculations
local sumcache_limit = 100
local chipmult_sum_cache = {}

-- Calculate final score based on current operator
function get_chipmult_sum(chips, mult)
  chips = chips or 0
  mult = mult or 0
  if #chipmult_sum_cache > sumcache_limit then
    for i = 1, sumcache_limit do
      table.remove(chipmult_sum_cache)
    end
  end
  local op = get_final_operator()
  if to_big(chips) == to_big(0) or to_big(mult) == to_big(0) then
    chips = 0
    mult = 0
    op = 0
  end
  local sum
  for k, v in ipairs(chipmult_sum_cache) do
    if v.oper == op and v.c == to_big(chips) and v.m == to_big(mult) then
      return v.result
    end
  end
  if op > 2 then
    sum = to_big(chips):arrow(math.min(maxArrow, op - 1), to_big(mult))
  elseif op == 2 then
    sum = to_big(chips) ^ to_big(mult)
  elseif op == 1 then
    sum = to_big(chips) * to_big(mult)
  elseif op == -1 then
    sum = to_big(chips) - to_big(mult)
  elseif op <= -2 then
    sum = to_big(chips) / to_big(mult)
  else
    sum = to_big(chips) + to_big(mult)
  end
  table.insert(chipmult_sum_cache, {oper = op, c = chips, m = mult, result = sum})
  return sum
end

-- Update operator display in UI
function update_operator_display()
  local op = get_final_operator()
  local txt = ''
  local col = G.C.WHITE
  if not final_operations[op] then
    txt = '{' .. number_format(op-1) .. '}'
    col = G.C.jen_RGB
  else
    txt = final_operations[op][1]
    col = type(final_operations[op][2]) == 'table' and final_operations[op][2] or G.C[final_operations[op][2]]
  end
  Q(function()
    play_sound('button', 1.1, 0.65)
    G.hand_text_area.op.config.text = txt
    G.hand_text_area.op.config.text_drawable:set(txt)
    G.hand_text_area.op.UIBox:recalculate()
    G.hand_text_area.op.config.colour = col
    G.hand_text_area.op:juice_up(0.8, 0.5)
  return true end)
end

-- Update operator display with custom text/color
function update_operator_display_custom(txt, col)
  Q(function()
    play_sound('button', 1.1, 0.65)
    G.hand_text_area.op.config.text = txt
    G.hand_text_area.op.config.text_drawable:set(txt)
    G.hand_text_area.op.UIBox:recalculate()
    G.hand_text_area.op.config.colour = (col or G.C.UI_MULT)
    G.hand_text_area.op:juice_up(0.8, 0.5)
  return true end)
end

-- Get operator offset value
function get_final_operator_offset()
  if not G.GAME then return 0 end
  if not G.GAME.finaloperator then G.GAME.finaloperator = 1 end
  if not G.GAME.finaloperator_offset then G.GAME.finaloperator_offset = 0 end
  return math.max(-1, G.GAME.finaloperator_offset)
end

-- Get current operator level
function get_final_operator(absolute)
  if not G.GAME then return 0 end
  if not G.GAME.finaloperator then G.GAME.finaloperator = 1 end
  if not G.GAME.finaloperator_offset then G.GAME.finaloperator_offset = 0 end
  return math.max(0, math.min(maxArrow + 1, G.GAME.finaloperator + (absolute and 0 or get_final_operator_offset())))
end

-- Set operator to specific value
function set_final_operator(value)
  G.GAME.finaloperator = math.min(math.max(value, 0), maxArrow + 1)
  update_operator_display()
end

-- Set operator offset to specific value
function set_final_operator_offset(value)
  G.GAME.finaloperator_offset = math.min(math.max(value, -1), maxArrow)
  update_operator_display()
end

-- Change operator by delta
function change_final_operator(mod)
  set_final_operator(get_final_operator(true) + mod)
end

-- Change operator offset by delta
function offset_final_operator(mod)
  set_final_operator_offset(get_final_operator_offset() + mod)
end

