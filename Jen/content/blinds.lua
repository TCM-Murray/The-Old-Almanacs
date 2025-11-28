
if SMODS.BlindEdition then
	SMODS.BlindEdition:take_ownership('ble_base', {
		key = 'base',
		loc_txt = {
			name = "Base",
			text = {"No additional effects"}
		},
		has_text = false,
		weight = 8
	})
	SMODS.BlindEdition:take_ownership('ble_foil', {
		key = 'foil',
		blind_shader = 'foil',
		loc_txt = {
			name = "Foil",
			text = {"+50% blind size"}
		},
		special_colour = G.C.CHIPS,
		blind_size_mult = 1.5,
		contrast = 3,
		weight = 0.4,
		set_blind = function(self, blind_on_deck)
			play_sound_q('foil1', 0.9)
		end,
		dollars_mod = 1
	})
	SMODS.BlindEdition:take_ownership('ble_holographic', {
		key = 'holographic',
		blind_shader = 'holo',
		loc_txt = {
			name = "Holographic",
			text = {"-1 hand size"}
		},
		special_colour = G.C.MULT,
		contrast = 3,
		weight = 0.3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('holo1', 0.9)
			G.hand:change_size(-1)
		end,
		defeat = function(self, blind_on_deck)
			G.hand:change_size(1)
		end,
		dollars_mod = 2
	})
	SMODS.BlindEdition:take_ownership('ble_polychrome', {
		key = 'polychrome',
		blind_shader = 'polychrome',
		weight = 0.2,
		dollars_mod = 3,
		loc_txt = {
			name = "Polychrome",
			text = {"-1 hand"}
		},
		new_colour = G.C.FILTER,
		special_colour = G.C.CHIPS,
		tertiary_colour = G.C.MULT,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('polychrome1', 0.9)
			Q(function() if G.GAME.current_round.hands_left > 1 then ease_hands_played(-1) end return true end, 0.1, nil, 'after')
		end
	})
	SMODS.BlindEdition:take_ownership('ble_negative', {
		key = 'negative',
		blind_shader = {'negative', 'negative_shine'},
		weight = 0.01,
		loc_txt = {
			name = "Negative",
			text = {
				"+700% blind size,",
				"+1 joker slot reward"
			}
		},
		blind_size_mult = 8,
		special_colour = G.C.BLACK,
		new_colour = G.C.SECONDARY_SET.Spectral,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('negative', 0.9)
		end,
		defeat = function(self, blind_on_deck)
			if G.jokers then G.jokers:change_size_absolute(1) end
		end
	})
	SMODS.BlindEdition {
		key = 'laminated',
		blind_shader = 'jen_laminated',
		loc_txt = {
			name = "Laminated",
			text = {"No reward money"}
		},
		special_colour = G.C.SECONDARY_SET.Planet,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('jen_e_laminated', 0.9)
		end,
		weight = 0.111,
		dollars_mod = function(self, dollars)
			return 0
		end
	}
	SMODS.BlindEdition {
		key = 'chromatic',
		blind_shader = 'jen_chromatic',
		loc_txt = {
			name = "Chromatic",
			text = {"All hands -0.5 levels"}
		},
		special_colour = G.C.CHIPS,
		new_colour = G.C.MULT,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('jen_e_chromatic', 0.9)
			lvupallhands(-0.5)
		end,
		weight = 0.25,
		dollars_mod = 2
	}
	SMODS.BlindEdition {
		key = 'ionized',
		blind_shader = 'jen_ionized',
		loc_txt = {
			name = "Ionised",
			text = {"#1#'s level",
			"gets halved"}
		},
		new_colour = G.C.FILTER,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('jen_e_ionized', 0.9)
			jl.th(jl.favhand())
			level_up_hand(G.GAME.blind.children.animatedSprite, jl.favhand(), nil, -(G.GAME.hands[jl.favhand()].level / 2))
			jl.ch()
		end,
		loc_vars = function(self, blind_on_deck)
			return {localize(jl.favhand(), 'poker_hands')}
		end,
		collection_loc_vars = function(self, blind_on_deck)
			return {'Most played hand'}
		end,
		weight = 0.15,
		dollars_mod = 4
	}
	SMODS.BlindEdition {
		key = 'gilded',
		blind_shader = 'jen_gilded',
		loc_txt = {
			name = "Gilded",
			text = {"+$20 extra reward money"}
		},
		special_colour = G.C.FILTER,
		new_colour = G.C.MONEY,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('jen_e_gilded', 0.9)
		end,
		weight = 0.02,
		dollars_mod = 20
	}
	SMODS.BlindEdition {
		key = 'sharpened',
		blind_shader = 'jen_sharpened',
		loc_txt = {
			name = "Sharpened",
			text = {"+5 random Rental",
			"playing cards"}
		},
		new_colour = G.C.BLACK,
		special_colour = G.C.WHITE,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('jen_e_sharpened', 0.9)
			for i = 1, 5 do
				local rental = create_playing_card(nil, G.play, nil, nil, {G.C.MONEY})
				rental.ability.rental = true
				rental:add_to_deck()
				G.play:remove_card(rental)
				G.deck:emplace(rental)
			end
		end,
		weight = 0.15,
		dollars_mod = 2
	}
	--[[SMODS.BlindEdition {
		key = 'diplopia',
		blind_shader = 'jen_diplopia',
		loc_txt = {
			name = "Diplopia",
			text = {"Blind has a second chance",
			"+100% reward money"}
		},
		special_colour = G.C.JOKER_GREY,
		contrast = 3,
		set_blind = function(self, blind_on_deck)
			play_sound_q('jen_e_diplopia', 0.9)
		end,
		weight = 0.1,
		dollars_mod = function(self, dollars)
			return (dollars or 0)*2
		end
	}]]
