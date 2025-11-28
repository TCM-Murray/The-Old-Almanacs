
function Card:destroy(dissolve_colours, silent, dissolve_time_fac, no_juice)
	self.ability.eternal = nil
	self.ignore_incantation_consumable_in_use = true
	self.true_dissolve = true
	self:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
end

local dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
	-- Check if this is a Joker being destroyed and if "The Saint" is active
	if self.ability and self.ability.set == 'Joker' and G.jokers then
		-- Check if this Joker is currently in the jokers area or if it's being destroyed by Gateway
		local is_in_jokers_area = (self.area == G.jokers)
		local is_being_destroyed_by_gateway = (G.GAME and G.GAME.gateway_destroying_jokers)
		
		-- Only check for protection if the Joker is in the jokers area OR if Gateway is destroying it
		if is_in_jokers_area or is_being_destroyed_by_gateway then
			local saint_active = false
			for i = 1, #G.jokers.cards do
				local joker = G.jokers.cards[i]
				if joker.ability and joker.ability.set == 'Joker' and 
				   (joker:gc().key == 'j_jen_saint' or joker:gc().key == 'j_jen_saint_attuned') then
					saint_active = true
					break
				end
			end
			
			-- If "The Saint" is active and this is being destroyed by Gateway, prevent destruction
			if saint_active and is_being_destroyed_by_gateway then
				-- Show protection message
				card_status_text(self, 'Protected by The Saint', nil, 0.05*self.T.h, G.C.PALE_GREEN, 0.8, 0.6, 1, 1, 'bm', 'jen_enlightened', 0.8, 1)
				-- Don't destroy the Joker, just return
				return
			elseif saint_active and not is_being_destroyed_by_gateway then
			elseif not saint_active and is_being_destroyed_by_gateway then
			end
		end
	end
	
	if self.true_dissolve then
		if self.gc and self:gc().key ~= 'j_jen_kosmos' and self.ability.set ~= 'jen_ability' and self.sell_cost > 0 and not G.screenwipe then
			add_malice(self.sell_cost * 3)
		end
		if (self.edition or {}).jen_encoded then
			for i = 1, (self.edition or {}).codes or 15 do
				local _card = create_card('Code', G.consumeables, nil, nil, nil, nil, nil, 'encoded_cards')
				_card.no_forced_edition = true
				_card:set_edition({negative = true})
				_card:add_to_deck()
				G.consumeables:emplace(_card)
			end
		end
		dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
	elseif ((self.config or {}).center or {}).dissolve_immune then
		card_status_text(card, 'Immune', nil, 0.05*card.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
		if not self.added_to_deck then
			self:add_to_deck()
			if self.ability.set == 'Joker' then G.jokers:emplace(self) else G.consumeables:emplace(self) end
		end
		return
	else
		if self.ability.set ~= 'Voucher' then
			if (self.edition or {}).jen_diplopia then
				card_status_text(self, 'Resist!', nil, 0.05*self.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
				if self.sell_cost > 0 and self.ability.set ~= 'jen_ability' and self.area then
					add_malice(self.sell_cost * 3)
				end
				if Jen.hv('astronomy', 7) and self.ability.set ~= 'jen_ability' and not self.no_astronomy and ((self.ability or {}).set or '') ~= 'Voucher' and ((self.ability or {}).set or '') ~= 'Booster' and self.gc and not self:gc().cant_astronomy then
					local hand = jl.rndhand()
					jl.th(hand)
					fastlv(self, hand, nil, self.sell_cost / 8)
					jl.ch()
				end
				self:set_edition(nil, true)
				if self.area then self.area:remove_card(self) end
				if not self.added_to_deck then self:add_to_deck() end
				if self.playing_card then
					local still_in_playingcard_table = false
					for k, v in pairs(G.playing_cards) do
						if v == self then
							still_in_playingcard_table = true
							break
						end
					end
					if not still_in_playingcard_table then
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						table.insert(G.playing_cards, self)
					end
					G.deck:emplace(self)
				else
					(self.ability.set == 'Joker' and G.jokers or G.consumeables):emplace(self)
					if self.ability.set ~= 'Joker' then
						self:setQty(self.OverrideBulkUseLimit or (self.ability or {}).qty_initial or 1)
					end
				end
				return
			elseif not G.screenwipe then
				if (self.edition or {}).jen_encoded then
					for i = 1, (self.edition or {}).codes or 15 do
						local _card = create_card('Code', G.consumeables, nil, nil, nil, nil, nil, 'encoded_cards')
						_card.no_forced_edition = true
						_card:set_edition({negative = true})
						_card:add_to_deck()
						G.consumeables:emplace(_card)
					end
				end
				if self.sell_cost > 0 and self.ability.set ~= 'jen_ability' and self.area then
					add_malice(self.sell_cost * 3)
				end
				if Jen.hv('astronomy', 8) and self.ability.set ~= 'jen_ability' and not self.no_astronomy and ((self.ability or {}).set or '') ~= 'Voucher' and ((self.ability or {}).set or '') ~= 'Booster' and self.gc and not self:gc().cant_astronomy then
					local hand = jl.rndhand()
					jl.th(hand)
					fastlv(self, hand, nil, self.sell_cost / 8)
					jl.ch()
					Q(function() dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice) return true end)
				else
					dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
				end
			else
				dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
			end
		else
			if self.sell_cost > 0 and not G.screenwipe then
				if self.ability.set ~= 'jen_ability' then
					add_malice(self.sell_cost * 3)
				end
				if Jen.hv('astronomy', 8) and self.ability.set ~= 'jen_ability' and not self.no_astronomy and (self.facing or 'down') == 'up' and ((self.ability or {}).set or '') ~= 'Voucher' and ((self.ability or {}).set or '') ~= 'Booster' and self.gc and not self:gc().cant_astronomy then
					local hand = jl.rndhand()
					jl.th(hand)
					fastlv(self, hand, nil, self.sell_cost / 8)
					jl.ch()
					Q(function() dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice) return true end)
				else
					dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
				end
			end
		end
	end
end

local shatter_ref = Card.shatter

