function init_cardbans()
  if not Jen.config.disable_bans then
    Jen:delete_hardbans()
  end
end

function Jen:delete_hardbans()
  for k, v in ipairs(Jen.config.bans) do
    if string.sub(v, 1, 1, true) ~= '!' then
      if G.P_CENTERS[v] then
        print('Deleting center : ' .. v)
        local success, err = pcall(function()
          local center_obj = SMODS.Center:get_obj(v)
          if center_obj and type(center_obj) == 'table' and center_obj.delete then
            center_obj:delete()
          end
        end)
        if not success then
          print('[JEN WARNING] Failed to delete center ' .. v .. ': ' .. tostring(err))
        end
        G.P_CENTERS[v] = {
          _deleted_by_almanac = true,
          effect = "",
          name = "",
          set = 'Center',
        }
      elseif G.P_BLINDS[v] then
        G.P_BLINDS[v] = nil
      end
    end
  end
end

