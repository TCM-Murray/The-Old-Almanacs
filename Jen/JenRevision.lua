
--[[SMODS.Consumable {
	key = 'bazaar',
	loc_txt = {
		name = 'The Bazaar',
		text = {
			'Choose up to {C:attention}#1#{} playing cards',
			'If the card is {C:attention}not enhanced{}, {C:green,E:1}randomise{} it for {C:money}$1',
			'If the card is {C:attention}enhanced{}, {C:money}sell{} it for {C:money}$4 + its sell value'
			spriter('cozyori')
		}
	},
	config = {max_highlighted = 5},
	set = 'Tarot',
	pos = { x = 3, y = 0 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).max_highlighted or 1}}
    end,
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted <= (card.ability.max_highlighted + (card.area == G.hand and 1 or 0)) and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.hand.highlighted) do
				v:set_edition({jen_wee = true})
				Q(function() G.hand:remove_from_highlighted(v) return true end)
			end
		end
	end
}]]

--[[ ##THIS NEEDS A REVISION##
local hoxxes_max = 1000

SMODS.Consumable {
	key = 'hoxxes',
	loc_txt = {
		name = 'Hoxxes',
		text = {
			'{C:attention}Mines{} each {C:attention}playing card{} in hand, {C:attention}downgrading{} its {C:attention}rank{} by {C:attention}1',
			'Repeat this by its {C:attention}max number of self-retriggers{} if it has any',
			'Apply {C:attention}various bonuses {C:inactive}(chip, mult, dollars){} to {C:attention}most played hand{} for each hit',
			'If card is a {C:attention}2{} or {C:attention}Stone{}, {C:red}destroy it{} and {C:planet}level up the hand',
			'{C:attention}Glass{} cards have a {C:green}#1# in 4 chance{} to {C:red}be destroyed instantly{} with each hit',
			'{C:inactive}(Most played hand : {C:attention}#2#{C:inactive})',
			'{C:inactive}(Max limit of ' .. number_format(hoxxes_max) .. ' cards)'
		}
	},
	set = 'Spectral',
    hidden = true,
	soul_rate = 0.02,
    soul_set = "Planet",
	set_card_type_badge = hoxxesplanet,
	pos = { x = 0, y = 0 },
	cost = 15,
	unlocked = true,
	discovered = true,
	atlas = 'jenhoxxes',
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse() and (G.STATE == G.STATES.SELECTING_HAND or (jl.booster() and (((card.area or {}) ~= G.consumeables) or #G.hand.cards > 0)))
	end,
	use = function(self, card, area, copier)
		if #G.hand.cards > 0 then
			local hand = jl.favhand()
			local exhausted = {}
			jl.th(hand)
			for k, v in ipairs(G.hand.cards) do
				if k <= hoxxes_max and v.gc and v:gc().key ~= 'j_jen_goob_lefthand' and v:gc().key ~= 'j_jen_goob_righthand' then
					local iterations = 1
					local extrachips = v.ability.name == 'Stone Card' and 0 or v.base.nominal
					local extramult = 0
					local xm = 1
					local xc = 1
					local em = 1
					local ec = 1
					local eem = to_big(1)
					local eec = to_big(1)
					local eeem = to_big(1)
					local eeec = to_big(1)
					local money = 0
					local willbreak = -1
					local predictedrank = v.base.id or 2
					local obj = v.edition or {}
					local levelup = false
					if v.ability.retriggers or v.ability.repetitions then
						iterations = iterations + (v.ability.retriggers or v.ability.repetitions)
					end
					if obj.retriggers or obj.repetitions then
						iterations = iterations + (obj.retriggers or obj.repetitions)
					end
						local obj2 = v:gc().config
						if obj2.retriggers or obj2.repetitions then
							iterations = iterations + (obj2.retriggers or obj2.repetitions)
						end
						for i = 1, iterations do
							if i ~= 1 then
								extrachips = extrachips + predictedrank
							end
							if obj2.mult and obj2.mult > 0 then
								extramult = extramult + obj2.mult
							end
							if obj2.bonus and obj2.bonus > 0 then
								extrachips = extrachips + obj2.bonus
							end
							if obj2.p_dollars and obj2.p_dollars > 0 then
								money = money + obj2.p_dollars
							end
							if obj2.h_dollars and obj2.h_dollars > 0 then
								money = money + obj2.h_dollars
							end
							if v.ability.perma_bonus and v.ability.perma_bonus > 0 then
								extrachips = extrachips + v.ability.perma_bonus
							end
							if obj2.h_x_mult and obj2.h_x_mult > 1 then
								xm = xm * obj2.h_x_mult
							end
							if obj2.Xmult and obj2.Xmult > 1 then
								xm = xm * obj2.Xmult
							end
							if obj and next(obj) ~= nil and not obj.negative then
								if obj.chips then
									extrachips = extrachips + obj.chips
								end
								if obj.mult then
									extramult = extramult + obj.mult
								end
								if obj.p_dollars then
									money = money + obj.p_dollars
								end
								if obj.x_mult then
									xm = xm * obj.x_mult
								end
								if obj.x_chips then
									xc = xc * obj.x_chips
								end
								if obj.e_mult then
									em = (em <= 1 and obj.e_mult or (em ^ obj.e_mult))
								end
							end
							predictedrank = predictedrank - 1
							if (v.ability.name == 'Glass Card' and jl.chance('mining_glass', 4)) or predictedrank < 2 or v:norank() then
								willbreak = i
								levelup = true
								break
							end
						end
					G.E_MANAGER:add_event(Event({delay = 1, func = function()
						card:juice_up(0.5, 0.2)
						v:juice_up(1, 1)
						if v:get_id() <= 2 or iterations == willbreak then
							iterations = 0
							play_sound(v.ability.name == 'Glass Card' and 'jen_crystalbreak' or ('jen_metalbreak' .. math.random(2)), 1, 0.4)
							if v.facing == 'front' then v:flip() end
							local suit_prefix = string.sub(v.base.suit, 1, 1)..'_'
							v:set_base(G.P_CARDS[suit_prefix..'2'])
							table.insert(exhausted, v)
							add_malice(5)
						else
							iterations = iterations - 1
							local suit_prefix = string.sub(v.base.suit, 1, 1)..'_'
							local rank_suffix = math.max(v.base.id-1, 2)
							if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
							elseif rank_suffix == 10 then rank_suffix = 'T'
							elseif rank_suffix == 11 then rank_suffix = 'J'
							elseif rank_suffix == 12 then rank_suffix = 'Q'
							elseif rank_suffix == 13 then rank_suffix = 'K'
							end
							if G.P_CARDS[suit_prefix..rank_suffix] then
							v:set_base(G.P_CARDS[suit_prefix..rank_suffix])
							play_sound(v.ability.name == 'Glass Card' and ('jen_crystalhit' .. math.random(3)) or 'jen_metalhit', 1, 0.4)
						end
					return iterations < 1 end }))
						if levelup then
							level_up_hand(v, hand, nil, 1)
						end
						if extrachips > 0 then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('chips1')
								v:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = 0}, {chips = '+' .. number_format(extrachips), StatusText = true})
							G.GAME.hands[hand].chips = G.GAME.hands[hand].chips + extrachips
						end
						if extramult > 0 then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('multhit1')
								v:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = 0}, {mult = '+' .. number_format(extramult), StatusText = true})
							G.GAME.hands[hand].mult = G.GAME.hands[hand].mult + extramult
						end
						if xc > 1 then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('talisman_xchip')
								v:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = 0}, {chips = 'x' .. tostring(jl.round(xc, 3)), StatusText = true})
							G.GAME.hands[hand].chips = G.GAME.hands[hand].chips * xc
						end
						if xm > 1 then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('multhit2')
								v:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = 0}, {mult = 'x' .. tostring(jl.round(xm, 3)), StatusText = true})
							G.GAME.hands[hand].mult = G.GAME.hands[hand].mult * xm
						end
						if em > 1 then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('talisman_emult')
								v:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = 0}, {mult = '^' .. tostring(jl.round(em, 3)), StatusText = true})
							G.GAME.hands[hand].mult = G.GAME.hands[hand].mult ^ em
						end
						if money > 0 then
							ease_dollars(money)
						end
					delay(1)
					update_hand_text({sound = 'button', volume = 0.5, pitch = 1.1, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
				end
			end
			jl.rd(2)
			jl.ch()
			G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
				for k, v in pairs(exhausted) do
					v:start_dissolve()
				end
				jl.jokers({ remove_playing_cards = true, removed = exhausted })
			return true end }))
			local rnd = math.random(#hoxxesblurbs)
			if rnd == #hoxxesblurbs - 2 then
				play_sound_q('jen_wererich')
			elseif rnd == #hoxxesblurbs - 1 then
				play_sound_q('jen_mushroom1')
			elseif rnd == #hoxxesblurbs then
				play_sound_q('jen_mushroom2')
			end
			add_malice(25)
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = hoxxesblurbs[rnd], colour = G.C.PURPLE})
		else
			local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, card:gc().key, 'hoxxesreturn')
			card2:add_to_deck()
			G.consumeables:emplace(card2)
		end
	end
}
]]


