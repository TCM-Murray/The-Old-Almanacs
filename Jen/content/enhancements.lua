--ENHANCEMENTS

SMODS.Enhancement {
	key = 'xchip',
	loc_txt = {
		name = 'Multichip Card',
		text = {
			jl.mulchips('#1#') .. ' Chips',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	config = {mod = 1.5},
	pos = { x = 1, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).mod or 1.5}}
    end,
	calculate = function(self, card, context)
		if jl.sc(context) then
			return {xchips = self.config.mod}
		end
	end
}

SMODS.Enhancement {
	key = 'echip',
	loc_txt = {
		name = 'Powerchip Card',
		text = {
			jl.expochips('#1#') .. ' Chips',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	config = {mod = 1.09},
	pos = { x = 2, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).mod or 1.09}}
    end,
	calculate = function(self, card, context)
		if jl.sc(context) then
			return {echips = self.config.mod}
		end
	end
}

SMODS.Enhancement {
	key = 'xmult',
	loc_txt = {
		name = 'Multimult Card',
		text = {
			jl.mulmult('#1#') .. ' Mult',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	config = {mod = 2},
	pos = { x = 3, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).mod or 2}}
    end,
	calculate = function(self, card, context)
		if jl.sc(context) then
			return {xmult = self.config.mod}
		end
	end
}

SMODS.Enhancement {
	key = 'emult',
	loc_txt = {
		name = 'Powermult Card',
		text = {
			jl.expomult('#1#') .. ' Mult',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	config = {mod = 1.13},
	pos = { x = 5, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).mod or 1.13}}
    end,
	calculate = function(self, card, context)
		if jl.sc(context) then
			return {emult = self.config.mod}
		end
	end
}

SMODS.Enhancement {
	key = 'power',
	loc_txt = {
		name = 'Supercharged Card',
		text = {
			jl.mulchips('#1#') .. ' Chips',
			jl.mulmult('#2#') .. ' Mult',
			jl.expochips('#3#') .. ' Chips',
			jl.expomult('#4#') .. ' Mult',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	config = {mod1 = 1.25, mod2 = 1.5, mod3 = 1.08, mod4 = 1.11},
	pos = { x = 4, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).mod1 or 1.25, ((center or {}).ability or {}).mod2 or 1.25, ((center or {}).ability or {}).mod3 or 1.08, ((center or {}).ability or {}).mod4 or 1.11}}
    end,
	calculate = function(self, card, context)
		if jl.sc(context) then
			return {xchips = self.config.mod1, xmult = self.config.mod2, echips = self.config.mod3, emult = self.config.mod4}
		end
	end
}

