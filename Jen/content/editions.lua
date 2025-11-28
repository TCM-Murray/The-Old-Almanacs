
SMODS.Edition({
    key = "dithered",
    loc_txt = {
        name = "Dithered",
        label = "Dithered",
        text = {
            "{C:red}#1#{} Chips",
            "{C:mult}+#2#{} Mult",
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'dithered',
    config = {chips = -25, mult = 33},
	sound = {
		sound = 'jen_e_dithered',
		per = 1,
		vol = 0.6
	},
    in_shop = true,
    weight = 8,
    extra_cost = 2,
    apply_to_float = false,
    loc_vars = function(self)
        return {vars = {self.config.chips, self.config.mult}}
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
})

SMODS.Edition({
    key = "sharpened",
    loc_txt = {
        name = "Sharpened",
        label = "Sharpened",
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:red}#2#{} Mult",
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'sharpened',
    config = {chips = 333, mult = -5},
	sound = {
		sound = 'jen_e_sharpened',
		per = 1.2,
		vol = 0.6
	},
    in_shop = true,
    weight = 8,
    extra_cost = 2,
    apply_to_float = false,
    loc_vars = function(self)
        return {vars = {self.config.chips, self.config.mult}}
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
})

SMODS.Edition({
    key = "prismatic",
    loc_txt = {
        name = "Prismatic",
        label = "Prismatic",
        text = {
            "{X:mult,C:white}x#1#{C:mult} Mult{}, {X:chips,C:white}x#2#{C:chips} Chips",
			'and {C:money}+$#3#{} when scored',
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    shader = "prismatic",
    discovered = true,
    unlocked = true,
    config = {x_mult = 15, x_chips = 5, p_dollars = 5},
	sound = {
		sound = 'jen_e_prismatic',
		per = 1.2,
		vol = 0.5
	},
    in_shop = true,
    weight = 0.2,
    extra_cost = 12,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.x_mult, self.config.x_chips, self.config.p_dollars } }
    end,
	calculate = function(self, card, context)
		if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
			return {
				x_mult = self.config.x_mult,
				x_chips = self.config.x_chips,
				dollars = self.config.p_dollars
			}
		end
	end
})
SMODS.Edition({
	key = "ionized",
	loc_txt = {
		name = "Ionised",
		label = "Ionised",
		text = {
			"{C:blue}+#1# Chips{}, {C:red,s:1.2}BUT",
			"{X:red,C:white}x#2#{C:red} Mult",
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
		}
	},
	shader = "ionized",
	discovered = true,
	unlocked = true,
	config = {chips = 2000, x_mult = 0.5},
	sound = {
		sound = 'jen_e_ionized',
		per = 1,
		vol = 0.5
	},
	in_shop = true,
	weight = 3,
	extra_cost = 7,
	apply_to_float = false,
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self)
		return { vars = { self.config.chips, self.config.x_mult } }
	end,
	calculate = function(self, card, context)
		if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
			return {
				chips = self.config.chips,
				x_mult = self.config.x_mult
			}
		end
	end
})

SMODS.Edition({
    key = "misprint",
    loc_txt = {
        name = "Misprint",
        label = "Misprint",
        text = {
            "Card has {C:attention}unknown, random bonus values",
            '{C:inactive}({C:tarot}+{C:inactive}, {X:tarot,C:white}x{C:inactive}, and {X:tarot,C:dark_edition}^{C:inactive} Chips and/or Mult)',
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    shader = "misprint",
	disable_base_shader = true,
	no_shadow = true,
    discovered = true,
    unlocked = true,
    config = {},
	sound = {
		sound = 'jen_e_misprint',
		per = 1,
		vol = 0.5
	},
	misc_badge = {
		colour = G.C.RARITY[3],
		text = {
			"Rare"
		}
	},
    in_shop = true,
    weight = 1.5,
    extra_cost = 8,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
})

local wee_description = {
	'{C:inactive}==On Jokers==',
	'Values of card {C:attention}increase by 8%',
	'whenever a {C:attention}2{} scores',
	'{C:inactive}(If possible)',
	' ',
	'{C:inactive}==On Playing Cards==',
	'{C:chips}Extra chips{} on card increases by',
	'{X:attention,C:white}3x{} the card\'s rank when scored',
	'{C:inactive}(2s gain +60 instead, rankless cards gain +25 instead)',
	' ',
	'{C:inactive,E:1,s:0.7}Haha, look; it\'s tiny!'
}

SMODS.Edition({
    key = "wee",
    no_edeck= true,
    loc_txt = {
        name = "Wee",
        label = "Wee",
        text = wee_description
    },
	on_apply = function(card)
		Q(function()
			card:shrink(Jen.config.wee_sizemod)
			return true
		end, nil, nil, nil, false, false)
	end,
	on_remove = function(card)
		Q(function()
			card:grow(Jen.config.wee_sizemod)
			return true
		end, nil, nil, nil, false, false)
	end,
    shader = false,
    discovered = true,
    unlocked = true,
    config = {twos_scored = 0},
	sound = {
		sound = 'jen_e_wee',
		per = 1,
		vol = 0.5
	},
    in_shop = true,
    weight = 4,
    extra_cost = 5,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight * (G.GAME.weeck and 222.22 or 1)
    end,
})

SMODS.Edition({
    key = "jumbo",
    no_edeck = true,
    loc_txt = {
        name = "Jumbo",
        label = "Jumbo",
        text = {
			"All card values are",
			"{C:attention}multiplied{} by {C:attention}up to 100",
			"{C:inactive}(If possible)",
			"{C:inactive,s:1}(May be less effective on some items)",
			"{C:inactive,E:1,s:0.7}Whoa, it's huge!!{}"
        }
    },
	misc_badge = {
		colour = G.C.RARITY[4],
		text = {
			"Legendary"
		}
	},
	on_apply = function(card)
		Q(function()
			card:grow(Jen.config.wee_sizemod)
			return true
		end, nil, nil, nil, false, false)
		local modifier = 100
		local obj = card:gc()
		if obj.set == 'Booster' or obj.jumbo_mod then
			modifier = obj.jumbo_mod or 10
		end
		local was_added = card.added_to_deck
		if was_added then
			card:remove_from_deck()
		end
		Cryptid.misprintize(card, {min = modifier, max = modifier}, nil, true)
		if was_added then
			card:add_to_deck()
		end
	end,
	on_remove = function(card)
		Q(function()
			card:shrink(Jen.config.wee_sizemod)
			return true
		end, nil, nil, nil, false, false)
		local modifier = 100
		local was_added = card.added_to_deck
		if was_added then
			card:remove_from_deck()
		end
		Cryptid.misprintize(card, {min = 1/modifier, max = 1/modifier}, nil, true)
		if was_added then
			card:add_to_deck()
		end
	end,
    shader = false,
    discovered = true,
    unlocked = true,
    config = {twos_scored = 0},
	sound = {
		sound = 'jen_e_jumbo',
		per = 1,
		vol = 0.5
	},
    in_shop = true,
    weight = 0.8,
    extra_cost = 12,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
})

SMODS.Edition({
    key = "blaze",
    loc_txt = {
        name = "Blaze",
        label = "Blaze",
        text = {
			'Retrigger this card {C:attention}#1#{} time(s), {C:red,s:1.2}BUT',
            "{C:red}#2#{C:chips} Chips{} and {C:red}#3#{C:mult} Mult",
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    shader = "blaze",
    discovered = true,
    unlocked = true,
    config = {retriggers = 5, chips = -5, mult = -1},
	sound = {
		sound = 'jen_e_blaze',
		per = 1,
		vol = 0.5
	},
    in_shop = true,
    weight = 5,
    extra_cost = 7,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.retriggers, self.config.chips, self.config.mult } }
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				retriggers = self.config.retriggers,
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				repetitions = self.config.retriggers,
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
})

SMODS.Edition({
    key = "wavy",
    loc_txt = {
        name = "Wavy",
        label = "Wavy",
        text = {
			'Retrigger this card {C:attention}#1#{} time(s)',
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
	misc_badge = {
		colour = G.C.RARITY[3],
		text = {
			"Rare"
		}
	},
    shader = "wavy",
	disable_base_shader = true,
	no_shadow = true,
    discovered = true,
    unlocked = true,
    config = {retriggers = 30},
	sound = {
		sound = 'jen_e_wavy',
		per = 1,
		vol = 0.5
	},
    in_shop = true,
    weight = 1,
    extra_cost = 13,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.retriggers } }
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				retriggers = self.config.retriggers
			}
		end
		if context.repetition and context.cardarea == G.play then
			return {
				repetitions = self.config.retriggers
			}
		end
	end
})

SMODS.Edition({
    key = "encoded",
    loc_txt = {
        name = "Encoded",
        label = "Encoded",
        text = {
			'Creates {C:attention}#1# {C:dark_edition}Negative {C:cry_code}Code{} cards',
			'when destroyed, sold or used',
			mayoverflow,
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    shader = "encoded",
    discovered = true,
    unlocked = true,
    config = {codes = 15},
	sound = {
		sound = 'jen_e_encoded',
		per = 1,
		vol = 0.5
	},
	misc_badge = {
		colour = G.C.RARITY[3],
		text = {
			"Rare"
		}
	},
    in_shop = true,
    weight = 1,
    extra_cost = 9,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.codes } }
    end
})

SMODS.Edition({
    key = "diplopia",
    loc_txt = {
        name = "Diplopia",
        label = "Diplopia",
        text = {
			'Retrigger this card {C:attention}#1#{} time(s)',
			'{C:attention}Resists{} being destroyed/sold {C:attention}once{}, after which',
			'this edition is then removed from the card',
			'{C:inactive}(Selling will still give money)',
			"{C:inactive}I'm... seeing... double...!",
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    shader = "diplopia",
    discovered = true,
    unlocked = true,
    config = {retriggers = 1},
	sound = {
		sound = 'jen_e_diplopia',
		per = 1,
		vol = 0.8
	},
    in_shop = true,
    weight = 3,
    extra_cost = 7,
    apply_to_float = true,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.retriggers } }
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				retriggers = self.config.retriggers
			}
		end
		if context.repetition and context.cardarea == G.play then
			return {
				repetitions = self.config.retriggers
			}
		end
	end
})

SMODS.Edition({
    key = "sequin",
    loc_txt = {
        name = "Sequin",
        label = "Sequin",
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:red}+#2#{} Mult",
			'Can be {C:money}sold{} for {C:attention}three times{} its cost {C:inactive}(+200% profit)',
			'Minimum sell price is always at least {C:money}$6 {C:inactive}(+500% minimum profit)',
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'sequin',
    config = { chips = 25, mult = 2 },
	sound = {
		sound = 'jen_e_sequin',
		per = 1,
		vol = 0.4
	},
    in_shop = true,
    weight = 3,
    extra_cost = 0,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = {self.config.chips, self.config.mult}}
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
})