--[[SMODS.Consumable {
	key = 'hiiaka',
	loc_txt = {
		name = 'Hi\'iaka',
		text = {
			'{C:inactive}(Currently placeholder, has the same effect as Namaka)',
			'The number of {C:tarot}Tarots{}, {C:planet}Planets{}, {C:spectral}Spectrals{} or {C:code}Codes',
			'you have used throughout the run are',
			'{C:attention}applied as levels{} to {C:attention}four random {C:purple}poker hands',
			'{C:inactive}(The same hand can be picked multiple times)',
			'{C:inactive}({C:tarot}#1#{C:inactive}, {C:planet}#2#{C:inactive}, {C:spectral}#3#{C:inactive}, {C:code}#4#{C:inactive})',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	set_card_type_badge = natsat,
	pos = { x = 1, y = 10 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local fav = jl.favhand()
		local hands = jl.adjacenthands(fav)
        return {vars = {jl.ctu('tarot'), jl.ctu('planet'), jl.ctu('spectral'), jl.ctu('code')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		jl.ch()
		jl.hcm('', '')
		update_operator_display_custom(' ', G.C.WHITE)
		delay(1)
		for k, v in pairs(namaka_data) do
			local amt = jl.ctu(string.lower(k))
			update_operator_display_custom(k, v)
			delay(2)
			update_operator_display_custom('+' .. number_format(amt), v)
			delay(2)
			if amt > 0 then
				local sel = jl.rndhand(nil, 'jen_namaka_' .. string.lower(k))
				if (G.SETTINGS.FASTFORWARD or 0) < 1 then
					for i = 1, math.random(3, 6) do
						jl.th(G.handlist[math.random(#G.handlist)])
						delay(0.15)
					end
				end
				jl.th(sel)
				delay(1)
				level_up_hand(card, sel, nil, amt)
			else
				play_sound_q('timpani')
				update_operator_display_custom('Nope!', G.C.RED)
				delay(1)
			end
			delay(1)
		end
		jl.ch()
		update_operator_display()
	end,
	bulk_use = function(self, card, area, copier, number)
		jl.ch()
		jl.hcm('', '')
		update_operator_display_custom(' ', G.C.WHITE)
		delay(1)
		for i = 1, number do
			for k, v in pairs(namaka_data) do
				local amt = jl.ctu(string.lower(k))
				update_operator_display_custom(k, v)
				delay(2/i)
				update_operator_display_custom('+' .. number_format(amt), v)
				delay(2/i)
				if amt > 0 then
					local sel = jl.rndhand(nil, 'jen_namaka_' .. string.lower(k))
					if i == 1 and (G.SETTINGS.FASTFORWARD or 0) < 1 then
						for i = 1, math.random(3, 6) do
							jl.th(G.handlist[math.random(#G.handlist)])
							delay(0.15)
						end
					end
					jl.th(sel)
					delay(1/i)
					level_up_hand(card, sel, nil, amt)
				else
					play_sound_q('timpani')
					update_operator_display_custom('Nope!', G.C.RED)
					delay(1)
				end
				delay(1/i)
			end
		end
		jl.ch()
		update_operator_display()
	end
}]]

--TAGS
--[[
SMODS.Tag {
	key = 'solace',
	loc_txt = {
		name = 'Solace Tag',
		text = {
			'Immediately uses {C:spectral}Solace'
		}
	},
	pos = { x = 6, y = 2 },
	config = { type = "new_blind_choice" },
	atlas = "jentags",
	loc_vars = function(self, info_queue)
		local tar = (self.ability or {}).pack_key or '
		return ((self.ability or {})
	end,
	in_pool = function()
		return false
	end,
	apply = function(tag, context)
		if context.type == "new_blind_choice" then
			tag:yep("+", G.C.almanac, function()
				local key = "p_cry_code_normal_" .. math.random(1, 2)
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
}
]]

-- Currently unused, has identical functionality to Landa Veris
--[[SMODS.Joker {
	key = 'urizyth',
	loc_txt = {
		name = 'Urizyth',
		text = {
			'Gives {X:purple,C:dark_edition}^Chips&Mult{} according',
			'to {C:attention}(number of Jokers + 1){} multiplied by',
			'{C:attention}((cards in deck / 100) + 1)',
			'{C:inactive}(Currently {X:purple,C:dark_edition}^#1#{C:inactive})',
			' ',
			caption('#2#'),
			faceart('laviolive')
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	sinis = { x = 2, y = 0 },
	cost = 50,
	rarity = 'cry_exotic',
	fusable = true,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	wee_incompatible = true,
	immutable = true,
	atlas = 'jenlanda',
    loc_vars = function(self, info_queue, center)
        return {vars = {number_format(landa_mod()), Jen.sinister and 'OH GOD, OH NO, OH FU-!!' or Jen.gods() and 'That... thing... have I seen it before?' or 'I must do what I must-... w-wait, was that REALLY my line?'}}
    end,
    calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main then
			local mod = landa_mod()
			return {
				message = '^' .. mod .. ' Chips & Mult',
				Echip_mod = mod,
				Emult_mod = mod,
				colour = G.C.PURPLE,
				card = card
			}, true
		end
	end
}]]

--[[SMODS.Joker {
	key = 'math',
	loc_txt = {
		name = 'Math Mathew',
		text = {
			'Provides a base of {C:chips}#1# Chips{} and {C:mult}#2# Mult',
			'Final amount is based on a {C:attention}mathematical operation',
			'using the {C:attention}scored cards',
			'{C:inactive}(Experiment with playing cards to learn more)'
			"{C:inactive,s:1.8,E:1}Math is fun.",
			faceart('jenwalter666')
		}
	},
	config = {extra = {basechips = 500, basemult = 50}},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	cost = 20,
	rarity = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'jenmath',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.basechips, center.ability.extra.basemult}}
    end,
    calculate = function(self, card, context)
		if not context.blueprint_card then
			local equation = {
				text = '',
				add = {},
				subtract = {},
				multiply = {},
				exponentiate = {}
			}
			if context.cardarea == G.jokers and not context.before and not context.after then
				if #SMODS.find_card('j_jen_rai') > 0 and #SMODS.find_card('j_jen_koslo') > 0 then
					return {
						message = '^1e100 Mult',
						Emult_mod = 1e100,
						colour = G.C.DARK_EDITION
					}
				elseif #SMODS.find_card('j_jen_rai') > 0 or #SMODS.find_card('j_jen_koslo') > 0 then
					return {
						message = 'x777',
						Xchip_mod = 777,
						colour = G.C.CHIPS
					}
				else
					return {
						message = '+1',
						chip_mod = 1,
						colour = G.C.CHIPS
					}
				end
			end
		end
	end
}]]

--[[SMODS.Joker {
	key = 'kori',
	loc_txt = {
		name = '{C:edition}K{C:dark_edition}o{C:edition}r{C:dark_edition}i {C:cry_ember}S{C:cry_blossom}i{C:cry_ember}n{C:cry_blossom}g{C:cry_ember}u{C:cry_blossom}l{C:cry_ember}a{C:cry_blossom}r{C:cry_ember}i{C:cry_blossom}s',
		text = {
			'{C:spectral}Black Holes{} give',
			'{X:cry_ember,C:chips}?n{} Chips and {X:cry_azure,C:mult}?n{} Mult',
			'to {C:attention}all hands{} when used',
			'{C:inactive}(Scales according to number of Black Holes used in run)',
			'{C:inactive}(Currently {C:cry_ascendant}#2#{C:cry_blossom}#3#{C:inactive})',
			' ',
			caption('#1#'),
			faceart('astralightsky')
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	drama = { x = 2, y = 0 },
	fusable = true,
	cost = 250,
	rarity = 'jen_wondrous',
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	unique = true,
	immutable = true,
	debuff_immune = true,
	atlas = 'jenkori',
    loc_vars = function(self, info_queue, center)
		local selected = kori_captions[Jen.gods() and 'marble' or Jen.dramatic and 'scared' or 'normal']
		local strength = kori_strength(((((G.GAME or {}).consumeable_usage or {}).c_black_hole or {}).count or 0) + 1)
        return {vars = {selected[math.random(#selected)], strength.op > 5 and ('{' .. strength.op .. '}') or strength.op > 1 and string.rep('^', strength.op-1) or 'x', number_format(strength.no)}}
    end,
	calculate = function(self, card, context)
		if not context.blueprint_card and not context.destroying_card and not context.cry_ease_dollars and not context.post_trigger then
			if context.jen_lving and context.card and context.card.gc and context.card:gc().key == 'c_black_hole' then
				for i = 1, iterations do
					local strength = kori_strength(((((G.GAME or {}).consumeable_usage or {}).c_black_hole or {}).count or 0) - (iterations - i))
					G.GAME.hands[context.lv_hand].chips = to_big(G.GAME.hands[context.lv_hand].chips):arrow(3, 3)
					G.GAME.hands[context.lv_hand].mult = to_big(G.GAME.hands[context.lv_hand].mult):arrow(3, 3)
				end
				if jl.njr(context)
					if not context.lv_instant then 
						delay(0.5)
						Q(function() card:juice_up(2, 2) return true end)
						play_sound_q('talisman_echip', 1)
						play_sound_q('talisman_echip', 1.25)
						play_sound_q('talisman_echip', 1.5)
						play_sound_q('talisman_emult', 1)
						play_sound_q('talisman_emult', 1.25)
						play_sound_q('talisman_emult', 1.5)
						jl.hcm('^^^3 (x' .. iterations .. ')', '^^^3 (x' .. iterations .. ')', true)
						jl.hcm(G.GAME.hands[context.lv_hand].chips, G.GAME.hands[context.lv_hand].mult)
						delay(0.5)
					end
				end
			end
		end
	end
}]]

--[[SMODS.Joker {
	key = 'baal',
	loc_txt = {
		name = '{C:cry_verdant}Baal',
		text = {
			'When {C:attention}Straddle{} is about to progress,',
			'there is a {C:green}#1#% chance{} for it to {C:attention}rewind progress{} instead',
			'{C:inactive}(Cannot go below Straddle 0)',
			' ',
			caption('#2#'),
			caption('#3#'),
			faceart('raidoesthings'),
			origin('Cult of the Lamb'),
			au('Prophecy of the Broken Crowns')
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	sinis = { x = 2, y = 0 },
	cost = 50,
	fusable = true,
	rarity = 'cry_exotic',
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'jenaym',
	unique = true,
    loc_vars = function(self, info_queue, center)
		local strength = aym_strength()
        return {vars = {strength[1] == 0 and 'x' or string.rep('^', strength[1]), strength[2], Jen.sinister and '...pleaselordhavemercyonme...' or #SMODS.find_card('j_jen_narinder') > 0 and '...Fuck sake...' or 'Is *he* with you? I don\'t', (Jen.sinister or #SMODS.find_card('j_jen_narinder') > 0) and '' or 'want anything to do with you then.'}}
    end,
    calculate = function(self, card, context)
	end
}]]

--[[SMODS.Edition({
    key = "unreal",
    loc_txt = {
        name = "Unreal",
        label = "Unreal",
        text = {
            '{X:cry_twilight,C:cry_blossom,s:3}#1#{}3 Chips & Mult',
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
	misc_badge = {
		colour = G.C.CRY_ASCENDANT,
		text = {
			"Transcendent"
		}
	},
    discovered = true,
    unlocked = true,
    shader = 'unreal',
    config = { hyper_chips = {20, 3}, hyper_mult = {20, 3} },
	sound = {
		sound = 'jen_e_unreal',
		per = 1,
		vol = 0.7
	},
    in_shop = true,
    weight = 0,
    extra_cost = 6666,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { '{20}' } }
    end
})]]

--it'll be a while before we get to this point...
--[[
SMODS.ConsumableType {
	key = 'jen_weapon',
	collection_rows = {5, 5},
	primary_colour = G.C.CHIPS,
	secondary_colour = HEX('6a7f00'),
	loc_txt = {
		collection = 'Weapons',
		name = 'Weapon'
	},
	shop_rate = 0
}

SMODS.ConsumableType {
	key = 'jen_gear',
	collection_rows = {5, 5},
	primary_colour = G.C.CHIPS,
	secondary_colour = HEX('00ffaf'),
	loc_txt = {
		collection = 'Gear',
		name = 'Gear'
	},
	shop_rate = 0
}

SMODS.ConsumableType {
	key = 'jen_bauble',
	collection_rows = {5, 5},
	primary_colour = G.C.CHIPS,
	secondary_colour = HEX('af00af'),
	loc_txt = {
		collection = 'Baubles',
		name = 'Bauble'
	},
	shop_rate = 0
}
]]

--[[
function ease_ante_autoraisewinante(mod)
	local targetante = G.GAME.round_resets.ante + mod
	ease_ante(mod)
	if G.GAME.win_ante < targetante then
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
			ease_winante(targetante - G.GAME.win_ante)
		return true end }))
	end
end
]]