end

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

SMODS.Blind	{
    loc_txt = {
        name = 'The Descending',
        text = { 'Decrease Chip-Mult', 'operator by 1 level' }
    },
    key = 'descending',
    config = {},
    boss = {min = 1, max = 10, hardcore = true}, 
    boss_colour = HEX("b200ff"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 0},
    vars = {},
    dollars = 15,
    mult = .5,
    defeat = function(self)
        if not G.GAME.blind.disabled and get_final_operator_offset() < 0 then
			offset_final_operator(1)
        end
    end,
    set_blind = function(self, reset, silent)
        if not reset then
            offset_final_operator(-1)
        end
    end,
    disable = function(self)
		if get_final_operator_offset() < 0 then
			offset_final_operator(1)
		end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Grief',
        text = { 'Disabling this blind', 'will destroy every Joker,', 'including Eternals' }
    },
    key = 'grief',
    config = {},
    boss = {min = 4, max = 10, no_orb = true, hardcore = true}, 
    boss_colour = HEX("0026ff"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 1},
    vars = {},
    dollars = 7,
    mult = 2,
	in_pool = function() return #SMODS.find_card('j_chicot') > 0 end,
    defeat = function(self)
    end,
    set_blind = function(self, reset, silent)
    end,
    disable = function(self)
		for k, v in pairs(G.jokers.cards) do
			if v:gc().key ~= 'j_jen_kosmos' then
				v:start_dissolve()
			end
		end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Eater',
        text = { 'Destroy all cards', 'previously played this ante,', '+5% score requirement per card destroyed' }
    },
    key = 'eater',
    config = {},
    boss = {min = 1, max = 10, hardcore = true}, 
    boss_colour = HEX("ff7f7f"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 2},
    vars = {},
    dollars = 7,
    mult = 2,
    defeat = function(self)
    end,
    set_blind = function(self, reset, silent)
		if not next(SMODS.find_card('j_chicot')) then
			local size_multiplier = 1
			for k, card in ipairs(G.playing_cards) do
				if card.ability.played_this_ante then
					card:start_dissolve()
					size_multiplier = size_multiplier + 0.05
				end
			end
			change_blind_size(G.GAME.blind.chips * size_multiplier)
		end
    end,
    disable = function(self)
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Wee',
        text = { 'All non-Wee Jokers debuffed,', 'only 2s or Wees can be played' }
    },
    key = 'wee',
    config = {},
    boss = {min = 1, max = 10, no_orb = true, hardcore = true},
    boss_colour = HEX("7F3F3F"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 3},
    vars = {},
    dollars = 2,
    mult = 22/300,
	debuff_hand = function(self, cards, hand, handname, check)
		for k, v in ipairs(cards) do
			if (v:norank() or v:get_id() ~= 2) and not (v.edition or {}).jen_wee then
				return true
			end
		end
	end,
	get_loc_debuff_text = function(self)
		return "Hand must contain only 2s or Wee cards"
	end,
	recalc_debuff = function(self, card, from_blind)
		return card.area and card.area ~= G.consumeables and (card:norank() or card:get_id() ~= 2) and not (card.edition or {}).jen_wee
	end,
}

