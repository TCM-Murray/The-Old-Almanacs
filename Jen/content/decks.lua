--DECKS

SMODS.Back {
	key = 'orrery',
	atlas = 'jendecks',
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = 'Orrery Deck',
		text = {
			'All hands start at {X:chips,C:white}150{C:mult} X {X:red,C:white}1',
			'and are {C:cry_ascendant}equalised{} whenever their',
			'{C:chips}Chips{}, {C:mult}Mult{} or {C:planet}level {C:attention}change',
			'{C:inactive,s:0.6}T.E.F.D. excluded',
			spriter('ThreeCubed')
		}
	},
    apply = function(self)
        G.GAME.orrery = true
		Q(function() for k, v in pairs(G.GAME.hands) do
			v.chips = to_big(150)
			v.mult = to_big(1)
			v.level = to_big(1)
		end save_run() return true end)
    end
}

SMODS.Back {
	key = 'mysterious',
	atlas = 'jendecks',
	pos = { x = 1, y = 0 },
	loc_txt = {
		name = 'Mysterious Deck',
		text = {
			'{C:red}Warning : Highly unstable!',
			'Jokers, consumables, and',
			'playing cards are {C:green,E:1}randomised',
			'when they are added',
			'to your possession',
			spriter('mailingway')
		}
	},
    apply = function(self)
        G.GAME.mysterious = true
		Q(function() save_run() return true end)
    end
}

SMODS.Back {
	key = 'weeck',
	atlas = 'jendecks',
	pos = { x = 4, y = 1 },
	loc_txt = {
		name = 'Weeck',
		text = {
			'Start with a deck composed',
			'of a {C:dark_edition}Wee {C:attention}2',
			'of {C:attention}each suit',
			'The {C:dark_edition}Wee{} edition is',
			'{X:attention,C:white}222.22x{C:attention} more likely',
			'to appear over other editions',
			'{C:dark_edition}Wee{} scales {X:attention,C:white}3x{C:attention} faster',
			spriter('CrimboJimbo')
		}
	},
    apply = function(self)
		G.GAME.weeck = true
		Q(function() for k, v in pairs(G.playing_cards) do
			if v.base.id == 2 then
				v:set_edition({jen_wee = true}, true, true)
			else
				v.area:remove_card(v)
				v:destroy()
			end
		end return true end)
		delay(1)
		Q(function() save_run() return true end)
    end
}

SMODS.Back {
	key = 'obsidian',
	atlas = 'jendecks',
	pos = { x = 2, y = 1 },
	loc_txt = {
		name = 'Obsidian Deck',
		text = {
			'{C:attention}Hidden{} cards {C:inactive}(ex. {C:spectral}The Soul{C:inactive})',
			'can {C:attention}appear normally{},',
			'{C:spectral}Spectral{} cards may',
			'appear in the {C:attention}shop{},',
			'{C:jen_RGB,E:1}Omega{} consumables appear',
			'{C:attention}twice{} as often',
			spriter('CrimboJimbo')
		}
	},
	config = {
		spectral_rate = 2
	},
    apply = function(self)
		G.GAME.obsidian = true
    end
}

SMODS.Back {
	key = 'tortoise',
	atlas = 'jendecks',
	pos = { x = 3, y = 1 },
	loc_txt = {
		name = 'Tortoise Deck',
		text = {
			'{C:attention}Ante increases{} are {C:attention}half{} as strong,',
			'{C:attention}Straddle{} takes {C:attention}twice as long{} to increase',
			spriter('laviolive')
		}
	},
    apply = function(self)
		G.GAME.tortoise = true
    end
}

if Jen.config.straddle.enabled then
	SMODS.Back {
		key = 'nitro',
		atlas = 'jendecks',
		pos = { x = 1, y = 1 },
		loc_txt = {
			name = 'Acceleration Deck',
			text = {
				'{C:attention}Straddle{} is enabled {C:attention}pre-endless',
				'and {C:attention}increases {X:attention,C:white}' .. number_format(Jen.config.straddle.progress_min) .. 'x{C:attention} as fast{},',
				'create an {C:tarot}Empowered Pack{} and',
				'a random {C:attention}Booster Pack{} in',
				'the {C:attention}consumable tray{} after',
				'defeating the {C:attention}Boss Blind',
				spriter('mailingway')
			}
		},
		apply = function(self)
			G.GAME.straddle_active = true
			G.GAME.nitro = true
			G.GAME.straddle = 0
			G.GAME.straddle_progress = 0
		end,
		trigger_effect = function(self, args)
			if args.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
				Q(function()
					local pack = create_card('Booster', G.consumeables, nil, nil, nil, nil, 'p_cry_empowered', 'nitro_empowered')
					if pack.gc and pack:gc().set ~= 'Booster' then
						pack:set_ability(G.P_CENTERS.p_cry_empowered, true, nil)
						pack:set_cost()
					end
					pack:add_to_deck()
					G.consumeables:emplace(pack)
				return true end)
				Q(function()
					local pack2 = create_card('Booster', G.consumeables, nil, nil, nil, nil, nil, 'nitro_bonus')
					if pack2.gc and pack2:gc().set ~= 'Booster' then
						pack2:set_ability(jl.rnd('nitro_bonus_equilibrium', nil, G.P_CENTER_POOLS.Booster), true, nil)
						pack2:set_cost()
					end
					pack2:add_to_deck()
					G.consumeables:emplace(pack2)
				return true end)
			end
		end
	}
end