local scr = Card.set_cost
function Card:set_cost()
	scr(self)
	if (self.edition or {}).jen_crystal then
		self.cost = 1
		self.sell_cost = 1
		self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
	end
	if (self.edition or {}).jen_sequin then
		self.sell_cost = math.max(2, (self.sell_cost or 2), (self.cost or 2)) * 3
		self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
	end
	if self.from_tag then
		self.sell_cost = 0
		self.sell_cost_label = 0
	end
end

SMODS.Edition{
    key = "laminated",
    loc_txt = {
        name = "Laminated",
        label = "Laminated",
        text = {
            "{C:blue}+#1# Chips{}, {C:red}+#2# Mult{}",
			"Card costs and sells for",
			"{C:purple}significantly less value{}"
        }
    },
    shader = "laminated",
    discovered = true,
    unlocked = true,
    config = {chips = 3, mult = 1},
	sound = {
		sound = 'jen_e_laminated',
		per = 1,
		vol = 0.4
	},
    in_shop = true,
    weight = 8,
    extra_cost = -5,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.chips, self.config.mult } }
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
}

SMODS.Edition{
    key = "crystal",
    loc_txt = {
        name = "Crystal",
        label = "Crystal",
        text = {
            "{C:chips}+#1# Chips{}",
			"Card costs and sells for {C:money}$1{}"
        }
    },
    shader = "laminated",
    discovered = true,
    unlocked = true,
	disable_base_shader = true,
	no_shadow = true,
    config = {chips = 111},
	sound = {
		sound = 'jen_e_crystal',
		per = 1,
		vol = 0.4
	},
    in_shop = true,
    weight = 4,
    extra_cost = 0,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.chips } }
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
		return {
			chips = self.config.chips
		}
	end
	if context.cardarea == G.play and context.main_scoring then
		return {
			chips = self.config.chips
		}
	end
	end
}