SMODS.Blind	{
    loc_txt = {
        name = 'The One',
        text = { 'Play only 1 hand, no discards' }
    },
    key = 'one',
    config = {},
    boss = {min = 4, max = 10, no_orb = true, hardcore = true}, 
    boss_colour = HEX('000000'),
    atlas = 'jenblinds',
    pos = {x = 0, y = 4},
    vars = {},
    dollars = 7,
    mult = 0.75,
    defeat = function(self)
    end,
    set_blind = function(self, reset, silent)
		if not next(SMODS.find_card('j_chicot')) then
			ease_hands_played(-G.GAME.current_round.hands_left + 1)
			ease_discard(-G.GAME.current_round.discards_left)
		end
    end,
    disable = function(self)
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Bisected',
        text = { 'Halved hand size' }
    },
    key = 'bisected',
    config = {},
    boss = {min = 2, max = 10, hardcore = true}, 
    boss_colour = HEX("7f0000"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 5},
    vars = {},
    dollars = 9,
    mult = 1.75,
    defeat = function(self)
        if not G.GAME.blind.disabled and self.handsize_mod then
			G.hand:change_size(self.handsize_mod)
			self.handsize_mod = nil
        end
    end,
    set_blind = function(self, reset, silent)
        if not reset then
			self.handsize_mod = math.floor(G.hand.config.card_limit / 2)
			G.hand:change_size(-self.handsize_mod)
        end
    end,
    disable = function(self)
		if self.handsize_mod then
			G.hand:change_size(self.handsize_mod)
			self.handsize_mod = nil
		end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Press',
        text = { '-2 hand size per play,', 'discard leftmost and rightmost cards', 'in hand per play' }
    },
    key = 'press',
    config = {},
    boss = {min = 1, max = 10, no_orb = true, hardcore = true}, 
    boss_colour = HEX("21007f"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 6},
    vars = {},
    dollars = 12,
    mult = 2,
	press_play = function(self)
		G.E_MANAGER:add_event(Event({ func = function()
			if G.hand.cards[1] then
				draw_card(G.hand, G.discard, 100, 'down', false, G.hand.cards[1])
			end
			if G.hand.cards[#G.hand.cards] and G.hand.cards[#G.hand.cards] ~= G.hand.cards[1] then
				draw_card(G.hand, G.discard, 100, 'down', false, G.hand.cards[#G.hand.cards])
			end
		return true end })) 
		G.GAME.blind.triggered = true
		self.handsize_mod = (self.handsize_mod or 0) + 2
		G.hand:change_size(-2)
	end,
    defeat = function(self)
        if not G.GAME.blind.disabled and self.handsize_mod then
			G.hand:change_size(self.handsize_mod or 0)
			self.handsize_mod = nil
        end
    end,
    set_blind = function(self, reset, silent)
        if not reset then
			self.handsize_mod = 0
        end
    end,
    disable = function(self)
		if self.handsize_mod then
			G.hand:change_size(self.handsize_mod)
			self.handsize_mod = nil
		end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Solo',
        text = { 'Must play only one card' }
    },
    key = 'solo',
    config = {},
    boss = {min = 3, max = 10, no_orb = true, hardcore = true},
    boss_colour = HEX("cd7998"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 7},
    vars = {},
    dollars = 10,
    mult = 1,
	debuff_hand = function(self, cards, hand, handname, check)
		return #cards > 1
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'ERR://91*M%/',
        text = { '??????????' }
    },
    key = 'error',
    config = {},
    boss = {min = 1, max = 10, no_orb = true, hardcore = true},
    boss_colour = HEX("ff00ff"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 8},
    vars = {},
    dollars = 5,
    mult = 1,
	press_play = function(self)
		for i = 1, pseudorandom('err91_randomise', 3, 9) do
			Q(function()
				local bsize = G.GAME.blind.chips
								change_blind_size(bsize * Cryptid.log_random(pseudoseed('err91_randomisesize' .. i), 0.873, 1.265))
				G.GAME.blind:wiggle()
				G.GAME.blind.dollars = math.max(1, G.GAME.blind.dollars + pseudorandom('err91_randomisepayout', -1, 2))
				G.GAME.current_round.dollars_to_be_earned = G.GAME.blind.dollars > 8 and ('$' .. G.GAME.blind.dollars) or (string.rep(localize('$'), G.GAME.blind.dollars)..'')
				if G.HUD_blind then
					local ui_e = G.HUD_blind:get_UIE_by_ID("dollars_to_be_earned")
					if ui_e and ui_e.config and ui_e.config.object and ui_e.config.object.update_text then
						ui_e.config.object:update_text()
						ui_e.config.object:juice_up(0.2, 0.2)
					end
				end
				return true
			end, 1)
		end
		G.GAME.blind.triggered = true
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Insignia',
        text = { 'Hand must contain', 'only one suit' }
    },
    key = 'insignia',
    config = {},
    boss = {min = 2, max = 10, no_orb = true, hardcore = true},
    boss_colour = HEX("a5aa00"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 9},
    vars = {},
    dollars = 7,
    mult = 2,
	debuff_hand = function(self, cards, hand, handname, check)
		local numsuits = 0
		local checked_suits = {}
		for k, card in ipairs(cards) do
			if not card:nosuit() and not checked_suits[card.base.suit] then
				numsuits = numsuits + 1
				checked_suits[card.base.suit] = true
				if numsuits > 1 then return true end
			end
		end
		if numsuits < 1 then return true end
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Palette',
        text = { 'Hand must contain', 'at least three suits' }
    },
    key = 'palette',
    config = {},
    boss = {min = 1, max = 10, no_orb = true},
    boss_colour = HEX("ff9cff"),
    atlas = 'jenblinds',
    pos = {x = 0, y = 10},
    vars = {},
    dollars = 7,
    mult = 2,
	debuff_hand = function(self, cards, hand, handname, check)
		local numsuits = 0
		local checked_suits = {}
		for k, card in ipairs(cards) do
			if not card:nosuit() and not checked_suits[card.base.suit] then
				numsuits = numsuits + 1
				checked_suits[card.base.suit] = true
				if numsuits >= 3 then break end
			end
		end
		return numsuits < 3
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Ahneharka',
        text = { '+1 Ante per $2 owned,', 'x3 Ante if less than $1 owned (max 1e1 Ante increase)' }
    },
    key = 'epicox',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("673305"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 0},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
	set_blind = function(self, reset, silent)
		if not reset then
			-- Normalize potentially Big values to primitive numbers for safe math/comparisons
			local dollars = to_number(G.GAME.dollars)
			local base_ante = to_number(G.GAME.round_resets.ante)
			-- Gold-based ante increase with hard cap to avoid overflow/straddle runaway
			local quota = (dollars < 1) and (base_ante * 3) or (dollars / 2)
			quota = math.min(quota or 0, 1e1)
			if jl.invalid_number(quota) then quota = 1e1 end
			local target_ante = base_ante + quota
			G.GAME.blind.chips = get_blind_amount(target_ante) * G.GAME.blind.mult * G.GAME.starting_params.ante_scaling
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			-- Bypass Straddle mechanics for this ante increase (no start/progress/boost)
			ease_ante(quota, true, true)
			Q(function() G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante; G.GAME.blind:set_text() return true end)
		end
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Sokeudentalo',
        text = { 'First hand drawn face-down,', 'plays must have at least 3 cards,', 'no identical cards (rank + suit),', 'and 2/3 of played cards must be face-down' }
    },
    key = 'epichouse',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("2d4b5d"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 1},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
	debuff_hand = function(self, cards, hand, handname, check)
		-- Plays must have at least 3 cards
		if #cards < 3 then return true end
		-- No identical cards (rank + suit) and at least 2/3 face-down
			local numfacedown = 0
			local alreadyhad = {}
		for _, card in ipairs(cards) do
			local suit = (card.base and card.base.suit) or ''
			local suitandrank = card:get_id() .. '_' .. suit
			if alreadyhad[suitandrank] then return true end
						alreadyhad[suitandrank] = true
			if card.facing == 'back' then numfacedown = numfacedown + 1 end
		end
		return numfacedown < math.ceil((#cards * 2) / 3)
	end,
	stay_flipped = function(self, area, card)
		if G.GAME.blind.facedown then
			if not G.GAME.blind.firstpass then
				G.GAME.blind.firstpass = true
				Q(function() Q(function() G.GAME.blind.firstpass = nil G.GAME.blind.facedown = nil return true end) return true end)
			end
			return true
		end
	end,
    set_blind = function(self, reset, silent)
		if not reset then
			G.GAME.blind.prepped = true
			G.GAME.blind.facedown = true
        end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Ruttoklubi',
        text = { 'If played hand contains', 'no Clubs (ignoring suit modifiers), instantly lose' }
    },
    key = 'epicclub',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("677151"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 2},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		local safe = false
		for k, v in ipairs(cards) do
			if v.base.suit == 'Clubs' then
				safe = true
				break
			end
		end
		if not safe then gameover() return to_big(0), to_big(0), true end
		return hand_chips, mult, false
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Sabotöörikala',
        text = { 'Add Stone cards equal to', 'triple the number of cards in deck,', 'no hands containing rankless/suitless cards allowed' }
    },
    key = 'epicfish',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("94BBDA"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 3},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
    set_blind = function(self, reset, silent)
		if not reset then
			for i = 1, #G.playing_cards * 3 do
				G.E_MANAGER:add_event(Event({
					delay = 0.1,
					func = function()
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, pseudorandom_element(G.P_CARDS, pseudoseed('epicfish_stone')), G.P_CENTERS.m_stone, {playing_card = G.playing_card})
						if math.floor(i/2) ~= i then play_sound('card1') end
						table.insert(G.playing_cards, card)
						G.deck:emplace(card)
						return true
					end
				}))
			end
        end
    end,
	debuff_hand = function(self, cards, hand, handname, check)
		for k, v in ipairs(cards) do
			if v:norank() or v:nosuit() then
				return true
			end
		end
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Epätoivonikkuna',
        text = { 'If played hand contains', 'no Diamonds (ignoring suit modifiers), instantly lose' }
    },
    key = 'epicwindow',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("5e5a53"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 4},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		local safe = false
		for k, v in ipairs(cards) do
			if v.base.suit == 'Diamonds' then
				safe = true
				break
			end
		end
		if not safe then gameover() return to_big(0), to_big(0), true end
		return hand_chips, mult, false
	end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Verenvuotokoukku',
        text = { 'Destroy all cards in deck', 'that have the same rank & suit as another' }
    },
    key = 'epichook',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("5d2414"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 5},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
    set_blind = function(self, reset, silent)
		local entries = {}
		if not reset then
			for k, v in ipairs(G.playing_cards) do
				if not v:norankorsuit() then
					local face = v.base.suit .. '_' .. v.base.id
					if not entries[face] then entries[face] = {} end
					table.insert(entries[face], v)
				end
			end
			for k, v in pairs(entries) do
				if #v > 1 then
					for kk, vv in pairs(v) do
						vv:destroy()
					end
				end
			end
		end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Tuskallisetkäsiraudat',
        text = { 'Hand size set to 2,', 'must play only Pairs' }
    },
    key = 'epicmanacle',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("a2a2a2"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 6},
    vars = {},
    dollars = 25,
    mult = 1e9,
	ignore_showdown_check = true,
	debuff = {hand = {h_size_ge = 2, h_size_le = 2}},
	get_loc_debuff_text = function(self)
		return "Hand must be a Pair"
	end,
	debuff_hand = function(self, cards, hand, handname, check)
		if handname ~= 'Pair' and not G.GAME.blind.disabled then
			if not check then G.GAME.blind.triggered = true end
			return true
		end
		return false
	end,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
    defeat = function(self)
        if not G.GAME.blind.disabled and self.handsize_mod then
			G.hand:change_size(self.handsize_mod)
        end
    end,
    set_blind = function(self, reset, silent)
        if not reset then
			self.handsize_mod = G.hand.config.card_limit - 2
			G.hand:change_size(-self.handsize_mod)
        end
    end,
    disable = function(self)
		if self.handsize_mod then
			G.hand:change_size(self.handsize_mod)
		end
    end
}

