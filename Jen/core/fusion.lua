local fusion = {}

Jen.fusions = {
  ['Mutate Leshy'] = {
    cost = 50,
    output = 'j_jen_pawn',
    ingredients = {
      'j_jen_leshy',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Heket'] = {
    cost = 50,
    output = 'j_jen_knight',
    ingredients = {
      'j_jen_heket',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Kallamar'] = {
    cost = 50,
    output = 'j_jen_jester',
    ingredients = {
      'j_jen_kallamar',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Shamura'] = {
    cost = 50,
    output = 'j_jen_arachnid',
    ingredients = {
      'j_jen_shamura',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Lambert'] = {
    cost = 50,
    output = 'j_jen_reign',
    ingredients = {
      'j_jen_lambert',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Narinder'] = {
    cost = 50,
    output = 'j_jen_feline',
    ingredients = {
      'j_jen_narinder',
      'j_jen_godsmarble'
    }
  },
  ['A M A L G A M A T E'] = {
    cost = 1e100,
    output = 'j_jen_amalgam',
    ingredients = {
      'j_jen_pawn',
      'j_jen_knight',
      'j_jen_jester',
      'j_jen_arachnid',
      'j_jen_reign',
      'j_jen_feline',
      'j_jen_sigil'
    }
  },
  ['Mutate Clauneck'] = {
    cost = 50,
    output = 'j_jen_fateeater',
    ingredients = {
      'j_jen_clauneck',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Kudaai'] = {
    cost = 50,
    output = 'j_jen_foundry',
    ingredients = {
      'j_jen_kudaai',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Chemach'] = {
    cost = 50,
    output = 'j_jen_broken',
    ingredients = {
      'j_jen_chemach',
      'j_jen_godsmarble'
    }
  },
  ['Mutate Aster Flynn'] = {
    cost = 5e3,
    output = 'j_jen_astrophage',
    ingredients = {
      'j_jen_aster',
      'j_jen_godsmarble'
    }
  },
  ['Empower Landa Veris'] = {
    cost = 1e4,
    output = 'j_jen_bulwark',
    ingredients = {
      'j_jen_landa',
      'j_jen_godsmarble'
    }
  },
  ['Corrupt Crimbo'] = {
    cost = 250,
    output = 'j_jen_faceless',
    ingredients = {
      'j_jen_crimbo',
      'j_jen_godsmarble'
    }
  },
  ['Corrupt Alice'] = {
    cost = 5e3,
    output = 'j_jen_nexus',
    ingredients = {
      'j_jen_alice',
      'j_jen_godsmarble'
    }
  },
  ['Corrupt Nyx'] = {
    cost = 1e3,
    output = 'j_jen_paragon',
    ingredients = {
      'j_jen_nyx',
      'j_jen_godsmarble'
    }
  },
  ['Possess Oxy'] = {
    cost = 3e3,
    output = 'j_jen_inhabited',
    ingredients = {
      'j_jen_oxy',
      'j_jen_godsmarble'
    }
  },
  ['Petrify Honey'] = {
    cost = 50,
    output = 'j_jen_cracked',
    ingredients = {
      'j_jen_honey',
      'j_jen_godsmarble'
    }
  },
  ['Immolate Maxie'] = {
    cost = 2e3,
    output = 'j_jen_charred',
    ingredients = {
      'j_jen_maxie',
      'j_jen_godsmarble'
    }
  },
  ['Empower Jen'] = {
    cost = 1e4,
    output = 'j_jen_wondergeist',
    ingredients = {
      'j_jen_jen',
      'j_jen_godsmarble'
    }
  },
  ['Empower Jen (2nd Pass)'] = {
    cost = 1e6,
    output = 'j_jen_wondergeist2',
    ingredients = {
      'j_jen_wondergeist',
      'j_jen_godsmarble'
    }
  },
  ['???'] = {
    cost = 1e100,
    output = 'c_jen_soul_omega',
    ingredients = {
      'c_soul',
      'c_black_hole',
      'c_jen_black_hole_omega',
      'c_cry_white_hole',
      'j_jen_godsmarble'
    }
  }
}

function Jen.add_fusion(key, cost, output, ...)
  local inputs = { ... }
  Jen.fusions[key] = {cost = cost, output = output, ingredients = inputs}
end

function Jen.find_matching_recipe(items)
  if #items <= 0 then return nil end
  for k, v in pairs(Jen.fusions) do
    local matches = 0
    for _, w in ipairs(v.ingredients) do
      for __, x in ipairs(items) do
        if x:gc().key == w then
          matches = matches + 1
          break
        end
      end
    end
    if matches >= #v.ingredients then
      return k
    end
  end
  return nil
end

function Jen.has_ingredients(key)
  if not Jen.fusions[key] then return false end
  local inputs = Jen.fusions[key].ingredients
  if #inputs <= 0 then Jen.fusions[key] = nil; return false end
  local acquired = 0
  for k, v in ipairs(inputs) do
    if #SMODS.find_card(v, true) > 0 then
      acquired = acquired + 1
    end
  end
  return acquired >= #inputs
end

function Jen.get_cards_for_recipe(key)
  if not Jen.fusions[key] then return false end
  local inputs = Jen.fusions[key].ingredients
  if #inputs <= 0 then Jen.fusions[key] = nil; return false end
  local acquired = 0
  local ingreds = {}
  for k, v in ipairs(inputs) do
    if #SMODS.find_card(v, true) > 0 then
      acquired = acquired + 1
      table.insert(ingreds, next(SMODS.find_card(v, true)))
    end
  end
  if acquired >= #inputs then return ingreds else return false end
end

function Jen.is_fusable(center)
  for k, v in pairs(Jen.fusions) do
    for __, w in pairs(v.ingredients) do
      if (type(center) == 'table' and w == center.key) or (type(center) == 'string' and w == center) then
        return k
      end
    end
  end
  return false
end

return fusion