SMODS.Edition{
    key = "sepia",
    loc_txt = {
        name = "Sepia",
        label = "Sepia",
        text = {
            "{C:blue}+#1# Chips{}, {C:red}+#2# Mult{}",
            "Card costs and sells for",
			"{C:money}significantly more value{}",
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    shader = "sepia",
    discovered = true,
    unlocked = true,
    config = {chips = 150, mult = 9},
	sound = {
		sound = 'jen_e_sepia',
		per = 1,
		vol = 0.5
	},
    in_shop = true,
    weight = 6,
    extra_cost = 20,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    apply_to_float = false,
    loc_vars = function(self)
        return { vars = { self.config.chips, self.config.mult } }
    end,
	calculate = function(self, card, context)
		local chips = self.config.chips
		local mult = self.config.mult
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
}

SMODS.Edition{
    key = "ink",
    loc_txt = {
        name = "Ink",
        label = "Ink",
        text = {
            "{C:chips}+#1# Chips{}, {C:mult}+#2# Mult{}",
            "and {X:mult,C:white}X#3#{C:red} Mult{}",
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    shader = "ink",
    discovered = true,
    unlocked = true,
    config = { chips = 200, mult = 10, x_mult = 2 },
	sound = {
		sound = 'jen_e_ink',
		per = 1.2,
		vol = 0.4
	},
    in_shop = true,
    weight = 4,
    extra_cost = 7,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self)
        return { vars = { self.config.chips, self.config.mult, self.config.x_mult } }
    end,
	calculate = function(self, card, context)
		local chips = self.config.chips
		local mult = self.config.mult
		local x_mult = self.config.x_mult
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult,
				x_mult = self.config.x_mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult,
				x_mult = self.config.x_mult
			}
		end
	end
}

SMODS.Edition{
    key = "polygloss",
    loc_txt = {
        name = "Polygloss",
        label = "Polygloss",
        text = {
            "{C:chips}+#1#{}, {X:chips,C:white}x#2#{} & {X:chips,C:dark_edition}^#3#{} Chips",
            "{C:mult}+#4#{}, {X:mult,C:white}x#5#{} & {X:mult,C:dark_edition}^#6#{} Mult",
			"Generates {C:money}+$#7#",
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'polygloss',
    config = { chips = 1, mult = 1, x_chips = 1.1, x_mult = 1.1, e_chips = 1.01, e_mult = 1.01, p_dollars = 1 },
    in_shop = true,
    weight = 8,
	sound = {
		sound = 'jen_e_polygloss',
		per = 1.2,
		vol = 0.4
	},
    extra_cost = 2,
    apply_to_float = false,
    loc_vars = function(self)
        return { vars = {self.config.chips, self.config.x_chips, self.config.e_chips, self.config.mult, self.config.x_mult, self.config.e_mult, self.config.p_dollars}}
    end,
	calculate = function(self, card, context)
		local chips = self.config.chips
		local mult = self.config.mult
		local x_chips = self.config.x_chips
		local x_mult = self.config.x_mult
		local e_chips = self.config.e_chips
		local e_mult = self.config.e_mult
		local p_dollars = self.config.p_dollars
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult,
				x_chips = self.config.x_chips,
				x_mult = self.config.x_mult,
				e_chips = self.config.e_chips,
				e_mult = self.config.e_mult,
				p_dollars = self.config.p_dollars
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult,
				x_chips = self.config.x_chips,
				x_mult = self.config.x_mult,
				e_chips = self.config.e_chips,
				e_mult = self.config.e_mult,
				p_dollars = self.config.p_dollars
			}
		end
	end
}

SMODS.Edition{
    key = "gilded",
    loc_txt = {
        name = "Gilded",
        label = "Gilded",
        text = {
            "Generates {C:money}$#1#",
			"Card has an {C:red}extreme{C:money} buy & sell value",
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'gilded',
    config = { p_dollars = 20 },
    in_shop = true,
    weight = 2,
	sound = {
		sound = 'jen_e_gilded',
		per = 1,
		vol = 0.4
	},
	misc_badge = {
		colour = G.C.RARITY[3],
		text = {
			"Rare"
		}
	},
    extra_cost = 200,
    apply_to_float = false,
    loc_vars = function(self)
        return { vars = {self.config.p_dollars}}
    end,
	calculate = function(self, card, context)
		local p_dollars = self.config.p_dollars
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				p_dollars = self.config.p_dollars
			}
		end
		if context.main_scoring and context.cardarea == G.play then
			return {
				p_dollars = self.config.p_dollars
			}
		end
	end
}

SMODS.Edition{
    key = "chromatic",
    loc_txt = {
        name = "Chromatic",
        label = "Chromatic",
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:mult}+#2#{} Mult",
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'chromatic',
    config = { chips = 10, mult = 4 },
	sound = {
		sound = 'jen_e_chromatic',
		per = 1,
		vol = 0.5
	},
    in_shop = true,
    weight = 8,
    extra_cost = 4,
    apply_to_float = false,
    loc_vars = function(self)
        return { vars = {self.config.chips, self.config.mult}}
    end,
	calculate = function(self, card, context)
		local chips = self.config.chips
		local mult = self.config.mult
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				mult = self.config.mult
			}
		end
	end
}

SMODS.Edition{
    key = "watered",
    loc_txt = {
        name = "Watercoloured",
        label = "Watercoloured",
        text = {
            "Retrigger this card {C:attention}#1#{} times",
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'watered',
    config = { retriggers = 2 },
	sound = {
		sound = 'jen_e_watered',
		per = 1,
		vol = 0.4
	},
    in_shop = true,
    weight = 8,
    extra_cost = 4,
    apply_to_float = false,
    loc_vars = function(self)
        return {vars = {self.config.retriggers}}
    end,
	calculate = function(self, card, context)
		local retriggers = self.config.retriggers
		if context.edition and context.cardarea == G.jokers and context.joker_main and context.other_joker == self then
			return { repetitions = self.config.retriggers}
		end
		if context.repetition and context.cardarea == G.play then
			return {repetitions = self.config.retriggers}
		end
	end
}

SMODS.Edition{
    key = "reversed",
    loc_txt = {
        name = "Reversed",
        label = "Reversed",
        text = {
            '{C:chips}+#1#{} and {X:chips,C:white}x#2#{C:chips} Chips{},',
            '{C:mult}+#3#{} and {X:mult,C:white}x#4#{C:mult} Mult',
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    discovered = true,
    unlocked = true,
	disable_base_shader = true,
	no_shadow = true,
    shader = 'reversed',
    config = { chips = 300, x_chips = 3, mult = 300, x_mult = 3 },
	sound = {
		sound = 'jen_e_reversed',
		per = 1,
		vol = 0.4
	},
    in_shop = true,
    weight = 0.1,
    extra_cost = 7,
    apply_to_float = false,
    loc_vars = function(self)
        return { vars = { self.config.chips, self.config.x_chips, self.config.mult, self.config.x_mult } }
    end,
	calculate = function(self, card, context)
		local chips = self.config.chips
		local x_chips = self.config.x_chips
		local mult = self.config.mult
		local x_mult = self.config.x_mult
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = self.config.chips,
				x_chips = self.config.x_chips,
				mult = self.config.mult,
				x_mult = self.config.x_mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = self.config.chips,
				x_chips = self.config.x_chips,
				mult = self.config.mult,
				x_mult = self.config.x_mult
			}
		end
	end
}

SMODS.Edition{
    key = "missingtexture",
    loc_txt = {
        name = "Missing Textures",
        label = "Missing Textures",
        text = {
            "{X:red,C:white}x#1#{C:red} Mult{}, {C:red,s:1.2}BUT",
			"{C:red}lose {C:money}$#2#{} when scored",
			'{C:inactive,S:0.7}Someone forgot to install Counter-Strike: Source...',
			'{C:dark_edition,s:0.7,E:2}Shader by : stupxd'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'missingtexture',
    config = { x_mult = 25, p_dollars = -5 },
	sound = {
		sound = 'jen_e_missingtexture',
		per = 1,
		vol = 0.6
	},
    in_shop = true,
    weight = 3,
    extra_cost = 7,
    apply_to_float = false,
    loc_vars = function(self)
        return { vars = { self.config.x_mult, math.abs(self.config.p_dollars) } }
    end,
	calculate = function(self, card, context)
		local x_mult = self.config.x_mult
		local p_dollars = self.config.p_dollars
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				x_mult = self.config.x_mult,
				p_dollars = self.config.p_dollars
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				x_mult = self.config.x_mult,
				p_dollars = self.config.p_dollars
			}
		end
	end
}

SMODS.Edition{
    key = "bloodfoil",
    loc_txt = {
        name = "Bloodfoil",
        label = "Bloodfoil",
        text = {
            "{X:jen_RGB,C:white,s:1.5}^^#1#{C:chips} Chips"
        }
    },
	misc_badge = {
		colour = G.C.RARITY['cry_exotic'],
		text = {
			"Exotic"
		}
	},
    shader = "bloodfoil",
    discovered = true,
    unlocked = true,
    config = {ee_chips = 1.2},
	sound = {
		sound = 'negative',
		per = 0.5,
		vol = 1
	},
    weight = 0.04,
    extra_cost = 30,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight * (250 ^ #SMODS.find_card('j_jen_bulwark'))
    end,
    loc_vars = function(self)
        return { vars = { self.config.ee_chips } }
    end,
	calculate = function(self, card, context)
		local ee_chips = self.config.ee_chips
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				ee_chips = self.config.ee_chips
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				ee_chips = self.config.ee_chips
			}
		end
	end
}

SMODS.Edition {
    key = "blood",
    no_edeck = true,
    loc_txt = {
        name = "Blood",
        label = "Blood",
        text = {
            "{X:jen_RGB,C:white,s:1.5}^^#1#{C:mult} Mult",
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
    shader = "cosmic",
    discovered = true,
    unlocked = true,
    config = {ee_mult = 1.2},
	sound = {
		sound = 'negative',
		per = 0.5,
		vol = 1
	},
	misc_badge = {
		colour = G.C.RARITY['cry_exotic'],
		text = {
			"Exotic"
		}
	},
    weight = 0.04,
    extra_cost = 30,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight * (250 ^ #SMODS.find_card('j_jen_bulwark'))
    end,
    loc_vars = function(self)
        return { vars = { self.config.ee_mult } }
    end,
	calculate = function(self, card, context)
		local ee_mult = self.config.ee_mult
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				ee_mult = self.config.ee_mult
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				ee_mult = self.config.ee_mult
			}
		end
	end
}

SMODS.Edition{
    key = "moire",
    loc_txt = {
        name = "Moire",
        label = "Moire",
        text = {
			jl.pluschips('#1#') .. ', ' .. jl.mulchips('#2#') .. ', ' .. jl.expochips('#3#') .. ', ' .. jl.tetchips('#4#') .. ' & ' .. jl.penchips('#5#') .. ' Chips',
			jl.plusmult('#6#') .. ', ' .. jl.mulmult('#7#') .. ', ' .. jl.expomult('#8#') .. ', ' .. jl.tetmult('#9#') .. ' & ' .. jl.penmult('#10#') .. ' Mult',
			'{C:dark_edition,s:0.7,E:2}Shader by : Oiiman'
        }
    },
	misc_badge = {
		colour = G.C.jen_RGB,
		text = {
			"Wondrous"
		}
	},
    discovered = true,
	no_edeck = true,
    unlocked = true,
    shader = 'moire',
    config = { chips = math.pi*1e4, x_chips = math.pi*1e3, e_chips = math.pi*100, ee_chips = math.pi*10, eee_chips = math.pi, mult = math.pi*1e4, x_mult = math.pi*1e3, e_mult = math.pi*100, ee_mult = math.pi*10, eee_mult = math.pi },
	sound = {
		sound = 'jen_e_moire',
		per = 1,
		vol = 0.7
	},
    in_shop = true,
    weight = 0.01,
    extra_cost = math.pi*1e3,
    apply_to_float = false,
	get_weight = function(self)
        return G.GAME.edition_rate * self.weight * (250 ^ #SMODS.find_card('j_jen_bulwark'))
    end,
    loc_vars = function(self)
        return { vars = { self.config.chips, self.config.x_chips, self.config.e_chips, self.config.ee_chips, self.config.eee_chips, self.config.mult, self.config.x_mult, self.config.e_mult, self.config.ee_mult, self.config.eee_mult } }
    end,
	calculate = function(self, card, context)
		local chips = self.config.chips
		local mult = self.config.mult
		local x_chips = self.config.x_chips
		local x_mult = self.config.x_mult
		local e_chips = self.config.e_chips
		local e_mult = self.config.e_mult
		local ee_chips = self.config.ee_chips
		local ee_mult = self.config.ee_mult
		local eee_chips = self.config.eee_chips
		local eee_mult = self.config.eee_mult
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			return {
				chips = chips * math.pi,
				mult = mult * math.pi,
				x_chips = x_chips * math.pi,
				x_mult = x_mult * math.pi,
				e_chips = e_chips * math.pi,
				e_mult = e_mult * math.pi,
				ee_chips = ee_chips * math.pi,
				ee_mult = ee_mult * math.pi,
				eee_chips = eee_chips * math.pi,
				eee_mult = eee_mult * math.pi
			}
		end
		if context.cardarea == G.play and context.main_scoring then
			return {
				chips = chips * math.pi,
				mult = mult * math.pi,
				x_chips = x_chips * math.pi,
				x_mult = x_mult * math.pi,
				e_chips = e_chips * math.pi,
				e_mult = e_mult * math.pi,
				ee_chips = ee_chips * math.pi,
				ee_mult = ee_mult * math.pi,
				eee_chips = eee_chips * math.pi,
				eee_mult = eee_mult * math.pi
			}
		end
	end
}