function Card:shatter()
	if ((self.config or {}).center or {}).dissolve_immune then
		card_status_text(card, 'Immune', nil, 0.05*card.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
		if not self.added_to_deck then
			self:add_to_deck()
			if self.ability.set == 'Joker' then G.jokers:emplace(self) else G.consumeables:emplace(self) end
		end
		return
	else
		if self.ability.set ~= 'Voucher' then
			if (self.edition or {}).jen_diplopia then
				card_status_text(self, 'Resist!', nil, 0.05*self.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
				if self.sell_cost > 0 and self.ability.set ~= 'jen_ability' and self.area then
					add_malice(self.sell_cost * 3)
				end
				if Jen.hv('astronomy', 8) and self.ability.set ~= 'jen_ability' and not self.no_astronomy and ((self.ability or {}).set or '') ~= 'Voucher' and ((self.ability or {}).set or '') ~= 'Booster' and self.gc and not self:gc().cant_astronomy then
					local hand = jl.rndhand()
					jl.th(hand)
					fastlv(self, hand, nil, self.sell_cost / 8)
					jl.ch()
				end
				self:set_edition(nil, true)
				if self.area then self.area:remove_card(self) end
				if not self.added_to_deck then self:add_to_deck() end
				if self.playing_card then
					local still_in_playingcard_table = false
					for k, v in pairs(G.playing_cards) do
						if v == self then
							still_in_playingcard_table = true
							break
						end
					end
					if not still_in_playingcard_table then
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						table.insert(G.playing_cards, self)
					end
					G.deck:emplace(self)
				else
					(self.ability.set == 'Joker' and G.jokers or G.consumeables):emplace(self)
					if self.ability.set ~= 'Joker' then
						self:setQty((self.ability or {}).qty_initial or 1)
					end
				end
				return
			else
				if (self.edition or {}).jen_encoded then
					for i = 1, (self.edition or {}).codes or 15 do
						local _card = create_card('Code', G.consumeables, nil, nil, nil, nil, nil, 'encoded_cards')
						_card.no_forced_edition = true
						_card:set_edition({negative = true})
						_card:add_to_deck()
						G.consumeables:emplace(_card)
					end
				end
				if self.sell_cost > 0 and not G.screenwipe then
					if self.ability.set ~= 'jen_ability' then
						add_malice(self.sell_cost * 3)
					end
					if Jen.hv('astronomy', 8) and self.ability.set ~= 'jen_ability' and not self.no_astronomy and ((self.ability or {}).set or '') ~= 'Voucher' and ((self.ability or {}).set or '') ~= 'Booster' and self.gc and not self:gc().cant_astronomy then
						local hand = jl.rndhand()
						jl.th(hand)
						fastlv(self, hand, nil, self.sell_cost / 8)
						jl.ch()
						Q(function() shatter_ref(self) return true end)
					else
						shatter_ref(self)
					end
				end
			end
		else
			if self.sell_cost > 0 and not G.screenwipe then
				if self.ability.set ~= 'jen_ability' then
					add_malice(self.sell_cost * 3)
				end
				if Jen.hv('astronomy', 8) and not self.no_astronomy and ((self.ability or {}).set or '') ~= 'Voucher' and ((self.ability or {}).set or '') ~= 'Booster' and self.gc and not self:gc().cant_astronomy then
					local hand = jl.rndhand()
					jl.th(hand)
					fastlv(self, hand, nil, self.sell_cost / 8)
					jl.ch()
					Q(function() shatter_ref(self) return true end)
				else
					shatter_ref(self)
				end
			end
		end
	end
end

local csdr = Card.set_debuff
function Card:set_debuff(should_debuff)
	if #SMODS.find_card('j_jen_dandy') > 0 then
		return false
	elseif (((self.config or {}).center or {}).debuff_immune or (((self.config or {}).center or {}).rarity or 1) == 6) and should_debuff == true then
		card_status_text(self, 'Immune', nil, 0.05*self.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
		return false
	else
		csdr(self, should_debuff)
	end
end

local misprintedition_config = {
	additive = {0, 50},
	multiplicative = 5,
	exponential = 1.3
}

local ser = Card.set_edition
function Card:set_edition(edition, immediate, silent)
	if (((self.config or {}).center or {}).set or '') == 'jen_ability' and not (edition or {}).negative then
		return
	elseif ((self.config or {}).center or {}).cannot_edition then
		return
	elseif ((self.config or {}).center or {}).edition_immune then
		local immunity = self.gc and self:gc().edition_immune
		if type(immunity) ~= 'string' or (edition or {})[immunity] then
			card_status_text(self, localize('k_nope_ex'), nil, 0.05*self.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
			return
		else
			ser(self, edition, immediate, silent)
			if self.edition then
				if self.edition.jen_misprint then
					self.edition.chips = pseudorandom('misprintedition_1', misprintedition_config.additive[1], misprintedition_config.additive[2])
					self.edition.mult = pseudorandom('misprintedition_2', misprintedition_config.additive[1], misprintedition_config.additive[2])
					self.edition.x_chips = 1 + (jl.round(pseudorandom('misprintedition_3'), 2) * (misprintedition_config.multiplicative - 1))
					self.edition.x_mult = 1 + (jl.round(pseudorandom('misprintedition_4'), 2) * (misprintedition_config.multiplicative - 1))
					self.edition.e_chips = 1 + (jl.round(pseudorandom('misprintedition_5'), 3) * (misprintedition_config.exponential - 1))
					self.edition.e_mult = 1 + (jl.round(pseudorandom('misprintedition_6'), 3) * (misprintedition_config.exponential - 1))
				end
			end
		end
	else
		ser(self, edition, immediate, silent)
		if self.edition then
			if self.edition.jen_misprint then
				self.edition.chips = pseudorandom('misprintedition_1', misprintedition_config.additive[1], misprintedition_config.additive[2])
				self.edition.mult = pseudorandom('misprintedition_2', misprintedition_config.additive[1], misprintedition_config.additive[2])
				self.edition.x_chips = 1 + (jl.round(pseudorandom('misprintedition_3'), 2) * (misprintedition_config.multiplicative - 1))
				self.edition.x_mult = 1 + (jl.round(pseudorandom('misprintedition_4'), 2) * (misprintedition_config.multiplicative - 1))
				self.edition.e_chips = 1 + (jl.round(pseudorandom('misprintedition_5'), 3) * (misprintedition_config.exponential - 1))
				self.edition.e_mult = 1 + (jl.round(pseudorandom('misprintedition_6'), 3) * (misprintedition_config.exponential - 1))
			end
		end
	end
end

local etref = Card.set_eternal
function Card:set_eternal(e)
	if ((self.config or {}).center or {}).permaeternal then
		self.ability.eternal = true
	else
		etref(self, e)
	end
end

local blank_types = {
	'Planet',
	'Spectral',
	'Tarot',
	'Code'
}

local function can_use_booster()
	return (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SHOP or G.CONTROLLER.locked or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) and not jl.booster()
end

G.FUNCS.jen_canopenpack = function(e)
    local card = e.config.ref_table
    if not can_use_booster() then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.SECONDARY_SET.Tarot
        e.config.button = 'jen_openpack'
    end
end

G.FUNCS.jen_openpack = function(e)
    local card = e.config.ref_table
	if card.config.center.set == 'Booster' then
		Q(function()
			local ncard = Card(
				G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
				G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
				G.CARD_W * 1.27,
				G.CARD_H * 1.27,
				G.P_CARDS.empty,
				G.P_CENTERS[card.config.center.key],
				{ bypass_discovery_center = true, bypass_discovery_ui = true }
			)
			ncard:start_materialize()
			if card.edition then ncard:set_edition(card.edition, true, true) end
			ncard.from_tag = true
			ncard.cost = 0
			ncard:fire()
		return true end)
		card:destroy()
	end
end

G.FUNCS.jen_canredeemvoucher = function(e)
    local card = e.config.ref_table
    if not jl.canuse() then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.SECONDARY_SET.Spectral
        e.config.button = 'jen_redeemvoucher'
    end
end

G.FUNCS.jen_redeemvoucher = function(e)
    local card = e.config.ref_table
	if card.config.center.set == 'Voucher' then
		jl.voucher(card.config.center.key)
		card:destroy()
	end
end

local gfucr = G.FUNCS.use_card

G.FUNCS.use_card = function(e, mute, nosave)
	local card = e.config.ref_table
	if card then
		if not can_use_booster() and card.config.center.set == 'Booster' then
			if card.area then card.area:remove_card(card) end
			G.consumeables:emplace(card)
			G.from_tag = true
			G.sell_cost = 0
			G.sell_cost_label = 0
			G.cost = 0
			return
		end
	end
	gfucr(e, mute, nosave)
end



--CONSUMABLES
for k, v in pairs(blank_types) do
	SMODS.Consumable {
		key = 'blank' .. string.lower(v),
		loc_txt = {
			name = 'Blank ' .. v,
			text = {
				'Copies the {C:attention}next',
				'{C:' .. string.lower(v) .. '}' .. v .. '{} card used',
				'{C:inactive,s:0.6}(Only works in Consumables tray)',
				'{C:inactive,s:0.6}(If in a different tray, use this card to add it to Consumables tray)',
				'{C:inactive}(Must have room)',
				'{C:inactive,s:0.8}(Other blanks' .. (v == 'Spectral' and ', The Genius, and POINTER://' or '') .. ' excluded)'
			}
		},
		set = v,
		pos = { x = (k - 1), y = 0 },
		cost = 2,
		aurinko = v == 'Planet',
		unlocked = true,
		discovered = true,
		atlas = 'jenblanks',
		can_use = function(self, card)
			return (card.area or {}) ~= G.consumeables and #G.consumeables < G.consumeables.config.card_limit
		end,
		use = function(self, card, area, copier)
			if not card.already_used_once then
				card.already_used_once = true
				local card2 = copy_card(card)
				card2:add_to_deck()
				G.consumeables:emplace(card2)
			end
		end
	}
end

local supported_tags = {
	{'tag_standard', 'Standard', 0, 0, 3},
	{'tag_charm', 'Charm', 1, 0, 5},
	{'tag_meteor', 'Meteor', 2, 0, 5},
	{'tag_ethereal', 'Ethereal', 3, 0, 5},
	{'tag_buffoon', 'Buffoon', 4, 0, 8},
	{'tag_cry_bundle', 'Bundle', 1, 1, 10},
	{'tag_uncommon', 'Uncommon', 2, 1, 3},
	{'tag_rare', 'Rare', 3, 1, 5},
	{'tag_cry_epic', 'Epic', 4, 1, 8},
	{'tag_foil', 'Foil', 1, 3, 3},
	{'tag_holo', 'Holographic', 2, 3, 4},
	{'tag_polychrome', 'Polychrome', 3, 3, 5},
	{'tag_negative', 'Negative', 4, 3, 10},
	{'tag_investment', 'Investment', 0, 3, 8},
	{'tag_voucher', 'Voucher', 4, 5, 5},
	{'tag_handy', 'Handy', 1, 5, 8},
	{'tag_garbage', 'Garbage', 0, 5, 6},
	{'tag_coupon', 'Coupon', 4, 4, 10},
	{'tag_juggle', 'Juggle', 2, 5, 2},
	{'tag_d_six', 'Dice', 0, 4, 2},
	{'tag_top_up', 'Top-up', 2, 4, 2},
	{'tag_skip', 'Speed', 4, 2, 7},
	{'tag_economy', 'Economy', 5, 2, 10},
	{'tag_double', 'Double', 0, 2, 6},
	{'tag_cry_triple', 'Triple', 1, 2, 8},
	{'tag_cry_quadruple', 'Quadruple', 2, 2, 10},
	{'tag_cry_quintuple', 'Quintuple', 3, 2, 13},
	{'tag_cry_memory', 'Memory', 5, 4, 8}
}

for k, v in pairs(supported_tags) do
	SMODS.Consumable {
		key = 'token_' .. v[1],
		set = 'jen_tokens',
		loc_txt = {
			name = v[2] .. ' Token',
			text = {
				'Use to create a',
				('{C:attention}' .. v[2] .. ' Tag'),
				spriter('cozyori')
			},
		},
		pos = {x = v[3], y = v[4]},
		cost = v[5],
		unlocked = true,
		discovered = true,
		atlas = 'jentokens',
		can_stack = true,
		can_divide = true,
		in_pool = function(self)
			-- Check if the corresponding tag exists and is not disabled by Cryptid
			local tag_key = v[1]
			if not G.P_TAGS or not G.P_TAGS[tag_key] then
				return false
			end
			-- Check if Cryptid has disabled this tag
			local tag_obj = G.P_TAGS[tag_key]
			if tag_obj and tag_obj.cry_disabled then
				return false
			end
			return true
		end,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			play_sound('jen_e_gilded', 1.25, 0.4)
			local tag_key = v[1]
			if G.P_TAGS and G.P_TAGS[tag_key] then
				add_tag(Tag(tag_key))
			else
				-- Fallback: delay tag creation until next frame when mods are fully loaded
				G.E_MANAGER:add_event(Event({
					func = function()
						if G.P_TAGS and G.P_TAGS[tag_key] then
							add_tag(Tag(tag_key))
						end
						return true
					end
				}))
			end
		end,
		bulk_use = function(self, card, area, copier, number)
			play_sound('jen_e_gilded', 1.25, 0.4)
			local tag_key = v[1]
			for i = 1, number do
				if G.P_TAGS and G.P_TAGS[tag_key] then
					add_tag(Tag(tag_key))
				else
					G.E_MANAGER:add_event(Event({
						func = function()
							if G.P_TAGS and G.P_TAGS[tag_key] then
								add_tag(Tag(tag_key))
							end
							return true
						end
					}))
				end
			end
		end
	}
end

local torat = function(self, card, badges)
	badges[#badges + 1] = create_badge("Torat", get_type_colour(self or card.config, card), G.C.RED, 1.2)
end

SMODS.Consumable {
	key = 'reverse_fool',
	set = 'Spectral',
	loc_txt = {
		name = 'The Genius',
		text = {
			'Recreate {C:attention}all consumables',
			'you have {C:attention}used throughout the run{} as {C:dark_edition}Negatives',
			'{C:inactive,s:0.7}(The Genius, POINTER://, and Omega consumables excluded)',
			'{X:attention,C:white,s:2}x2{C:red,s:2} Ante',
			spriter('virtuecpu')
		}
	},
	set_card_type_badge = torat,
	pos = { x = 9, y = 2 },
	cost = 50,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.001,
	atlas = 'jenrtarots',
	can_use = function(self, card)
		return jl.canuse() and next(G.GAME.consumeable_usage or {})
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(G.GAME.consumeable_usage) do
			if k ~= 'c_jen_reverse_fool' and k ~= 'c_cry_pointer' and not string.find(k, '_omega') and not string.find(k, 'jen_cheat') then
				Q(function()
					local neg = create_card(v.set, G.consumeables, nil, nil, nil, nil, k, nil)
					neg.no_forced_edition = true
					neg:set_edition({negative = true})
					neg.no_forced_edition = nil
					neg:setQty(v.count)
					neg:add_to_deck()
					G.consumeables:emplace(neg)
					return true
				end, 0.1)
			end
		end
		add_malice(math.max(5000, get_malice()))
		multante()
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(G.GAME.consumeable_usage) do
			if k ~= 'c_jen_reverse_fool' and not string.find(k, '_omega') then
				Q(function()
					local neg = create_card(v.set, G.consumeables, nil, nil, nil, nil, k, nil)
					neg.no_forced_edition = true
					neg:set_edition({negative = true})
					neg.no_forced_edition = nil
					neg:setQty(v.count * number)
					neg:add_to_deck()
					G.consumeables:emplace(neg)
					return true
				end, 0.1)
			end
		end
		add_malice(math.max(5000 * number, get_malice() * (2^number)))
		multante(number)
	end
}

local function createfulldeck(enhancement, edition, amount, emplacement)
	local cards = {}
	for k, v in pairs(G.P_CARDS) do
		local front = v
		for i = 1, (amount or 1) do
			Q(function()
				cards[i] = true
				G.playing_card = (G.playing_card and G.playing_card + 1) or 1
				local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, v, enhancement or G.P_CENTERS.c_base, {playing_card = G.playing_card})
				if edition then
					card:set_edition(type(edition) == 'table' and edition or {[edition] = true}, true, true)
				end
				play_sound('card1')
				table.insert(G.playing_cards, card)
				card:add_to_deck()
				if emplacement then emplacement:emplace(card) else G.deck:emplace(card) end
				return true
			end, 0.1)
		end
	end
	Q(function()
		if next(cards) then
			playing_card_joker_effects(cards)
		end
	return true end)
	Q(function() cards = nil return true end)
end

local function createcardset(needle, enhancement, edition, amount, emplacement)
	local cards = {}
	for k, v in pairs(G.P_CARDS) do
		if string.find(k, needle) then
			local front = v
			for i = 1, (amount or 1) do
				Q(function()
					cards[i] = true
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, v, enhancement or G.P_CENTERS.c_base, {playing_card = G.playing_card})
					if edition then
						card:set_edition(type(edition) == 'table' and edition or {[edition] = true}, true, true)
					end
					play_sound('card1')
					table.insert(G.playing_cards, card)
					card:add_to_deck()
					if emplacement then emplacement:emplace(card) else G.deck:emplace(card) end
					return true
				end, 0.1)
			end
		end
	end
	Q(function()
		if next(cards) then
			playing_card_joker_effects(cards)
		end
	return true end)
	Q(function() cards = nil return true end)
end

local enhancetarots_info = {
	{
		b = 'magician',
		n = 'The Scientist',
		o = 'The Magician',
		c = 'Lucky',
		a = 'smg9000',
		e = G.P_CENTERS.m_lucky,
		p = { x = 8, y = 2 },
		omega = 1
	},
	{
		b = 'empress',
		n = 'The Peasant',
		o = 'The Empress',
		c = 'Mult',
		a = 'ocksie',
		e = G.P_CENTERS.m_mult,
		p = { x = 6, y = 2 },
		omega = 3,
	},
	{
		b = 'hierophant',
		n = 'The Adversary',
		o = 'The Hierophant',
		c = 'Bonus',
		a = 'lutitious',
		e = G.P_CENTERS.m_bonus,
		p = { x = 4, y = 2 },
		omega = 5
	},
	{
		b = 'lovers',
		n = 'The Rivals',
		o = 'The Lovers',
		c = 'Wild',
		a = 'footlongdingledong',
		e = G.P_CENTERS.m_wild,
		p = { x = 3, y = 2 },
		omega = 6
	},
	{
		b = 'chariot',
		n = 'The Hitchhiker',
		o = 'The Chariot',
		c = 'Steel',
		a = 'mailingway',
		e = G.P_CENTERS.m_steel,
		p = { x = 2, y = 2 },
		omega = 7
	},
	{
		b = 'justice',
		n = 'Injustice',
		o = 'Justice',
		c = 'Glass',
		a = 'mailingway',
		e = G.P_CENTERS.m_glass,
		p = { x = 1, y = 2 },
		omega = 8
	},
	{
		b = 'devil',
		n = 'The Angel',
		o = 'The Devil',
		c = 'Gold',
		a = 'gudusername_53951',
		e = G.P_CENTERS.m_gold,
		p = { x = 4, y = 1 },
		omega = 15,
	},
	{
		b = 'tower',
		n = 'The Collapse',
		o = 'The Tower',
		c = 'Stone',
		a = 'astralightsky',
		e = G.P_CENTERS.m_stone,
		p = { x = 3, y = 1 },
		omega = 16
	}
}

for k, v in ipairs(enhancetarots_info) do
	SMODS.Consumable {
		key = 'reverse_' .. v.b,
		set = 'Spectral',
		loc_txt = {
			name = v.n,
			text = {
				'Creates a {C:green}full deck{} of {C:attention}' .. v.c .. '',
				'cards and {C:blue}adds them to your deck',
				spriter(v.a)
			}
		},
		set_card_type_badge = torat,
		config = {},
		pos = v.p,
		cost = 13,
		aurinko = true,
		unlocked = true,
		discovered = true,
		hidden = true,
		soul_rate = 0.002,
		atlas = 'jenrtarots',
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			createfulldeck(v.e, not (card.edition or {}).negative and card.edition or nil)
			add_malice(80)
		end,
		bulk_use = function(self, card, area, copier, number)
			createfulldeck(v.e, not (card.edition or {}).negative and card.edition or nil, number)
			add_malice(80 * number)
		end
	}
end

SMODS.Consumable {
	key = 'reverse_high_priestess',
	set = 'Spectral',
	loc_txt = {
		name = 'The Low Laywoman',
		text = {
			'Create {C:attention}#1#',
			'{C:planet}Meteor {C:attention}Tags',
			spriter('ocksie')
		}
	},
	set_card_type_badge = torat,
	config = {extra = {planetpacks = 10}},
	pos = { x = 7, y = 2 },
	cost = 13,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.planetpacks}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for i = 1, card.ability.extra.planetpacks do
			add_tag(Tag('tag_meteor'))
		end
		add_malice(200)
	end,
	bulk_use = function(self, card, area, copier, number)
		for i = 1, card.ability.extra.planetpacks * number do
			add_tag(Tag('tag_meteor'))
		end
		add_malice(200 * number)
	end
}

SMODS.Consumable {
	key = 'reverse_emperor',
	set = 'Spectral',
	loc_txt = {
		name = 'The Servant',
		text = {
			'Gives {C:attention}#1#{C:spectral} Ethereal',
			'and {C:tarot}Charm{C:attention} Tags',
			'{C:attention}+1{C:red} Ante',
			spriter('reddz_')
		}
	},
	set_card_type_badge = torat,
	config = {extra = {tags = 5}},
	pos = { x = 5, y = 2 },
	cost = 13,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.tags}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for i = 1, card.ability.extra.tags do
			add_tag(Tag('tag_ethereal'))
			add_tag(Tag('tag_charm'))
		end
		ease_ante(1)
		add_malice(50)
	end,
	bulk_use = function(self, card, area, copier, number)
		for i = 1, card.ability.extra.tags * number do
			add_tag(Tag('tag_ethereal'))
			add_tag(Tag('tag_charm'))
		end
		ease_ante(number)
		add_malice(50 * number)
	end
}

local function rhermittotal()
	if not G.jokers or not G.hand or not G.consumeables or not G.deck then return 0 end
	local value = 0
	for k, v in pairs(G.hand.cards) do
		value = value + (v.sell_cost or 0)
	end
	for k, v in pairs(G.jokers.cards) do
		value = value + (v.sell_cost or 0)
	end
	for k, v in pairs(G.consumeables.cards) do
		value = value + (v.sell_cost or 0)
	end
	for k, v in pairs(G.deck.cards) do
		value = value + (v.sell_cost or 0)
	end
	return value
end

local function rtemperancemult()
	if not G.jokers then return 2 end
	return 2 + #G.jokers.cards
end

SMODS.Consumable {
	key = 'reverse_hermit',
	set = 'Spectral',
	loc_txt = {
		name = 'The Extrovert',
		text = {
			'Gives you {C:money}money{} equal to the',
			'{C:money}net sell value{} of {C:attention,s:1.5}ALL{} cards you have',
			'{C:inactive}(Currently {C:money}$#1#{C:inactive})',
			'{C:attention}+2{C:red} Ante',
			spriter('laviolive')
		}
	},
	set_card_type_badge = torat,
	pos = { x = 0, y = 2 },
	cost = 30,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {rhermittotal()}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		ease_dollars(rhermittotal())
		ease_ante(2)
		add_malice(150)
	end,
	bulk_use = function(self, card, area, copier, number)
		ease_dollars(rhermittotal() * number)
		ease_ante(2 * number)
		add_malice(150 * number)
	end
}

SMODS.Consumable {
	key = 'reverse_wheel',
	set = 'Spectral',
	loc_txt = {
		name = 'The Disc of Penury',
		text = {
			'{C:attention}Randomises{} the {C:dark_edition}editions{} of',
			'your {C:attention}Jokers{}, {C:attention}consumables{} and {C:attention}playing cards',
			'{C:attention}+1{C:red} Ante',
			'{C:inactive,s:0.8}(Some editions are excluded from the pool)',
			'{C:inactive,s:0.8}(Does not randomise Negative cards)',
			spriter('ocksie')
		}
	},
	set_card_type_badge = torat,
	pos = { x = 9, y = 1 },
	cost = 25,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(G.jokers.cards) do
			if not (v.edition or {}).negative and not v:is_exotic_edition() then
				v:set_edition({[random_editions[pseudorandom('disc1', 1, #random_editions)]] = true}, k > 50, k > 50)
			end
		end
		for k, v in pairs(G.hand.cards) do
			if not (v.edition or {}).negative and not v:is_exotic_edition() then
				v:set_edition({[random_editions[pseudorandom('disc2', 1, #random_editions)]] = true}, k > 52, k > 52)
			end
		end
		for k, v in pairs(G.deck.cards) do
			if not (v.edition or {}).negative and not v:is_exotic_edition() then
				v:set_edition({[random_editions[pseudorandom('disc3', 1, #random_editions)]] = true}, true, true)
			end
		end
		for k, v in pairs(G.consumeables.cards) do
			if not (v.edition or {}).negative and not v:is_exotic_edition() and v.ability.set ~= 'jen_ability' then
				v:set_edition({[random_editions[pseudorandom('disc4', 1, #random_editions)]] = true}, k > 20, k > 20)
			end
		end
		ease_ante(1)
		add_malice(200)
	end
}

SMODS.Consumable {
	key = 'reverse_strength',
	set = 'Spectral',
	loc_txt = {
		name = 'Infirmity',
		text = {
			'{C:attention}+#1#{} hand size',
			'{C:attention}+#1#{} maximum selectable cards',
			'{C:attention}+1{C:red} Ante',
			spriter('raut44')
		}
	},
	set_card_type_badge = torat,
	pos = { x = 8, y = 1 },
	config = {extra = {increase = 1}},
	cost = 20,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.ceil(center.ability.extra.increase)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		G.hand:change_size(math.ceil(card.ability.extra.increase))
		G.hand:change_max_highlight(math.ceil(card.ability.extra.increase))
		ease_ante(1)
		add_malice(175)
	end,
	bulk_use = function(self, card, area, copier, number)
		G.hand:change_size(math.ceil(card.ability.extra.increase) * number)
		G.hand:change_max_highlight(math.ceil(card.ability.extra.increase) * number)
		ease_ante(number)
		add_malice(175 * number)
	end
}

SMODS.Consumable {
	key = 'reverse_hanged_man',
	set = 'Spectral',
	loc_txt = {
		name = 'Zen',
		text = {
			'{C:attention}Reset{} your deck to',
			'a {C:attention}standard 52-card deck',
			spriter('gudusername_53951')
		}
	},
	config = {extra = {destruction = 0.5}},
	set_card_type_badge = torat,
	pos = { x = 7, y = 1 },
	cost = 15,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.min(100, center.ability.extra.destruction * 100), math.ceil(#(G.playing_cards or {}) * center.ability.extra.destruction)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		Q(function()
			for k, v in pairs(G.playing_cards) do
				v:destroy()
			end
		return true end)
		jl.rd(1)
		createfulldeck()
	end
}

SMODS.Consumable {
	key = 'reverse_death',
	set = 'Spectral',
	loc_txt = {
		name = 'Life',
		text = {
			'Duplicate {C:attention}every card{} in',
			'{C:blue}your hand',
			spriter('ocksie')
		}
	},
	set_card_type_badge = torat,
	pos = { x = 6, y = 1 },
	cost = 10,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
	can_use = function(self, card)
		return jl.canuse() and #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		local cards = {}
		for k, v in pairs(G.hand.cards) do
			G.playing_card = (G.playing_card and G.playing_card + 1) or 1
			local copy = copy_card(v, nil, nil, G.playing_card)
			copy:add_to_deck()
			copy:start_materialize()
			table.insert(cards, copy)
		end
		for k, v in pairs(cards) do
			if v ~= card then
				table.insert(G.playing_cards, v)
				G.hand:emplace(v)
			end
		end
		add_malice(60)
		playing_card_joker_effects(cards)
	end
}

SMODS.Consumable {
	key = 'reverse_temperance',
	set = 'Spectral',
	loc_txt = {
		name = 'Prodigality',
		text = {
			'Multiplies your {C:money}money{} by',
			'{C:attention}the number of Jokers{} you have {C:green}plus two',
			'{C:inactive}(Currently {X:money,C:white}$x#1#{C:tarot} = {C:money}$#2#{C:inactive})',
			'{X:attention,C:white,s:2}x2{C:red,s:2} Ante',
			spriter('raut44')
		}
	},
	set_card_type_badge = torat,
	pos = { x = 5, y = 1 },
	cost = 30,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {rtemperancemult(), math.min(1e308, (G.GAME.dollars or 0) * rtemperancemult())}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		ease_dollars(math.min(1e308, G.GAME.dollars * (rtemperancemult()) - G.GAME.dollars))
		multante()
		add_malice(1000)
	end,
	bulk_use = function(self, card, area, copier, number)
		ease_dollars(math.min(1e308, G.GAME.dollars * (rtemperancemult()^number) - G.GAME.dollars))
		multante(number)
		add_malice(1000)
	end
}

local suittarots_info = {
	{
		b = 'star',
		n = 'The Flash',
		s = 'Diamonds',
		a = 'mailingway',
		p = { x = 2, y = 1 },
		o = 17
	},
	{
		b = 'moon',
		n = 'The Eclipse',
		s = 'Clubs',
		a = 'ocksie',
		p = { x = 1, y = 1 },
		o = 18
	},
	{
		b = 'sun',
		n = 'The Darkness',
		s = 'Hearts',
		a = 'laviolive',
		p = { x = 0, y = 1 },
		o = 19
	},
	{
		b = 'world',
		n = 'Desolate',
		s = 'Spades',
		a = 'aphi.s.soos',
		p = { x = 8, y = 0 },
		o = 21
	}
}

for kk, vv in pairs(suittarots_info) do
	SMODS.Consumable {
		key = 'reverse_' .. vv.b,
		set = 'Spectral',
		loc_txt = {
			name = vv.n,
			text = {
				'Duplicate {C:attention}all{} of your',
				'{C:' .. string.lower(vv.s) .. '}' .. string.sub(vv.s, 1, string.len(vv.s) - 1) .. '{} card(s)',
				'{s:0.7}Also considers {C:attention,s:0.7}Wilds',
				'{s:0.7}and any {C:attention,s:0.7}Joker effects{s:0.7},',
				'{s:0.7}bypasses {C:red,s:0.7}debuffs',
				spriter(vv.a)
			}
		},
		set_card_type_badge = torat,
		pos = vv.p,
		cost = 30,
		unlocked = true,
		discovered = true,
		hidden = true,
		soul_rate = 0.002,
		atlas = 'jenrtarots',
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			local cards = {}
			local handcards = {}
			local deckcards = {}
			if next(G.hand.cards) then
				for k, v in pairs(G.hand.cards) do
					if v:is_suit(vv.s, true) then
						cards[#cards + 1] = true
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						local copy = copy_card(v, nil, nil, G.playing_card)
						copy:add_to_deck()
						copy:start_materialize()
						table.insert(handcards, copy)
					end
				end
			end
			if next(G.deck.cards) then
				for k, v in pairs(G.deck.cards) do
					if v:is_suit(vv.s, true) then
						cards[#cards + 1] = true
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						local copy = copy_card(v, nil, nil, G.playing_card)
						copy:add_to_deck()
						copy:start_materialize()
						table.insert(deckcards, copy)
					end
				end
			end
			if next(handcards) then
				for k, v in pairs(handcards) do
					if v ~= card then
						table.insert(G.playing_cards, v)
						G.hand:emplace(v)
					end
				end
			end
			if next(deckcards) then
				for k, v in pairs(deckcards) do
					if v ~= card then
						table.insert(G.playing_cards, v)
						G.deck:emplace(v)
					end
				end
			end
			if #cards > 0 then playing_card_joker_effects(cards) end
			add_malice(100)
		end
	}
end

SMODS.Consumable {
	key = 'reverse_judgement',
	set = 'Spectral',
	loc_txt = {
		name = 'Cunctation',
		text = {
			'Gives {C:attention}#1# {X:inactive}Buffoon',
			'and {C:attention}Standard Tags',
			spriter('mailingway')
		}
	},
	set_card_type_badge = torat,
	config = {extra = {tags = 5}},
	pos = { x = 9, y = 0 },
	cost = 13,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.002,
	atlas = 'jenrtarots',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.tags}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for i = 1, card.ability.extra.tags do
			add_tag(Tag('tag_buffoon'))
			add_tag(Tag('tag_standard'))
		end
		add_malice(250)
	end,
	bulk_use = function(self, card, area, copier, number)
		for i = 1, card.ability.extra.tags * number do
			add_tag(Tag('tag_buffoon'))
			add_tag(Tag('tag_standard'))
		end
		add_malice(250)
	end
}

SMODS.Consumable {
	key = 'obfuscation',
	set = 'Spectral',
	loc_txt = {
		name = 'Obfuscation',
		text = {
			'{C:green,E:1}Randomises{} all cards in hand',
			'{C:inactive}(Rank, seal, edition, enhancement and suit)',
			spriter('ocksie')
		}
	},
	pos = { x = 0, y = 4 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
	can_use = function(self, card)
		return jl.canuse() and #((G.hand or {}).cards or {}) > 0
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound('tarot1')
			card:juice_up(0.3, 0.5)
			return true
		end }))
		jl.randomise(G.hand.cards)
		delay(0.5)
	end
}

SMODS.Consumable {
	key = 'bisection',
	set = 'Spectral',
	loc_txt = {
		name = 'Bisection',
		text = {
			'{C:green}Randomly {C:red}destroy {C:attention}#1#% {C:inactive}(#2#){} of all owned',
			'playing cards for {C:attention}+#3#{} Joker slot(s)',
			spriter('cozyori')
		}
	},
	config = {extra = {destruction = 0.5, slots = 1}},
	pos = { x = 1, y = 4 },
	cost = 5,
	unlocked = true,
	discovered = true,
	no_ratau = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.min(99.99, center.ability.extra.destruction * 100), math.min(math.ceil(#(G.playing_cards or {}) * center.ability.extra.destruction), math.max(0, #(G.playing_cards or {}) - 1)), center.ability.extra.slots}}
    end,
	can_use = function(self, card)
		return jl.canuse() and #G.playing_cards > 1
	end,
	use = function(self, card, area, copier)
		local todestroy = 0
		local targets = {}
		local count = #G.playing_cards
		local allcards = G.playing_cards
		if count > 1 then
			todestroy = math.min(count - 1, math.ceil(count * card.ability.extra.destruction))
			while todestroy > 0 do
				local sel = allcards[pseudorandom('offering1', 1, count)]
				if not sel.rhm then
					sel.rhm = true
					if sel.area then sel.area:remove_card(sel) end
					table.insert(targets, sel)
					todestroy = todestroy - 1
				end
			end
		end
		if #targets > 0 then
			for k, v in pairs(targets) do
				v.rhm = false
				v:start_dissolve()
				add_malice(v.sell_cost * 3)
			end
			jl.jokers({ remove_playing_cards = true, removed = targets })
		end
		delay(0.5)
		Q(function()
			if G.jokers then 
				G.jokers:change_size_absolute(card.ability.extra.slots)
			end
			todestroy = nil
			targets = nil
			count = nil
			cards = nil
			return true
		end)
	end
}

SMODS.Consumable {
	key = 'conjure',
	set = 'Spectral',
	loc_txt = {
		name = 'Conjure',
		text = {
			'Creates up to {C:attention}#1#',
			'{C:spectral}Spectral{} card(s)',
			'{C:inactive}(Must have room)',
			spriter('mailingway')
		}
	},
	config = {extra = {spectrals = 2}},
	pos = { x = 2, y = 4 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.ceil(center.ability.extra.spectrals)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(math.ceil(card.ability.extra.spectrals), G.consumeables.config.card_limit - #G.consumeables.cards) do
			Q(function()
				if G.consumeables.config.card_limit > #G.consumeables.cards then
					play_sound('jen_draw')
					local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'pri')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
				end
				return true
			end, 0.4, nil, 'after')
		end
		delay(0.6)
	end,
	bulk_use = function(self, card, area, copier, number)
		for i = 1, math.min(math.ceil(card.ability.extra.spectrals) * number, G.consumeables.config.card_limit - #G.consumeables.cards) do
			Q(function()
				if G.consumeables.config.card_limit > #G.consumeables.cards then
					play_sound('jen_draw')
					local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'pri')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
				end
				return true
			end, 0.4, nil, 'after')
		end
		delay(0.6)
	end
}

SMODS.Consumable {
	key = 'shadows',
	set = 'Spectral',
	loc_txt = {
		name = 'Shadows',
		text = {
			'Create {C:attention}#1#{} {C:green}random',
			'{C:dark_edition}Negative {C:attention}Perishable {C:attention}Joker(s){},',
			'set {C:money}sell value{} of {C:attention}all Jokers{} to {C:money}$0',
			spriter('mailingway')
		}
	},
	config = {extra = {shadows = 2}},
	pos = { x = 3, y = 4 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center.ability or {}).extra or {}).shadows or 2}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for i = 1, card.ability.extra.shadows do
			local card2 = create_card("Joker", G.jokers, nil, nil, nil, nil, nil, 'phantom')
			card2.no_forced_edition = true
			card2:set_edition({negative = true})
			card2.no_forced_edition = nil
			card2.ability.eternal = false
			card2.ability.perishable = true
			card2.ability.perish_tally = 5
			card2:add_to_deck()
			G.jokers:emplace(card2)
		end
		delay(0.6)
		for i=1, #G.jokers.cards do
			G.jokers.cards[i].base_cost = 0
			G.jokers.cards[i].extra_cost = 0
			G.jokers.cards[i].cost = 0
			G.jokers.cards[i].sell_cost = 0
			G.jokers.cards[i].sell_cost_label = G.jokers.cards[i].facing == 'back' and '?' or G.jokers.cards[i].sell_cost
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		for i = 1, card.ability.extra.shadows * number do
			local card2 = create_card("Joker", G.jokers, nil, nil, nil, nil, nil, 'phantom')
			card2.no_forced_edition = true
			card2:set_edition({negative = true})
			card2.no_forced_edition = nil
			card2.ability.eternal = false
			card2.ability.perishable = true
			card2.ability.perish_tally = 5
			card2:add_to_deck()
			G.jokers:emplace(card2)
		end
		delay(0.6)
		for i=1, #G.jokers.cards do
			G.jokers.cards[i].base_cost = 0
			G.jokers.cards[i].extra_cost = 0
			G.jokers.cards[i].cost = 0
			G.jokers.cards[i].sell_cost = 0
			G.jokers.cards[i].sell_cost_label = G.jokers.cards[i].facing == 'back' and '?' or G.jokers.cards[i].sell_cost
		end
	end
}

SMODS.Consumable {
	key = 'rift',
	set = 'Spectral',
	loc_txt = {
		name = 'Rift',
		text = {
			'Create {C:attention}#1#{} random {C:attention}consumables',
			'that {C:attention}also act as playing cards{},',
			'and shuffle them into your deck',
			'{C:inactive}(Suit and rank will be random, most editions will carry over)',
			spriter('mailingway')
		}
	},
	config = {extra = {rift = 5}},
	pos = { x = 4, y = 4 },
	cost = 4,
	jumbo_mod = 5,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.rift}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local cards = {}
		local objects = {}
		for i = 1, card.ability.extra.rift do
			cards[i] = true
			local new = create_playing_card(nil, G.play, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
			if card.edition and not card.edition.negative and not card.edition.jen_jumbo and not card.edition.cry_double_sided then
				new:set_edition(card.edition)
			end
			table.insert(objects, new)
		end
		jl.rd(0.5)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1')
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2, 'REAL')
		end
		jl.rd(0.5)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 0.9)
				v:set_ability(jl.rnd('jen_rift'), true, nil)
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2, 'REAL')
		end
		jl.rd(1.5)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 1.1)
				v:add_to_deck()
				G.play:remove_card(v)
				G.deck:emplace(v)
				return true
			end, 0.2, 'REAL')
		end
		Q(function()
			if next(cards) then
				playing_card_joker_effects(cards)
			end
		return true end)
	end,
	bulk_use = function(self, card, area, copier, number)
		local cards = {}
		local objects = {}
		for i = 1, card.ability.extra.rift * number do
			cards[i] = true
			local new = create_playing_card(nil, G.play, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
			if card.edition and not card.edition.negative and not card.edition.jen_jumbo and not card.edition.cry_double_sided then
				new:set_edition(card.edition)
			end
			table.insert(objects, new)
		end
		jl.rd(0.5/number)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1')
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2/number, 'REAL')
		end
		jl.rd(0.5/number)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 0.9)
				v:set_ability(jl.rnd('jen_rift'), true, nil)
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2/number, 'REAL')
		end
		jl.rd(1.5/number)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 1.1)
				v:add_to_deck()
				G.play:remove_card(v)
				G.deck:emplace(v)
				return true
			end, 0.2/number, 'REAL')
		end
		Q(function()
			if next(cards) then
				playing_card_joker_effects(cards)
			end
		return true end)
	end
}

local spiritcard = function(self, card, badges)
	badges[#badges + 1] = create_badge('Spirit', get_type_colour(self or card.config, card), G.C.DARK_EDITION, 1.2)
end

SMODS.Consumable {
	key = 'solace',
	set = 'Spectral',
	loc_txt = {
		name = '{C:blue}Solace',
		text = {
			'{C:blue}+#1#{} hand(s)',
			spriter('OvertLeaf4')
		}
	},
	set_card_type_badge = spiritcard,
	config = {extra = {add = 1}},
	pos = { x = 5, y = 4 },
	cost = 15,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
	hidden = true,
	soul_rate = 0.02,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.add}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local additive = card.ability.extra.add
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + additive
        ease_hands_played(additive)
	end,
	bulk_use = function(self, card, area, copier, number)
		local additive = card.ability.extra.add * number
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + additive
        ease_hands_played(additive)
	end
}

SMODS.Consumable {
	key = 'sorrow',
	set = 'Spectral',
	loc_txt = {
		name = '{C:red}Sorrow',
		text = {
			'{C:red}+#1#{} discard(s)',
			spriter('OvertLeaf4')
		}
	},
	set_card_type_badge = spiritcard,
	config = {extra = {add = 1}},
	pos = { x = 6, y = 4 },
	cost = 15,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
	hidden = true,
	soul_rate = 0.02,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.add}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local additive = card.ability.extra.add
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + additive
        ease_discard(additive)
	end,
	bulk_use = function(self, card, area, copier, number)
		local additive = card.ability.extra.add * number
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + additive
        ease_discard(additive)
	end
}

SMODS.Consumable {
	key = 'singularity',
	set = 'Spectral',
	loc_txt = {
		name = '{C:attention}Singularity',
		text = {
			'{C:attention}+#1#{} hand size, Joker slot(s) & consumable slot(s)',
			spriter('OvertLeaf4')
		}
	},
	set_card_type_badge = spiritcard,
	config = {extra = {add = 1}},
	pos = { x = 7, y = 4 },
	cost = 20,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
	hidden = true,
	soul_rate = 0.02,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.add}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local additive = card.ability.extra.add
		G.hand:change_size(additive)
		G.jokers:change_size_absolute(additive)
		G.consumeables:change_size_absolute(additive)
	end,
	bulk_use = function(self, card, area, copier, number)
		local additive = card.ability.extra.add * number
		G.hand:change_size(additive)
		G.jokers:change_size_absolute(additive)
		G.consumeables:change_size_absolute(additive)
	end
}

SMODS.Consumable {
	key = 'pandemonium',
	set = 'Spectral',
	loc_txt = {
		name = '{C:green}Pandemonium',
		text = {
			'{C:green}-#1#{} Ante',
			spriter('OvertLeaf4')
		}
	},
	set_card_type_badge = spiritcard,
	config = {extra = {add = 1}},
	pos = { x = 8, y = 4 },
	cost = 20,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
	hidden = true,
	soul_rate = 0.02,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.add}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local additive = card.ability.extra.add
		ease_ante(-additive)
	end,
	bulk_use = function(self, card, area, copier, number)
		local additive = card.ability.extra.add * number
		ease_ante(-additive)
	end
}

SMODS.Consumable {
	key = 'spectacle',
	set = 'Spectral',
	loc_txt = {
		name = '{C:pink}Spectacle',
		text = {
			'Gives {C:attention}#1# {C:tarot}Charm{},',
			'{X:inactive}Buffoon{}, {C:planet}Meteor{},',
			'{C:attention}Standard{} and {C:spectral}Ethereal {C:attention}Tags',
			spriter('OvertLeaf4')
		}
	},
	set_card_type_badge = spiritcard,
	config = {extra = {add = 2}},
	pos = { x = 9, y = 4 },
	cost = 12,
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_rate = 0.02,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {(((center or {}).ability or {}).extra or {}).add or 2}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local additive = card.ability.extra.add
		for i = 1, additive do
			add_tag(Tag('tag_charm'))
			add_tag(Tag('tag_buffoon'))
			add_tag(Tag('tag_meteor'))
			add_tag(Tag('tag_standard'))
			add_tag(Tag('tag_ethereal'))
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		local additive = card.ability.extra.add * number
		for i = 1, additive do
			add_tag(Tag('tag_charm'))
			add_tag(Tag('tag_buffoon'))
			add_tag(Tag('tag_meteor'))
			add_tag(Tag('tag_standard'))
			add_tag(Tag('tag_ethereal'))
		end
	end
}

local sssb = function(self, card, badges)
	badges[#badges + 1] = create_badge('S.S.S.B.', get_type_colour(self or card.config, card), nil, 1.2)
end

local spacedebris = function(self, card, badges)
	badges[#badges + 1] = create_badge('Space Debris', get_type_colour(self or card.config, card), nil, 1.2)
end

local stardust = function(self, card, badges)
	badges[#badges + 1] = create_badge('Stardust', get_type_colour(self or card.config, card), nil, 1.2)
end

local spacecraft = function(self, card, badges)
	badges[#badges + 1] = create_badge('Spacecraft', get_type_colour(self or card.config, card), nil, 1.2)
end

local natsat = function(self, card, badges)
	badges[#badges + 1] = create_badge('Natural Satellite', get_type_colour(self or card.config, card), nil, 1.2)
end

local galilean = function(self, card, badges)
	badges[#badges + 1] = create_badge('Galilean Moon', get_type_colour(self or card.config, card), nil, 1.2)
end

local hoxxesplanet = function(self, card, badges)
	badges[#badges + 1] = create_badge("Karl's Hellhole", get_type_colour(self or card.config, card), nil, 1.2)
end

local hoxxesblurbs = {
	'Rock and Stone!',
	'Like that; Rock and Stone!',
	'Stone and Rock! ...Oh, wait-?',
	'Rock solid!',
	"Rock'n'roll'n'stone!",
	'Rock on!',
	'For Rock and Stone!',
	'Rock and Stone forever!',
	'By the Beard!',
	'Stone.',
	'Yeah, yeah, Rock and Stone...',
	'We fight, for Rock and Stone!',
	'Did I hear a Rock and Stone?',
	'Rock and Stone, brotha!',
	'Leave no dwarf behind!',
	"If y'don't Rock 'n' Stone; you ain't comin' home!",
	'Karl would approve of this!',
	'For Karl!',
	'To Karl!',
	'Skal!',
	"We're rich!",
	"Mushroom.",
	"Mushroom!"
}

local yawetag_badge = function(self, card, badges)
	badges[#badges + 1] = create_badge("Spectral?", G.C.CRY_EMBER, G.C.CRY_ASCENDANT, 1.2)
end

SMODS.Consumable {
	key = 'yawetag',
	loc_txt = {
		name = 'Yawetag',
		text = {
			'Create a {C:jen_RGB,E:1,s:1.5}Wondrous{C:attention} Joker{},',
			'{C:red}destroy{} all other Jokers, {C:red,s:1.25}including {C:purple,s:1.25}Eternals'
		}
	},
	set = 'Spectral',
	pos = { x = 0, y = 0 },
	soul_pos = { x = 2, y = 0, extra = { x = 1, y = 0 }},
	cost = 15,
	unlocked = true,
	discovered = true,
	atlas = 'jenyawetag',
	set_card_type_badge = yawetag_badge,
	hidden = true,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		if #SMODS.find_card("j_jen_saint_attuned") <= 0 then
			Q(function()
				for k, v in ipairs(G.jokers.cards) do
					if v.gc and v:gc().key ~= 'j_jen_kosmos' then
						v:destroy()
					end
				end
				return true
			end, 0.4)
		end
		Q(function()
			play_sound('jen_gong')
			local card = create_card('Joker', G.jokers, nil, 'jen_wondrous', nil, nil, nil, 'jen_yawetag')
			card:add_to_deck()
			G.jokers:emplace(card)
			card:juice_up(0.3, 0.5)
			return true
		end, 0.75)
	end,
}

SMODS.Consumable {
	key = 'debris',
	loc_txt = {
		name = 'Debris',
		text = {
			'Upgrade a {C:green}random',
			'poker hand by {C:attention}one-twentieth',
			'{C:inactive,s:0.75}(Cannot be editioned, and does not trigger Astronomicon or leveling jokers)',
			'{C:dark_edition,s:0.7,E:2}Art by : Maxie'
		}
	},
	set = 'Planet',
	set_card_type_badge = spacedebris,
	pos = { x = 6, y = 2 },
	cost = 1,
	unlocked = true,
	discovered = true,
	cannot_edition = true,
	cant_astronomy = true,
	atlas = 'jenacc',
	in_pool = function() return false end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = jl.rndhand()
		jl.th(hand)
		level_up_hand(card, hand, nil, 0.05, true, true, true)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local hands = {}
		for i = 1, number do
			local hand = jl.rndhand()
			hands[hand] = (hands[hand] or 0) + 0.05
		end
		for k, v in pairs(hands) do
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(k, 'poker_hands'),chips = G.GAME.hands[k].chips, mult = G.GAME.hands[k].mult, level=G.GAME.hands[k].level})
			jl.a('+' .. tostring(v), 0.75, 2, G.C.BLUE, 'generic1')
			delay(0.75)
			level_up_hand(card, k, nil, v, true, true, true)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'comet',
	loc_txt = {
		name = 'Comet',
		text = {
			'Upgrade a {C:green}random',
			'poker hand by {C:attention}#1#',
			spriter('mailingway')
		}
	},
	config = {extra = {levels = 2}},
	set = 'Planet',
	set_card_type_badge = sssb,
	pos = { x = 0, y = 2 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {(((center or {}).ability or {}).extra or {}).levels or 2}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = jl.rndhand()
		jl.th(hand)
		level_up_hand(card, hand, nil, card.ability.extra.levels)
		jl.ch()
	end,
	bulk_use = function(self,card,area,copier,number)
		local hands = {}
		for i = 1, number do
			local hand = jl.rndhand()
			hands[hand] = (hands[hand] or 0) + card.ability.extra.levels
		end
		for k, v in pairs(hands) do
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(k, 'poker_hands'),chips = G.GAME.hands[k].chips, mult = G.GAME.hands[k].mult, level=G.GAME.hands[k].level})
			jl.a('+' .. tostring(v), 0.75, 2, G.C.BLUE, 'generic1')
			delay(0.75)
			level_up_hand(card, k, nil, v)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'meteor',
	loc_txt = {
		name = 'Meteor',
		text = {
			'Upgrades a {C:green}random',
			'poker hand by {C:attention}#1#{},',
			'but {C:red}downgrades{} a {C:attention}different',
			'{C:green}random{} poker hand by {C:red}#2#',
			spriter('mailingway')
		}
	},
	config = {extra = {levels = 3, downgrades = 1}},
	jumbo_mod = 3,
	set = 'Planet',
	set_card_type_badge = spacedebris,
	pos = { x = 1, y = 2 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {(((center or {}).ability or {}).extra or {}).levels or 3, ((((center or {}).ability or {}).extra or {}).downgrades or 1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = jl.rndhand()
		jl.th(hand)
		level_up_hand(card, hand, nil, card.ability.extra.levels)
		hand = jl.rndhand(hand)
		local downgradefactor = card.ability.extra.downgrades
		jl.th(hand)
		if downgradefactor <= 0 then
			jl.a('Safe!', 0.75, 2, G.C.FILTER, 'generic1')
			delay(0.75)
		else
			level_up_hand(card, hand, nil, -downgradefactor)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local hands = {}
		for i = 1, number do
			local hand = jl.rndhand()
			hands[hand] = (hands[hand] or 0) + card.ability.extra.levels
			hand = jl.rndhand(hand)
			hands[hand] = (hands[hand] or 0) - card.ability.extra.downgrades
		end
		for k, v in pairs(hands) do
			local downgradefactor = v
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(k, 'poker_hands'),chips = G.GAME.hands[k].chips, mult = G.GAME.hands[k].mult, level=G.GAME.hands[k].level})
			if v == 0 then
				jl.a('0', 0.75, 2, G.C.FILTER, 'generic1')
				delay(0.75)
			else
				jl.a((v > 0 and '+' or '-') .. tostring(math.abs(v)), 0.75, 2, (v < 0 and G.C.RED or G.C.BLUE), 'generic1')
				delay(0.75)
				level_up_hand(card, k, nil, v)
			end
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'satellite',
	loc_txt = {
		name = 'Satellite',
		text = {
			'Creates up to {C:attention}#1#',
			'random {C:planet}Planet{} card(s)',
			'{C:inactive}(Copies edition of this card if it has one)',
			mayoverflow,
			spriter('patchy')
		}
	},
	config = {extra = {planets = 2}},
	set = 'Planet',
	set_card_type_badge = spacecraft,
	pos = { x = 2, y = 2 },
	cost = 3,
	jumbo_mod = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.ceil((((center or {}).ability or {}).extra or {}).planets or 2)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		if not card.already_used_once then
			card.already_used_once = true
			for i = 1, math.ceil(card.ability.extra.planets) do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						play_sound('jen_draw')
						local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'satellite_planet')
						if card.edition then
							card2:set_edition(card.edition, true)
						end
						card2:add_to_deck()
						G.consumeables:emplace(card2)
						card:juice_up(0.3, 0.5)
					return true
				end }))
			end
			Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
			delay(0.6)
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		if not card.already_used_once then
			local quota = math.ceil(card.ability.extra.planets) * number
			card.already_used_once = true
			if quota > 20 then
				for i = 1, quota do
					local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'satellite_planet')
					if card.edition then
						card2:set_edition(card.edition, true)
					end
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
				end
			else
				for i = 1, quota do
					Q(function()
							play_sound('jen_draw')
							local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'satellite_planet')
							if card.edition then
								card2:set_edition(card.edition, true)
							end
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end, 0.4, nil, 'after')
				end
			end
			Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
			delay(0.6)
		end
	end
}

local power_enhancements = {
	'xmult',
	'emult',
	'xchip',
	'echip',
	'power',
	'tossy',
	'handy',
	'juggler',
	'cash',
	'potassium',
	'fizzy',
	'atman',
	'fortune',
	'astro'
}

SMODS.Consumable {
	key = 'centurion',
	loc_txt = {
		name = 'The Centurion',
		text = {
			'Enhance up to {C:attention}#1#{} selected card(s)',
			'into a random {C:cry_exotic,E:1}Power{} card',
			spriter('mailingway')
		}
	},
	config = {max_highlighted = 2},
	set = 'Tarot',
	pos = { x = 0, y = 0 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).max_highlighted or 2}}
    end,
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted <= (card.ability.max_highlighted + (card.area == G.hand and 1 or 0)) and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			Q(function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, nil, 'after')
			for i=1, #G.hand.highlighted do
				local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
				Q(function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end, 0.15, nil, 'after')
			end
			delay(0.2)
			for i=1, #G.hand.highlighted do
				local CARD = G.hand.highlighted[i]
				local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
				Q(function() G.hand:remove_from_highlighted(CARD);CARD:flip();CARD:set_ability(G.P_CENTERS['m_jen_' .. pseudorandom_element(power_enhancements, pseudoseed("centurion_random"))], true, nil);play_sound('jen_pop');CARD:juice_up(0.3, 0.3);return true end, 0.15, nil, 'after')
			end
		end
	end
}

SMODS.Consumable {
	key = 'sleeve',
	loc_txt = {
		name = 'The Sleeve',
		text = {
			'Enhance up to {C:attention}#1#{} selected card(s)',
			'into a random {C:cry_epic,E:1}Hand{} card',
			spriter('mailingway')
		}
	},
	config = {max_highlighted = 3},
	set = 'Tarot',
	pos = { x = 1, y = 0 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).max_highlighted or 3}}
    end,
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted <= (card.ability.max_highlighted + (card.area == G.hand and 1 or 0)) and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			Q(function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, nil, 'after')
			for i=1, #G.hand.highlighted do
				local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
				Q(function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end, 0.15, nil, 'after')
			end
			delay(0.2)
			for i=1, #G.hand.highlighted do
				local CARD = G.hand.highlighted[i]
				local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
				Q(function() G.hand:remove_from_highlighted(CARD);CARD:flip();CARD:set_ability(G.P_CENTERS['m_jen_' .. string.lower(pseudorandom_element(handinacard, pseudoseed("sleeve_random"))[2])], true, nil);play_sound('jen_pop');CARD:juice_up(0.3, 0.3);return true end, 0.15, nil, 'after')
			end
		end
	end
}

SMODS.Consumable {
	key = 'sizeoflife',
	loc_txt = {
		name = 'The Size of Life',
		text = {
			'Apply {C:dark_edition}Wee{} on',
			'up to {C:attention}#1#{} selected card(s)',
			spriter('mailingway')
		}
	},
	config = {max_highlighted = 1},
	set = 'Tarot',
	pos = { x = 2, y = 0 },
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
}


local jokerinatarot_blurbs = {
	"Hey! Pick me!",
	"You wouldn't say no to a free negative me, would you?",
	"Sometimes, an extra four mult goes a long way!",
	"I won't take up space, I promise!",
	"Don't ask how I ended up in a tarot!",
	"Hee-hee, hoo-hoo!",
	"Who knew even fortunes could be a circus act?",
	"Looks like the joke is on the crystal globe!",
	"It's a little cramped in this tarot...!",
	"Ouch, I think the joke is on me!",
	"Looks like the joke is on you!",
	"I'm not just a clown; I'm the whole circus!",
	"Seems a little suspicious for a jolly old fella like me to be in this card...",
	"I can't help if I'm still in this silly old card, break me out!",
	"Let me tell you, you'd love the show going on in this tarot!",
	"I'd give you more tickets to JimCon, but I'm fresh out.",
	"I've heard of a round buffoon that lives in a pretty funky town...",
	"I can't give four mult if I'm still in this card!",
	"I'm rooting for you! Even if it means I'll never get out of this card...",
	"Who knew I'd have access to a great show? That show being you!",
	"The stakes are only gonna rise here!",
	"Juggling is one of my favourite passtimes!",
	"I wonder what's the deal with pairs?",
	"You don't need to understand math to enjoy watching the digits climb!",
	"You should meet my friend Joseph; he's stuck in a Planet card!",
	"M!",
	"Hotfix!"
}

local jokerinaplanet_blurbs = {
	"Hey, can you hear me? You gotta get me outta here.",
	"I don't trust Jimbo...",
	"This card is making me feel breathless. Literally!",
	"How did I even get here?",
	"I don't even like astronomy.",
	"John, wherever you are... HEEEEEEEEEELP!!!",
	"Get me outta here, man!!",
	"Why must I be in this dang card?",
	"I guess I could help you...",
	"Have you been grinding for that one-in-a-thousand chance for Jimbo?",
	"I need some Joker-Cola...",
	"Have you seen John? He's my friend, and I heard he's got himself into a Tarot card...",
	"M... I guess?",
	"Hotfix... I guess?"
}

SMODS.Consumable {
	key = 'jokerinatarot',
	loc_txt = {
		name = 'Joker-in-a-Tarot',
		text = {
			'Create a {C:dark_edition}Negative {C:attention}default Joker',
			'{C:green}0.1% chance{} to create {C:jen_RGB,E:1,s:1.5}Jimbo{} instead',
			"{C:inactive,E:1}#1#{}"
		}
	},
	config = {},
	set = 'Tarot',
	pos = { x = 0, y = 1 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {jokerinatarot_blurbs[math.random(#jokerinatarot_blurbs)]}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		if jl.chance('jokerinatarot_secret', 1000, true) then
			local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jen_jimbo', 'jokerfromatarot')
			G.jokers:emplace(card2)
			play_sound_q('jen_omegacard', 1, 0.75)
			card2:add_to_deck()
			jl.a('Hee-hee, hoo-hoo!!', G.SETTINGS.GAMESPEED, 1, G.C.DARK_EDITION)
			jl.rd(1)
		else
			local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_joker', 'jokerfromatarot')
			card2.no_forced_edition = true
			card2:set_edition({negative = true}, true)
			card2.no_forced_edition = nil
			card2.base_cost = 1
			card2.extra_cost = 0
			card2.cost = 1
			card2.sell_cost = 1
			card2.sell_cost_label = card2.facing == 'back' and '?' or card2.sell_cost
			card2:add_to_deck()
			G.jokers:emplace(card2)
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		for i = 1, number do
			if jl.chance('jokerinatarot_secret', 1000, true) then
				local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jen_jimbo', 'jokerfromatarot')
				G.jokers:emplace(card2)
				play_sound_q('jen_omegacard', 1, 0.75)
				card2:add_to_deck()
				jl.a('Hee-hee, hoo-hoo!!', G.SETTINGS.GAMESPEED, 1, G.C.DARK_EDITION)
				jl.rd(1)
			else
				local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_joker', 'jokerfromatarot')
				card2.no_forced_edition = true
				card2:set_edition({negative = true}, true)
				card2.no_forced_edition = nil
				card2.base_cost = 1
				card2.extra_cost = 0
				card2.cost = 1
				card2.sell_cost = 1
				card2.sell_cost_label = card2.facing == 'back' and '?' or card2.sell_cost
				card2:add_to_deck()
				G.jokers:emplace(card2)
			end
		end
	end
}

SMODS.Consumable {
	key = 'jokerinaplanet',
	loc_txt = {
		name = 'Joker-in-a-Planet',
		text = {
			"For each {C:attention}default Joker{}, {C:planet}level up",
			'a {C:attention}random discovered poker hand{} by {C:attention}1',
			'plus {C:attention}1{} for each {C:attention}other default Joker{} that came before it',
			'{C:jen_RGB,E:1,s:1.5}Jimbo{} levels up by {X:planet,C:dark_edition}^1.13{} instead',
			"{C:inactive,E:1}#1#{}"
		}
	},
	ignore_allplanets = true,
	set = 'Planet',
	pos = { x = 1, y = 1 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
	in_pool = function() return #SMODS.find_card('j_joker') > 0 end,
    loc_vars = function(self, info_queue, center)
        return {vars = {jokerinaplanet_blurbs[math.random(#jokerinaplanet_blurbs)]}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = 'n/a'
		local upgrades = 0
		if #SMODS.find_card('j_joker') + #SMODS.find_card('j_jen_jimbo') > 0 then
			for k, v in ipairs(SMODS.find_card('j_joker')) do
				hand = jl.rndhand()
				jl.th(hand)
				Q(function() v:juice_up(1, 0.5) return true end)
				upgrades = upgrades + 1
				level_up_hand(card, hand, nil, upgrades)
			end
			for k, v in ipairs(SMODS.find_card('j_jen_jimbo')) do
				hand = jl.rndhand()
				local lvs = math.ceil(G.GAME.hands[hand].level ^ 1.13) - G.GAME.hands[hand].level
				jl.th(hand)
				Q(function() v:juice_up(1, 0.5) return true end)
				level_up_hand(card, hand, nil, lvs)
			end
			jl.ch()
		else
			jl.a('No default jokers!', G.SETTINGS.GAMESPEED, 0.65, G.C.RED, 'timpani')
			jl.rd(1)
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		local hand = 'n/a'
		local upgrades = 0
		if #SMODS.find_card('j_joker') + #SMODS.find_card('j_jen_jimbo') > 0 then
			for i = 1, number do
				upgrades = 0
				for k, v in ipairs(SMODS.find_card('j_joker')) do
					hand = jl.rndhand()
					jl.th(hand)
					Q(function() v:juice_up(1, 0.5) return true end)
					upgrades = upgrades + 1
					level_up_hand(card, hand, nil, upgrades)
				end
				for k, v in ipairs(SMODS.find_card('j_jen_jimbo')) do
					hand = jl.rndhand()
					local lvs = math.ceil(G.GAME.hands[hand].level ^ 1.13) - G.GAME.hands[hand].level
					jl.th(hand)
					Q(function() v:juice_up(1, 0.5) return true end)
					level_up_hand(card, hand, nil, lvs)
				end
			end
			jl.ch()
		else
			jl.a('No default jokers!', G.SETTINGS.GAMESPEED, 0.65, G.C.RED, 'timpani')
			jl.rd(1)
		end
	end
}

SMODS.Consumable {
	key = 'moon',
	loc_txt = {
		name = 'Moon',
		text = {
			'Creates up to {C:attention}#1#',
			'random {C:attention}consumable(s)',
			'{C:inactive}(Copies edition of this card if it has one)',
			mayoverflow,
			spriter('mailingway')
		}
	},
	config = {extra = {extraconsumables = 1}},
	set = 'Planet',
	set_card_type_badge = natsat,
	pos = { x = 3, y = 2 },
	cost = 3,
	jumbo_mod = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.ceil((((center or {}).ability or {}).extra or {}).extraconsumables or 1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		if not card.already_used_once then
			card.already_used_once = true
			for i = 1, math.ceil(card.ability.extra.extraconsumables) do
				Q(function()
						play_sound('jen_draw')
						local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, nil, 'moon_planet')
						if card.edition then
							card2:set_edition(card.edition, true)
						end
						card2:add_to_deck()
						G.consumeables:emplace(card2)
						card:juice_up(0.3, 0.5)
					return true
				end, 0.4, nil, 'after')
			end
			Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
			delay(0.6)
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		if not card.already_used_once then
			local quota = math.ceil(card.ability.extra.extraconsumables) * number
			card.already_used_once = true
			if quota > 20 then
				for i = 1, quota do
					local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, nil, 'moon_planet')
					if card.edition then
						card2:set_edition(card.edition, true)
					end
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
				end
			else
				for i = 1, quota do
					Q(function()
							play_sound('jen_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, nil, 'moon_planet')
							if card.edition then
								card2:set_edition(card.edition, true)
							end
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end, 0.4, nil, 'after')
				end
			end
			Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
			delay(0.6)
		end
	end
}

SMODS.Consumable {
	key = 'spacestation',
	loc_txt = {
		name = 'Space Station',
		text = {
			'Upgrade your {C:attention}most played poker hand',
			'by {C:attention}#1#{} level(s)',
			'{C:inactive}(#2#)',
			spriter('mailingway')
		}
	},
	config = {extra = {levels = 1}},
	jumbo_mod = 3,
	set = 'Planet',
	set_card_type_badge = spacecraft,
	pos = { x = 4, y = 2 },
	cost = 3,
	ayanami = true,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {(((center or {}).ability or {}).extra or {}).levels or 1, localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = jl.favhand()
		card:do_jen_astronomy(hand)
		jl.th(hand)
		level_up_hand(card, hand, nil, card.ability.extra.levels)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local hand = jl.favhand()
		card:do_jen_astronomy(hand, number)
		jl.th(hand)
		level_up_hand(card, hand, nil, card.ability.extra.levels * number)
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'dysnomia',
	loc_txt = {
		name = 'Dysnomia',
		text = {
			'{C:green}Randomly{} shifts the level of',
			'{C:attention}all poker hands{} by',
			'{C:red}#1#{} to {C:attention}#2#{} level(s)',
			spriter('mailingway')
		}
	},
	config = {extra = {down = -1, up = 2}},
	set = 'Planet',
	set_card_type_badge = natsat,
	pos = { x = 5, y = 2 },
	cost = 3,
	jumbo_mod = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenacc',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.floor((((center or {}).ability or {}).extra or {}).down or -1), math.ceil((((center or {}).ability or {}).extra or {}).up or 2)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		if card.ability.cry_rigged then
			Q(function()
				play_sound('gong', 0.94, 0.3)
				play_sound('gong', 0.94*1.5, 0.2)
				play_sound('tarot1', 1.5)
			return true end)
			jl.a('Rigged!', G.SETTINGS.GAMESPEED/2, 1.4, G.C.SET.Code)
			jl.rd(.5)
			lvupallhands(math.ceil(card.ability.extra.up), card)
		else
			jl.th('all')
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true
			end, 0.2, nil, 'after')
			update_hand_text({ delay = 0 }, { mult = "?", notifcol = G.C.JOKER_GREY, StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ delay = 0 }, { chips = "?", notifcol = G.C.JOKER_GREY, StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = card.ability.extra.down .. '~+' .. card.ability.extra.up })
			delay(1.3)
			for _, hand in ipairs(G.handlist) do
				local shift = pseudorandom('dysnomia', math.floor(card.ability.extra.down), math.ceil(card.ability.extra.up))
				if shift ~= 0 then
					level_up_hand(card, hand, true, shift)
				end
				jl.th(hand)
			end
			jl.ch()
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		if card.ability.cry_rigged then
			Q(function()
				play_sound('gong', 0.94, 0.3)
				play_sound('gong', 0.94*1.5, 0.2)
				play_sound('tarot1', 1.5)
			return true end)
			jl.a('Rigged!', G.SETTINGS.GAMESPEED/2, 1.4, G.C.SET.Code)
			jl.rd(.5)
			lvupallhands(math.ceil(card.ability.extra.up) * number, card)
		else
			local hands = {}
			for i = 1, number do
				for _, hand in ipairs(G.handlist) do
					hands[hand] = (hands[hand] or 0) + pseudorandom('dysnomia', math.floor(card.ability.extra.down), math.ceil(card.ability.extra.up))
				end
			end
			jl.th('all')
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true
			end, 0.2, nil, 'after')
			update_hand_text({ delay = 0 }, { mult = "?", notifcol = G.C.JOKER_GREY, StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ delay = 0 }, { chips = "?", notifcol = G.C.JOKER_GREY, StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = card.ability.extra.down*number .. '~+' .. card.ability.extra.up*number })
			delay(1.3)
			for hand, lv in pairs(hands) do
				if lv ~= 0 then
					level_up_hand(card, hand, true, lv)
				end
				jl.th(hand)
			end
			jl.ch()
		end
	end
}

SMODS.Consumable {
	key = 'asteroid',
	loc_txt = {
		name = 'Asteroid',
		text = {
			'{C:planet}Level up{} all {C:purple}poker hands',
			'by {C:attention}#1#{}, plus another {C:attention}#1#',
			'for each {C:spectral}Spectral{} card used this run',
			'{C:inactive}(Currently #2#)',
			'{C:dark_edition,s:0.7,E:2}Art by : abreaker'
		}
	},
	config = {extra = {levels = 0.15}},
	jumbo_mod = 3,
	set = 'Planet',
	pos = { x = 0, y = 0 },
	cost = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local lv = (((center or {}).ability or {}).extra or {}).levels or 0.15
        return {vars = {lv, lv * (jl.ctu('spectral') + 1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(card.ability.extra.levels * (jl.ctu('spectral') + 1))
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(card.ability.extra.levels * (jl.ctu('spectral') + 1) * number)
	end
}

SMODS.Consumable {
	key = 'voy1',
	loc_txt = {
		name = 'Voyager 1',
		text = {
			'{C:planet}Level up{} all {C:purple}poker hands',
			'by {C:attention}#1#{}, plus another {C:attention}#1#',
			'for each {C:planet}Planet{} card used this run',
			'{C:inactive}(Currently #2#)',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	config = {extra = {levels = 0.05}},
	jumbo_mod = 3,
	set_card_type_badge = spacecraft,
	set = 'Planet',
	pos = { x = 1, y = 0 },
	cost = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local lv = (((center or {}).ability or {}).extra or {}).levels or 0.05
        return {vars = {lv, lv * (jl.ctu('planet') + 1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(card.ability.extra.levels * jl.ctu('planet'))
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(card.ability.extra.levels * jl.ctu('planet') * number)
	end
}

SMODS.Consumable {
	key = 'nebula',
	loc_txt = {
		name = 'Nebula',
		text = {
			'{C:planet}Level up{} all {C:purple}poker hands',
			'by {C:attention}#1#{}, plus another {C:attention}#1#',
			'for each {C:tarot}Tarot{} card used this run',
			'{C:inactive}(Currently #2#)',
			'{C:dark_edition,s:0.7,E:2}Art by : hexatheboi'
		}
	},
	config = {extra = {levels = 0.1}},
	jumbo_mod = 3,
	set_card_type_badge = stardust,
	set = 'Planet',
	pos = { x = 2, y = 0 },
	cost = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local lv = (((center or {}).ability or {}).extra or {}).levels or 0.1
        return {vars = {lv, lv * (jl.ctu('tarot') + 1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(card.ability.extra.levels * (jl.ctu('tarot') + 1))
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(card.ability.extra.levels * (jl.ctu('tarot') + 1) * number)
	end
}

SMODS.Consumable {
	key = 'deimos',
	loc_txt = {
		name = 'Deimos',
		text = {
			'Take {C:attention}all but one{} levels from',
			'all {C:purple}poker hands{}, then',
			'{C:attention}equally redistribute{} taken levels',
			'across all {C:attention}discovered {C:purple}poker hands',
			'{C:dark_edition,s:0.7,E:2}Art by : smg9000'
		}
	},
	ignore_allplanets = true,
	set = 'Planet',
	pos = { x = 0, y = 1 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local HANDS = {}
		local numhands = 0
		local levels = 0
		for k, v in pairs(G.GAME.hands) do
			if v.visible then
				HANDS[k] = true
				numhands = numhands + 1
			end
			    if to_big(v.level) > to_big(1) then
			                levels = levels + math.max(0, v.level - 1)
			                level_up_hand(nil, k, true, -v.level + 1, true, true)
			            end
		end
		jl.th('all')
		delay(1)
		levels = jl.round(levels / numhands, 2)
		Q(function()
			play_sound('gong', 0.94, 0.3)
			play_sound('gong', 0.94*1.5, 0.2)
			play_sound('tarot1', 1.5)
			card:juice_up(1, 0.5)
		return true end)
		jl.h(localize('k_all_hands'), '=', '=', '=' .. number_format(levels + 1), true)
		delay(1)
		for k, v in pairs(HANDS) do
			level_up_hand(nil, k, true, levels, true, true)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local HANDS = {}
		local numhands = 0
		local levels = 0
		for k, v in pairs(G.GAME.hands) do
			if v.visible then
				HANDS[k] = true
				numhands = numhands + 1
			end
			    if to_big(v.level) > to_big(1) then
			                levels = levels + math.max(0, v.level - 1)
			                level_up_hand(nil, k, true, -v.level + 1, true, true)
			            end
		end
		jl.th('all')
		delay(1)
		levels = jl.round(levels / numhands, 2)
		Q(function()
			play_sound('gong', 0.94, 0.3)
			play_sound('gong', 0.94*1.5, 0.2)
			play_sound('tarot1', 1.5)
			card:juice_up(1, 0.5)
		return true end)
		jl.h(localize('k_all_hands'), '=', '=', '=' .. number_format(levels + 1), true)
		delay(1)
		for k, v in pairs(HANDS) do
			level_up_hand(nil, k, true, levels, true, true)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'phobos',
	loc_txt = {
		name = 'Phobos',
		text = {
			'Take {C:attention}#1# level(s){} from your',
			'{C:attention}most-leveled poker hand(s)',
			'and {C:attention}add three times{} the amount taken',
			'to your {C:attention}most played hand',
			'{C:inactive}(#2#)',
			'{C:inactive}(Can target itself)',
			'{C:dark_edition,s:0.7,E:2}Art by : Basilloon'
		}
	},
	ayanami = true,
	jumbo_mod = 3,
	config = {level_mod = 1},
	set = 'Planet',
	pos = { x = 1, y = 1 },
	cost = 5,
	unlocked = true,
	discovered = true,
	ayanami = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).level_mod or 1, localize(jl.favhand(), 'poker_hands')}}
    end,
	use = function(self, card, area, copier)
		local hands = {}
		local max_level = 0
		local levels = 0
		for k, v in pairs(G.GAME.hands) do
					if to_big(v.level) > to_big(max_level) then
						hands = {[k] = true}
						max_level = v.level
					elseif to_big(v.level) == to_big(max_level) then
						hands[k] = true
					end
				end
		for k, v in pairs(hands) do
			levels = levels + card.ability.level_mod
			jl.th(k)
			level_up_hand(card, k, false, -card.ability.level_mod)
		end
		local fav = jl.favhand()
		card:do_jen_astronomy(fav, levels * 3) 
		jl.th(fav)
		level_up_hand(card, fav, false, levels * 3)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local current_levels = {}
		local hands = {}
		local fav = jl.favhand()
		local max_level = 0
		local levels = 0
		for k, v in pairs(G.GAME.hands) do
			current_levels[k] = v.level
		end
		for i = 1, number do
			hands = {}
			levels = 0
			for k, v in pairs(G.GAME.hands) do
							if current_levels[k] > to_big(max_level) then
								hands = {[k] = true}
								max_level = v.level
							elseif current_levels[k] == to_big(max_level) then
								hands[k] = true
							end
						end
			for k, v in pairs(hands) do
				levels = levels + card.ability.level_mod
				current_levels[k] = current_levels[k] - card.ability.level_mod
			end
			current_levels[fav] = current_levels[fav] + (levels * 3)
		end
		for k, v in pairs(current_levels) do
			if v > G.GAME.hands[k].level then
				card:do_jen_astronomy(fav, v - G.GAME.hands[k].level)
			end
			if v ~= G.GAME.hands[k].level then
				jl.th(k)
				level_up_hand(card, k, false, v - G.GAME.hands[k].level)
			end
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'pallas',
	loc_txt = {
		name = '2 Pallas',
		text = {
			'Level up all {C:purple}poker hands',
			'by {C:attention}one-fifth{} of a level',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	set = 'Planet',
	pos = { x = 2, y = 1 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(0.2)
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(0.2*number)
	end
}

SMODS.Consumable {
	key = 'vesta',
	loc_txt = {
		name = '4 Vesta',
		text = {
			'{C:red}Level down{} your {C:attention}most played poker hand',
			'by {C:attention}#1#{}, but {C:planet}level up',
			'all {C:attention}other {C:purple}poker hands',
			'by {C:attention}half of that amount',
			'{C:inactive}(#2#)',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	jumbo_mod = 3,
	config = {level_mod = 2},
	set = 'Planet',
	pos = { x = 0, y = 2 },
	cost = 6,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).level_mod or 1, localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local fav = jl.favhand()
		local mod = card.ability.level_mod
		jl.th(fav)
		level_up_hand(card, fav, nil, -mod)
		delay(0.5)
		jl.h('Other Hands', '...', '...', '')
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true
			end, 0.2, nil, 'after')
			update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+" .. (mod / 2) })
			delay(1.3)
			for k, v in pairs(G.GAME.hands) do
				if k ~= fav then
					level_up_hand(card, k, true, mod / 2)
				end
			end
			jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local fav = jl.favhand()
		local mod = card.ability.level_mod * number
		jl.th(fav)
		level_up_hand(card, fav, nil, -mod)
		delay(0.5)
		jl.h('Other Hands', '...', '...', '')
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true
			end, 0.2, nil, 'after')
			update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
			Q(function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end, 0.9, nil, 'after')
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "+" .. (mod / 2) })
			delay(1.3)
			for k, v in pairs(G.GAME.hands) do
				level_up_hand(card, k, true, mod / 2)
			end
			jl.ch()
	end
}

SMODS.Consumable {
	key = 'hygiea',
	set = 'Planet',
	loc_txt = {
		name = '10 Hygiea',
		text = {
			'Create between {C:attention}#1#{} to {C:attention}#2#',
			'random {C:attention}playing ("CCD") {C:planet}Planet {C:attention}cards',
			'and shuffle them into your deck',
			'{C:inactive}(Suit and rank will be random, most editions will carry over)',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	ignore_allplanets = true,
	config = {min_planets = 2, max_planets = 4},
	pos = { x = 1, y = 2 },
	cost = 4,
	jumbo_mod = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.ceil(((center or {}).ability or {}).min_planets or 1), math.ceil(((center or {}).ability or {}).max_planets or 3)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local cards = {}
		local objects = {}
		local ccdamnt = pseudorandom('hygiearandom', math.ceil(card.ability.min_planets), math.ceil(card.ability.max_planets))
		for i = 1, ccdamnt do
			cards[i] = true
			local new = create_playing_card(nil, G.play, nil, i ~= 1, {G.C.SECONDARY_SET.Planet})
			if card.edition and not card.edition.negative and not card.edition.jen_jumbo and not card.edition.cry_double_sided then
				new:set_edition(card.edition)
			end
			table.insert(objects, new)
		end
		jl.rd(0.5)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1')
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2, 'REAL')
		end
		jl.rd(0.5)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 0.9)
				v:set_ability(jl.rnd('jen_hygiea', nil, G.P_CENTER_POOLS.Planet), true, nil)
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2, 'REAL')
		end
		jl.rd(1.5)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 1.1)
				v:add_to_deck()
				G.play:remove_card(v)
				G.deck:emplace(v)
				return true
			end, 0.2, 'REAL')
		end
		Q(function()
			if next(cards) then
				playing_card_joker_effects(cards)
			end
		return true end)
	end,
	bulk_use = function(self, card, area, copier, number)
		local cards = {}
		local objects = {}
		local ccdamnt = pseudorandom('hygiearandom', math.ceil(card.ability.min_planets) * number, math.ceil(card.ability.max_planets) * number)
		for i = 1, ccdamnt do
			cards[i] = true
			local new = create_playing_card(nil, G.play, nil, i ~= 1, {G.C.SECONDARY_SET.Planet})
			if card.edition and not card.edition.negative and not card.edition.jen_jumbo and not card.edition.cry_double_sided then
				new:set_edition(card.edition)
			end
			table.insert(objects, new)
		end
		jl.rd(0.5/number)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1')
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2/number, 'REAL')
		end
		jl.rd(0.5/number)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 0.9)
				v:set_ability(jl.rnd('jen_hygiea', nil, G.P_CENTER_POOLS.Planet), true, nil)
				v:juice_up(0.3, 0.3)
				v:flip()
				return true
			end, 0.2/number, 'REAL')
		end
		jl.rd(1.5/number)
		for k, v in ipairs(objects) do
			Q(function()
				play_sound('card1', 1.1)
				v:add_to_deck()
				G.play:remove_card(v)
				G.deck:emplace(v)
				return true
			end, 0.2/number, 'REAL')
		end
		Q(function()
			if next(cards) then
				playing_card_joker_effects(cards)
			end
		return true end)
	end
}

SMODS.Consumable {
	key = 'io',
	loc_txt = {
		name = 'Io',
		text = {
			'{C:planet}Level up{} all {C:purple}poker hands',
			'by {C:attention}#1#{}, plus another {C:attention}#1#',
			'for each {C:cry_code}Code{} card used this run',
			'{C:inactive}(Currently #2#)',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	config = {extra = {levels = 0.1}},
	jumbo_mod = 3,
	set_card_type_badge = galilean,
	set = 'Planet',
	pos = { x = 2, y = 2 },
	cost = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local lv = (((center or {}).ability or {}).extra or {}).levels or 0.1
        return {vars = {lv, lv * (jl.ctu('code') + 1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(card.ability.extra.levels * (jl.ctu('code') + 1))
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(card.ability.extra.levels * (jl.ctu('code') + 1) * number)
	end
}

SMODS.Consumable {
	key = 'europa',
	loc_txt = {
		name = 'Europa',
		text = {
			'Exchange the {C:attention}rightmost consumable',
			'for {C:attention}#1# {C:planet}Planet{} per {C:money}$#2#',
			'of sell value that consumable has',
			mayoverflow,
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	no_ratau = true,
	ignore_allplanets = true,
	config = {exchange = 1, exchange_rate = 0.5},
	jumbo_mod = 3,
	set_card_type_badge = galilean,
	set = 'Planet',
	pos = { x = 0, y = 3 },
	cost = 3,
	aurinko = true,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {math.ceil(((center or {}).ability or {}).exchange or 1), ((center or {}).ability or {}).exchange_rate or 0.5}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local did_exchange = false
		local target = G.consumeables.cards[#G.consumeables.cards]
		if target and not (target.ability or {}).eternal then
			local absolute_value = target.sell_cost / target:getQty()
			if absolute_value >= card.ability.exchange_rate then
				local budget = absolute_value
				while budget >= card.ability.exchange_rate do
					did_exchange = true
					for i = 1, math.ceil(card.ability.exchange) do
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('jen_draw')
							local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'europa_exchange')
							if card.edition then
								card2:set_edition(card.edition, true)
							end
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
							target:juice_up(0.3, 0.5)
							return true
						end }))
					end
					budget = budget - card.ability.exchange_rate
				end
			end
		end
		if not did_exchange then
			jl.a('No valid consumable!', G.SETTINGS.GAMESPEED, 0.65, G.C.RED, 'timpani')
			jl.rd(1)
		else
			if not target:getInfinite() then
				Q(function() if target:getQty() > 1 then target:subQty(1) else target:start_dissolve() end return true end)
			end
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		local did_exchange = false
		local target = G.consumeables.cards[#G.consumeables.cards]
		if target and not (target.ability or {}).eternal then
			local absolute_value = target.sell_cost / target:getQty()
			if absolute_value >= card.ability.exchange_rate then
				local budget = absolute_value
				while budget >= card.ability.exchange_rate do
					did_exchange = true
					for i = 1, math.ceil(card.ability.exchange) do
						Q(function()
							play_sound('jen_draw')
							local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'europa_exchange')
							if card.edition then
								card2:set_edition(card.edition, true)
							end
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
							target:juice_up(0.3, 0.5)
							return true
						end, 0.4, nil, 'after')
					end
					budget = budget - card.ability.exchange_rate
				end
			end
		end
		if not did_exchange then
			jl.a('No valid consumable!', G.SETTINGS.GAMESPEED, 0.65, G.C.RED, 'timpani')
			jl.rd(1)
		else
			if not target:getInfinite() then
				Q(function() if target:getQty() > 1 then target:subQty(1) else target:start_dissolve() end return true end)
			end
		end
	end
}

SMODS.Consumable {
	key = 'ganymede',
	loc_txt = {
		name = 'Ganymede',
		text = {
			'{C:attention}Most played poker hand{} gains',
			'the {C:chips}Chips{} of a {C:green}random{},',
			'{C:attention}different discovered poker hand',
			'{C:inactive}(#1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	set_card_type_badge = galilean,
	set = 'Planet',
	pos = { x = 1, y = 3 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		update_operator_display_custom(' ', G.C.WHITE)
		local hand = jl.favhand()
		local sel = jl.rndhand(hand, 'jen_ganymede')
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			for i = 1, math.random(6, 12) do
				jl.th(G.handlist[math.random(#G.handlist)])
				delay(0.2)
			end
		end
		jl.h(localize(sel, 'poker_hands'), G.GAME.hands[sel].chips, '', G.GAME.hands[sel].level)
		delay(2)
		jl.hc('')
		Q(function() play_sound('timpani') return true end)
		update_operator_display_custom('+' .. number_format(G.GAME.hands[sel].chips), G.C.CHIPS)
		delay(2)
		jl.h(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips, '', G.GAME.hands[hand].level)
		delay(2)
		G.GAME.hands[hand].chips = G.GAME.hands[hand].chips + G.GAME.hands[sel].chips
		jl.hc(G.GAME.hands[hand].chips, true)
		Q(function() play_sound('talisman_xchip') return true end)
		update_operator_display_custom(' ', G.C.WHITE)
		delay(1)
		jl.th(hand)
		update_operator_display()
		delay(1)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		update_operator_display_custom(' ', G.C.WHITE)
		local hand = jl.favhand()
		local sels = {}
		local rand = ''
		local total = to_big(0)
		for i = 1, number do
			rand = jl.rndhand(hand, 'jen_ganymede')
			sels[rand] = (sels[rand] or 0) + 1
		end
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			for i = 1, math.random(6, 12) do
				jl.th(G.handlist[math.random(#G.handlist)])
				delay(0.2)
			end
		end
		for k, v in pairs(sels) do
			jl.h(localize(k, 'poker_hands'), G.GAME.hands[k].chips, v > 1 and ('x' .. v) or '', G.GAME.hands[k].level)
			delay(1)
			if v > 1 then
				Q(function() play_sound('talisman_xchip', 1.5) return true end)
				jl.hcm(G.GAME.hands[k].chips * v, '')
			end
			total = total + to_big(G.GAME.hands[k].chips * v)
			local txt = number_format(total)
			delay(1)
			jl.hc('')
			Q(function() play_sound('timpani') return true end)
			update_operator_display_custom('+' .. txt, G.C.CHIPS)
			delay(1)
		end
		delay(1)
		jl.h(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips, '', G.GAME.hands[hand].level)
		delay(1)
		G.GAME.hands[hand].chips = G.GAME.hands[hand].chips + total
		jl.hc(G.GAME.hands[hand].chips, true)
		Q(function() play_sound('talisman_xchip') return true end)
		update_operator_display_custom(' ', G.C.WHITE)
		delay(1)
		jl.th(hand)
		update_operator_display()
		delay(1)
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'callisto',
	loc_txt = {
		name = 'Callisto',
		text = {
			'{C:attention}Most played poker hand{} gains',
			'the {C:mult}Mult{} of a {C:green}random{},',
			'{C:attention}different discovered poker hand',
			'{C:inactive}(#1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : ThreeCubed'
		}
	},
	set_card_type_badge = galilean,
	set = 'Planet',
	pos = { x = 2, y = 3 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		update_operator_display_custom(' ', G.C.WHITE)
		local hand = jl.favhand()
		local sel = jl.rndhand(hand, 'jen_callisto')
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			for i = 1, math.random(6, 12) do
				jl.th(G.handlist[math.random(#G.handlist)])
				delay(0.2)
			end
		end
		jl.h(localize(sel, 'poker_hands'), '', G.GAME.hands[sel].mult, G.GAME.hands[sel].level)
		delay(2)
		jl.hm('')
		Q(function() play_sound('timpani') return true end)
		update_operator_display_custom(number_format(G.GAME.hands[sel].mult) .. '+', G.C.MULT)
		delay(2)
		jl.h(localize(hand, 'poker_hands'), '', G.GAME.hands[hand].mult, G.GAME.hands[hand].level)
		delay(2)
		G.GAME.hands[hand].mult = G.GAME.hands[hand].mult + G.GAME.hands[sel].mult
		jl.hm(G.GAME.hands[hand].mult, true)
		Q(function() play_sound('multhit2') return true end)
		update_operator_display_custom(' ', G.C.WHITE)
		delay(1)
		jl.th(hand)
		update_operator_display()
		delay(1)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		update_operator_display_custom(' ', G.C.WHITE)
		local hand = jl.favhand()
		local sels = {}
		local rand = ''
		local total = to_big(0)
		for i = 1, number do
			rand = jl.rndhand(hand, 'jen_callisto')
			sels[rand] = (sels[rand] or 0) + 1
		end
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			for i = 1, math.random(6, 12) do
				jl.th(G.handlist[math.random(#G.handlist)])
				delay(0.2)
			end
		end
		for k, v in pairs(sels) do
			jl.h(localize(k, 'poker_hands'), v > 1 and (v .. 'x') or '', G.GAME.hands[k].mult, G.GAME.hands[k].level)
			delay(1)
			if v > 1 then
				Q(function() play_sound('multhit2', 1.5) return true end)
				jl.hcm('', G.GAME.hands[k].mult * v)
			end
			total = total + to_big(G.GAME.hands[k].mult * v)
			local txt = number_format(total)
			delay(1)
			jl.hm('')
			Q(function() play_sound('timpani') return true end)
			update_operator_display_custom(txt .. '+', G.C.MULT)
			delay(1)
		end
		delay(1)
		jl.h(localize(hand, 'poker_hands'), '', G.GAME.hands[hand].mult, G.GAME.hands[hand].level)
		delay(1)
		G.GAME.hands[hand].mult = G.GAME.hands[hand].mult + total
		jl.hm(G.GAME.hands[hand].mult, true)
		Q(function() play_sound('multhit2') return true end)
		update_operator_display_custom(' ', G.C.WHITE)
		delay(1)
		jl.th(hand)
		update_operator_display()
		delay(1)
		jl.ch()
    end
}

SMODS.Consumable {
	key = 'mimas',
	loc_txt = {
		name = 'Mimas',
		text = {
			'Increases the {C:attention}most played poker hand\'s',
			'{C:chips}Chips-per-level{} and {C:mult}Mult-per-level',
			'by {C:attention}one-fifth of the square root{} of its {C:attention}current {C:chips}Chips{} & {C:mult}Mult{},',
			'then {C:attention}increase the hand\'s current {C:chips}Chips{} & {C:mult}Mult',
			'to reflect on its new {C:chips}Chips-per-level{} and {C:mult}Mult-per-level',
			'{C:inactive}(#1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : smg9000'
		}
	},
	set_card_type_badge = natsat,
	set = 'Planet',
	pos = { x = 0, y = 4 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = jl.favhand()
		local data = G.GAME.hands[hand]
		update_operator_display_custom('Per Lv.', G.C.WHITE)
		jl.h(localize(hand, 'poker_hands'), data.l_chips, data.l_mult, data.level)
		local old_lchips = G.GAME.hands[hand].l_chips
		local old_lmult = G.GAME.hands[hand].l_mult
		local added_chips = (G.GAME.hands[hand].chips^.5) / 5
		local added_mult = (G.GAME.hands[hand].mult^.5) / 5
		G.GAME.hands[hand].l_chips = old_lchips + added_chips
		G.GAME.hands[hand].l_mult = old_lmult + added_mult
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true
			end,
		}))
		update_hand_text({ delay = 0 }, { mult = G.GAME.hands[hand].l_mult, StatusText = true })
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.9,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end,
		}))
		update_hand_text({ delay = 0 }, { chips = G.GAME.hands[hand].l_chips, StatusText = true })
		delay(4)
		update_operator_display()
		jl.th(hand)
		G.GAME.hands[hand].chips = G.GAME.hands[hand].chips + (added_chips * data.level)
		G.GAME.hands[hand].mult = G.GAME.hands[hand].mult + (added_mult * data.level)
		Q(function()
			play_sound("tarot1")
			card:juice_up(0.8, 0.5)
			G.TAROT_INTERRUPT_PULSE = true
			return true
		end, 0.2, nil, 'after')
		update_hand_text({ delay = 0 }, { mult = G.GAME.hands[hand].mult, StatusText = true })
		Q(function()
			play_sound("tarot1")
			card:juice_up(0.8, 0.5)
			G.TAROT_INTERRUPT_PULSE = nil
			return true
		end, 0.9, nil, 'after')
		update_hand_text({ delay = 0 }, { chips = G.GAME.hands[hand].chips, StatusText = true })
		delay(4)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local hand = jl.favhand()
		local data = G.GAME.hands[hand]
		update_operator_display_custom('Per Lv.', G.C.WHITE)
		jl.h(localize(hand, 'poker_hands'), data.l_chips, data.l_mult, data.level)
		local old_lchips = G.GAME.hands[hand].l_chips
		local old_lmult = G.GAME.hands[hand].l_mult
		local old_chips = G.GAME.hands[hand].chips
		local old_mult = G.GAME.hands[hand].mult
		local added_chips = 0
		local added_mult = 0
		for i = 1, math.max(1, number) do
			added_chips = added_chips + ((old_chips^.5) / 5)
			added_mult = added_mult + ((old_mult^.5) / 5)
			old_chips = old_chips + (added_chips * data.level)
			old_mult = old_mult + (added_mult * data.level)
		end
		G.GAME.hands[hand].l_chips = old_lchips + added_chips
		G.GAME.hands[hand].l_mult = old_lmult + added_mult
		Q(function()
			play_sound("tarot1")
			card:juice_up(0.8, 0.5)
			G.TAROT_INTERRUPT_PULSE = true
			return true
		end, 0.2, nil, 'after')
		update_hand_text({ delay = 0 }, { mult = G.GAME.hands[hand].l_mult, StatusText = true })
		Q(function()
			play_sound("tarot1")
			card:juice_up(0.8, 0.5)
			G.TAROT_INTERRUPT_PULSE = nil
			return true
		end, 0.9, nil, 'after')
		update_hand_text({ delay = 0 }, { chips = G.GAME.hands[hand].l_chips, StatusText = true })
		delay(4)
		update_operator_display()
		jl.th(hand)
		G.GAME.hands[hand].chips = old_chips
		G.GAME.hands[hand].mult = old_mult
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true
			end,
		}))
		update_hand_text({ delay = 0 }, { mult = G.GAME.hands[hand].mult, StatusText = true })
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.9,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end,
		}))
		update_hand_text({ delay = 0 }, { chips = G.GAME.hands[hand].chips, StatusText = true })
		delay(4)
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'enceladus',
	loc_txt = {
		name = 'Enceladus',
		text = {
			'Gain {C:money}$#1#{} for each time',
			'your {C:attention}most played poker hand',
			'has been played',
			'{C:inactive}(Max of $#2#)',
			'{C:inactive}(Currently #3#, {C:money}$#4#{C:inactive})',
			spriter('mailingway')
		}
	},
	config = {max_payout = 50, earnings = 1},
	set_card_type_badge = natsat,
	set = 'Planet',
	pos = { x = 1, y = 4 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).earnings or 1, ((center or {}).ability or {}).max_payout or 50, localize(jl.favhand(), 'poker_hands'), (((center or {}).ability or {}).earnings or 1) * ((((G.GAME or {}).hands or {})[jl.favhand()] or {}).played or 0)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand = jl.favhand()
		delay(1)
		ease_dollars(math.min(G.GAME.hands[hand].played * card.ability.earnings, card.ability.max_payout))
		Q(function() card:juice_up(0.8, 0.5) return true end)
	end,
	bulk_use = function(self, card, area, copier, number)
		local hand = jl.favhand()
		delay(1)
		ease_dollars(math.min(G.GAME.hands[hand].played * card.ability.earnings, card.ability.max_payout) * number)
		Q(function() card:juice_up(0.8, 0.5) return true end)
	end
}

SMODS.Consumable {
	key = 'tethys',
	loc_txt = {
		name = 'Tethys',
		text = {
			'Level up all {C:purple}poker hands',
			'by {C:attention}one-tenth{} of a level',
			'for every {C:attention}Joker{} you have',
			'{C:inactive}(Currently #1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : Zahrizi'
		}
	},
	set = 'Planet',
	pos = { x = 2, y = 4 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {not G.jokers and 0 or (#G.jokers.cards * 0.1)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(#G.jokers.cards * 0.1)
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(#G.jokers.cards * 0.1 * number)
	end
}

SMODS.Consumable {
	key = 'dione',
	loc_txt = {
		name = 'Dione',
		text = {
			'{C:red}Least leveled poker hand{} gains',
			'{C:attention}one-fifth{} of the {C:planet}levels',
			'from the {C:blue}most played poker hand',
			'{C:inactive}(Currently {C:red}#1#{C:inactive} and {C:blue}#2#{C:inactive})',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	pos = { x = 0, y = 5 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {localize(jl.lowhand(), 'poker_hands'), localize(jl.favhand(), 'poker_hands')}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand1 = jl.favhand()
		local hand2 = jl.lowhand()
		local mod = G.GAME.hands[hand1].level / 5
		card:do_jen_astronomy(hand2, mod)
		jl.th(hand2)
		level_up_hand(card, hand2, nil, mod)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local hand1 = jl.favhand()
		local hand2 = jl.lowhand()
		local mod = G.GAME.hands[hand1].level / 5
		if hand1 == hand2 then
			for i = 1, number do
				mod = (G.GAME.hands[hand1].level + mod) / 5
			end
		else
			mod = mod * number
		end
		card:do_jen_astronomy(hand2, mod)
		jl.th(hand2)
		level_up_hand(card, hand2, nil, mod)
		jl.ch()
	end
}

local function rhea_value()
	if not G.playing_cards then return 0 end
	local val = 0
	for k, v in ipairs(G.playing_cards) do
		if (v.edition or {}).jen_wee then
			val = val + (0.02 * (1 + (v.ability.wee_upgrades or 0)))
		end
	end
	return val
end

SMODS.Consumable {
	key = 'rhea',
	loc_txt = {
		name = 'Rhea',
		text = {
			'All hands gain {C:attention}+0.02 {C:planet}levels{}, plus {C:attention}another +0.02',
			'for each {C:dark_edition}Wee {C:attention}playing card',
			'as well as by how many times',
			'said card {C:attention}has been upgraded by {C:dark_edition}Wee',
			'{C:inactive}(Currently #1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : abreaker'
		}
	},
	set = 'Planet',
	pos = { x = 1, y = 5 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {rhea_value() + 0.02}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole(rhea_value() + 0.02)
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole((rhea_value() + 0.02) * number)
	end
}

local function faces_in_deck()
	local count = 0
	if not G.playing_cards then return count end
	for k, v in ipairs(G.playing_cards) do
		if v:is_face() then
			count = count + 1
		end
	end
	return count
end

local function odds_in_deck()
	local count = 0
	if not G.playing_cards then return count end
	if #SMODS.find_card('j_cry_maximized') > 0 then return count end
	for k, v in ipairs(G.playing_cards) do
		if v.base.id and not v:norankorsuit() and v.base.id ~= 13 and v.base.id ~= 12 and v.base.id ~= 11 and (math.floor(v.base.id / 2) ~= (v.base.id / 2) or v.base.id == 14) then
			count = count + 1
		end
	end
	return count
end

local function evens_in_deck()
	local count = 0
	if not G.playing_cards then return count end
	if #SMODS.find_card('j_cry_maximized') > 0 then
		if #SMODS.find_card('j_pareidolia') > 0 then
			return count
		else
			for k, v in ipairs(G.playing_cards) do
				if v.base.id and not v:norankorsuit() and not v:is_face() then
					count = count + 1
				end
			end
		end
	else
		for k, v in ipairs(G.playing_cards) do
			if v.base.id and not v:norankorsuit() and v.base.id < 11 and math.floor(v.base.id / 2) == (v.base.id / 2) then
				count = count + 1
			end
		end
	end
	return count
end

local function suits_in_deck(suit)
	local count = 0
	if not G.playing_cards then return count end
	for k, v in ipairs(G.playing_cards) do
		if v:is_suit(suit) then
			count = count + 1
		end
	end
	return count
end

SMODS.Consumable {
	key = 'titan',
	loc_txt = {
		name = 'Titan',
		text = {
			'All hands gain {C:attention}+0.01 {C:planet}levels{}, plus {C:attention}another +0.01',
			'for each {C:attention}face card{} in your deck',
			'{C:inactive}(J, Q, K)',
			'{C:inactive}(Currently #1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : Maxie'
		}
	},
	set = 'Planet',
	pos = { x = 2, y = 5 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {(faces_in_deck() + 1) / 100}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole((faces_in_deck() + 1) / 100)
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(((faces_in_deck() + 1) / 100) * number)
	end
}

SMODS.Consumable {
	key = 'hyperion',
	loc_txt = {
		name = 'Hyperion',
		text = {
			'All hands gain {C:attention}+0.005 {C:planet}levels{}, plus {C:attention}another +0.005',
			'for each {C:attention}odd-numbered card{} in your deck',
			'{C:inactive}(A, 3, 5, 7, 9)',
			'{C:inactive}(Currently #1#)',
			'{C:dark_edition,s:0.7,E:2}Art by : Maxie'
		}
	},
	set = 'Planet',
	pos = { x = 0, y = 6 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {tostring((odds_in_deck() + 1) / 200)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole((odds_in_deck() + 1) / 200)
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(((odds_in_deck() + 1) / 200) * number)
	end
}

SMODS.Consumable {
	key = 'iapetus',
	loc_txt = {
		name = 'Iapetus',
		text = {
			'All hands gain {C:attention}+0.005 {C:planet}levels{}, plus {C:attention}another +0.005',
			'for each {C:attention}even-numbered card{} in your deck',
			'{C:inactive}(2, 4, 6, 8, 10)',
			'{C:inactive}(Currently #1#)',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	pos = { x = 1, y = 6 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
        return {vars = {tostring((evens_in_deck() + 1) / 200)}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		card:blackhole((evens_in_deck() + 1) / 200)
	end,
	bulk_use = function(self, card, area, copier, number)
		card:blackhole(((evens_in_deck() + 1) / 200) * number)
	end
}

SMODS.Consumable {
	key = 'phoebe',
	loc_txt = {
		name = 'Phoebe',
		text = {
			'All hands gain {C:attention}+0.05 {C:planet}levels',
			'for each time that hand has been {C:attention}played',
			'{C:dark_edition,s:0.7,E:2}Art by : Basilloon'
		}
	},
	set = 'Planet',
	pos = { x = 2, y = 6 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		jl.th('all')
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					play_sound("tarot1")
					card:juice_up(0.8, 0.5)
					G.TAROT_INTERRUPT_PULSE = true
					return true
				end,
			}))
			update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.9,
				func = function()
					play_sound("tarot1")
					card:juice_up(0.8, 0.5)
					return true
				end,
			}))
			update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.9,
				func = function()
					play_sound("tarot1")
					card:juice_up(0.8, 0.5)
					G.TAROT_INTERRUPT_PULSE = nil
					return true
				end,
			}))
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+?' })
			delay(1.3)
		for k, v in pairs(G.GAME.hands) do
			if v.played > 0 then
				level_up_hand(card, k, true, v.played/20)
				jl.th(k)
			end
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		jl.th('all')
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					play_sound("tarot1")
					card:juice_up(0.8, 0.5)
					G.TAROT_INTERRUPT_PULSE = true
					return true
				end,
			}))
			update_hand_text({ delay = 0 }, { mult = "+", StatusText = true })
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.9,
				func = function()
					play_sound("tarot1")
					card:juice_up(0.8, 0.5)
					return true
				end,
			}))
			update_hand_text({ delay = 0 }, { chips = "+", StatusText = true })
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.9,
				func = function()
					play_sound("tarot1")
					card:juice_up(0.8, 0.5)
					G.TAROT_INTERRUPT_PULSE = nil
					return true
				end,
			}))
			update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+?' })
			delay(1.3)
		for k, v in pairs(G.GAME.hands) do
			if v.played > 0 then
				level_up_hand(card, k, true, (v.played/20) * number)
				jl.th(k)
			end
		end
		jl.ch()
	end
}

local suitsindeck_planets = {
	{
		n = 'Miranda',
		s = 'Hearts',
		p = { x = 0, y = 7 },
		a = 'ThreeCubed'
	},
	{
		n = 'Ariel',
		s = 'Clubs',
		p = { x = 1, y = 7 },
		a = 'Zahrizi'
	},
	{
		n = 'Umbriel',
		s = 'Spades',
		p = { x = 2, y = 7 },
		a = 'abreaker'
	},
	{
		n = 'Titania',
		s = 'Diamonds',
		p = { x = 0, y = 8 },
		a = 'mailingway'
	}
}

for k, v in ipairs(suitsindeck_planets) do
	SMODS.Consumable {
		key = string.lower(v.n),
		loc_txt = {
			name = v.n,
			text = {
				'All hands gain {C:attention}+0.01 {C:planet}levels{}, plus {C:attention}another +0.01',
				'for each {C:' .. string.lower(string.sub(v.s, 1, string.len(v.s) - 1)) .. '}' .. string.sub(v.s, 1, string.len(v.s) - 1) .. '{} in your deck',
				'{C:inactive}(Currently #1#)',
				'{C:dark_edition,s:0.7,E:2}Art by : ' .. v.a
			}
		},
		set = 'Planet',
		pos = v.p,
		cost = 3,
		unlocked = true,
		discovered = true,
		atlas = 'jenplanets',
		loc_vars = function(self, info_queue, center)
			return {vars = {(suits_in_deck(v.s) + 1) / 100}}
		end,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			card:blackhole((suits_in_deck(v.s) + 1) / 100)
		end,
		bulk_use = function(self, card, area, copier, number)
			card:blackhole(((suits_in_deck(v.s) + 1) / 100) * number)
		end
	}
end

local function count_identical_cards(rank, suit)
	local count = 0
	if not G.playing_cards then return count end
	for k, v in ipairs(G.playing_cards) do
		if not v:norankorsuit() and (v.base.id or 0) == rank and (v.base.suit or '') == suit and not v.oberon_created then
			count = count + 1
		end
	end
	return count
end

SMODS.Consumable {
	key = 'oberon',
	loc_txt = {
		name = 'Oberon',
		text = {
			'Shows a card with a {C:attention}random rank and suit{},',
			'then for each card in your deck',
			'that is {C:attention}identical in rank and suit',
			'to the shown card, {C:planet}upgrade {C:attention}all poker hands',
			'Level amount starts at {C:attention}0.25{}, and {C:attention}doubles each time',
			'{C:inactive}(ex. if you had 3 Jack of Hearts and',
			'{C:inactive}Jack of Hearts was the shown card,',
			'{C:inactive}all poker hands would level up',
			'{C:inactive}by +0.25, then by +0.5, then by +1, for a total of +1.75)',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	pos = { x = 1, y = 8 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		jl.ch()
		jl.hcm('', '')
		update_operator_display_custom(' ', G.C.WHITE)
		local evaluator = create_playing_card(nil, G.play, nil, nil, {G.C.SECONDARY_SET.Planet})
		evaluator.oberon_created = true
		if card.edition then
			evaluator:set_edition(card.edition, true, true)
		end
		local cumulative = 0
		delay(3)
		jl.hn(SMODS.Ranks[evaluator.base.value].key .. ' of ' .. SMODS.Suits[evaluator.base.suit].key)
		play_sound_q('button')
		Q(function() if evaluator then evaluator:juice_up(0.8, 0.5) evaluator.highlighted = true end return true end)
		delay(3)
		local identical = count_identical_cards(evaluator.base.id, evaluator.base.suit)
		if identical > 0 then
			play_sound_q('button')
			jl.hm('x' .. identical)
			delay(3)
			for i = 1, identical do
				cumulative = cumulative + ((2 ^ (i-1))/4)
				play_sound_q('button', 1.1)
				jl.hcm('+' .. number_format(cumulative), i == identical and '' or ('x' .. (identical - i)))
				delay(0.25)
			end
			delay(2.75)
			update_operator_display()
			card:blackhole(cumulative)
		else
			jl.hcm('Nope!', 'Nope!')
			play_sound_q('timpani')
			delay(3)
			update_operator_display()
		end
		Q(function() if evaluator then evaluator.highlighted = false evaluator:destroy() end return true end)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		jl.ch()
		jl.hcm('', '')
		update_operator_display_custom(' ', G.C.WHITE)
		local evaluators = {}
		for i = 1, number do
			evaluators[i] = create_playing_card(nil, G.play, nil, nil, {G.C.SECONDARY_SET.Planet})
			evaluators[i].oberon_created = true
			if card.edition then
				evaluators[i]:set_edition(card.edition, true, true)
			end
		end
		local cumulative = 0
		delay(3)
		for k, evaluator in ipairs(evaluators) do
			jl.hn(SMODS.Ranks[evaluator.base.value].key .. ' of ' .. SMODS.Suits[evaluator.base.suit].key)
			play_sound_q('button')
			Q(function() if evaluator then evaluator:juice_up(0.8, 0.5) evaluator.highlighted = true end return true end)
			delay(3)
			local identical = count_identical_cards(evaluator.base.id, evaluator.base.suit)
			if identical > 0 then
				play_sound_q('button')
				jl.hm('x' .. identical)
				delay(3)
				for i = 1, identical do
					cumulative = cumulative + ((2 ^ (i-1))/4)
					play_sound_q('button', 1.1)
					jl.hcm('+' .. number_format(cumulative), i == identical and '' or ('x' .. (identical - i)))
					delay(0.25)
				end
				delay(2.75)
			else
				if cumulative <= 0 then jl.hcm('Nope!', 'Nope!') else jl.hc('Nope!') end
				play_sound_q('timpani')
				delay(3)
			end
			Q(function() if evaluator then evaluator.highlighted = false end return true end)
		end
		update_operator_display()
		if cumulative > 0 then
			card:blackhole(cumulative)
		end
		Q(function() for k, evaluator in ipairs(evaluators) do if evaluator then evaluator:destroy() end end return true end)
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'orcus',
	loc_txt = {
		name = 'Orcus',
		text = {
			'Your {C:blue}most played hand{} will',
			'{C:purple,E:1}siphon {C:attention}half{} of the {C:planet}levels',
			'from the {C:red}poker hands{} that are {C:attention}adjacent{} to it',
			'{C:inactive}({C:red}#1# {C:purple}>> {C:blue}#2# {C:purple}<< {C:red}#3#{C:inactive})',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	ayanami = true,
	pos = { x = 2, y = 8 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local fav = jl.favhand()
		local hands = jl.adjacenthands(fav)
        return {vars = {hands.backhand and localize(hands.backhand, 'poker_hands') or '<none>', localize(fav, 'poker_hands'), hands.forehand and localize(hands.forehand, 'poker_hands') or '<none>'}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
		use = function(self, card, area, copier)
			local fav = jl.favhand()
			local hands = jl.adjacenthands(fav)
			local lv = to_big(0)
			local levels_siphoned = to_big(0)
			if hands.backhand then
				if G.GAME.hands[hands.backhand].level > to_big(0) then
					jl.th(hands.backhand)
					lv = G.GAME.hands[hands.backhand].level / to_big(2)
					level_up_hand(card, hands.backhand, nil, -lv)
					levels_siphoned = lv
				end
			end
			if hands.forehand then
				if G.GAME.hands[hands.forehand].level > to_big(0) then
					jl.th(hands.forehand)
					lv = G.GAME.hands[hands.forehand].level / to_big(2)
					level_up_hand(card, hands.forehand, nil, -lv)
					levels_siphoned = levels_siphoned + lv
				end
			end
			card:do_jen_astronomy(fav, levels_siphoned)
			jl.th(fav)
			level_up_hand(card, fav, nil, levels_siphoned)
			jl.ch()
		end,
		bulk_use = function(self, card, area, copier, number)
			local fav = jl.favhand()
			local hands = jl.adjacenthands(fav)
			local lv = to_big(0)
			local levels_siphoned = to_big(0)
			local divisor = to_big(2) - (1 / (2^(number-1)))
			if hands.backhand then
				if G.GAME.hands[hands.backhand].level > to_big(0) then
					jl.th(hands.backhand)
					lv = (G.GAME.hands[hands.backhand].level/divisor)
					level_up_hand(card, hands.backhand, nil, -lv)
					levels_siphoned = lv
				end
			end
			if hands.forehand then
				if G.GAME.hands[hands.forehand].level > to_big(0) then
					jl.th(hands.forehand)
					lv = (G.GAME.hands[hands.forehand].level/divisor)
					level_up_hand(card, hands.forehand, nil, -lv)
					levels_siphoned = levels_siphoned + lv
				end
			end
			card:do_jen_astronomy(fav, levels_siphoned)
			jl.th(fav)
			level_up_hand(card, fav, nil, levels_siphoned)
			jl.ch()
		end
}

SMODS.Consumable {
	key = 'vanth',
	loc_txt = {
		name = 'Vanth',
		text = {
			'{C:attention}Rounds{} all hand levels {C:attention}up',
			'to the {C:attention}next integer',
			'{C:inactive}(ex. 2.43 >becomes> 3, 5.81 >becomes> 6)',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	pos = { x = 0, y = 9 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.handlist) do
			if to_big(G.GAME.hands[v].level) < to_big(9e15) then
				if math.ceil(G.GAME.hands[v].level) ~= G.GAME.hands[v].level then
					level_up_hand(nil, v, true, math.ceil(G.GAME.hands[v].level) - G.GAME.hands[v].level, true, true)
				end
			end
		end
		jl.th('all')
		delay(1)
		jl.h(localize('k_all_hands'), '+', '+', '=ceil(#)', true)
		Q(function() card:juice_up(1, 0.5) play_sound('highlight2', 1, 0.6) return true end)
		delay(3)
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in ipairs(G.handlist) do
			if to_big(G.GAME.hands[v].level) < to_big(9e15) then
				if math.ceil(G.GAME.hands[v].level) ~= G.GAME.hands[v].level then
					level_up_hand(nil, v, true, math.ceil(G.GAME.hands[v].level) - G.GAME.hands[v].level, true, true)
				end
			end
		end
		jl.th('all')
		delay(1)
		jl.h(localize('k_all_hands'), '+', '+', '=ceil(#)', true)
		Q(function() card:juice_up(1, 0.5) play_sound('highlight2', 1, 0.6) return true end)
		delay(3)
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'charon',
	loc_txt = {
		name = 'Charon',
		text = {
			'{C:attention}Two {C:green}random {C:attention}discovered{} poker hands',
			'will {C:attention}swap over{} their statistics',
			'{C:inactive}(Chips, Mult, Chips/Level, Mult/Level, Level, Times Played)',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	pos = { x = 1, y = 9 },
	cost = 6,
	unlocked = true,
	discovered = true,
	ignore_allplanets = true,
	atlas = 'jenplanets',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local hand1 = jl.rndhand()
		local hand2 = jl.rndhand(hand1)
		local card1 = jl.rawcard(jl.planethand(hand1), 1, 0.5)
		local card2 = jl.rawcard(jl.planethand(hand2), 1, 1.5)
		local hand1data = {
			chips = G.GAME.hands[hand1].chips,
			l_chips = G.GAME.hands[hand1].l_chips,
			mult = G.GAME.hands[hand1].mult,
			l_mult = G.GAME.hands[hand1].l_mult,
			level = G.GAME.hands[hand1].level,
			played = G.GAME.hands[hand1].played
		}
		if (G.SETTINGS.FASTFORWARD or 0) <= 0 then
			jl.h('', '', '', '')
			delay(1)
			jl.th(hand1)
			Q(function() card1:juice_up(0.3, 0.5); return true end)
			delay(2)
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			jl.hcm(G.GAME.hands[hand1].l_chips, G.GAME.hands[hand1].l_mult)
			delay(2)
			update_operator_display()
			jl.th(hand2)
			Q(function() card2:juice_up(0.3, 0.5); return true end)
			delay(2)
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			jl.hcm(G.GAME.hands[hand2].l_chips, G.GAME.hands[hand2].l_mult)
			delay(2)
			update_operator_display()
			jl.h('', '', '', '')
		else
			jl.ch()
		end
		delay(1)
		Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
		delay(0.5)
		Q(function() card1:fake_dissolve(); card2:fake_dissolve(); return true end)
		delay(0.5)
		card:speak('Swapped!')
		Q(function() card1:set_ability(G.P_CENTERS[jl.planethand(hand2)]); card2:set_ability(G.P_CENTERS[jl.planethand(hand1)]); card1:start_materialize(); card2:start_materialize(); play_sound('jen_misc1'); return true end)
		G.GAME.hands[hand1].chips = G.GAME.hands[hand2].chips
		G.GAME.hands[hand1].l_chips = G.GAME.hands[hand2].l_chips
		G.GAME.hands[hand1].mult = G.GAME.hands[hand2].mult
		G.GAME.hands[hand1].l_mult = G.GAME.hands[hand2].l_mult
		G.GAME.hands[hand1].level = G.GAME.hands[hand2].level
		G.GAME.hands[hand1].played = G.GAME.hands[hand2].played
		G.GAME.hands[hand2].chips = hand1data.chips
		G.GAME.hands[hand2].l_chips = hand1data.l_chips
		G.GAME.hands[hand2].mult = hand1data.mult
		G.GAME.hands[hand2].l_mult = hand1data.l_mult
		G.GAME.hands[hand2].level = hand1data.level
		G.GAME.hands[hand2].played = hand1data.played
		delay(1)
		if (G.SETTINGS.FASTFORWARD or 0) <= 0 then
			jl.th(hand2)
			Q(function() card1:juice_up(0.3, 0.5) return true end)
			delay(2)
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			jl.hcm(G.GAME.hands[hand2].l_chips, G.GAME.hands[hand2].l_mult)
			delay(2)
			update_operator_display()
			jl.th(hand1)
			Q(function() card2:juice_up(0.3, 0.5) return true end)
			delay(2)
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			jl.hcm(G.GAME.hands[hand1].l_chips, G.GAME.hands[hand1].l_mult)
			delay(2)
			update_operator_display()
			jl.ch()
		end
		Q(function() card1:destroy(); card2:destroy(); hand1data = nil; return true end)
	end
}

SMODS.Consumable {
	key = 'haumea',
	loc_txt = {
		name = 'Haumea',
		text = {
			'Your {C:red}most played hand{} will',
			'{C:planet}upgrade{} the {C:blue}poker hands{} that are',
			'{C:attention}adjacent{} to it by a {C:attention}fourth',
			'of its current level',
			'{C:inactive}({C:blue}#1# {C:green}<< {C:red}#2# {C:green}>> {C:blue}#3#{C:inactive})',
			spriter('mailingway')
		}
	},
	set = 'Planet',
	ayanami = true,
	pos = { x = 2, y = 9 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'jenplanets',
    loc_vars = function(self, info_queue, center)
		local fav = jl.favhand()
		local hands = jl.adjacenthands(fav)
        return {vars = {hands.backhand and localize(hands.backhand, 'poker_hands') or '<none>', localize(fav, 'poker_hands'), hands.forehand and localize(hands.forehand, 'poker_hands') or '<none>'}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local fav = jl.favhand()
		local hands = jl.adjacenthands(fav)
		local mod = G.GAME.hands[fav].level / 4
		if to_big(G.GAME.hands[fav].level) > to_big(0) then
		            if hands.backhand then
		                card:do_jen_astronomy(hands.backhand, mod)
		                jl.th(hands.backhand)
		                level_up_hand(card, hands.backhand, nil, mod)
		            end
		            if hands.forehand then
		                card:do_jen_astronomy(hands.forehand, mod)
		                jl.th(hands.forehand)
		                level_up_hand(card, hands.forehand, nil, mod)
		            end
		        end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		local fav = jl.favhand()
		local hands = jl.adjacenthands(fav)
		local mod = (G.GAME.hands[fav].level / 4) * number
		if to_big(G.GAME.hands[fav].level) > to_big(0) then
			if hands.backhand then
				card:do_jen_astronomy(hands.backhand, mod)
				jl.th(hands.backhand)
				level_up_hand(card, hands.backhand, nil, mod)
			end
			if hands.forehand then
				card:do_jen_astronomy(hands.forehand, mod)
				jl.th(hands.forehand)
				level_up_hand(card, hands.forehand, nil, mod)
			end
		end
		jl.ch()
	end
}

local namaka_data = {
	Tarot = G.C.SECONDARY_SET.Tarot,
	Planet = G.C.SECONDARY_SET.Planet,
	Spectral = G.C.SECONDARY_SET.Spectral,
	Code = HEX('14b341')
}

SMODS.Consumable {
	key = 'namaka',
	loc_txt = {
		name = 'Namaka',
		text = {
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
	pos = { x = 0, y = 10 },
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
			if to_big(amt) > to_big(0) then
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
				if to_big(amt) > to_big(0) then
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
}


--UNO CONSUMABLES

local uno_data = {
	values = {
		'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'
	},
	colours = {
		Red = 'Hearts',
		Blue = 'Spades',
		Green = 'Clubs',
		Yellow = 'Diamonds'
	}
}

SMODS.Consumable {
	key = 'uno_uno',
	loc_txt = {
		name = 'UNO',
		text = {
			'Level up {C:attention}all ranks',
			'and {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s{} by {C:attention}1',
			spriter('jenwalter666')
		}
	},
	set = 'Spectral',
	pos = { x = 2, y = 4 },
	cost = 3,
	hidden = true,
	unlocked = true,
	discovered = true,
	soul_set = 'jen_uno',
	soul_rate = .05,
	atlas = 'jenuno',
	ignore_kudaai = true,
	can_use = function(self, card)
		return jl.canuse()
	end,
	can_mass_use = true,
	use = function(self, card, area, copier)
		delay(1)
		play_sound_q('jen_uno')
		jl.a('UNO!', 2, 1, G.C.MONEY)
		Q(function() if card then card:juice_up(0.8, 0.5) end return true end)
		delay(2)
		jl.h('All Ranks & Suits', '...', '...', '')
		delay(.5)
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hc('+', true)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hm('+', true)
			Q(function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
			end, 0.9, nil, 'after')
			jl.hlv('+1')
			play_sound_q('button', 0.9, 0.7)
		else
			Q(function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
			end, 0.9, nil, 'after')
			jl.h('All Ranks & Suits', '+', '+', '+1', true)
		end
		delay(1)
		for a, b in ipairs(uno_data.values) do
			level_up_rank(card, b, true, 1)
		end
		for c, d in pairs(uno_data.colours) do
			level_up_suit(card, d, true, 1)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		delay(1)
		play_sound_q('jen_uno')
		jl.a('UNO!', 2, 1, G.C.MONEY)
		Q(function() if card then card:juice_up(0.8, 0.5) end return true end)
		delay(2)
		jl.h('All Ranks & Suits', '...', '...', '')
		delay(.5)
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			Q(function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
			end, 0.2, nil, 'after')
			jl.hc('+', true)
			Q(function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
			end, 0.2, nil, 'after')
			jl.hm('+', true)
			Q(function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
			end, 0.2, nil, 'after')
			jl.hlv('+' .. number)
			play_sound_q('button', 0.9, 0.7)
		else
			Q(function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
			end, 0.2, nil, 'after')
			jl.h('All Ranks & Suits', '+', '+', '+' .. number, true)
		end
		delay(1)
		for a, b in ipairs(uno_data.values) do
			level_up_rank(card, b, true, number)
		end
		for c, d in pairs(uno_data.colours) do
			level_up_suit(card, d, true, number)
		end
		jl.ch()
	end
}

for a, b in ipairs(uno_data.values) do
	for c, d in pairs(uno_data.colours) do
		SMODS.Consumable {
			key = 'uno_' .. string.lower(c) .. string.lower(b),
			loc_txt = {
				name = c .. ' ' .. b,
				text = {
					'Level up {C:attention}' .. b .. 's{} and {C:' .. string.lower(d) .. '}' .. d,
					'{C:attention}' .. b .. 's{C:inactive} | {V:1}lvl.#1#{} : {X:chips,C:white}+#2#{} & {X:mult,C:white}+#3#',
					'{C:' .. string.lower(d) .. '}' .. d .. '{C:inactive} | {V:2}lvl.#4#{} : {X:chips,C:white}+#5#{} & {X:mult,C:white}+#6#',
					spriter('jenwalter666')
				}
			},
			set = 'jen_uno',
			pos = { x = (a - 1) % 10, y = (d == 'Hearts' and 0 or d == 'Spades' and 1 or d == 'Clubs' and 2 or d == 'Diamonds' and 3 or 0) + (a > 10 and 5 or 0) },
			cost = b == 'Ace' and 3 or 2,
			unlocked = true,
			discovered = true,
			atlas = 'jenuno',
			ignore_kudaai = true,
			can_mass_use = true,
			loc_vars = function(self, info_queue, center)
				if not G.GAME or not (G.GAME or {}).suits or not (G.GAME or {}).ranks then
					return {
						vars = {
							1,
							Jen.config.rank_leveling[b].chips,
							Jen.config.rank_leveling[b].mult,
							1,
							Jen.config.suit_leveling[d].chips,
							Jen.config.suit_leveling[d].mult,
							colours = {
								G.C.UI.TEXT_DARK,
								G.C.UI.TEXT_DARK
							}
						},
					}
				end
				return {
					vars = {
						G.GAME.ranks[b].level,
						G.GAME.ranks[b].l_chips,
						G.GAME.ranks[b].l_mult,
						G.GAME.suits[d].level,
						G.GAME.suits[d].l_chips,
						G.GAME.suits[d].l_mult,
						colours = {
							G.GAME.ranks[b].level <= to_big(7200) and G.C.HAND_LEVELS['!' .. number_format(G.GAME.ranks[b].level)] or G.C.HAND_LEVELS[number_format(G.GAME.ranks[b].level)] or G.C.UI.TEXT_DARK,
							G.GAME.suits[d].level <= to_big(7200) and G.C.HAND_LEVELS['!' .. number_format(G.GAME.suits[d].level)] or G.C.HAND_LEVELS[number_format(G.GAME.suits[d].level)] or G.C.UI.TEXT_DARK
						}
					},
				}
			end,
			can_use = function(self, card)
				return jl.canuse()
			end,
			use = function(self, card, area, copier)
				level_up_rank(card, b, nil, 1, true)
				level_up_suit(card, d, nil, 1)
			end,
			bulk_use = function(self, card, area, copier, number)
				level_up_rank(card, b, nil, number, true)
				level_up_suit(card, d, nil, number)
			end
		}
	end
end

for k, v in pairs(uno_data.colours) do
	SMODS.Consumable {
		key = 'uno_' .. string.lower(k) .. 'drawtwo',
		loc_txt = {
			name = k .. ' Draw Two',
			text = {
				'Creates {C:attention}2 {C:' .. string.lower(v) .. '}' .. k,
				'{C:attention}numerical {C:uno}UNO{} cards',
				mayoverflow,
				spriter('jenwalter666')
			}
		},
		set = 'jen_uno',
		pos = { x = 3, y = k == 'Red' and 5 or k == 'Blue' and 6 or k == 'Green' and 7 or k == 'Yellow' and 8 or 5 },
		cost = 4,
		unlocked = true,
		discovered = true,
		atlas = 'jenuno',
		ignore_kudaai = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			if not card.already_used_once then
				card.already_used_once = true
				for i = 1, 2 do
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('jen_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_jen_uno_' .. string.lower(k) .. string.lower(pseudorandom_element(uno_data.values, pseudoseed('unodrawtwo_' .. string.lower(k)))), 'unodrawtwo_' .. string.lower(k))
							--[[if card.edition then
								card2:set_edition(card.edition, true)
							end]]
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
		end,
		bulk_use = function(self, card, area, copier, number)
			if not card.already_used_once then
				local quota = 2 * number
				card.already_used_once = true
				if quota > 40 then
					for i = 1, quota do
						local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_jen_uno_' .. string.lower(k) .. string.lower(pseudorandom_element(uno_data.values, pseudoseed('unodrawtwo' .. string.lower(k)))), 'unodrawtwo_' .. string.lower(k))
						--[[if card.edition then
							card2:set_edition(card.edition, true)
						end]]
						card2:add_to_deck()
						G.consumeables:emplace(card2)
						card:juice_up(0.3, 0.5)
					end
				else
					for i = 1, quota do
						Q(function()
								play_sound('jen_draw')
								local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_jen_uno_' .. string.lower(k) .. string.lower(pseudorandom_element(uno_data.values, pseudoseed('unodrawtwo' .. string.lower(k)))), 'unodrawtwo_' .. string.lower(k))
								--[[if card.edition then
									card2:set_edition(card.edition, true)
								end]]
								card2:add_to_deck()
								G.consumeables:emplace(card2)
								card:juice_up(0.3, 0.5)
							return true
						end, 0.4, nil, 'after')
					end
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
		end
	}
	
	SMODS.Consumable {
		key = 'uno_' .. string.lower(k) .. 'skip',
		loc_txt = {
			name = k .. ' Skip',
			text = {
				'{C:' .. string.lower(v) .. '}' .. v .. '{C:red} siphons{} up to{C:attention} half a level',
				'from {C:attention}all{} of the {C:attention}other{} suits',
				spriter('jenwalter666')
			}
		},
		set = 'jen_uno',
		pos = { x = 4, y = k == 'Red' and 5 or k == 'Blue' and 6 or k == 'Green' and 7 or k == 'Yellow' and 8 or 5 },
		cost = 4,
		unlocked = true,
		discovered = true,
		atlas = 'jenuno',
		ignore_kudaai = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			jl.h('Other Ranks & Suits', '...', '...', '')
			if (G.SETTINGS.FASTFORWARD or 0) < 1 then
				Q(function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
					return true
				end, 0.9, nil, 'after')
				jl.hc('-', true)
				Q(function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
					return true
				end, 0.9, nil, 'after')
				jl.hm('-', true)
				Q(function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
					return true
				end, 0.9, nil, 'after')
				jl.hlv('-0~0.5')
				play_sound_q('button', 0.9, 0.7)
			else
				Q(function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
					return true
				end, 0.9, nil, 'after')
				jl.h('Other Ranks & Suits', '-', '-', '-0~0.5', true)
			end
			delay(1.3)
			local siphoned = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					local to_siphon = to_big(math.max(0, math.min(G.GAME.suits[b].level, 0.5)))
					siphoned = siphoned + to_siphon
					level_up_suit(card, b, true, -to_siphon)
				end
			end
			level_up_suit(card, v, nil, siphoned)
		end,
		bulk_use = function(self, card, area, copier, number)
			jl.h('Other Ranks & Suits', '...', '...', '')
			if (G.SETTINGS.FASTFORWARD or 0) < 1 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hc('-', true)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hm('-', true)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hlv('-0~' .. (number / 2))
				play_sound_q('button', 0.9, 0.7)
			else
				Q(function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
					return true
				end, 0.9, nil, 'after')
				jl.h('Other Ranks & Suits', '-', '-', '-0~' .. (number / 2), true)
			end
			delay(1.3)
			local siphoned = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					local to_siphon = to_big(math.max(0, math.min(G.GAME.suits[b].level, number / 2)))
					siphoned = siphoned + to_siphon
					level_up_suit(card, b, true, -to_siphon)
				end
			end
			level_up_suit(card, v, nil, siphoned)
		end
	}
	
	SMODS.Consumable {
		key = 'uno_' .. string.lower(k) .. 'reverse',
		loc_txt = {
			name = k .. ' Reverse',
			text = {
				'Swap the level of {C:' .. string.lower(v) .. '}' .. v,
				'with the level of the {C:attention}highest',
				'level among the {C:attention}other suits{},',
				'then {C:attention}level up both suits by 1',
				spriter('jenwalter666')
			}
		},
		set = 'jen_uno',
		pos = { x = 5, y = k == 'Red' and 5 or k == 'Blue' and 6 or k == 'Green' and 7 or k == 'Yellow' and 8 or 5 },
		cost = 4,
		unlocked = true,
		discovered = true,
		atlas = 'jenuno',
		ignore_kudaai = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			local selected = v
			local highest = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					if G.GAME.suits[b].level > highest then
						highest = G.GAME.suits[b].level
						selected = b
					end
				end
			end
			delay(.5)
			local level1 = G.GAME.suits[v].level
			local level2 = G.GAME.suits[selected].level
			if level1 ~= level2 then
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
				delay(.25)
				play_sound_q('jen_misc1')
				card:speak('Swapped!')
				level_up_suit(card, v, nil, level2 - level1, true)
				level_up_suit(card, selected, nil, level1 - level2, true)
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot2'); return true end)
			else
				card:speak('No change!')
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
			end
			delay(.25)
			play_sound_q('jen_misc1', 1.15)
			level_up_suit(card, selected, nil, 1, true)
			level_up_suit(card, v, nil, 1)
		end,
		bulk_use = function(self, card, area, copier, number)
			local selected = v
			local highest = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					if G.GAME.suits[b].level > highest then
						highest = G.GAME.suits[b].level
						selected = b
					end
				end
			end
			delay(.5)
			local level1 = G.GAME.suits[v].level
			local level2 = G.GAME.suits[selected].level
			if level1 ~= level2 and number / 2 ~= math.ceil(number / 2) then
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
				delay(.25)
				play_sound_q('jen_misc1')
				card:speak('Swapped!')
				level_up_suit(card, v, nil, level2 - level1, true)
				level_up_suit(card, selected, nil, level1 - level2, true)
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot2'); return true end)
			else
				card:speak('No change!')
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
			end
			delay(.25)
			play_sound_q('jen_misc1', 1.15)
			level_up_suit(card, selected, nil, number, true)
			level_up_suit(card, v, nil, number)
		end
	}
end

SMODS.Consumable {
	key = 'uno_wild',
	loc_txt = {
		name = 'Wild',
		text = {
			'Level up {C:attention}all {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s',
			'by {C:attention}#1#{}, plus {C:attention}another #1#',
			'for {C:attention}each playing card',
			'in deck that {C:attention}has the relative suit',
			'{C:inactive}({C:hearts}#2#{C:inactive}, {C:spades}#3#{C:inactive}, {C:clubs}#4#{C:inactive}, {C:diamonds}#5#{C:inactive})',
			spriter('jenwalter666')
		}
	},
	config = {levels = 0.1},
	set = 'jen_uno',
	pos = { x = 0, y = 4 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'jenuno',
	ignore_kudaai = true,
	can_mass_use = true,
    loc_vars = function(self, info_queue, center)
		local suits = jl.countsuit()
		if type(suits) ~= 'table' then suits = {} end
        return {vars = {((center or {}).ability or {}).levels or 0.1, suits.Hearts or 0, suits.Spades or 0, suits.Clubs or 0, suits.Diamonds or 0}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels, true)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels * number, true)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'uno_drawfour',
	loc_txt = {
		name = 'Wild Draw Four',
		text = {
			'Create {C:attention}4{} random {C:uno}UNO{}',
			'cards and level up {C:attention}all {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s',
			'by {C:attention}#1#{}, plus {C:attention}another #1#',
			'for {C:attention}each playing card',
			'in deck that {C:attention}has the relative suit',
			'{C:inactive}({C:hearts}#2#{C:inactive}, {C:spades}#3#{C:inactive}, {C:clubs}#4#{C:inactive}, {C:diamonds}#5#{C:inactive})',
			mayoverflow,
			spriter('jenwalter666')
		}
	},
	config = {levels = 0.05},
	set = 'jen_uno',
	pos = { x = 1, y = 4 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'jenuno',
	ignore_kudaai = true,
	can_mass_use = true,
    loc_vars = function(self, info_queue, center)
		local suits = jl.countsuit()
		if type(suits) ~= 'table' then suits = {} end
        return {vars = {((center or {}).ability or {}).levels or 0.05, suits.Hearts or 0, suits.Spades or 0, suits.Clubs or 0, suits.Diamonds or 0}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels, true)
		end
		jl.ch()
			if not card.already_used_once then
				card.already_used_once = true
				for i = 1, 4 do
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('jen_draw')
							local card2 = create_card('jen_uno', G.consumeables, nil, nil, nil, nil, nil, 'unodrawfour')
							--[[if card.edition then
								card2:set_edition(card.edition, true)
							end]]
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels * number, true)
		end
			if not card.already_used_once then
				card.already_used_once = true
				for i = 1, 4 * number do
					Q(function()
							play_sound('jen_draw')
							local card2 = create_card('jen_uno', G.consumeables, nil, nil, nil, nil, nil, 'unodrawfour')
							--[[if card.edition then
								card2:set_edition(card.edition, true)
							end]]
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end, 0.4, nil, 'after')
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'uno_wild_paint',
	loc_txt = {
		name = 'Wild Paint',
		text = {
			'Level up {C:attention}all {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s',
			'by {C:attention}#1#{}, plus {C:attention}another #1#',
			'for {C:attention}each playing card',
			'in deck that {C:attention}has the relative suit{},',
			'and create a {C:attention}Draw Two{} of relative colours',
			'for {C:attention}every 2 occurrences{} of that suit',
			'{C:inactive}({C:hearts}#2#{C:inactive}, {C:spades}#3#{C:inactive}, {C:clubs}#4#{C:inactive}, {C:diamonds}#5#{C:inactive})',
			spriter('jenwalter666')
		}
	},
	config = {levels = 0.01},
	set = 'Spectral',
	pos = { x = 3, y = 4 },
	cost = 5,
	hidden = true,
	unlocked = true,
	discovered = true,
	soul_set = 'jen_uno',
	atlas = 'jenuno',
	ignore_kudaai = true,
	can_mass_use = true,
    loc_vars = function(self, info_queue, center)
		local suits = jl.countsuit()
		if type(suits) ~= 'table' then suits = {} end
        return {vars = {((center or {}).ability or {}).levels or 0.01, suits.Hearts or 0, suits.Spades or 0, suits.Clubs or 0, suits.Diamonds or 0}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels, true)
				if v / 2 > 1 then
					Q(function()
							play_sound('jen_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_jen_uno_' .. suit_to_uno(k) .. 'drawtwo', 'uno_paint')
							if math.floor(v / 2) > 1 then
								card2:setQty(math.floor(v / 2))
								card2:create_stack_display()
							end
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end, 0.4, nil, 'after')
				end
			delay(0.6)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels * number, true)
				if v / 2 > 1 then
					Q(function()
							play_sound('jen_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_jen_uno_' .. suit_to_uno(k) .. 'drawtwo', 'uno_paint')
							card2:setQty(math.floor(v / 2) * number)
							card2:create_stack_display()
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end, 0.4, nil, 'after')
				end
			delay(0.6)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'uno_null',
	loc_txt = {
		name = 'Null',
		text = {
			'Does nothing',
			spriter('jenwalter666')
		}
	},
	set = 'jen_uno',
	pos = { x = 9, y = 9 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'jenuno',
	can_mass_use = true,
	in_pool = function() return false end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
	end,
	bulk_use = function(self, card, area, copier, number)
	end
}

--OMEGA CONSUMABLES (global, used by vouchers.lua)

omegaconsumables = {
	'ankh',
	'aura',
	'black_hole',
	'ceres',
	'chariot',
	'cryptid',
	'death',
	'deja_vu',
	'devil',
	'earth',
	'ectoplasm',
	'emperor',
	'empress',
	'eris',
	'familiar',
	'fool',
	'grim',
	'hanged_man',
	'hermit',
	'hex',
	'hierophant',
	'high_priestess',
	'immolate',
	'incantation',
	'judgement',
	'jupiter',
	'justice',
	'lovers',
	'magician',
	'mars',
	'medium',
	'mercury',
	'moon',
	'neptune',
	'ouija',
	'planet_x',
	'pluto',
	'saturn',
	'sigil',
	'soul',
	'star',
	'strength',
	'sun',
	'talisman',
	'temperance',
	'tower',
	'trance',
	'uranus',
	'venus',
	'wheel_of_fortune',
	'world',
	'wraith'
}

local omegaplanets = {
	{
		n = 'Pluto',
		c = 'pluto',
		h = 'High Card',
		y = 9
	},
	{
		n = 'Mercury',
		c = 'mercury',
		h = 'Pair',
		y = 6
	},
	{
		n = 'Uranus',
		c = 'uranus',
		h = 'Two Pair',
		y = 11
	},
	{
		n = 'Venus',
		c = 'venus',
		h = 'Three of a Kind',
		y = 12
	},
	{
		n = 'Saturn',
		c = 'saturn',
		h = 'Straight',
		y = 10
	},
	{
		n = 'Jupiter',
		c = 'jupiter',
		h = 'Flush',
		y = 4
	},
	{
		n = 'Earth',
		c = 'earth',
		h = 'Full House',
		y = 2
	},
	{
		n = 'Mars',
		c = 'mars',
		h = 'Four of a Kind',
		y = 5
	},
	{
		n = 'Neptune',
		c = 'neptune',
		h = 'Straight Flush',
		y = 7
	},
	{
		n = 'Planet X',
		c = 'planet_x',
		h = 'Five of a Kind',
		y = 8
	},
	{
		n = 'Ceres',
		c = 'ceres',
		h = 'Flush House',
		y = 1
	},
	{
		n = 'Eris',
		c = 'eris',
		h = 'Flush Five',
		y = 3
	}
}

for k, v in pairs(omegaplanets) do
	SMODS.Consumable {
		key = v.c .. '_omega',
		loc_txt = {
			name = v.n .. ' {C:dark_edition}Omega',
			text = {
				'{C:attention,s:1.5,E:1}' .. v.h .. '',
				' ',
				'{C:attention}Triples {C:chips}Chips{}, {C:chips}Level Chips{}, {C:mult}Mult{}, and {C:mult}Level Mult{},',
				'and then {C:attention}doubles{} current {C:planet}level'
			}
		},
		set = 'jen_omegaconsumable',
		pos = { x = 0, y = v.y },
		soul_pos = { x = 1, y = v.y },
		cost = 15,
		no_doe = true,
		aurinko = true,
		unlocked = true,
		discovered = true,
		gloss = true,
		soul_rate = 0,
		atlas = 'jenomegaplanets',
		hidden = true,
		hidden2 = true,
		can_stack = true,
		can_divide = true,
		can_bulk_use = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			local hand = v.h
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].l_chips, mult = G.GAME.hands[hand].l_mult, level=G.GAME.hands[hand].level})
			G.GAME.hands[hand].l_chips = G.GAME.hands[hand].l_chips * 3
			G.GAME.hands[hand].l_mult = G.GAME.hands[hand].l_mult * 3
			Q(function()
				play_sound('jen_boost1', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {chips = 'x3', StatusText = true})
			Q(function()
				play_sound('jen_boost2', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {mult = 'x3', StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = G.GAME.hands[hand].l_chips, mult = G.GAME.hands[hand].l_mult})
			delay(2)
			update_operator_display()
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 1}, {chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult})
			G.GAME.hands[hand].chips = G.GAME.hands[hand].chips * 3
			G.GAME.hands[hand].mult = G.GAME.hands[hand].mult * 3
			Q(function()
				play_sound('jen_boost3', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {chips = 'x3', StatusText = true})
			Q(function()
				play_sound('jen_boost4', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {mult = 'x3', StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult})
			level_up_hand(card, hand, false, G.GAME.hands[hand].level)
			jl.ch()
		end,
		bulk_use = function(self, card, area, copier, number)
			local hand = v.h
			local factor = to_big(3) ^ number
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].l_chips, mult = G.GAME.hands[hand].l_mult, level=G.GAME.hands[hand].level})
			G.GAME.hands[hand].l_chips = G.GAME.hands[hand].l_chips * factor
			G.GAME.hands[hand].l_mult = G.GAME.hands[hand].l_mult * factor
			Q(function()
				play_sound('jen_boost1', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 0.3}, {chips = 'x' .. number_format(factor), StatusText = true})
			Q(function()
				play_sound('jen_boost2', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 0.3}, {mult = 'x' .. number_format(factor), StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = G.GAME.hands[hand].l_chips, mult = G.GAME.hands[hand].l_mult})
			delay(2)
			update_operator_display()
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 1}, {chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult})
			G.GAME.hands[hand].chips = G.GAME.hands[hand].chips * 3
			G.GAME.hands[hand].mult = G.GAME.hands[hand].mult * 3
			Q(function()
				play_sound('jen_boost3', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 0.3}, {chips = 'x' .. number_format(factor), StatusText = true})
			Q(function()
				play_sound('jen_boost4', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 0.3}, {mult = 'x' .. number_format(factor), StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult})
			level_up_hand(card, hand, false, G.GAME.hands[hand].level * (number <= 1 and number or (2 ^ number)) - (number <= 1 and 0 or G.GAME.hands[hand].level))
			jl.ch()
		end
	}
end

	SMODS.Consumable {
		key = 'black_hole_omega',
		loc_txt = {
			name = '{C:dark_edition}Sagittarius A*',
			text = {
				'{C:attention}Nonuples {C:chips}Chips{}, {C:chips}Level Chips{}, {C:mult}Mult{}, and {C:mult}Level Mult{},',
				'and then {C:attention}quadruples{} current {C:planet}level{} of {C:purple}all poker hands'
			}
		},
		set = 'jen_omegaconsumable',
		pos = { x = 0, y = 0 },
		soul_pos = { x = 1, y = 0 },
		cost = 15,
		soul_rate = 0,
		fusable = true,
		no_doe = true,
		unlocked = true,
		discovered = true,
		atlas = 'jenomegaplanets',
		gloss = true,
		hidden = true,
		hidden2 = true,
		can_stack = true,
		can_divide = true,
		can_bulk_use = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			jl.th('all')
			Q(function()
				play_sound('jen_boost1', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {chips = 'x9', StatusText = true})
			Q(function()
				play_sound('jen_boost2', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {mult = 'x9', StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = '+++', mult = '+++'})
			delay(2)
			update_operator_display()
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 1}, {chips = '...', mult = '...'})
			Q(function()
				play_sound('jen_boost3', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {chips = 'x9', StatusText = true})
			Q(function()
				play_sound('jen_boost4', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {mult = 'x9', StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = '+++', mult = '+++'})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {level = 'x4'})
			for k, v in pairs(G.handlist) do
				local hand = v
				G.GAME.hands[hand].l_chips = G.GAME.hands[hand].l_chips * 9
				G.GAME.hands[hand].l_mult = G.GAME.hands[hand].l_mult * 9
				G.GAME.hands[hand].chips = G.GAME.hands[hand].chips * 9
				G.GAME.hands[hand].mult = G.GAME.hands[hand].mult * 9
				level_up_hand(card, hand, true, G.GAME.hands[hand].level * 3)
			end
			jl.ch()
		end,
		bulk_use = function(self, card, area, copier, number)
			local factor = to_big(9) ^ number
			update_operator_display_custom('Per Lv.', G.C.WHITE)
			jl.th('all')
			Q(function()
				play_sound('jen_boost1', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {chips = 'x' .. number_format(factor), StatusText = true})
			Q(function()
				play_sound('jen_boost2', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {mult = 'x' .. number_format(factor), StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = '+++', mult = '+++'})
			delay(2)
			update_operator_display()
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 1}, {chips = '...', mult = '...'})
			Q(function()
				play_sound('jen_boost3', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {chips = 'x' .. number_format(factor), StatusText = true})
			Q(function()
				play_sound('jen_boost4', 1, 0.4)
				card:juice_up(0.8, 0.5)
				return true
			end, 1, nil, 'after')
			update_hand_text({delay = 1}, {mult = 'x' .. number_format(factor), StatusText = true})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = '+++', mult = '+++'})
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {level = 'x' .. number_format(4^number)})
			for k, v in pairs(G.handlist) do
				local hand = v
				G.GAME.hands[hand].l_chips = G.GAME.hands[hand].l_chips * factor
				G.GAME.hands[hand].l_mult = G.GAME.hands[hand].l_mult * factor
				G.GAME.hands[hand].chips = G.GAME.hands[hand].chips * factor
				G.GAME.hands[hand].mult = G.GAME.hands[hand].mult * factor
				level_up_hand(card, hand, true, (G.GAME.hands[hand].level * (number <= 1 and 4 or (4^number))) - G.GAME.hands[hand].level)
			end
			jl.ch()
		end
	}

SMODS.Consumable {
	key = 'ankh_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Ankh {C:dark_edition}Omega',
		text = {
			'Create {C:attention}4{} copies',
			'of a {C:attention}selected Joker',
			'{C:inactive}(Chooses randomly if no Joker is chosen)',
			'{C:inactive}(Does not require room, but may overflow)'
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	cost = 20,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and #((G.jokers or {}).cards or {}) > 0
	end,
	use = function(self, card, area, copier)
		local joker = G.jokers.highlighted[1]
		if not joker then
			joker = G.jokers.cards[pseudorandom('ankhexrandom', 1, #G.jokers.cards)]
		end
		if joker then
			for i = 1, 4 do	
				local ankhcard = copy_card(joker)
				ankhcard:start_materialize()
				ankhcard:add_to_deck()
				G.jokers:emplace(ankhcard)
			end
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		local joker = G.jokers.highlighted[1]
		if not joker then
			joker = G.jokers.cards[pseudorandom('ankhexrandom', 1, #G.jokers.cards)]
		end
		if joker then
			for i = 1, 4 * number do	
				local ankhcard = copy_card(joker)
				ankhcard:start_materialize()
				ankhcard:add_to_deck()
				G.jokers:emplace(ankhcard)
			end
		end
	end
}

SMODS.Consumable {
	key = 'aura_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Aura {C:dark_edition}Omega',
		text = {
			'Apply a random {C:cry_exotic}Exotic Edition',
			'to any {C:attention}selected Joker{} and/or to',
			'{C:attention}any number{} of {C:attention}selected playing cards',
			'{C:inactive}(Can overwrite editions)'
		}
	},
	pos = { x = 0, y = 1 },
	soul_pos = { x = 1, y = 1 },
	cost = 20,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and (#G.jokers.highlighted + #G.hand.highlighted) > 0 and #G.jokers.highlighted <= 1
	end,
	use = function(self, card, area, copier)
		local joker = G.jokers.highlighted[1]
		if joker then
			joker:set_edition({[exotic_editions[pseudorandom('auraexrandom', 1, #exotic_editions)]] = true})
		end
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.hand.highlighted) do
				v:set_edition({[exotic_editions[pseudorandom('auraexrandom', 1, #exotic_editions)]] = true})
			end
		end
	end
}

SMODS.Consumable {
	key = 'cryptid_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Cryptid {C:dark_edition}Omega',
		text = {
			'Create {C:attention}20{} copies of',
			'{C:attention}any number{} of {C:attention}selected playing cards'
		}
	},
	pos = { x = 0, y = 2 },
	soul_pos = { x = 1, y = 2 },
	cost = 20,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			for k, v in ipairs(G.hand.highlighted) do
				for i = 1, 20 do	
					local cryptidcard = copy_card(v)
					cryptidcard:start_materialize()
					cryptidcard:add_to_deck()
					G.hand:emplace(cryptidcard)
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					table.insert(G.playing_cards, cryptidcard)
				end
			end
		end
	end,
	bulk_use = function(self, card, area, copier, number)
		if #G.hand.highlighted > 0 then
			for k, v in ipairs(G.hand.highlighted) do
				for i = 1, 20 * number do	
					local cryptidcard = copy_card(v)
					cryptidcard:start_materialize()
					cryptidcard:add_to_deck()
					G.hand:emplace(cryptidcard)
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					table.insert(G.playing_cards, cryptidcard)
				end
			end
		end
	end
}

local exsealcards = {
	{
		n = 'Deja Vu',
		c = 'deja_vu',
		s = 'Red',
		y = 3
	},
	{
		n = 'Medium',
		c = 'medium',
		s = 'Purple',
		y = 10
	},
	{
		n = 'Talisman',
		c = 'talisman',
		s = 'Gold',
		y = 13
	},
	{
		n = 'Trance',
		c = 'trance',
		s = 'Blue',
		y = 14
	}
}

for k, v in pairs(exsealcards) do
	SMODS.Consumable {
		key = v.c .. '_omega',
		set = 'jen_omegaconsumable',
		loc_txt = {
			name = v.n .. ' {C:dark_edition}Omega',
			text = {
				'Apply a {C:attention}' .. v.s .. ' Seal{} to',
				'{C:attention}all playing cards{} you currently have'
			}
		},
		pos = { x = 0, y = v.y },
		soul_pos = { x = 1, y = v.y },
		cost = 20,
		soul_rate = 0,
		unlocked = true,
		discovered = true,
		no_doe = true,
		hidden = true,
		hidden2 = true,
		gloss = true,
		atlas = 'jenomegaspectrals',
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			if G.hand and G.hand.cards then
				for _, card in pairs(G.hand.cards) do
					card:set_seal(v.s, k > 50, k > 50)
				end
			end
			if G.deck and G.deck.cards then
				for _, card in pairs(G.deck.cards) do
					card:set_seal(v.s, true, true)
				end
			end
		end
	}
end

SMODS.Consumable {
	key = 'ectoplasm_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Ectoplasm {C:dark_edition}Omega',
		text = {
			'Apply {C:dark_edition}Negative{} to {C:attention}every Joker',
			'{C:inactive}(Overwrites any existing edition, except for Exotic+ editions)'
		}
	},
	pos = { x = 0, y = 4 },
	soul_pos = { x = 1, y = 4 },
	cost = 100,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and #((G.jokers or {}).cards or {}) > 0
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(G.jokers.cards) do
			if not v:is_exotic_edition() then
				v.no_forced_edition = true
				v:set_edition({negative = true}, k > 200, k > 200)
				v.no_forced_edition = nil
			end
		end
	end
}

SMODS.Consumable {
	key = 'familiar_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Familiar {C:dark_edition}Omega',
		text = {
			'Add a {C:attention}full set{} of {C:jen_RGB,E:1}Moire {C:attention}Kings{},',
			'{C:cry_exotic,E:1}Blood {C:attention}Queens{} and {C:cry_exotic,E:1}Bloodfoil {C:attention}Jacks',
			'to your deck'
		}
	},
	pos = { x = 0, y = 5 },
	soul_pos = { x = 1, y = 5 },
	cost = 100,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		createcardset('_K', nil, 'jen_moire', 1)
		createcardset('_Q', nil, 'jen_blood', 1)
		createcardset('_J', nil, 'jen_bloodfoil', 1)
	end,
	bulk_use = function(self, card, area, copier, number)
		createcardset('_K', nil, 'jen_moire', number)
		createcardset('_Q', nil, 'jen_blood', number)
		createcardset('_J', nil, 'jen_bloodfoil', number)
	end
}

SMODS.Consumable {
	key = 'grim_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Grim {C:dark_edition}Omega',
		text = {
			'Add two {C:attention}full sets{} of',
			'{C:jen_RGB,E:1}Moire {C:attention}Aces{} to your deck'
		}
	},
	pos = { x = 0, y = 6 },
	soul_pos = { x = 1, y = 6 },
	cost = 80,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		createcardset('_A', nil, 'jen_moire', 2)
	end,
	bulk_use = function(self, card, area, copier, number)
		createcardset('_A', nil, 'jen_moire', 2 * number)
	end
}

SMODS.Consumable {
	key = 'hex_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Hex {C:dark_edition}Omega',
		text = {
			'Apply a random {C:cry_exotic,E:1}Exotic Edition{} to',
			'a {C:green}random selection{} of {C:attention}half',
			'of your {C:attention}Jokers{} that {C:attention}do not already have',
			'an {C:cry_exotic,E:1}Exotic Edition'
		}
	},
	pos = { x = 0, y = 7 },
	soul_pos = { x = 1, y = 7 },
	cost = 150,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local possible_selections = {}
		for k, v in pairs(G.jokers.cards) do
			if not v:is_exotic_edition() then
				table.insert(possible_selections, v)
			end
		end
		if #possible_selections > 0 then
			local selections = {}
			local toselect = math.ceil(#possible_selections / 2)
			local tries = 1e4
			local choice
			while toselect > 0 and tries > 0 do
				choice = possible_selections[pseudorandom('hex_omega_selection', 1, #possible_selections)]
				if not choice.selectedbyhexex then
					choice.selectedbyhexex = true
					table.insert(selections, choice)
					toselect = toselect - 1
				end
				tries = tries - 1
			end
			if #selections > 0 then
				for k, v in pairs(selections) do
					v:set_edition({[exotic_editions[pseudorandom('hexexrandom', 1, #exotic_editions)]] = true})
				end
			else
				card_status_text(card, 'No targets!', nil, 0.05*card.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
			end
		else
			card_status_text(card, 'No targets!', nil, 0.05*card.T.h, G.C.RED, nil, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
		end
	end
}

SMODS.Consumable {
	key = 'immolate_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Immolate {C:dark_edition}Omega',
		text = {
			'Select {C:attention}any number{} of playing cards to {C:red}destroy{},',
			"For each destroyed card; {C:money}money{} is {C:attention}multiplied{} by {C:attention}R{},",
			"all hands {C:planet}level up{} by {X:green,C:white}3x{C:attention}R{},",
			"and increase Joker slots by {C:attention}R",
			'{C:inactive}(R = card rank)',
			'{C:inactive}(Stones are treated as a 2)'
		}
	},
	pos = { x = 0, y = 8 },
	soul_pos = { x = 1, y = 8 },
	cost = 200,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.hand.highlighted) do
				local rank = v:norank() and 2 or v:get_id()
				if rank >= 1 then
					ease_dollars(math.min(1e308, G.GAME.dollars * rank - G.GAME.dollars))
					G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
						v:juice_up(0.5, 0.5)
						return true
					end }))
					delay(0.25)
					lvupallhands(rank * 3, v, true)
					delay(0.25)
					G.jokers:change_size_absolute(rank)
					delay(0.25)
					G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
						v:start_dissolve()
						return true
					end }))
				end
			end
		end
	end
}

SMODS.Consumable {
	key = 'incantation_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Incantation {C:dark_edition}Omega',
		text = {
			'Add a {C:attention}full set{} of cards {C:attention}2{} through {C:attention}10',
			'to your deck, with {C:cry_exotic,E:1}Bloodfoil{} on {C:attention}odd ranks{} and {C:cry_exotic,E:1}Blood{} on {C:attention}even ranks'
		}
	},
	pos = { x = 0, y = 9 },
	soul_pos = { x = 1, y = 9 },
	cost = 175,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		createcardset('_2', nil, 'jen_blood', 1)
		createcardset('_3', nil, 'jen_bloodfoil', 1)
		createcardset('_4', nil, 'jen_blood', 1)
		createcardset('_5', nil, 'jen_bloodfoil', 1)
		createcardset('_6', nil, 'jen_blood', 1)
		createcardset('_7', nil, 'jen_bloodfoil', 1)
		createcardset('_8', nil, 'jen_blood', 1)
		createcardset('_9', nil, 'jen_bloodfoil', 1)
		createcardset('_T', nil, 'jen_blood', 1)
	end,
	bulk_use = function(self, card, area, copier, number)
		createcardset('_2', nil, 'jen_blood', number)
		createcardset('_3', nil, 'jen_bloodfoil', number)
		createcardset('_4', nil, 'jen_blood', number)
		createcardset('_5', nil, 'jen_bloodfoil', number)
		createcardset('_6', nil, 'jen_blood', number)
		createcardset('_7', nil, 'jen_bloodfoil', number)
		createcardset('_8', nil, 'jen_blood', number)
		createcardset('_9', nil, 'jen_bloodfoil', number)
		createcardset('_T', nil, 'jen_blood', number)
	end
}

SMODS.Consumable {
	key = 'ouija_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Ouija {C:dark_edition}Omega',
		text = {
			'Select {C:attention}any number{} of cards,',
			'all other cards whose rank',
			'{C:attention}does not match any of the selected cards',
			'will be removed and {C:money}sold',
			'{C:inactive}(Removes Diplopia from card before selling)'
		}
	},
	pos = { x = 0, y = 11 },
	soul_pos = { x = 1, y = 11 },
	cost = 175,
	soul_rate = 0,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		local targets = {}
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.playing_cards) do
				local safe = false
				if not v.highlighted then
					for a, b in pairs(G.hand.highlighted) do
						if b:get_id() == v:get_id() or (b:norank() and v:norank()) then
							safe = true
							break
						end
					end
				end
				if not safe and not v.highlighted then
					if v.edition and v.edition.jen_diplopia then
						v:set_edition(nil, true, true)
					end
					table.insert(targets, v)
				end
			end
		end
		if #targets > 0 then
			bulk_sell_cards(targets, true, true)
		end
	end
}

SMODS.Consumable {
	key = 'sigil_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Sigil {C:dark_edition}Omega',
		text = {
			'Select {C:attention}any number{} of cards,',
			'all other cards whose suit',
			'{C:attention}does not match any of the selected cards',
			'will be removed and {C:money}sold',
			'{C:inactive}(Ignores effect of Wilds; card\'s ACTUAL suit must match)',
			'{C:inactive}(Removes Diplopia from card before selling)'
		}
	},
	pos = { x = 0, y = 12 },
	soul_pos = { x = 1, y = 12 },
	soul_rate = 0,
	cost = 175,
	unlocked = true,
	discovered = true,
	no_doe = true,
	hidden = true,
	hidden2 = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		local targets = {}
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.playing_cards) do
				local safe = false
				if not v.highlighted then
					for a, b in pairs(G.hand.highlighted) do
						if (b:norank() and v:norank()) or b.base.suit == v.base.suit then
							safe = true
							break
						end
					end
				end
				if not safe and not v.highlighted then
					if v.edition and v.edition.jen_diplopia then
						v:set_edition(nil, true, true)
					end
					table.insert(targets, v)
				end
			end
		end
		if #targets > 0 then
			bulk_sell_cards(targets, true, true)
		end
	end
}

SMODS.Consumable {
	key = 'wraith_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'Wraith {C:dark_edition}Omega',
		text = {
			'Create one of every {C:cry_epic,E:1}Epic{} and',
			'{C:legendary,E:1}Legendary {C:almanac,E:1}Jen\'s Almanac {C:attention}Joker',
			mayoverflow
		}
	},
	pos = { x = 0, y = 15 },
	soul_pos = { x = 1, y = 15 },
	cost = 175,
	soul_rate = 0,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	gloss = true,
	atlas = 'jenomegaspectrals',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(G.P_CENTERS) do
			if v.set == 'Joker' and string.sub(k, 1, 6) == 'j_jen_' and (tostring(v.rarity) == 'cry_epic' or (type(v.rarity) == 'number' and v.rarity == 4)) then
				local card2 = jl.card(v.key)
				card2:add_to_deck()
				G.jokers:emplace(card2)
			end
		end
	end
}

SMODS.Consumable {
	key = 'fool_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'The Fool {C:dark_edition}Omega',
		text = {
			'Create {C:attention}2{} random',
			'{C:red,E:1}Omega{} cards',
			'{C:inactive}(Excludes Balatro\'s Soul)',
			mayoverflow
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	cost = 175,
	soul_rate = 0,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	atlas = 'jenomegatarots',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local to_generate = 2
		local cntr
		while to_generate > 0 do
			cntr = ('c_jen_' .. pseudorandom_element(omegaconsumables, pseudoseed('fool_omega')) .. '_omega')
			while cntr == 'c_jen_soul_omega' do
				cntr = ('c_jen_' .. pseudorandom_element(omegaconsumables, pseudoseed('fool_omega')) .. '_omega')
			end
			if G.P_CENTERS[cntr] then
				local card2 = create_card('jen_omegaconsumable', G.consumeables, nil, nil, nil, nil, cntr, 'fool_omega')
				card2:add_to_deck()
				G.consumeables:emplace(card2)
				to_generate = to_generate - 1
			end
		end
	end
}

local omega_copyamount = 19
for k, v in ipairs(enhancetarots_info) do
	SMODS.Consumable {
		key = v.b .. '_omega',
		set = 'jen_omegaconsumable',
		loc_txt = {
			name = v.o .. ' {C:dark_edition}Omega',
			text = {
				'Select {C:attention}any number{} of cards to enhance to {C:attention}' .. v.c .. '{} cards,',
				'{C:red}destroy all other cards{} and {C:attention}duplicate the selected cards ' .. omega_copyamount .. ' times'
			}
		},
		pos = { x = 0, y = v.omega },
		soul_pos = { x = 1, y = v.omega },
		cost = 35,
		soul_rate = 0,
		hidden = true,
		hidden2 = true,
		unlocked = true,
		discovered = true,
		no_doe = true,
		atlas = 'jenomegatarots',
		can_use = function(self, card)
			return jl.canuse() and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
		end,
		use = function(self, card, area, copier)
			local targets = {}
			for k, v in ipairs(G.playing_cards) do
				if not v.highlighted then v:destroy() end
			end
			delay(1)
			if #G.hand.highlighted > 0 then
				Q(function()
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
					return true
				end, 0.4, nil, 'after')
				for i=1, #G.hand.highlighted do
					local CARD = G.hand.highlighted[i]
					table.insert(targets, CARD)
					local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
					Q(function() CARD:flip();play_sound('card1', percent);CARD:juice_up(0.3, 0.3);return true end, 0.15, nil, 'after')
				end
				delay(0.2)
				for i=1, #G.hand.highlighted do
					local CARD = G.hand.highlighted[i]
					local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
					Q(function() G.hand:remove_from_highlighted(CARD);CARD:flip();CARD:set_ability(v.e, true, nil);play_sound('tarot2', percent);CARD:juice_up(0.3, 0.3);return true end, 0.15, nil, 'after')
				end
			end
			Q(function()
				for k, v in ipairs(targets) do
					for i = 1, omega_copyamount do
						local dupe = copy_card(v)
						dupe:start_materialize()
						dupe:add_to_deck()
						G.hand:emplace(dupe)
						G.playing_card = (G.playing_card and G.playing_card + 1) or 1
						table.insert(G.playing_cards, dupe)
					end
				end
			return true end)
		end
	}
end

SMODS.Consumable {
	key = 'high_priestess_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'The High Priestess {C:dark_edition}Omega',
		text = {
			'Every {C:attention}Joker{}, {C:attention}consumable{},',
			'and {C:attention}playing card{} will trigger',
			'as if they were {C:spectral}Black Holes'
		}
	},
	pos = { x = 0, y = 2 },
	soul_pos = { x = 1, y = 2 },
	cost = 200,
	soul_rate = 0,
	dangerous = true,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	atlas = 'jenomegatarots',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local uneditioned_lvups = not card.edition and 1 or 0
		if card.edition then
			lvupallhands(card:getQty(), card, true)
		end
		for k, v in ipairs(G.jokers.cards) do
			if v.edition then
				lvupallhands(1, v, true)
			else
				uneditioned_lvups = uneditioned_lvups + 1
			end
		end
		for k, v in ipairs(G.consumeables.cards) do
			if v.edition then
				lvupallhands(v:getQty(), v, true)
			else
				uneditioned_lvups = uneditioned_lvups + v:getQty()
			end
		end
		for k, v in ipairs(G.playing_cards) do
			if v.edition then
				lvupallhands(1, v, true)
			else
				uneditioned_lvups = uneditioned_lvups + 1
			end
		end
		if uneditioned_lvups > 0 then
			lvupallhands(uneditioned_lvups, nil, true)
		end
	end
}

SMODS.Consumable {
	key = 'emperor_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'The Emperor {C:dark_edition}Omega',
		text = {
			'Create a random {C:cry_exotic,E:1}Exotic {C:attention}Joker',
			'for every {C:attention}King{} in your deck',
			'Temporarily create a {X:attention}Showman',
			'for the joker-creation process',
			mayoverflow
		}
	},
	pos = { x = 0, y = 4 },
	soul_pos = { x = 1, y = 4 },
	cost = 300,
	soul_rate = 0,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	atlas = 'jenomegatarots',
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		local showman = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ring_master', 'tempshowman')
		showman.ability.eternal = true
		showman:add_to_deck()
		G.jokers:emplace(showman)
		local exotics_to_create = 0
		for k, v in ipairs(G.playing_cards) do
			if not v:norank() and v:get_id() == 13 then
				exotics_to_create = exotics_to_create + 1
			end
		end
		if exotics_to_create < 0 then exotics_to_create = 1 end
		for i = 1, exotics_to_create do
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
				play_sound('timpani')
				local exotic = create_card('Joker', G.jokers, nil, "cry_exotic", nil, nil, nil, 'cry_gateway')
				exotic:add_to_deck()
				G.jokers:emplace(exotic)
				exotic:juice_up(0.3, 0.5)
            return true end }))
		end
		Q(function() showman:destroy() return true end)
	end
}

SMODS.Consumable {
	key = 'hermit_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'The Hermit {C:dark_edition}Omega',
		text = {
			'Gain {X:money,C:dark_edition,s:1.25}+$^2{C:inactive,s:0.75} (+$#1#)'
		}
	},
	pos = { x = 0, y = 9 },
	soul_pos = { x = 1, y = 9 },
	cost = 50,
	soul_rate = 0,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	atlas = 'jenomegatarots',
	can_use = function(self, card)
		return jl.canuse()
	end,
    loc_vars = function(self, info_queue, center)
        return {vars = {((G.GAME or {}).dollars or 0) ^ 2}}
    end,
	use = function(self, card, area, copier)
		ease_dollars(G.GAME.dollars ^ 2)
	end
}

SMODS.Consumable {
	key = 'wheel_of_fortune_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = 'The Wheel of Fortune {C:dark_edition}Omega',
		text = {
			'Create {C:dark_edition,s:1.5,E:1}#1#{} random {C:attention}consumables',
			'Temporarily create a {X:attention}Showman',
			'for the consumable-creation process',
			'{C:inactive}(Created cards cannot roll for OMEGA)'
		}
	},
	pos = { x = 0, y = 10 },
	soul_pos = { x = 1, y = 10 },
	cost = 50,
	soul_rate = 0,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	atlas = 'jenomegatarots',
	can_use = function(self, card)
		return jl.canuse()
	end,
	loc_vars = function(self, info_queue, center)
		return {vars = { (CFG and CFG.omega_wheel_count) or (Jen and Jen.config and Jen.config.omega_wheel_count) or 200 }}
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card
		local showman = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ring_master', 'tempshowman')
		showman.ability.eternal = true
		showman:add_to_deck()
		G.jokers:emplace(showman)
		Q(function()
			local count = (CFG and CFG.omega_wheel_count) or (Jen and Jen.config and Jen.config.omega_wheel_count) or 200
			local max_cap = 500 -- absolute safety ceiling (restored from previous 5000 test cap)
			for i = 1, math.min(count, max_cap) do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
						play_sound('timpani')
						local _card = create_card('Consumeables', G.consumables, nil, nil, nil, nil, nil, 'wofomega')
						_card.no_omega = true
						_card:add_to_deck()
						G.consumeables:emplace(_card)
						used_consumable:juice_up(0.3, 0.5)
				return true end }))
			end
			Q(function() showman:destroy() return true end)
		return true end)
	end
}

for kk, vv in pairs(suittarots_info) do
	
	SMODS.Consumable {
		key = vv.b .. '_omega',
		set = 'jen_omegaconsumable',
		loc_txt = {
			name = 'The ' .. string.upper(string.sub(vv.b, 1, 1)) .. string.sub(vv.b, 2, string.len(vv.b)) .. ' {C:dark_edition}Omega',
			text = {
				'Convert {C:attention}all {C:' .. string.lower(vv.s) .. '}' .. vv.s .. '{} in full deck',
				'into {C:cry_exotic,E:1}Exotic{} cards',
				'{C:inactive}(Does not consider Wilds, the actual suit must match)'
			}
		},
		pos = { x = 0, y = vv.o },
		soul_pos = { x = 1, y = vv.o },
		cost = 250,
		soul_rate = 0,
		hidden = true,
		hidden2 = true,
		unlocked = true,
		discovered = true,
		no_doe = true,
		atlas = 'jenomegatarots',
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			play_sound('jen_pop')
			for k, v in ipairs(G.playing_cards) do
				if v.base.suit == vv.s and not v:nosuit() then
					if v.area == G.hand then
						Q(function() v:set_ability(G.P_CENTERS['m_jen_exotic']) play_sound('jen_pop') v:juice_up(1, 0.5) return true end, 0.75)
					else
						v:set_ability(G.P_CENTERS['m_jen_exotic'])
					end
				end
			end
		end
	}
end

local randtext = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',' ','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','-','?','!','$','%','[',']','(',')'}

local function obfuscatedtext(length)
	local str = ''
	for i = 1, length do
		str = str .. randtext[math.random(#randtext)]
	end
	return str
end

SMODS.Consumable {
	key = 'soul_omega',
	set = 'jen_omegaconsumable',
	loc_txt = {
		name = '{C:red,s:3}Balatro\'s Soul',
		text = {
			'{C:red,s:5,E:1}?????'
		}
	},
	pos = { x = 0, y = 22 },
	soul_pos = { x = 1, y = 22, extra = {x = 2, y = 22} },
	cost = 0,
	soul_rate = 0,
	gloss = true,
	hidden = true,
	hidden2 = true,
	unlocked = true,
	discovered = true,
	no_doe = true,
	atlas = 'jenomegatarots',
	can_use = function(self, card)
		return jl.canuse() and not ((G.GAME or {}).banned_keys or {}).c_jen_soul_omega and #SMODS.find_card('j_jen_kosmos', true) <= 0
	end,
	use = function(self, card, area, copier)
		if not G.GAME.banned_keys then G.GAME.banned_keys = {} end
		G.GAME.banned_keys.c_jen_soul_omega = true
		jl.rd(1)
		for i = 1, 60 do
			card_status_text(card, obfuscatedtext(math.random(6,18)), nil, 0.05*card.T.h, G.C.RED, 0.6, 2.5 - (i/50), 0.4, 0.4, 'bm', 'generic1')
		end
		Q(function()
			for k, v in pairs(G.jokers.cards) do
				v:destroy()
			end
			for k, v in pairs(G.consumeables.cards) do
				v:destroy()
			end
			for k, v in pairs(G.playing_cards) do
				v:destroy()
			end
			for k, v in pairs(G.GAME.tags) do
				v:remove()
			end
		return true end)
		jl.rd(3)
		if G.GAME.round_resets.ante > 2 then ease_ante(math.floor(-G.GAME.round_resets.ante / 4 * 3), true, true, true) end
		createfulldeck()
		jl.a('Baaaa.', G.SETTINGS.GAMESPEED, 1, G.C.RED)
		card.sell_cost = 0
		Q(function()
			local kosmos = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jen_kosmos', 'thekingslayer')
			kosmos.ability.eternal = true
			kosmos:add_to_deck()
			G.jokers:emplace(kosmos)
			Q(function() G.jokers:set_size_absolute(1) set_dollars(4) return true end, 0.1, nil, 'after')
			G.consumeables:change_size_absolute(G.consumeables.config.card_limit)
		return true end, 1)
	end
}
SMODS.Consumable {
    key = 'fateeater_c',
    loc_txt = {
        name = 'Fateful Cuisine',
        text = {
            '{C:red}Devours {C:tarot}Tarot{} cards',
            'to {C:attention}provide a random amount of',
            '{C:planet}levels{}, {C:chips}+Chips{}, {C:mult}+Mult{},',
            '{X:chips,C:white}xChips{}, {X:mult,C:white}xMult{},',
            '{X:dark_edition,C:chips}^Chips{} and {X:dark_edition,C:red}^Mult',
            'to {C:attention}every poker hand, scaling with {C:attention}Ante',
            '{X:dark_edition,C:white}Negative{} {X:dark_edition,C:white}Ability:{} Levels up all poker hands once',
        }
    },
    config = {},
    set = 'jen_ability',
    permaeternal = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 15,
    dangerous = true,
    unlocked = true,
    discovered = true,
    hidden = true,
    hidden2 = true,
    no_doe = true,
    soul_rate = 0,
    atlas = 'jenfateeater_c',
    can_use = function(self, card)
        return abletouseabilities()
    end,
    keep_on_use = function(self, card)
        return #SMODS.find_card('j_jen_fateeater') > 0 and not (card.edition or {}).negative
    end,
    use = function(self, card, area, copier)
        if (card.edition or {}).negative then
            lvupallhands(1, card)
        end
        local targets = {}
        for k, v in pairs(G.consumeables.cards) do
            if v.ability.set == 'Tarot' and not v.alrm then
                v.alrm = true
                table.insert(targets, v)
            end
        end
        if #targets > 0 then
            local intensity = 0
            for k, v in pairs(targets) do
                intensity = intensity + 1 + (v:getQty()/2) - 0.5
                G.consumeables:remove_card(v)
                G.play:emplace(v)
            end
            for _, hand in ipairs(G.handlist) do
                local fastforward = false
                jl.th(hand)
                for k, v in pairs(targets) do
                    local qty = v:getQty()
                    fastforward = intensity > 5
                    local ante = math.min(math.max(1, G.GAME.round_resets.ante), 1e9)
                    local levels = pseudorandom(pseudoseed('fateeater_levels'), ante, ante * 5)
                    local addchips = pseudorandom(pseudoseed('fateeater_chips'), 25 * ante, 50 * ante)
                    local addmult = pseudorandom(pseudoseed('fateeater_mult'), 4 * ante, 30 * ante)
                    local xchips = pseudorandom(pseudoseed('fateeater_xchips'), 20 * (ante/2), 50 * ante) / 10
                    local xmult = pseudorandom(pseudoseed('fateeater_xmult'), 20 * (ante/2), 50 * ante) / 10
                    local echips = pseudorandom(pseudoseed('fateeater_echips'))/3 + 1 + (ante / 50)
                    local emult = pseudorandom(pseudoseed('fateeater_emult'))/3 + 1 + (ante / 50)
                    if fastforward then
                        for i = 1, qty do
                            G.GAME.hands[hand].chips = ((G.GAME.hands[hand].chips + addchips) * xchips) ^ echips
                            G.GAME.hands[hand].mult = ((G.GAME.hands[hand].mult + addmult) * xmult) ^ emult
                        end
                    else
                        for i = 1, qty do
                            fastlv(v, hand, nil, levels)
                            G.GAME.hands[hand].chips = ((G.GAME.hands[hand].chips + addchips) * xchips) ^ echips
                            G.GAME.hands[hand].mult = ((G.GAME.hands[hand].mult + addmult) * xmult) ^ emult
                            Q(function() play_sound('chips1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = '+' .. tostring(addchips), StatusText = true})
                            Q(function() play_sound('talisman_xchip'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = 'x' .. tostring(xchips), StatusText = true})
                            Q(function() play_sound('talisman_echip'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = '^' .. tostring(jl.round(echips, 3)), StatusText = true})
                            Q(function() play_sound('multhit1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = '+' .. tostring(addmult), StatusText = true})
                            Q(function() play_sound('multhit2'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = 'x' .. tostring(xmult), StatusText = true})
                            Q(function() play_sound('talisman_emult', 1); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = '^' .. tostring(jl.round(emult, 3)), StatusText = true})
                        end
                    end
                end
                if fastforward then
                    Q(function() play_sound('button'); return true end, 0.3, nil, 'after')
                    update_hand_text({delay = 1.3}, {chips = '+++', mult = '+++', level = '+++', StatusText = true})
                end
                update_hand_text({sound = 'button', volume = 0.5, pitch = 1.1, delay = 3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
            end
            Q(function()
                for k, v in pairs(targets) do v:remove() end
                return true
            end, 0.5, nil, 'after')
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Nothing to devour!', colour = G.C.MULT})
        end
        jl.ch()
    end
}

SMODS.Consumable {
    key = 'foundry_c',
    loc_txt = {
        name = 'Paranormal Deliquesce',
        text = {
            '{C:red}Smelts {C:spectral}Spectral{} cards',
            'to {C:attention}provide a random amount of',
            '{C:planet}levels{}, {C:chips}+Chips{}, {C:mult}+Mult{},',
            '{X:chips,C:white}xChips{}, {X:mult,C:white}xMult{},',
            '{X:dark_edition,C:chips}^Chips{} and {X:dark_edition,C:red}^Mult',
            'to {C:attention}every poker hand, scaling with {C:attention}Ante',
            '{X:dark_edition,C:white}Negative{} {X:dark_edition,C:white}Ability:{} Levels up all poker hands once',
        }
    },
    config = {},
    set = 'jen_ability',
    permaeternal = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 15,
    dangerous = true,
    unlocked = true,
    discovered = true,
    hidden = true,
    hidden2 = true,
    no_doe = true,
    soul_rate = 0,
    atlas = 'jenfoundry_c',
    can_use = function(self, card)
        return abletouseabilities()
    end,
    keep_on_use = function(self, card)
        return #SMODS.find_card('j_jen_foundry') > 0 and not (card.edition or {}).negative
    end,
    use = function(self, card, area, copier)
        if (card.edition or {}).negative then
            lvupallhands(1, card)
        end
        local targets = {}
        for k, v in pairs(G.consumeables.cards) do
            if v.ability.set == 'Spectral' and not v.alrm then
                v.alrm = true
                table.insert(targets, v)
            end
        end
        if #targets > 0 then
            local intensity = 0
            for k, v in pairs(targets) do
                intensity = intensity + 1 + (v:getQty()/2) - 0.5
                G.consumeables:remove_card(v)
                G.play:emplace(v)
            end
            for _, hand in ipairs(G.handlist) do
                local fastforward = false
                jl.th(hand)
                for k, v in pairs(targets) do
                    local qty = v:getQty()
                    fastforward = intensity > 5
                    local ante = math.min(math.max(1, G.GAME.round_resets.ante), 1e9)
                    local levels = pseudorandom(pseudoseed('foundry_levels'), ante, ante * 5)
                    local addchips = pseudorandom(pseudoseed('foundry_chips'), 25 * ante, 50 * ante)
                    local addmult = pseudorandom(pseudoseed('foundry_mult'), 4 * ante, 30 * ante)
                    local xchips = pseudorandom(pseudoseed('foundry_xchips'), 20 * (ante/2), 50 * ante) / 10
                    local xmult = pseudorandom(pseudoseed('foundry_xmult'), 20 * (ante/2), 50 * ante) / 10
                    local echips = pseudorandom(pseudoseed('foundry_echips'))/3 + 1 + (ante / 50)
                    local emult = pseudorandom(pseudoseed('foundry_emult'))/3 + 1 + (ante / 50)
                    if fastforward then
                        for i = 1, qty do
                            G.GAME.hands[hand].chips = ((G.GAME.hands[hand].chips + addchips) * xchips) ^ echips
                            G.GAME.hands[hand].mult = ((G.GAME.hands[hand].mult + addmult) * xmult) ^ emult
                        end
                    else
                        for i = 1, qty do
                            fastlv(v, hand, nil, levels)
                            G.GAME.hands[hand].chips = ((G.GAME.hands[hand].chips + addchips) * xchips) ^ echips
                            G.GAME.hands[hand].mult = ((G.GAME.hands[hand].mult + addmult) * xmult) ^ emult
                            Q(function() play_sound('chips1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = '+' .. tostring(addchips), StatusText = true})
                            Q(function() play_sound('chips1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = 'x' .. tostring(xchips), StatusText = true})
                            Q(function() play_sound('talisman_xchip'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = '^' .. tostring(jl.round(echips, 3)), StatusText = true})
                            Q(function() play_sound('multhit1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = '+' .. tostring(addmult), StatusText = true})
                            Q(function() play_sound('multhit2'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = 'x' .. tostring(xmult), StatusText = true})
                            Q(function() play_sound('talisman_emult', 1); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = '^' .. tostring(jl.round(emult, 3)), StatusText = true})
                        end
                    end
                end
                if fastforward then
                    Q(function() play_sound('button'); return true end, 0.3, nil, 'after')
                    update_hand_text({delay = 1.3}, {chips = '+++', mult = '+++', level = '+++', StatusText = true})
                end
                update_hand_text({sound = 'button', volume = 0.5, pitch = 1.1, delay = 3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
            end
            Q(function()
                for k, v in pairs(targets) do
                    v:remove()
                end
                return true
            end, 0.5, nil, 'after')
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Nothing to devour!', colour = G.C.MULT})
        end
        jl.ch()
    end
}

SMODS.Consumable {
    key = 'broken_c',
    loc_txt = {
        name = 'Extraterrestrial Rend',
        text = {
            '{C:red}Shatters {C:planet}Planet{} cards',
            'to {C:attention}provide a random amount of',
            '{C:planet}levels{}, {C:chips}+Chips{}, {C:mult}+Mult{},',
            '{X:chips,C:white}xChips{}, {X:mult,C:white}xMult{},',
            '{X:dark_edition,C:chips}^Chips{} and {X:dark_edition,C:red}^Mult',
            'to {C:attention}every poker hand, scaling with {C:attention}Ante',
            '{X:dark_edition,C:white}Negative{} {X:dark_edition,C:white}Ability:{} Levels up all poker hands once',
        }
    },
    config = {},
    set = 'jen_ability',
    permaeternal = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 15,
    dangerous = true,
    unlocked = true,
    discovered = true,
    hidden = true,
    hidden2 = true,
    no_doe = true,
    soul_rate = 0,
    atlas = 'jenbroken_c',
    can_use = function(self, card)
        return abletouseabilities()
    end,
    keep_on_use = function(self, card)
        return #SMODS.find_card('j_jen_broken') > 0 and not (card.edition or {}).negative
    end,
    use = function(self, card, area, copier)
        if (card.edition or {}).negative then
            lvupallhands(1, card)
        end
        local targets = {}
        for k, v in pairs(G.consumeables.cards) do
            if v.ability.set == 'Planet' and not v.alrm then
                v.alrm = true
                table.insert(targets, v)
            end
        end
        if #targets > 0 then
            local intensity = 0
            for k, v in pairs(targets) do
                intensity = intensity + 1 + (v:getQty()/2) - 0.5
                G.consumeables:remove_card(v)
                G.play:emplace(v)
            end
            for _, hand in ipairs(G.handlist) do
                local fastforward = false
                jl.th(hand)
                for k, v in pairs(targets) do
                    local qty = v:getQty()
                    fastforward = intensity > 5
                    local ante = math.min(math.max(1, G.GAME.round_resets.ante), 1e9)
                    local levels = pseudorandom(pseudoseed('broken_levels'), ante, ante * 5)
                    local addchips = pseudorandom(pseudoseed('broken_chips'), 25 * ante, 50 * ante)
                    local addmult = pseudorandom(pseudoseed('broken_mult'), 4 * ante, 30 * ante)
                    local xchips = pseudorandom(pseudoseed('broken_xchips'), 20 * (ante/2), 50 * ante) / 10
                    local xmult = pseudorandom(pseudoseed('broken_xmult'), 20 * (ante/2), 50 * ante) / 10
                    local echips = pseudorandom(pseudoseed('broken_echips'))/3 + 1 + (ante / 50)
                    local emult = pseudorandom(pseudoseed('broken_emult'))/3 + 1 + (ante / 50)
                    if fastforward then
                        for i = 1, qty do
                            G.GAME.hands[hand].chips = ((G.GAME.hands[hand].chips + addchips) * xchips) ^ echips
                            G.GAME.hands[hand].mult = ((G.GAME.hands[hand].mult + addmult) * xmult) ^ emult
                        end
                    else
                        for i = 1, qty do
                            fastlv(v, hand, nil, levels)
                            G.GAME.hands[hand].chips = ((G.GAME.hands[hand].chips + addchips) * xchips) ^ echips
                            G.GAME.hands[hand].mult = ((G.GAME.hands[hand].mult + addmult) * xmult) ^ emult
                            Q(function() play_sound('chips1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = '+' .. tostring(addchips), StatusText = true})
                            Q(function() play_sound('talisman_xchip'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = 'x' .. tostring(xchips), StatusText = true})
                            Q(function() play_sound('talisman_echip'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {chips = '^' .. tostring(jl.round(echips, 3)), StatusText = true})
                            Q(function() play_sound('multhit1'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = '+' .. tostring(addmult), StatusText = true})
                            Q(function() play_sound('multhit2'); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = 'x' .. tostring(xmult), StatusText = true})
                            Q(function() play_sound('talisman_emult', 1); v:juice_up(0.8, 0.5); return true end, 0.3, nil, 'after')
                            update_hand_text({delay = 1.3}, {mult = '^' .. tostring(jl.round(emult, 3)), StatusText = true})
                        end
                    end
                end
                if fastforward then
                    Q(function() play_sound('button'); return true end, 0.3, nil, 'after')
                    update_hand_text({delay = 1.3}, {chips = '+++', mult = '+++', level = '+++', StatusText = true})
                end
                update_hand_text({sound = 'button', volume = 0.5, pitch = 1.1, delay = 3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
            end
            Q(function()
                for k, v in pairs(targets) do
                    v:remove()
                end
                return true
            end, 0.5, nil, 'after')
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Nothing to devour!', colour = G.C.MULT})
        end
        jl.ch()
    end
}

SMODS.Consumable {
    key = 'roffle_c',
    loc_txt = {
        name = 'The Coin',
        text = {
            '{X:spectral,C:white}Mana{} : {C:spectral}#1# {C:inactive}/ #2#',
            'If {C:dark_edition}Negative{}, add {C:spectral}5 mana{},',
            'Otherwise, spend mana to {C:attention}defeat the blind instantly',
            faceart('jenwalter666'),
            origin('Hearthstone')
        }
    },
    config = {mana = 0},
    set = 'jen_ability',
    permaeternal = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    cost = 0,
    unlocked = true,
    discovered = true,
    hidden = true,
    hidden2 = true,
    no_doe = true,
    soul_rate = 0,
    atlas = 'jenroffle_c',
    loc_vars = function(self, info_queue, center)
        local isneg = ((center or {}).edition or {}).negative
        return {vars = {isneg and '---' or center.ability.mana, (G.GAME or {}).roffle_manareq or Jen.config.mana_cost}}
    end,
    can_use = function(self, card)
        return (((card.edition or {}).negative or card.ability.mana >= ((G.GAME or {}).roffle_manareq or Jen.config.mana_cost)) and abletouseabilities()) and G.GAME.blind
    end,
    keep_on_use = function(self, card)
        return #SMODS.find_card('j_jen_roffle') > 0 and not (card.edition or {}).negative
    end,
    use = function(self, card, area, copier)
        if not G.GAME.roffle_manareq then G.GAME.roffle_manareq = Jen.config.mana_cost end
        if (card.edition or {}).negative then
            for k, v in ipairs(G.consumeables.cards) do
                if v.gc and v:gc() and v:gc().key == 'c_jen_roffle_c' and not (v.edition or {}).negative then
                    v.ability.mana = v.ability.mana + 5
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = '+5 Mana', colour = G.C.SECONDARY_SET.Spectral})
                    break
                end
            end
        elseif card.ability.mana >= G.GAME.roffle_manareq then
            card.ability.mana = card.ability.mana - G.GAME.roffle_manareq
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '-' .. number_format(G.GAME.roffle_manareq) .. ' Mana', colour = G.C.RED})
            G.GAME.roffle_manareq = G.GAME.roffle_manareq * 2
            Q(function()
                Q(function()
                    Q(function()
                        Q(function()
                            G.GAME.chips = G.GAME.blind.chips
                            G.STATE = G.STATES.HAND_PLAYED
                            G.STATE_COMPLETE = true
                            end_round()
                        return true end)
                        jl.ch()
                    return true end)
                return true end)
            return true end)
        end
    end
    }

    SMODS.Consumable {
        key = 'swabbie_c',
        loc_txt = {
            name = 'Plunder',
            text = {
                '{C:money}Sells{} all {C:blue}selected',
                '{C:attention}playing cards',
                '{X:dark_edition,C:white}Negative{} {X:dark_edition,C:white}Ability:{} Gain an additional {C:money}$5',
                '{C:inactive}(Selection value : {X:money,C:white}$#1#{C:inactive})'
            }
        },
        config = {},
        set = 'jen_ability',
        permaeternal = true,
        pos = { x = 0, y = 0 },
        soul_pos = { x = 1, y = 0 },
        cost = 0,
        unlocked = true,
        discovered = true,
        hidden = true,
        hidden2 = true,
        no_doe = true,
        soul_rate = 0,
        atlas = 'jenswabbie_c',
        loc_vars = function(self, info_queue, center)
            return {vars = {sellvalueofhighlightedhandcards()}}
        end,
        can_use = function(self, card)
            return ((card.edition or {}).negative or #G.hand.highlighted > (card.area == G.hand and 1 or 0)) and (#G.hand.highlighted < #G.hand.cards) and abletouseabilities()
        end,
        keep_on_use = function(self, card)
            return #SMODS.find_card('j_jen_swabbie') > 0 and not (card.edition or {}).negative
        end,
        use = function(self, card, area, copier)
            if #G.hand.highlighted > 0 then
                play_sound('coin2')
                card:juice_up(0.3, 0.4)
                for k, v in pairs(G.hand.highlighted) do
                    if v ~= card then
                        v:sell_card_jokercalc()
                    end
                end
                if #G.hand.cards - #G.hand.highlighted < G.hand.config.card_limit and #G.deck.cards > 0 then
                    for i = 1, math.min(G.hand.config.card_limit - (#G.hand.cards - #G.hand.highlighted), #G.deck.cards) do
                        draw_card(G.deck,G.hand, 1, nil, true, nil, 0.07)
                    end
                end
            end
            if (card.edition or {}).negative then
                ease_dollars(5)
            end
        end
    }

    SMODS.Consumable {
        key = 'nyx_c',
        loc_txt = {
            name = 'Goddess\'s Call',
            text = {
                'Switches the ability of {X:attention}Nyx{} {X:attention}Equinox{C:attention} on/off',
                '{X:dark_edition,C:white}Negative{} {X:dark_edition,C:white}Ability:{} Does not toggle {X:attention}Nyx{} {X:attention}Equinox{C:attention} on/off{},',
                'instead granting {C:green}+1 energy{} to {X:attention}Nyx{} {X:attention}Equinox',
                '{C:inactive,s:1.35}(Currently {C:attention,s:1.35}#1#{C:inactive,s:1.35})'
            }
        },
        config = {},
        set = 'jen_ability',
        permaeternal = true,
        pos = { x = 0, y = 0 },
        soul_pos = { x = 1, y = 0 },
        cost = 0,
        unlocked = true,
        discovered = true,
        hidden = true,
        hidden2 = true,
        no_doe = true,
        soul_rate = 0,
        atlas = 'jennyx_c',
        loc_vars = function(self, info_queue, center)
            return {vars = {(G.GAME or {}).nyx_enabled and 'ENABLED' or 'DISABLED'}}
        end,
        can_use = function(self, card)
            return abletouseabilities()
        end,
        keep_on_use = function(self, card)
            return (#SMODS.find_card('j_jen_nyx') + #SMODS.find_card('j_jen_paragon')) > 0 and not (card.edition or {}).negative
        end,
        use = function(self, card, area, copier)
            if (card.edition or {}).negative then
                for k, v in ipairs(SMODS.find_card('j_jen_nyx')) do
                    v.ability.extra.energy = math.min(v.ability.extra.energy + 1, nyx_maxenergy)
                    card_status_text(v, v.ability.extra.energy .. '/' .. nyx_maxenergy, nil, 0.05*v.T.h, G.C.GREEN, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                end
                for k, v in ipairs(SMODS.find_card('j_jen_paragon')) do
                    v.ability.extra.energy = math.min(v.ability.extra.energy + 1, nyx_maxenergy*3)
                    card_status_text(v, v.ability.extra.energy .. '/' .. nyx_maxenergy*3, nil, 0.05*v.T.h, G.C.GREEN, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                end
            else
                G.GAME.nyx_enabled = not G.GAME.nyx_enabled
            end
        end
    }

    SMODS.Consumable {
        key = 'artificer_c',
        loc_txt = {
            name = 'Pyrotechnic Engineering',
            text = {
                '{C:red}Destroys{} all selected playing cards, giving various effects',
                "{C:inactive}(R = destroyed card's rank)",
                '{C:hearts}Hearts{} : All hands receive {X:mult,C:white}x(1 + (R/10)){} Mult',
                '{C:spades}Spades{} : All hands receive {X:chips,C:white}x(1 + (R/20)){} Chips',
                '{C:diamonds}Diamonds{} : Create {C:attention}R consumable(s) {C:inactive}(does not require room, copies edition)',
                '{C:clubs}Clubs{} : {C:planet}Level up{} all hands {C:attention}R{} time(s)',
                '{C:jen_RGB}Wilds{} : {C:purple}Applies all of the above',
                '{X:inactive}Stones/Rankless{} : All other {C:attention}playing cards{} gain {C:chips}+5,000{} bonus chips',
                ' ',
                '{X:dark_edition,C:white}Negative{} {X:dark_edition,C:white}Ability:{} Applies effects {C:attention}without destroying{} selected cards'
            }
        },
        set = 'jen_ability',
        permaeternal = true,
        pos = { x = 0, y = 0 },
        soul_pos = { x = 1, y = 0 },
        cost = 0,
        unlocked = true,
        discovered = true,
        hidden = true,
        hidden2 = true,
        no_doe = true,
        soul_rate = 0,
        atlas = 'jenartificer_c',
        can_use = function(self, card)
            return (#G.hand.highlighted > (card.area == G.hand and 1 or 0)) and abletouseabilities()
        end,
        keep_on_use = function(self, card)
            return #SMODS.find_card('j_jen_artificer') > 0 and not (card.edition or {}).negative
        end,
        use = function(self, card, area, copier)
            local isneg = card.edition and card.edition.negative
            if #G.hand.highlighted > 0 then
                for k, v in pairs(G.hand.highlighted) do
                    if v:norank() then
                        for a, b in pairs(G.hand.cards) do
                            if not b.highlighted or (card.edition or {}).negative then
                                b.ability.perma_bonus = (b.ability.perma_bonus or 0) + 5e3
                                card_eval_status_text(b, 'extra', nil, nil, nil, {message = '+' .. b.ability.perma_bonus, colour = G.C.CHIPS})
                            end
                        end
                        for a, b in pairs(G.deck.cards) do
                            b.ability.perma_bonus = (b.ability.perma_bonus or 0) + 5e3
                            if a == 1 then
                                card_eval_status_text(b, 'extra', nil, nil, nil, {message = '+', colour = G.C.CHIPS})
                            end
                        end
                        if not isneg then
                            G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                                v:start_dissolve()
                                return true
                            end }))
                        end
                    else
                        local rank = v:get_id()
                        if rank > 0 then
                            if v:is_suit('Clubs') then
                                lvupallhands(rank, v)
                            end
                            if v:is_suit('Hearts') or v:is_suit('Spades') then
                                jl.th('all')
                            end
                            if v:is_suit('Spades') then
                                for k, v in pairs(G.GAME.hands) do
                                    G.GAME.hands[k].chips = G.GAME.hands[k].chips * (1 + (rank/20))
                                end
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 2}, {chips = 'x' .. number_format(1 + (rank/20))})
                            end
                            if v:is_suit('Hearts') then
                                for k, v in pairs(G.GAME.hands) do
                                    G.GAME.hands[k].mult = G.GAME.hands[k].mult * (1 + (rank/10))
                                end
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 2}, {mult = 'x' .. number_format(1 + (rank/10))})
                            end
                            if v:is_suit('Hearts') or v:is_suit('Spades') then
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 2}, {mult = 0, chips = 0, handname = '', level = ''})
                            end
                            if v:is_suit('Diamonds') then
                                for i = 1, rank do
                                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                        play_sound('jen_draw')
                                        local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, nil, 'pyrotechnics')
                                        if v.edition then
                                            card2:set_edition(v.edition, true)
                                        end
                                        card2:add_to_deck()
                                        G.consumeables:emplace(card2)
                                        card:juice_up(0.3, 0.5)
                                        return true
                                    end }))
                                end
                            end
                            if not isneg then
                                G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                                    v:start_dissolve()
                                    return true
                                end }))
                            end
                        end
                    end
                end
                if not isneg and #G.hand.cards - #G.hand.highlighted < G.hand.config.card_limit and #G.deck.cards > 0 then
                    for i = 1, math.min(G.hand.config.card_limit - (#G.hand.cards - #G.hand.highlighted), #G.deck.cards) do
                        draw_card(G.deck,G.hand, 1, nil, true, nil, 0.07)
                    end
                end
            end
        end
    }

    SMODS.Consumable {
        key = 'fuse',
        loc_txt = {
            name = 'Fusion',
            text = {
                '{C:attention}Combines{} selected Jokers/Consumables',
                'if they make up a {C:attention}valid recipe',
                '{C:inactive}(This card only appears if you have at least 1 fusable)',
                '{C:inactive}(Some recipes may require more than 2 ingredients. Experiment!)',
                '{V:1,s:1.25}#1#'
            }
        },
        config = {},
        no_perkeo = true,
        set = 'jen_ability',
        permaeternal = true,
        pos = { x = 0, y = 0 },
        soul_pos = { x = 1, y = 0 },
        cost = 0,
        unlocked = true,
        discovered = true,
        hidden = true,
        hidden2 = true,
        no_doe = true,
        soul_rate = 0,
        atlas = 'jenfuse',
        loc_vars = function(self, info_queue, center)
            return {vars = {center.fusion_details or 'Waiting for input', colours = {center.fusion_colour or G.C.UI.TEXT_INACTIVE}}}
        end,
        can_use = function(self, card)
            card.fusion_ready = nil
            card.target_fusion = nil
            card.fusion_colour = G.C.UI.TEXT_INACTIVE
            card.fusion_details = 'Waiting for input'
            card.input_cards = {}
            if #G.jokers.highlighted + math.max(0, #G.consumeables.highlighted - 1) > 0 then
                if #G.jokers.highlighted > 0 then
                    for k, v in ipairs(G.jokers.highlighted) do
                        table.insert(card.input_cards, v)
                    end
                end
                if #G.consumeables.highlighted > 1 then
                    for k, v in ipairs(G.consumeables.highlighted) do
                        if v ~= card then
                            table.insert(card.input_cards, v)
                        end
                    end
                end
            end
            local fusion = Jen.find_matching_recipe(card.input_cards)
            if fusion then
                        local can_afford = to_big(Jen.fusions[fusion].cost or 0) <= to_big(G.GAME.dollars)
                        if can_afford and not card.already_notified then
                            play_sound('jen_done')
                            card:juice_up(0.5, 0.5)
                            card.already_notified = true
                        elseif not can_afford then
                            card.already_notified = false
                        end
                        card.fusion_ready = can_afford
                        card.target_fusion = fusion
                        card.fusion_details = fusion .. ' : $' .. number_format(Jen.fusions[fusion].cost or 0)
                    elseif #G.jokers.highlighted + math.max(0, #G.consumeables.highlighted - 1) > 0 then
                        card.fusion_details = 'No recipe matches selected cards'
                        card.already_notified = false
                    end
            return ((card.edition or {}).negative or card.fusion_ready) and abletouseabilities()
        end,
        keep_on_use = function(self, card)
            return not (card.edition or {}).negative
        end,
        use = function(self, card, area, copier)
            if card.fusion_ready and card.target_fusion and Jen.has_ingredients(card.target_fusion) then
                fuse_cards(Jen.get_cards_for_recipe(card.target_fusion), Jen.fusions[card.target_fusion].output, (G.SETTINGS.FASTFORWARD or 0) > 1)
                ease_dollars(-Jen.fusions[card.target_fusion].cost)
            else
                card.fusion_ready = false
                card.target_fusion = nil
            end
            if (card.edition or {}).negative then
                ease_dollars(3)
            end
        end
    }

--BOOSTERS

local guiduasbr = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then
		local cen = card.gc and card:gc()
		if cen and ((Jen.hv('reserve', 1) and cen.set == 'Planet') or (Jen.hv('reserve', 2) and cen.set == 'Tarot') or (Jen.hv('reserve', 3) and cen.set == 'Spectral')) then
			return {
				n = G.UIT.ROOT,
				config = { padding = -0.1, colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "bm",
							minw = 0.5 * card.T.w - 0.15,
							minh = 0.7 * card.T.h,
							maxw = 0.7 * card.T.w - 0.15,
							hover = true,
							shadow = true,
							colour = G.C.UI.BACKGROUND_INACTIVE,
							one_press = true,
							button = "use_card",
							func = "can_reserve_card",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = 'RESERVE',
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.55,
									shadow = true,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = {
							ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "bm",
							minw = 0.5 * card.T.w - 0.15,
							maxw = 0.9 * card.T.w - 0.15,
							minh = 0.1 * card.T.h,
							hover = true,
							shadow = true,
							colour = G.C.UI.BACKGROUND_INACTIVE,
							one_press = true,
							button = 'kekw',
							func = "can_use_consumeable",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("b_use"),
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.45,
									shadow = true,
								},
							},
						},
					},
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } }
				},
			}
		end
	end
	return guiduasbr(card)
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'ministandard' .. i,
		loc_txt = {
			name = 'Mini Standard Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# playing cards{} to',
				'add to your deck',
				spriter('cozyori')
			}
		},
		atlas = 'jenbooster',
		pos = {x = 6, y = i - 1},
		weight = .8,
		cost = 2,
		config = {extra = 2, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end,
        create_UIBox = function(self) return create_UIBox_standard_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.3,
                initialize = true,
                lifespan = 3,
                speed = 0.2,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.BLACK, G.C.RED},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 2, true)
            local _seal = SMODS.poll_seal({mod = 10})
            return {set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", edition = _edition, seal = _seal, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "sta"}
        end,
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'miniarcana' .. i,
		loc_txt = {
			name = 'Mini Arcana Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:tarot}Tarot{} cards to',
				'be used immediately',
				spriter('mailingway')
			}
		},
		atlas = 'jenbooster',
		pos = {x = 3 + i, y = 1},
		weight = .8,
		cost = 2,
		config = {extra = 2, choose = 1},
		discovered = true,
		draw_hand = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.TAROT_PACK) end,
        create_UIBox = function(self) return create_UIBox_arcana_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.2,
                initialize = true,
                lifespan = 1,
                speed = 1.1,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2)},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _card
            if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
                _card = {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar2"}
            else
                _card = {set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
            end
            return _card
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'minicelestial' .. i,
		loc_txt = {
			name = 'Mini Celestial Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:planet}Planet{} cards to',
				'be used immediately',
				spriter('mailingway')
			}
		},
		atlas = 'jenbooster',
		pos = {x = 3 + i, y = 0},
		weight = .8,
		cost = 2,
		config = {extra = 2, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self) ease_background_colour_blind(G.STATES.PLANET_PACK) end,
		create_UIBox = function(self) return create_UIBox_celestial_pack() end,
		particles = function(self)
			G.booster_pack_stars = Particles(1, 1, 0,0, {
				timer = 0.07,
				scale = 0.1,
				initialize = true,
				lifespan = 15,
				speed = 0.1,
				padding = -4,
				attach = G.ROOM_ATTACH,
				colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
				fill = true
			})
			G.booster_pack_meteors = Particles(1, 1, 0,0, {
				timer = 2,
				scale = 0.05,
				lifespan = 1.5,
				speed = 4,
				attach = G.ROOM_ATTACH,
				colours = {G.C.WHITE},
				fill = true
			})
		end,
		create_card = function(self, card, i)
			local _card
			if G.GAME.used_vouchers.v_telescope and i == 1 then
				local _planet, _hand, _tally = nil, nil, 0
				for k, v in ipairs(G.handlist) do
					if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
						_hand = v
						_tally = G.GAME.hands[v].played
					end
				end
				if _hand then
					for k, v in pairs(G.P_CENTER_POOLS.Planet) do
						if v.config.hand_type == _hand then
							_planet = v.key
						end
					end
				end
				_card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key = _planet, key_append = "pl1"}
			else
				_card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "pl1"}
			end
			return _card
		end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'minispectral' .. i,
		loc_txt = {
			name = 'Mini Spectral Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:spectral}Spectral{} cards to',
				'be used immediately',
				spriter('mailingway')
			}
		},
		atlas = 'jenbooster',
		pos = {x = 3 + i, y = 2},
		weight = .45,
		cost = 2,
		config = {extra = 1, choose = 1},
		discovered = true,
		draw_hand = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.SPECTRAL_PACK) end,
        create_UIBox = function(self) return create_UIBox_spectral_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.1,
                initialize = true,
                lifespan = 3,
                speed = 0.2,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            return {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "spe"}
        end,
	}
end

for i = 1, 4 do
	SMODS.Booster{
		key = 'unopack' .. i,
		loc_txt = {
			name = 'UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i-1, y = 1},
		weight = 1,
		cost = 4,
		config = {extra = 3, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX(i == 1 and 'ED1C24' or i == 2 and '0072BC' or i == 3 and '50AA44' or i == 4 and 'FFDE16' or 'ED1C24'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'jen_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'jumbounopack' .. i,
		loc_txt = {
			name = 'Jumbo UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i-1, y = 2},
		weight = 1,
		cost = 6,
		config = {extra = 5, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX(i == 1 and 'ED1C24' or i == 2 and '0072BC' or 'ED1C24'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'jen_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'megaunopack' .. i,
		loc_txt = {
			name = 'Mega UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i+1, y = 2},
		weight = .25,
		cost = 8,
		config = {extra = 5, choose = 2},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX('2a2a2a'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'jen_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'miniunopack' .. i,
		loc_txt = {
			name = 'Mini UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i-1, y = 3},
		weight = .8,
		cost = 2,
		config = {extra = 2, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX(i == 1 and 'FFDE16' or i == 2 and '50AA44' or 'FFDE16'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'jen_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'standardbundle' .. i,
		loc_txt = {
			name = 'Standard Bundle',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# playing cards{} to',
				'add to your deck',
				spriter('cozyori')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i + 6, y = 0},
		weight = .1,
		cost = 10,
		config = {extra = 10, choose = 5},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end,
        create_UIBox = function(self) return create_UIBox_standard_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.3,
                initialize = true,
                lifespan = 3,
                speed = 0.2,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.BLACK, G.C.RED},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 2, true)
            local _seal = SMODS.poll_seal({mod = 10})
            return {set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", edition = _edition, seal = _seal, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "sta"}
        end,
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'arcanabundle' .. i,
		loc_txt = {
			name = 'Arcana Bundle',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:tarot}Tarot{} cards to',
				'be used immediately',
				spriter('cozyori')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i + 6, y = 1},
		weight = .1,
		cost = 10,
		config = {extra = 10, choose = 5},
		discovered = true,
		draw_hand = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.TAROT_PACK) end,
        create_UIBox = function(self) return create_UIBox_arcana_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.2,
                initialize = true,
                lifespan = 1,
                speed = 1.1,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2)},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _card
            if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
                _card = {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar2"}
            else
                _card = {set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
            end
            return _card
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'celestialbundle' .. i,
		loc_txt = {
			name = 'Celestial Bundle',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:planet}Planet{} cards to',
				'be used immediately',
				spriter('cozyori')
			}
		},
		atlas = 'jenbooster',
		pos = {x = i + 6, y = 2},
		weight = .8,
		cost = 10,
		config = {extra = 10, choose = 5},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self) ease_background_colour_blind(G.STATES.PLANET_PACK) end,
		create_UIBox = function(self) return create_UIBox_celestial_pack() end,
		particles = function(self)
			G.booster_pack_stars = Particles(1, 1, 0,0, {
				timer = 0.07,
				scale = 0.1,
				initialize = true,
				lifespan = 15,
				speed = 0.1,
				padding = -4,
				attach = G.ROOM_ATTACH,
				colours = {G.C.WHITE, HEX('a7d6e0'), HEX('fddca0')},
				fill = true
			})
			G.booster_pack_meteors = Particles(1, 1, 0,0, {
				timer = 2,
				scale = 0.05,
				lifespan = 1.5,
				speed = 4,
				attach = G.ROOM_ATTACH,
				colours = {G.C.WHITE},
				fill = true
			})
		end,
		create_card = function(self, card, i)
			local _card
			if G.GAME.used_vouchers.v_telescope and i == 1 then
				local _planet, _hand, _tally = nil, nil, 0
				for k, v in ipairs(G.handlist) do
					if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
						_hand = v
						_tally = G.GAME.hands[v].played
					end
				end
				if _hand then
					for k, v in pairs(G.P_CENTER_POOLS.Planet) do
						if v.config.hand_type == _hand then
							_planet = v.key
						end
					end
				end
				_card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key = _planet, key_append = "pl1"}
			else
				_card = {set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "pl1"}
			end
			return _card
		end
	}
end

SMODS.Booster{
	key = 'spectralbundle',
	loc_txt = {
		name = 'Spectral Bundle',
		text = {
			'Choose {C:attention}#1#{} of up to',
			'{C:attention}#2# {C:spectral}Spectral{} cards to',
			'be used immediately',
			spriter('cozyori')
		}
	},
	atlas = 'jenbooster',
	pos = {x = 7, y = 3},
	weight = .075,
	cost = 10,
	config = {extra = 8, choose = 4},
	discovered = true,
	draw_hand = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.choose, card.ability.extra} }
	end,
	ease_background_colour = function(self) ease_background_colour_blind(G.STATES.SPECTRAL_PACK) end,
	create_UIBox = function(self) return create_UIBox_spectral_pack() end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0,0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
			fill = true
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		return {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "spe"}
	end,
}

SMODS.Booster{
    key = 'iconpack',
    loc_txt = {
		name = '{C:red}Icon Pack',
		text = {
			'Choose {C:attention}#1#{} of up to',
			'{C:attention}#2# {C:almanac,E:1}Almanac {C:attention}Jokers',
			'{C:green}#3#% chance{} to contain {C:dark_edition,E:1}Jen\'s Sigil',
			'if you have {C:blood}Kosmos',
			'{C:green}2% chance{} to contain an {C:cry_azure,s:1.5,E:1}Extraordinary{} Joker',
			' ',
			'{C:red}Contains only Rot if the',
			'{C:red}current Ante is not greater',
			'{C:red}than the furthest Ante an',
			'{C:red}Icon Pack was opened this run',
			'{C:inactive}(Currently {V:1}Ante #4#{C:inactive})',
			spriter('mailingway')
		},
	},
	atlas = 'jenbooster',
    pos = {x = 0, y = 0},
    weight = 1,
    cost = 15,
    config = {extra = 5, choose = 1, icon_pack = true},
    discovered = true,
	in_pool = function()
		return (G.GAME.latest_ante_icon_pack_opening or 0) < G.GAME.round_resets.ante
	end,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra, math.min(1, 1 / (100 - (G.GAME.icon_pity or 0))) * 100, tostring(((G.GAME or {}).latest_ante_icon_pack_opening or 0)), colours = {((G.GAME or {}).latest_ante_icon_pack_opening or 0) < (((G.GAME or {}).round_resets or {}).ante or 0) and G.C.GREEN or G.C.RED}} }
    end,
    create_card = function(self, card, i)
		if (G.GAME.latest_ante_icon_pack_opening or 0) < G.GAME.round_resets.ante then
			local possible = {}
			for k, v in pairs(G.P_CENTERS) do
				if v.set == 'Joker' and string.sub(k, 1, 6) == 'j_jen_' and not Jen.overpowered(v.rarity) then
					table.insert(possible, v.key)
				end
			end
			if math.floor(i) == math.floor(SMODS.OPENED_BOOSTER.ability.extra) then
				G.GAME.latest_ante_icon_pack_opening = G.GAME.round_resets.ante
				if get_kosmos() then
					if jl.chance('iconpack_sigil', math.max(1, 100 - (G.GAME.icon_pity or 0)), true) then
						G.GAME.icon_pity = 0
						QR(function()
							Q(function() play_sound_q('jen_chime', .5, 0.65); jl.a('Sigil!', G.SETTINGS.GAMESPEED * 3, 2, G.C.almanac); jl.rd(3); return true end)
						return true end, 99)
						return {set = 'Joker', area = G.pack_cards, skip_materialize = true, soulable = false, key = 'j_jen_sigil', key_append = "almanac"}
					else
						G.GAME.icon_pity = (G.GAME.icon_pity or 0) + 1
					end
				end
				return {set = 'Joker', area = G.pack_cards, skip_materialize = true, soulable = false, key = pseudorandom_element(possible, pseudoseed('almanac' .. G.GAME.round_resets.ante)), key_append = "almanac"}
			elseif math.floor(i) == 1 and jl.chance('iconpack_extraordinary', 50, true) then
				QR(function()
					Q(function() play_sound_q('jen_chime', .75, 0.65); jl.a('Extraordinary!', G.SETTINGS.GAMESPEED * 2.5, 1.25, G.C.jen_RGB); jl.rd(2.5); return true end)
				return true end, 99)
				return create_card("Joker", G.pack_cards, nil, 'jen_extraordinary', true, true, nil, 'almanac')
			else
				return {set = 'Joker', area = G.pack_cards, skip_materialize = true, soulable = false, key = pseudorandom_element(possible, pseudoseed('almanac' .. G.GAME.round_resets.ante)), key_append = "almanac"}
			end
		else
			return {set = 'Joker', area = G.pack_cards, skip_materialize = true, soulable = false, key = 'j_jen_rot', key_append = "almanac"}
		end
    end,
    ease_background_colour = function(self)
        ease_background_colour{new_colour = HEX('000000'), special_colour = HEX('ff0000'), contrast = 5}
    end,
    create_UIBox = function(self)
        local _size = SMODS.OPENED_BOOSTER.ability.extra
        G.pack_cards = CardArea(
            G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
            math.max(1,math.min(_size,5))*G.CARD_W*1.1,
            1.05*G.CARD_H, 
            {card_limit = _size, type = 'consumeable', highlight_limit = 1})

        local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
            {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                        {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
            {n=G.UIT.R, config={align = "cm"}, nodes={}},
            {n=G.UIT.R, config={align = "tm"}, nodes={
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                    UIBox_dyn_container({
                        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {'Icon Pack '}, colours = {G.C.CRY_ASCENDANT},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {'Indoctrinate '}, colours = {G.C.CRY_BLOSSOM},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.CRY_EXOTIC},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                    }),}},
                {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                    {n=G.UIT.R,config={minh =0.2}, nodes={}},
                    {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                        {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
        return t
    end,
}