SMODS.Enhancement {
	key = 'surreal',
	loc_txt = {
		name = 'Surreal Card',
		text = {
			'{C:attention}Ignores{} card selection limit',
			'{C:inactive}(e.g. can be used to play 6+ cards){}'
		}
	},
	pos = { x = 6, y = 1 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
}

local function faceinplay()
	if not G.play then return 0 end
	if not G.play.cards then return 0 end
	local qty = 0
	for k, v in pairs(G.play.cards) do
		if v:is_face() then qty = qty + 1 end
	end
	return qty
end

SMODS.Enhancement {
	key = 'astro',
	loc_txt = {
		name = 'Astro Card',
		text = {
			'Creates a {C:planet}Planet{} card',
			mayoverflow,
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	pos = { x = 0, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'jenenhance',
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			Q(function()
				local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'astro_card')
				card2:add_to_deck()
				G.consumeables:emplace(card2)
				return true
			end, nil, nil, 'after')
		end
	end
}

SMODS.Enhancement {
	key = 'fortune',
	loc_txt = {
		name = 'Fortune Card',
		text = {
			'Creates a {C:tarot}Tarot{} card',
			mayoverflow,
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	pos = { x = 6, y = 0 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			Q(function()
				local card2 = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'fortune_card')
				card2:add_to_deck()
				G.consumeables:emplace(card2)
				return true
			end, nil, nil, 'after')
		end
	end
}

SMODS.Enhancement {
	key = 'atman',
	loc_txt = {
		name = 'Atman Card',
		text = {
			'Creates a {C:spectral}Spectral{} card',
			mayoverflow,
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	pos = { x = 8, y = 0 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			Q(function()
				local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'osmium_card')
				card2:add_to_deck()
				G.consumeables:emplace(card2)
				return true
			end, nil, nil, 'after')
		end
	end
}

SMODS.Enhancement {
	key = 'potassium',
	loc_txt = {
		name = 'Potassium Card',
		text = {
			'Creates a {C:dark_edition}Negative {C:attention}Gros Michel',
			'{C:red}Destroyed{} after scoring',
			'{C:cry_exotic,s:0.6,E:1}Power Card'
		}
	},
	disposable = true,
	pos = { x = 7, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context)
		if jl.sc(context) then
			Q(function()
				local k19 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_gros_michel', 'nanner')
				k19.no_forced_edition = true
				k19:set_edition({negative = true}, true)
				k19.no_forced_edition = nil
				k19:add_to_deck()
				G.jokers:emplace(k19)
				return true 
			end)
		end
		if context.destroy_card == card and context.cardarea == G.play then
			return { remove = true }
		end
	end
}

SMODS.Enhancement {
	key = 'fizzy',
	loc_txt = {
		name = 'Fizzy Card',
		text = {
			'Creates a {C:attention}Double Tag{}',
			'{C:red}Destroyed{} after scoring',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	disposable = true,
	pos = { x = 8, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
				add_tag(Tag('tag_double'))
				return true
			end }))
		end
		if context.destroy_card == card and context.cardarea == G.play then
			return { remove = true }
		end
	end
}

SMODS.Enhancement {
	key = 'water',
	loc_txt = {
		name = 'Water Card',
		text = {
			'{C:green}Always scores{}'
		}
	},
	always_scores = true,
	pos = { x = 9, y = 0 },
	atlas = 'jenenhance'
}

SMODS.Enhancement {
	key = 'handy',
	loc_txt = {
		name = 'Handy Card',
		text = {
			'{C:blue}+1{} hand this round',
			'{C:red}Destroyed{} after scoring',
			'{C:cry_exotic,s:0.6,E:1}Power Card'
		}
	},
	disposable = true,
	pos = { x = 1, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context)
		if jl.sc(context) then
			ease_hands_played(1)
		end
		if context.destroy_card == card and context.cardarea == G.play then
			return { remove = true }
		end
	end
}

SMODS.Enhancement {
	key = 'tossy',
	loc_txt = {
		name = 'Tossy Card',
		text = {
			'{C:red}+1{} discard this round',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	pos = { x = 3, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			ease_discard(1)
		end
	end
}

SMODS.Enhancement {
	key = 'juggler',
	loc_txt = {
		name = 'Juggling Card',
		text = {
			'{C:attention}+1{} hand size this round',
			'{C:cry_exotic,s:0.6,E:1}Power Card{}'
		}
	},
	pos = { x = 2, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			G.hand:change_size(1)
			G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + 1
		end
	end
}

SMODS.Enhancement {
	key = 'cash',
	loc_txt = {
		name = 'Cash Card',
		text = {
			'{C:money}+$#1#{} when scored',
			'{C:red}Destroyed{} after scoring',
			'{C:cry_exotic,s:0.6,E:1}Power Card'
		}
	},
	config = {p_dollars = 10},
	disposable = true,
	pos = { x = 4, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	loc_vars = function(self, info_queue, center)
		return {vars = {((center or {}).ability or {}).p_dollars}}
	end,
	calculate = function(self, card, context)
		if jl.sc(context) then
			G.GAME.p_dollars = (G.GAME.p_dollars or 0) + self.config.p_dollars
		end
		if context.destroy_card == card and context.cardarea == G.play then
			return { remove = true }
		end
	end
}

local handinacard = {
	[1] = {'High Card', 'Lonely'},
	[2] = {'Pair', 'Twin'},
	[3] = {'Two Pair', 'Siamese'},
	[4] = {'Three of a Kind', 'Triplet'},
	[5] = {'Straight', 'Sequential'},
	[6] = {'Flush', 'Symbolic'},
	[7] = {'Full House', 'Descendant'},
	[8] = {'Four of a Kind', 'Quadruplet'},
	[9] = {'Straight Flush', 'Tsunami'},
	[10] = {'Five of a Kind', 'Quintuplet'},
	[11] = {'Flush House', 'Ascendant'},
	[12] = {'Flush Five', 'Identity'}
}

for k, v in ipairs(handinacard) do
	SMODS.Enhancement {
		key = string.lower(v[2]),
		loc_txt = {
			name = v[2] .. ' Card',
			text = {
				'Gives the {C:chips}Chips{} & {C:mult}Mult{} of {C:attention}' .. v[1] .. '{},',
				'then is {C:red}destroyed{} after scoring is finished',
				' ',
				'{C:inactive,s:1.5}({X:chips,C:white,s:1.5}#1#{s:1.5} & {X:mult,C:white,s:1.5}#2#{C:inactive,s:1.5})',
				'{C:cry_epic,s:0.6,E:1}Hand Card{}'
			}
		},
		disposable = true,
		pos = { x = k - 1, y = 2 },
		atlas = 'jenenhance',
		unlocked = true,
		discovered = true,
		loc_vars = function(self, info_queue, center)
			local tbl = ((G.GAME or {}).hands or {})[v[1]] or {}
			return {vars = {tbl.chips or '???', tbl.mult or '???'}}
		end,
		calculate = function(self, card, context)
			if jl.sc(context) then
				local tbl = ((G.GAME or {}).hands or {})[v[1]] or {}
				if tbl and next(tbl) then
					if not card.cashed_out then
						card.cashed_out = true
					end
					return {
						chips = tbl.chips,
						mult = tbl.mult
					}
				end
			end
			if context.destroy_card == card and context.cardarea == G.play then
				return { remove = true }
			end
		end
	}
end

SMODS.Enhancement {
	key = 'exotic',
	loc_txt = {
		name = 'Exotic Card',
		text = {
			'Has {C:attention}double{} the {C:attention}combined upsides{}',
			'of {C:attention}all vanilla + {C:almanac,E:1}Almanac{} enhancements',
			'{C:red}Destroyed{} after scoring',
			'{C:inactive}(Excludes Hand Card and Super Power Card enhancements){}',
			'{C:jen_RGB,s:0.6,E:1}Super Power Card{}'
		}
	},
	config = {h_dollars = 6, p_dollars = 20, chips = 160, mult = 8, h_x_mult = 2.25, mod1 = 3.515625, mod2 = 9, mod3 = 1.2, mod4 = 1.3},
	disposable = true,
	any_suit = true,
	always_scores = true,
	pos = { x = 0, y = 1 },
	atlas = 'jenenhance',
	unlocked = true,
	discovered = true,
	calculate = function(self, card, context, effect)
		if jl.sc(context) then
			for i = 1, 6 do
				G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
					local ii = math.ceil(i/2)
					local card2 = create_card(ii == 1 and 'Planet' or ii == 2 and 'Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, nil, 'exotic_card' .. i)
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					ii = nil
					return true
				end }))
			end
			for i = 1, 2 do
				Q(function()
					local k19 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_gros_michel', 'nanner')
					k19.no_forced_edition = true
					k19:set_edition({negative = true}, true)
					k19.no_forced_edition = nil
					k19:add_to_deck()
					G.jokers:emplace(k19)
				return true end)
			end
			ease_hands_played(2)
			ease_discard(2)
			G.hand:change_size(2)
			Q(function() add_tag(Tag('tag_double'));add_tag(Tag('tag_double')); return true end)
			G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + 2
			return {xchips = self.config.mod1, xmult = self.config.mod2, echips = self.config.mod3, emult = self.config.mod4}
		end
		if context.destroy_card == card and context.cardarea == G.play then
			return { remove = true }
		end
	end
}