SMODS.Blind	{
    loc_txt = {
        name = 'Ylitsepääsemätönseinä',
        text = { 'Dramatically rescale blind size if', 'score requirement reached', 'before last hand' }
    },
    key = 'epicwall',
    config = {},
	showdown = true,
    boss = {min = 1, max = 10, no_orb = true, showdown = true, hardcore = true, epic = true},
    boss_colour = HEX("4d325c"),
    atlas = 'jenepicblinds',
    pos = {x = 0, y = 7},
    vars = {},
    dollars = 25,
    mult = 1e100,
	ignore_showdown_check = true,
	in_pool = function(self)
		return G.GAME.round > Jen.config.ante_threshold * 2
	end,
    set_blind = function(self, reset, silent)
        if not reset then
			self.reference_ante = G.GAME.round_resets.ante
        end
    end,
	cry_after_play = function(self)
		if G.GAME.chips >= G.GAME.blind.chips and G.GAME.current_round.hands_left > 0 then
			G.GAME.blind:wiggle()
			local to_ease = G.GAME.blind.chips
			self.reference_ante = math.ceil((self.reference_ante or G.GAME.round_resets.ante) * 1.5)
			G.E_MANAGER:add_event(Event({
				trigger = 'ease',
				blocking = false,
				ref_table = G.GAME.blind,
				ref_value = 'chips',
				ease_to = get_blind_amount(self.reference_ante) * 1e100,
				delay = 0.5,
				func = (function(t) return math.floor(t) end)
			}))
		end
    end
}