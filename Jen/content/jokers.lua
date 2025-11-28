-- Badge definitions for themed jokers
local sevensins = {
  guilduryn = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Pride'}
  },
  hydrangea = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Wrath'}
  },
  heisei = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Greed'}
  },
  soryu = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Lust'}
  },
  shikigami = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Gluttony'}
  },
  leviathan = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Envy'}
  },
  behemoth = {
    colour = HEX('7c0000'),
    text_colour = G.C.RED,
    text = {'The Seven Sins', 'Sloth'}
  },
}

local twitch = {
  colour = HEX('9164ff'),
  text_colour = G.C.jen_RGB,
  text = {'Twitch Series'}
}

SMODS.Joker:take_ownership('perkeo', {
    name = 'Perkeo (Almanac)',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        return {vars = {center.ability.extra}}
    end,
    calculate = function(self, card, context)
        local should_retrigger = false
        if context.ending_shop then
            if G.consumeables.cards[1] then
                local total, checked, center = 0, 0, nil
                for i = 1, #G.consumeables.cards do
                    total = total + (G.consumeables.cards[i]:getQty())
                end
                local poll = pseudorandom(pseudoseed('perkeo'))*total
                for i = 1, #G.consumeables.cards do
                    checked = checked + (G.consumeables.cards[i]:getQty())
                    if checked >= poll and G.consumeables.cards[i]:gc().key ~= 'c_cry_pointer' and not G.consumeables.cards[i]:gc().no_perkeo then
                        center = G.consumeables.cards[i]
                        break
                    end
                end
                if center then
                    should_retrigger = true
                    local card = copy_card(center, nil)
                    card.ability.qty = 1
                    if center:gc().set ~= 'Booster' then card:set_edition({negative = true}, true) end
                    card:add_to_deck()
                    G.consumeables:emplace(card) 
                end
                if jl.njr(context) then
                    Q(function()
                        if should_retrigger then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                        else
                            card:speak('No valid consumables!', G.C.RED)
                        end
                    return true end)
                end
                return nil, should_retrigger
            end
        end
    end
})

SMODS.Joker {
key = 'lambert',
loc_txt = {
    name = '{C:dark_edition}Lambert',
    text = {
        'All {C:attention}Jokers{} to the {C:green}left',
        'of this {C:attention}Joker{} become {C:purple}Eternal',
        'All {C:attention}Jokers{} to the {C:green}right',
        'of this {C:attention}Joker{} {C:red}lose{} {C:purple}Eternal',
        'Removes {C:attention}all other stickers',
        'and {C:red}debuffs{} from all other {C:attention}Jokers',
        '{C:inactive}(Stickers update whenever jokers are calculated)',
        ' ',
        caption('#1#'),
        caption('#2#'),
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
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenlambert',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_reign') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.sinister and 'By the Fates, what is' or Jen.gods() and "My skin burns... it's... I-IT'S" or 'I try to give my followers', Jen.sinister and "this madness you've conjured?!!" or Jen.gods() and 'MEEeeEEllLLttTTiiiNNNggGGG!!!' or 'a good life before death.'}}
end,
calculate = function(self, card, context)
    if not context.blueprint and card.added_to_deck and jl.njr(context) and G.jokers and G.jokers.cards then
        for i=1, #G.jokers.cards do
            local other_card = G.jokers.cards[i]
            if other_card and other_card ~= card then
                if card.T.x + card.T.w/2 > other_card.T.x + other_card.T.w/2 then
                    other_card:set_eternal(true)
                else
                    other_card:set_eternal(nil)
                end
                if other_card.ability then
                    other_card.ability.perishable = nil
                    other_card.ability.banana = nil
                end
                other_card.debuff = nil
                other_card:set_rental(nil)
                other_card.pinned = nil
            end
        end
    end
end
}

SMODS.Joker {
key = 'leshy',
loc_txt = {
    name = '{C:green}Leshy',
    text = {
        '{C:clubs}Clubs{} give',
        jl.expomult('#1#') .. ' Mult when scored',
        ' ',
        caption('#2#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {power = 1.3}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 3, y = 0 },
cost = 50,
fusable = true,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenleshy',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_pawn') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.power, Jen.sinister and "STOP! STOP IT, PLEASE!! I CAN'T TAKE IT ANYMORE!!" or Jen.gods() and "MY ARMS ARE MELTING!!!" or 'Hope is what led us this far, right?'}}
end,
calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        if context.other_card:is_suit('Clubs') then
            return {
                e_mult = card.ability.extra.power,
                colour = G.C.DARK_EDITION,
                card = card
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'heket',
loc_txt = {
    name = '{C:money}Heket',
    text = {
        '{C:diamonds}Diamonds{} give',
        jl.expomult('#1#') .. ' Mult when scored',
        ' ',
        caption('#2#'),
        caption('#3#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {power = 1.3}},
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
atlas = 'jenheket',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_knight') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.power, Jen.sinister and "Stop this goddamn nonsense!!" or Jen.gods() and 'What is happening to me...?!' or 'Sometimes, you have to do', Jen.sinister and "WHAT IS WRONG WITH YOU?!?" or Jen.gods() and "My spine... it's... FOLDIIIING...!" or 'things the hard way.'}}
end,
calculate = function(self, card, context)
    if context.individual then
        if context.cardarea == G.play then
            if context.other_card:is_suit('Diamonds') then
                return {
                    e_mult = card.ability.extra.power,
                    colour = G.C.DARK_EDITION,
                    card = card
                }, true
            end
        end
    end
end
}

SMODS.Joker {
key = 'kallamar',
loc_txt = {
    name = '{C:planet}Kallamar',
    text = {
        '{C:spades}Spades{} give',
        jl.expomult('#1#') .. ' Mult when scored',
        ' ',
        caption('#2#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {power = 1.3}},
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
atlas = 'jenkallamar',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_jester') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.power, Jen.sinister and 'WAAAAAAAAAAAAAAAA-!!!' or Jen.gods() and 'MyyYyyYY hEeaDDd iSS BiiSEEecCttInGG...!!!' or "It's not too late to turn a new leaf."}}
end,
calculate = function(self, card, context)
    if context.individual then
        if context.cardarea == G.play then
            if context.other_card:is_suit('Spades') then
                return {
                    e_mult = card.ability.extra.power,
                    colour = G.C.DARK_EDITION,
                    card = card
                }, true
            end
        end
    end
end
}

SMODS.Joker {
key = 'shamura',
loc_txt = {
    name = '{C:tarot}Shamura',
    text = {
        '{C:hearts}Hearts{} give',
        jl.expomult('#1#') .. ' Mult when scored',
        ' ',
        caption('#2#'),
        caption('#3#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {power = 1.3}},
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
atlas = 'jenshamura',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_shamura') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.power, Jen.sinister and 'My brain\'s already suffered enough... Please!! Stop!!' or Jen.gods() and 'My mind... my BRAIN...' or 'I wish to help create a', Jen.sinister and 'IT DOESN\'T NEED TO BREAK ANY MORE THAN IT ALREADY HAS!!' or Jen.gods() and "IT'S FRACTURING MY CRANIUM!!!" or 'better future for everyone.'}}
end,
calculate = function(self, card, context)
    if context.individual then
        if context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') then
                return {
                    e_mult = card.ability.extra.power,
                    colour = G.C.DARK_EDITION,
                    card = card
                }, true
            end
        end
    end
end
}

SMODS.Joker {
key = 'narinder',
loc_txt = {
    name = '{C:red}N{C:green}a{C:money}r{C:planet}i{C:tarot}n{C:red}d{C:dark_edition}e{C:red}r',
    text = {
        '{C:attention}Face cards{} give',
        jl.expomult('#1#') .. ' Mult when scored',
        ' ',
        caption('#2#'),
        caption('#3#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {power = 1.15}},
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
atlas = 'jennarinder',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_feline') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.power, Jen.gods() and 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' or Jen.sinister and 'GAAAAHHHHH!!!' or 'Just keep moving forward;', Jen.gods() and 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' or Jen.sinister and 'STOP!!! STOP, PLEEEEASE!!! AAAHHH!!!' or "don't let any idiot stop you."}}
end,
calculate = function(self, card, context)
    if context.individual then
        if context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                    e_mult = card.ability.extra.power,
                    colour = G.C.DARK_EDITION,
                    card = card
                }, true
            end
        end
    end
end
}

local function aym_strength()
return { op = math.min(3, math.floor(((G.GAME or {}).tension or 0) / 5)), level = ((G.GAME or {}).tension or 0) + 3 }
end

SMODS.Joker {
key = 'aym',
loc_txt = {
    name = '{C:cry_ember}Aym',
    text = {
        '{C:cry_ember}Tension{} gives {X:almanac,C:cry_blossom}?n{} Chips & Mult,',
        '{C:red,E:1}but also increases thrice as fast',
        '{C:inactive}(Currently {C:attention}#1##2#{C:inactive})',
        ' ',
        caption('#3#'),
        caption('#4#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0 },
cost = 50,
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
    return {vars = {strength.op == 0 and 'x' or string.rep('^', strength.op), strength.level, Jen.sinister and '...pleaselordhavemercyonme...' or #SMODS.find_card('j_jen_narinder') > 0 and '...Fuck sake...' or 'Is *he* with you? I don\'t', (Jen.sinister or #SMODS.find_card('j_jen_narinder') > 0) and '' or 'want anything to do with you then.'}}
end,
calculate = function(self, card, context)
    if jl.scj(context) then
        local strength = aym_strength()
        local ret = {
            message = (strength.op == 0 and 'x' or string.rep('^', strength.op)) .. number_format(strength.level) .. ' Chips & Mult',
            colour = G.C.PURPLE,
            [(strength.op == 0 and 'x' or string.rep('e', strength.op)) .. '_chips'] = strength.level,
            [(strength.op == 0 and 'x' or string.rep('e', strength.op)) .. '_mult'] = strength.level,
            card = card
        }
        return ret, true
    end
end
}



local clauneck_blurbs = {
"I bless thee!",
"A good draw!",
"Here's your reading...",
"It's dangerous to go alone...",
"Be careful.",
"May the Fates bless you."
}

SMODS.Joker {
key = 'clauneck',
loc_txt = {
    name = 'Clauneck',
    text = {
        '{C:tarot}Tarot{} cards add',
        'either {X:blue,C:white}x#1#{} or {C:blue}+#2# Chips',
        'to all {C:attention}playing cards{} when used',
        '{C:inactive}(Uses whichever one that gives the better upgrade)',
        'When any card reaches {C:attention}1e100 chips or more{},',
        '{C:red}reset it to zero{}, {C:planet}level up all hands #3# time(s)',
        'and create a {C:dark_edition}Negative {C:spectral}Soul',
        ' ',
        caption('#4#'),
        caption('#5#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {chips_additive = 100, chips_mult = 2, levelup = 10}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
fusable = true,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenclauneck',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_fateeater') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.chips_mult, center.ability.extra.chips_additive, center.ability.extra.levelup, Jen.gods() and 'A-Apollo... I have failed you...' or Jen.sinister and 'This-... this is sacrilege, I say!' or 'May the Fates guide', Jen.gods() and 'May... t-the F-F-Fates..... have... m-.....' or Jen.sinister and 'Not even the Fates could fathom this!' or 'you to the best path.'}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Tarot' and (#G.hand.cards > 0 or #G.deck.cards > 0) then
        if jl.njr(context) then card:speak(clauneck_blurbs, G.C.MULT) end
        local e100cards = {}
        for k, v in ipairs(G.playing_cards) do
            if not v.ability.perma_bonus then v.ability.perma_bonus = 0 end
            local res1 = 0
            local res2 = 0
            for i = 1, context.consumeable:getEvalQty() do
                res1 = v.ability.perma_bonus * card.ability.extra.chips_mult
                res2 = v.ability.perma_bonus + card.ability.extra.chips_additive
                v.ability.perma_bonus = math.max(res1, res2)
            end
            if v.ability.perma_bonus >= 1e100 then table.insert(e100cards, v) end
        end
        local ecs = #e100cards
        if ecs > 0 then
            card_status_text(card, '!!!', nil, 0.05*card.T.h, G.C.DARK_EDITION, 0.6, 0.6, 2, 2, 'bm', 'jen_enlightened')
            jl.th('all')
            Q(function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end, 0.2, nil, 'after')
            jl.hcm('+', '+', true)
            jl.hlv('+' .. number_format(card.ability.extra.levelup * ecs))
            delay(1.3)
            for k, v in pairs(G.GAME.hands) do
                level_up_hand(v, k, true, card.ability.extra.levelup * ecs)
            end
            for k, v in pairs(e100cards) do
                v.ability.perma_bonus = 0
            end
            jl.ch()
            Q(function()
                local soul = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_soul', nil)
                soul.no_forced_edition = true
                soul:set_edition({negative = true})
                soul.no_forced_edition = nil
                soul:setQty(ecs)
                if ecs > 1 then soul:create_stack_display() end
                soul:set_cost()
                soul:add_to_deck()
                G.consumeables:emplace(soul)
                return true
            end, 0.2, nil, 'after')
        end
        return nil, true
    end
end
}

local exotic_editions = {
'jen_bloodfoil',
'jen_blood'
}

local wondrous_editions = {
'jen_moire'
--'jen_unreal'
}

function Card:is_exotic_edition(excludewondrous)
if not self.edition then return false end
local is_exotic = false
for k, v in pairs(exotic_editions) do
    if self.edition[v] then
        is_exotic = true
        break
    end
end
if not excludewondrous then
    for k, v in pairs(wondrous_editions) do
        if self.edition[v] then
            is_exotic = true
            break
        end
    end
end
return is_exotic
end

function Card:is_wondrous_edition()
if not self.edition then return false end
local is_exotic = false
for k, v in pairs(wondrous_editions) do
    if self.edition[v] then
        is_exotic = true
        break
    end
end
return is_exotic
end

Jen.pending_applyingeditions = false

SMODS.Joker {
key = 'kudaai',
loc_txt = {
    name = 'Kudaai',
    text = {
        'Non-{C:dark_edition}editioned{} cards are',
        '{C:attention}given a random {C:dark_edition}Edition',
        '{C:inactive,s:0.8}(Some editions are excluded from the pool)',
        '{C:inactive,s:0.8}(UNO cards excluded)',
        ' ',
        caption('#1#'),
        caption('#2#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
fusable = true,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenkudaai',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_foundry') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.gods() and 'HELP! HEEEEeeeell-...' or Jen.sinister and '*whining baby noises*' or "You'll need these...", (Jen.gods() or Jen.sinister) and '' or "...lest you wan'cha ass kicked."}}
end
}

local chemach_phrases = {
'Another precious relic!',
'A fine addition to my collection.',
'A worthy antique!',
'Oh, I love it!',
'It looks so shiny!',
'I am satisfied with this haul!',
"Now that's going on display!",
'I might need a bigger chest...'
}

local vars1plus = {'x_mult', 'e_mult', 'ee_mult', 'eee_mult', 'x_chips', 'e_chips', 'ee_chips', 'eee_chips'}

SMODS.Joker {
key = 'chemach',
loc_txt = {
    name = 'Chemach',
    text = {
        '{C:attention}Doubles{} the values of',
        '{C:attention}all Jokers{} whenever',
        'a Joker that is {C:red}not {C:blue}Common{} or {C:green}Uncommon{} is {C:money}sold{},',
        'then {C:attention}retrigger all add-to-inventory effects{} of {C:attention}all Jokers',
        '{C:inactive}(Not all values can be doubled, not all Jokers can be affected)',
        ' ',
        caption('#1#'),
        caption('#2#'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
fusable = true,
rarity = 'jen_wondrous',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenchemach',
unique = true,
in_pool = function()
    return #SMODS.find_card('j_jen_broken') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.gods() and 'No! NO! STOP! STOP IT!!' or Jen.sinister and 'Whatever artefact THAT is...' or "My treasures are remnants", Jen.gods() and 'THIS RELIC IS TOO MUCH!! NO!!! NOOOOOOooo-!!!' or Jen.sinister and 'you can keep it AWAY FROM ME!!!' or "of tales old and new."}}
end,
calculate = function(self, card, context)
    if context.selling_card then
        if context.card.ability.set == 'Joker' and context.card:gc().rarity ~= 1 and context.card:gc().rarity ~= 2 then
            if jl.njr(context) then card_eval_status_text(card, 'extra', nil, nil, nil, {message = chemach_phrases[math.random(#chemach_phrases)], colour = G.C.PURPLE}) end
            for k, v in pairs(G.jokers.cards) do
                if v ~= card and v ~= context.card then
                    if not v:gc().immutable then
                        v:remove_from_deck()
                        for a, b in pairs(v.ability) do
                            if a == 'extra' then
                                if type(v.ability.extra) == 'number' then
                                    v.ability.extra = math.min(v.ability.extra * 2, 1e300)
                                elseif type(v.ability.extra) == 'table' and next(v.ability.extra) then
                                    for c, d in pairs(v.ability.extra) do
                                        if type(d) == 'number' then
                                            v.ability.extra[c] = math.min(d * 2, 1e300)
                                        end
                                    end
                                end
                            elseif a ~= 'order' and a ~= 'hyper_chips' and a ~= 'hyper_mult' and type(b) == 'number' and b > (jl.bf(a, vars1plus) and 1 or 0) then
                                v.ability[a] = b * 2
                            end
                        end
                        v:add_to_deck()
                    end
                end
            end
            return nil, true
        end
    end
end
}

local haro_blurbs = {
"Once upon a time...",
"Have I got a story for you!",
"I remember one time...",
"This tale of mine is relatively ancient...",
"Let me tell you a story."
}

SMODS.Joker {
key = 'haro',
loc_txt = {
    name = 'Haro',
    text = {
        '{C:tarot}Tarots {C:planet}level up',
        '{C:attention}all hands{} when used or sold',
        '{X:green,C:white}Synergy:{} {X:dark_edition,C:red}^#1#{C:red} Mult{} if',
        'you have {X:attention,C:black}Suzaku',
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
config = {extra = {synergy_mult = 1.65}},
cost = 15,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenharo',
in_pool = function()
    return #SMODS.find_card('j_jen_godfather') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.synergy_mult, Jen.gods() and 'Make it stop! MAKE IT STOP!' or Jen.sinister and 'What kind of tales do you tell?!' or 'I live to tell tales,', Jen.gods() and 'I CAN\'T TAKE IIIIIT!' or Jen.sinister and 'This is just pure psychopathy!!' or 'both of old and of new.'}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Tarot' then
        local quota = (context.consumeable:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + quota
        if jl.njr(context) then
            card:speak(haro_blurbs, G.C.SECONDARY_SET.Tarot)
            card:apply_cumulative_levels()
        end
        return nil, true
    elseif context.selling_card and not context.selling_self and context.card.ability.set == 'Tarot' then
        local quota = (context.card:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + quota
        if jl.njr(context) then
            card:speak(haro_blurbs, G.C.SECONDARY_SET.Tarot)
            card:apply_cumulative_levels()
        end
        return nil, true
    end
    if #SMODS.find_card('j_jen_suzaku') > 0 then
        if context.cardarea == G.jokers and context.joker_main then
            return {
                message = 'Either with a sword, or a bullet! (^' .. card.ability.extra.synergy_mult .. ' Mult)',
                Emult_mod = card.ability.extra.synergy_mult,
                colour = G.C.DARK_EDITION
            }, true
        end
    end
end
}

local suzaku_blurbs = {
"More ammo!",
"Bullets! Yes!",
"Talk about a fine caliber.",
"I can shoot with this...",
"Let's fire a round, eh?"
}

SMODS.Joker {
key = 'suzaku',
loc_txt = {
    name = 'Suzaku',
    text = {
        '{C:spectral}Spectrals {C:planet}level up',
        '{C:attention}all hands{} when used or sold',
        '{X:green,C:white}Synergy:{} {X:dark_edition,C:red}^#1#{C:red} Mult{} if',
        'you have {X:attention,C:black}Haro',
        ' ',
        caption('#2#'),
        caption('#3#'),
        faceart('raidoesthings')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
config = {extra = {synergy_mult = 1.65}},
cost = 15,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jensuzaku',
in_pool = function()
    return #SMODS.find_card('j_jen_godmother') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.synergy_mult, Jen.gods() and 'GGHHAAAAAAAHHHHHHHHhhh-!!' or Jen.sinister and 'What kind of firepower is this?!' or 'You gotta finish the job fast', Jen.gods() and '' or Jen.sinister and 'My blunderbuss can\'t even compete!' or 'sometimes, and you have me to help!'}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Spectral' then
        local quota = (context.consumeable:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + quota
        if jl.njr(context) then
            card:speak(suzaku_blurbs, G.C.SECONDARY_SET.Spectral)
            card:apply_cumulative_levels()
        end
        return nil, true
    elseif context.selling_card and not context.selling_self and context.card.ability.set == 'Spectral' then
        local quota = (context.card:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + quota
        if jl.njr(context) then
            card:speak(suzaku_blurbs, G.C.SECONDARY_SET.Spectral)
            card:apply_cumulative_levels()
        end
        return nil, true
    end
    if #SMODS.find_card('j_jen_haro') > 0 then
        if context.cardarea == G.jokers and context.joker_main then
            return {
                message = 'All it takes is one chance. (^' .. card.ability.extra.synergy_mult .. ' Mult)',
                Emult_mod = card.ability.extra.synergy_mult,
                colour = G.C.DARK_EDITION
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'apollo',
loc_txt = {
    name = 'Apollo',
    text = {
        '{C:jen_RGB,E:1}Omega{} versions of consumables',
        'appear {C:attention}approximately #1#x as often{} than normal',
        '{C:inactive}(Stacks hyperbolically with other copies)',
        ' ',
        caption('#2#'),
        caption('#3#'),
        faceart('raidoesthings')
    }
},
config = {omegachance_amplifier = 8},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
jumbo_mod = 3,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenapollo',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.omegachance_amplifier, Jen.gods() and 'No-...! I will not submit-...!' or Jen.sinister and 'Your arbitrary power...' or 'Remember, the Fates aren\'t kind to anyone,', Jen.gods() and 'IT CANNOT END LIKE THIS!' or Jen.sinister and 'why must you go so overboard?!' or 'no matter how much you try to get on their good side.'}}
end,
}

local hep_blurbs = {
'A fine creation.',
'Careful, it\'s fresh out of the forge.',
'Still a little hot.',
'Not too shabby.'
}

SMODS.Joker {
key = 'hephaestus',
loc_txt = {
    name = 'Hephaestus',
    text = {
        'Using a {C:attention}consumable{} has a',
        '{C:green}50% chance{} to {C:attention}duplicate it',
        '{C:inactive}(Negatives, The Genius, POINTER://, and Omega consumables excluded)',
        '{C:inactive}(Clamped to 100,000 rolls in a single stack)',
        ' ',
        caption('Be as precise as possible.'),
        caption('What good is a blade if its user is sloppy?'),
        faceart('raidoesthings')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unique = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenhephaestus',
in_pool = function()
    return #SMODS.find_card('j_jen_smelter') <= 0
end,
calculate = function(self, card, context)
    if jl.njr(context) and not context.blueprint and context.using_consumeable and context.consumeable and context.consumeable:gc().key ~= 'c_jen_reverse_fool' and context.consumeable:gc().key ~= 'c_cry_pointer' and context.consumeable.ability.set ~= 'jen_omegaconsumable' and context.consumeable.ability.set ~= 'jen_ability' and not (context.consumeable.edition or {}).negative then
        local quota = 0
        local rolls = math.min(1e5, context.consumeable:getEvalQty())
        for i = 1, rolls do
            if jl.chance('hephaestus_duplicate', 2, true) then
                quota = quota + 1
            end
        end
        if quota > 0 then
            card:speak(hep_blurbs, G.C.FILTER)
            Q(function()
                local hep = copy_card(context.consumeable)
                hep:setQty(quota)
                hep:add_to_deck()
                G.consumeables:emplace(hep)
            return true end, 1)
        else
            card:speak(localize('k_nope_ex'), G.C.RED)
        end
    end
end
}

SMODS.Joker {
key = 'luke',
loc_txt = {
    name = 'Luke Carder',
    text = {
        '{C:attention}All{} Jokers, cards and',
        'consumables are {C:cry_code}Rigged',
        '{C:inactive}(Hunter excluded)',
        '{C:inactive}(Does not guarantee chances that are measured in a percentage)',
        '{C:attention}Lucky cards{} have a {C:green}chance{} to, when scored:',
        '{C:green}20%{} : Grant {C:dark_edition}+1{} Joker slot',
        '{C:green}35%{} : Grant {C:edition}+1{} Consumable slot',
        '{C:green}40% each{} : Create a {C:tarot}Tarot{}/{C:spectral}Spectral{}/{C:planet}Planet{}/{C:cry_code}Code{} card',
        '{C:green}1%{} : Create a {C:spectral}Soul',
        '{C:green}0.1%{} : Create a {C:cry_exotic,E:1}Gateway',
        ' ',
        caption('Hey there, Card Gamers! I\'m the Lucky Carder,'),
        caption('and welcome to my Balatro playthrough!'),
        faceart('raidoesthings'),
        origin('Inscryption'),
        au('Scryptic Swap')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 250,
rarity = 'jen_wondrous',
unique = true,
longful = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenluke',
in_pool = function()
    return #SMODS.find_card('j_jen_dealer') <= 0
end,
calculate = function(self, card, context)
    if not context.blueprint then
        if context.cardarea == G.play then
            if context.other_card and context.other_card.ability.name == 'Lucky Card' and jl.scj(context) then
                if jl.chance('jen_luke_jokerslot', 5, true) then
                    card:speak('+1 Joker Slot', G.C.DARK_EDITION)
                    G.jokers:change_size_absolute(1)
                end
                if jl.chance('jen_luke_consslot', 2.8571428571428571428571428571429, true) then
                    card:speak('+1 Consumable Slot', G.C.EDITION)
                    G.consumeables:change_size_absolute(1)
                end
                if jl.chance('jen_luke_tarot', 2.5, true) then
                    card:speak('+Tarot', G.C.SECONDARY_SET.Tarot)
                    Q(function()
                        play_sound('jen_draw')
                        local card2 = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'luke_tarot')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 0.4, nil, 'after')
                end
                if jl.chance('jen_luke_spectral', 2.5, true) then
                    card:speak('+Spectral', G.C.SECONDARY_SET.Spectral)
                    Q(function()
                        play_sound('jen_draw')
                        local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'luke_spectral')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 0.4, nil, 'after')
                end
                if jl.chance('jen_luke_planet', 2.5, true) then
                    card:speak('+Planet', G.C.SECONDARY_SET.Planet)
                    Q(function()
                        play_sound('jen_draw')
                        local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'luke_planet')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 0.4, nil, 'after')
                end
                if jl.chance('jen_luke_code', 2.5, true) then
                    card:speak('+Code', G.C.SET.Code)
                    Q(function()
                        play_sound('jen_draw')
                        local card2 = create_card('Code', G.consumeables, nil, nil, nil, nil, nil, 'luke_code')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 0.4, nil, 'after')
                end
                if jl.chance('jen_luke_soul', 100, true) then
                    card:speak('+Soul', G.C.CRY_TWILIGHT)
                    Q(function()
                        play_sound('jen_draw')
                        local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_soul', 'luke_soul')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 0.4, nil, 'after')
                end
                if jl.chance('jen_luke_gateway', 1000, true) then
                    card:speak('+Gateway', G.C.CRY_ASCENDANT)
                    Q(function()
                        play_sound('jen_draw')
                        local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_cry_gateway', 'luke_gateway')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 0.4, nil, 'after')
                end
                return nil, true
            end
        end
    end
end
}

local p03_blurbs = {
'Here, jackass.',
'Stop asking me for more.',
'You need more?',
'Piss off already.',
'Okay, this is already getting annoying.',
'WHO PUT GREASE ALL OVER THE CONVEYOR BELT?',
'Jesus.',
'I really need to make my workers better.',
'Why are you so... you?',
'Is that... questionable data... on your disk?',
'*Sigh*...',
'Getting too old for this shit.'
}

SMODS.Joker {
key = 'p03',
loc_txt = {
    name = 'P03',
    text = {
        'Create a {C:spectral}POINTER://{} for',
        'every {C:attention}#2# non-{C:dark_edition}Negative {C:cry_code}Code{} cards used,',
        'then {C:attention}increase requirement{} by {X:dark_edition,C:attention}^1.3{C:inactive,s:0.75} (rounded up)',
        '{C:inactive,s:2}[{C:attention,s:2}#1#{C:inactive,s:2} / #2#]',
        '{C:inactive}(Code cards that have a suit or rank on them do not count)',
        '{C:spectral}POINTER://{} can now create {C:cry_exotic,E:1}Exotic{} Jokers',
        ' ',
        caption('Well, I suppose I can help you'),
        caption('make your deck suck less.'),
        faceart('raidoesthings'),
        origin('Inscryption'),
        au('Scryptic Swap')
    }
},
config = {codes = 0},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 250,
unique = true,
debuff_immune = true,
rarity = 'jen_wondrous',
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenp03',
in_pool = function()
    return #SMODS.find_card('j_jen_disappointment') <= 0
end,
add_to_deck = function(self, card, from_debuff)
    -- When P03 is added, remove exotic from POINTER:// blacklist
    if Cryptid and Cryptid.pointerblistifytype then
        Cryptid.pointerblistifytype("rarity", "cry_exotic", true) -- true = remove from blacklist
        print("[JEN DEBUG] P03 added - enabled Exotic creation in POINTER://")
    end
end,
remove_from_deck = function(self, card, from_debuff)
    -- When P03 is removed, re-add exotic to POINTER:// blacklist
    if Cryptid and Cryptid.pointerblistifytype then
        Cryptid.pointerblistifytype("rarity", "cry_exotic", false) -- false = add to blacklist
        print("[JEN DEBUG] P03 removed - disabled Exotic creation in POINTER://")
    end
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.codes, (G.GAME or {}).p03_codereq or 3}}
end,
calculate = function(self, card, context)
    if not context.blueprint and context.using_consumeable and context.consumeable and not (context.consumeable.edition or {}).negative and context.consumeable.ability.set == 'Code' and jl.njr(context) and (not context.consumeable.base or not context.consumeable.base.suit or not context.consumeable.base.value) then
        if context.consumeable._saint_karma_done then return nil, true end
        local quota = context.consumeable:getEvalQty()
        context.consumeable._saint_karma_done = true
        if not G.GAME.p03_codereq then G.GAME.p03_codereq = 3 end
        card.ability.codes = card.ability.codes + quota
        if card.ability.codes >= G.GAME.p03_codereq then
            card:speak(p03_blurbs, G.C.SET.Code)
            while card.ability.codes >= G.GAME.p03_codereq do
                should_speak = true
                card.ability.codes = card.ability.codes - G.GAME.p03_codereq
                G.GAME.p03_codereq = math.min(1e7, math.ceil(G.GAME.p03_codereq ^ 1.3))
                Q(function()
                    if card then
                        play_sound('jen_draw')
                        local pointer = create_card('Code', G.consumeables, nil, nil, nil, nil, 'c_cry_pointer', 'p03_pointer')
                        pointer.no_omega = true
                        pointer:add_to_deck()
                        G.consumeables:emplace(pointer)
                    end
                    return true
                end, 0.2, nil, 'after')
            end
        end
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.codes .. ' / ' .. G.GAME.p03_codereq, colour = G.C.SET.Code})
        return nil, false
    end
end
}

local maxie_quotes = {
normal = {
    'Hey! I hope we can become great friends together!',
    'Need a paw?',
    'Together as a team!',
    'Mmm... Milk sounds good right about now.',
    'Unlike most other bunnies; I don\'t like carrots.',
    'Mmm... Mac and Cheese...',
    'I am just sitting here.'
},
drama = {
    'A-ah! S-stop it, please!! You\'re scaring me...!',
    'E-eek! B-be careful!!'
},
gods = {
    'I-it hurts... it h-hurts... it hurts, it hurts ithurts ithurtsITHURTS-!!!',
    'M-my flesh... it b-burns...',
    'G-get that... THING... away from me!! It\'s-... making me h-hear w-whispers...!'
},
trigger = {
    'A gift for your kindness!',
    'Temperance/Hermit value!',
    'Bnuuy.',
    'You can\'t handle the uber instincts of my uber autism.',
    'This might help!',
    'I\'m gonna have sexual thoughts about that.',
    '300 booster packs, for only 2 pounds?! Yes, sir!',
    'Hehea!',
    'Fucking Monopoly Money...',
    'Could you pass me some milk? I\'m thirsty.',
    'If you don\'t like bunnies; fuck you, die!',
    'Rizz.',
    'nnNOOOOOHHHH-',
    'Pocket £@"!@}$£:$%"%~$":%£',
    'Also try Soundpad!',
    'Balatro is on my soundboard!',
    'Bird up!',
    'Crazy? I was crazy once...',
    'The Giant Enemy Spider!',
    'gore5',
    'negativebutretriggeredreverb',
    'The sun is a deadly lazer...!',
    'rrrRRRRrRRRRrrrRRrrr',
    'I can\'t stop winning!',
    'I lost so much money, but...',
    'AAaaA-',
    'Oh no, not Wilhelm!',
    'SHOOT THEM WITH THE DEHYDRATION GUN!',
    'Five. Hundred. Booster packs.',
    'Fortnite.',
    'WHA\' DOES \'DIS BUTT\'N DUU?',
    'WHA\' DOES \'DIS FUCKA DUU?',
    'Balls.',
    'I turned myself into a card.',
    'I\'m card.',
    'I TURNED MYSELF INTO A CARD, MORTY!!!',
    'Do I look like I know what a JPEG is?',
    'G O   F U C K   Y O U R S E L F',
    'ONION- O- OH- ONION RING I\'VE GOT AN ONION RING',
    'Wow, I have so many trigger quotes!',
    'This is like, meta.',
    'Dude, the thing that everybo-',
    'Oooooohhhh, my pohh-!',
    'Dog park.',
    'Cock and Ball Torture, from Wikipedia, the free encyclopedia at en.wikipedia.org.',
    'Off to hang myself. Watch and lea-*choke*',
    'Boo-womp.',
    'See that moderator? We\'re gonna ping \'im!',
    'I\'ve come to make an announcement.',
    'UUAAAAAAAAAAA-',
    'I like to play with myself! Wait, that sounds wrong.',
    'isek die.m4a',
    'My eyes are having an orgasm.',
    'Hey there, are you having a good day? Well, fuck you!',
    'I\'M MAKING FUCKING MAC AND CHEESE, AND NOBODY CAN STO-',
    'iamjustsittinghere',
    'This PC > Downloads > iamjustsittinghere',
    'Stinky.',
    'This is Stinky I, and this is Stinky II!',
    'Stinky III... better not show up.'
}
}

SMODS.Joker {
key = 'maxie',
loc_txt = {
    name = '{C:edition}Maxie',
    text = maxie_desc
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
drama = { x = 2, y = 0 },
cost = 2375,
rarity = 'jen_extraordinary',
wee_incompatible = true,
loc_vars = function(self, info_queue, center)
    local quoteset = Jen.dramatic and 'drama' or Jen.gods() and 'gods' or 'normal'
    return {vars = {maxie_quotes[quoteset][math.random(#maxie_quotes[quoteset])]}}
end,
misc_badge = {
    colour = G.C.almanac,
    text_colour = G.C.CRY_BLOSSOM,
    text = {
        'Bishop of Kosmos',
        'Maxie'
    }
},
unique = true,
unlocked = true,
discovered = true,
fusable = true,
debuff_immune = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenmaxie',
in_pool = function()
    return #SMODS.find_card('j_jen_charred') <= 0
end,
calculate = function(self, card, context)
    if jl.njr(context) and context.using_consumeable and context.consumeable and context.consumeable.gc and jl.bf(context.consumeable:gc().key, maxie_consumables) then
        local quota = (context.consumeable:getEvalQty())*2
        local isnegative = (context.consumeable.edition or {}).negative
        if not isnegative then
            card:speak('+' .. quota .. ' Boosters', G.C.DARK_EDITION)
            card:speak(maxie_quotes.trigger, G.C.DARK_EDITION)
            for i = 1, quota do
                Q(function()
                    if card then
                        card:juice_up(0.8, 0.5)
                        local duplicate = create_card('Booster', G.consumeables, nil, nil, nil, nil, k, 'maxie_pack')
                        if duplicate.gc and duplicate:gc().set ~= 'Booster' then
                            duplicate:set_ability(jl.rnd('maxie_booster_equilibrium', nil, G.P_CENTER_POOLS.Booster), true, nil)
                            duplicate:set_cost()
                        end
                        duplicate:add_to_deck()
                        G.consumeables:emplace(duplicate)
                    end
                    return true
                end, 0.2/quota, nil, 'after')
                if i <= quota/2 and jl.chance('maxie_voucherchance', 10, true) then
                    card:speak('+Voucher', G.C.EDITION)
                    card:speak(maxie_quotes.trigger, G.C.EDITION)
                    Q(function()
                        if card then
                            card:juice_up(0.8, 0.5)
                            local duplicate = create_card('Voucher', G.consumeables, nil, nil, nil, nil, k, 'maxie_voucher')
                            if duplicate.gc and duplicate:gc().set ~= 'Voucher' then
                                duplicate:set_ability(jl.rnd('maxie_voucher_equilibrium', nil, G.P_CENTER_POOLS.Voucher), true, nil)
                                duplicate:set_cost()
                            end
                            duplicate:add_to_deck()
                            G.consumeables:emplace(duplicate)
                        end
                        return true
                    end, 0.2/quota, nil, 'after')
                end
            end
        end
        return nil, true
    end
end
}

SMODS.Joker {
key = 'oxy',
loc_txt = {
    name = '{C:pastel_yellow}O{C:pink}x{}y',
    text = {
        '{C:attention}Steel{} cards give',
        '{X:purple,C:white}x#1#{} Chips & Mult',
        'when scored',
        ' ',
        caption('#2#'),
        faceart('ocksie')
    }
},
misc_badge = {
    colour = G.C.almanac,
    text_colour = G.C.CRY_BLOSSOM,
    text = {
        'Bishop of Kosmos',
        'ocksie'
    }
},
config = {steel = 1.5},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0 },
cost = 10,
rarity = 3,
fusable = true,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenoxy',
in_pool = function()
    return #SMODS.find_card('j_jen_inhabited') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.steel, Jen.sinister and 'WHAT ARE YOU DOING DOWN THERE?!?' or Jen.gods() and 'I am-... I am-... I am... what is this feeling?' or 'We all cut close...'}}
end,
calculate = function(self, card, context)
    if context.individual then
        if context.cardarea == G.play then
            if context.other_card.ability.name == 'Steel Card' then
                return {
                    x_chips = card.ability.steel,
                    x_mult = card.ability.steel,
                    colour = G.C.PURPLE,
                    card = card
                }, true
            end
        end
    end
end
}

SMODS.Joker {
key = 'honey',
loc_txt = {
    name = '{C:pastel_yellow}H{C:caramel}one{C:pastel_yellow}y',
    text = {
        '{C:attention}Ignore{} the card selection limit',
        'if the card you try to select is',
        '{C:attention}up to N rank(s) higher or lower',
        'than the {C:attention}most-recently selected card',
        '{C:inactive}(N = no. of copies of this Joker you have)',
        '{C:inactive,s:0.75}(ex. If most recent selection is a 10, you can select a Jack or 9 regardless of selection limit)',
        ' ',
        '{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult',
        'for each card in played hand {C:attention}past the fifth card',
        '{C:inactive}(Cards do not need to score)',
        ' ',
        caption('#3#'),
        faceart('ocksie')
    }
},
sinis = { x = 2, y = 0 },
config = {c = 10, m = 2},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 8,
rarity = 3,
fusable = true,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenhoney',
in_pool = function()
    return #SMODS.find_card('j_jen_cracked') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.c, center.ability.m, Jen.sinister and 'S-STOP THAT!! YOU\'RE FREAKING ME OOOUT!!!' or Jen.gods() and "H-hey, get rid of that thing! It's making my head hurt!!" or "Buzzzzz! I'll do my best!"}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        if #G.play.cards > 5 then
            local excess = #G.play.cards - 5
            local mod1 = card.ability.c * excess
            local mod2 = card.ability.m * excess
            return {
                chip_mod = mod1,
                mult_mod = mod2,
                message = '+' .. number_format(mod1) .. ' Chips & +' .. number_format(mod2) .. ' Mult',
                colour = G.C.PURPLE
            }, true
        end
    end
end
}

local cheese_quotes = {
normal = {
    ':3',
    'Jiggle fart.',
    'Mmmm, single fried maggot...',
    'Wait, where\'s my son?',
    'Remember that you\'re awesome!',
    'Goodbye! Don\'t die! ...Preferably!',
    'F I S H ! !'
},
bb = {
    'There he is!',
    'La Jeremiah.'
},
trigger = {
    'Do you want to Cavern Crush?',
    'Cavern Crush!',
    'Can we crush the cavern crush with the crush in the cavern crush crush?',
    'FIIIIIIIIIIIIIIIIIIIIIIIIIISH',
    'f i s h',
    'Fish.',
    'CANWEGOFISHING',
    'I heard you like fishes, so I put more fishes in your fishes.',
    'For Nimbus!',
    'We fight, for Nimbus!',
    'For Jeremy!',
    'For the Jeremiah.',
    'To Jeremyyyyy!',
    'To Niiimbuuuus!',
    'Wawaaaaaaaa!!!',
    'Taste the WAWA!',
    'Too slow!',
    'Wuhaaaii-ya!'
}
}

SMODS.Joker {
key = 'cheese',
loc_txt = {
    name = 'Cheese',
    text = {
        '{C:blue}+#1#{} hand(s) if played',
        'hand is your {C:attention}most played',
        '{C:inactive}(#2#)',
        ' ',
        caption('#3#'),
        faceart('idot1537'),
        origin('Rain World')
    }
},
config = {add = 1},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 10,
rarity = 3,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jencheese',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.add, jl.favhand(), #SMODS.find_card('j_jen_jeremy') > 0 and cheese_quotes.bb[math.random(#cheese_quotes.bb)] or cheese_quotes.normal[math.random(#cheese_quotes.normal)]}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and context.poker_hands and context.scoring_name and context.scoring_name == jl.favhand() then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = cheese_quotes.trigger[math.random(#cheese_quotes.trigger)], colour = G.C.BLUE})
        ease_hands_played(card.ability.add or 1)
        return nil, true
    end
end
}

SMODS.Joker {
key = 'jeremy',
loc_txt = {
    name = 'Jeremy',
    text = {
        'Scored cards give',
        '{C:mult}+#1#{} Mult each',
        '{X:green,C:white}Synergy:{} Scored cards give',
        '{X:mult,C:white}x#1#{} Mult each instead',
        'if you have {X:attention}Cheese',
        ' ',
        caption('#2#'),
        faceart('idot1537'),
        origin('Rain World')
    }
},
config = {mul = 2},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 6,
rarity = 2,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenjeremy',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.mul, #SMODS.find_card('j_jen_cheese') > 0 and 'Wawa!' or ('Wawa.' .. (math.random(2) == 1 and '..' or ''))}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.play then
        local ret = {
            message = 'Wawa!',
            colour = G.C.MULT,
            card = card
        }
        if #SMODS.find_card('j_jen_cheese') > 0 then
            ret.x_mult = card.ability.mul
            ret.message = ret.message .. ' (x' .. number_format(card.ability.mul) .. ' Mult)'
        else
            ret.mult = card.ability.mul
            ret.message = ret.message .. ' (+' .. number_format(card.ability.mul) .. ' Mult)'
        end
        return ret, true
    end
end
}

SMODS.Joker {
key = 'pickel',
loc_txt = {
    name = 'Pickelcat',
    text = {
        '{C:attention}Straddle{} takes {C:attention}twice',
        'as long to progress',
        caption('#1#'),
        faceart('idot1537'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
debuff_immune = true,
unique = true,
atlas = 'jenpickel',
in_pool = function() return G.GAME.straddle_active end,
loc_vars = function(self, info_queue, center)
    return {vars = {math.random(2) == 1 and 'I don\'t know how to drive Undertale!' or 'I\'mma gonna insane.'}}
end
}

local aster_blurbs = {
'To the stars!',
'I gotcha!',
'Awesome!',
'Ooooh...',
'We have liftoff!',
"Let's bring them ALL up!",
"You're doing great!",
'Let me help you with that!',
'Boop!',
'Hehe!'
}

SMODS.Joker {
key = 'aster',
loc_txt = {
    name = 'Aster Flynn',
    text = {
        '{C:planet}Planets level up',
        '{C:attention}all hands{} when used or sold',
        ' ',
        caption('#1#'),
        faceart('HexaCryonic')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0},
cost = 15,
fusable = true,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenaster',
in_pool = function()
    return #SMODS.find_card('j_jen_astrophage') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.sinister and "Oh... O-Oh, my stars..." or Jen.gods() and "Goodness... I... feel strange... my head hurts..." or "Hi! Nice to meet you!"}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Planet' then
        local quota = (context.consumeable:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + quota
        if jl.njr(context) then
            card:speak(aster_blurbs, G.C.SECONDARY_SET.Planet)
            card:apply_cumulative_levels()
        end
        return nil, true
    elseif context.selling_card and not context.selling_self and context.card.ability.set == 'Planet' then
        local quota = (context.card:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + quota
        if jl.njr(context) then
            card:speak(aster_blurbs, G.C.SECONDARY_SET.Planet)
            card:apply_cumulative_levels()
        end
        return nil, true
    end
end
}

local rin_blurbs = {
"I'm in.",
'Pow!',
'Run that back.',
"local duplicate = create_card('Code', G.consumeables, nil, nil, nil, nil, k, 'rin_negative')",
'Got an ACE up my sleeve.',
'Trying to break the game?',
"Copy/Paste-n't.",
'Boop!',
'Gotcha.',
'Go forth and make the game cry.',
"card:speak(rin_blurbs, G.C.SET.Code)"
}

SMODS.Joker {
key = 'rin',
loc_txt = {
    name = 'Rin Whitaker',
    text = {
        'Using a {C:attention}non-{C:dark_edition}Negative {C:code}Code',
        'creates {C:attention}#1# {C:dark_edition}Negative{} copies',
        ' ',
        caption('#2#'),
        faceart('HexaCryonic')
    }
},
config = {extra = {copies = 2}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0 },
cost = 20,
rarity = 4,
jumbo_mod = 3,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenrin',
in_pool = function()
    return #SMODS.find_card('j_jen_corruption') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.copies, Jen.sinister and 'DUDE, WHAT THE HELL, ARE YOU TRYING TO MAKE THE COMPUTER EXPLODE?!?' or "Oh, hey, 'sup?"}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Code' then
        local quota = (context.consumeable:getEvalQty())
        local card_key = context.consumeable:gc().key
        local isnegative = (context.consumeable.edition or {}).negative
        if not isnegative then
            if not card.cumulative_qtys then card.cumulative_qtys = {} end
            card.cumulative_qtys[card_key] = (card.cumulative_qtys[card_key] or 0) + quota
            if jl.njr(context) then
                card:speak(rin_blurbs, G.C.SET.Code)
                Q(function()
                    Q(function()
                        if card then
                            if card.cumulative_qtys then
                                for k, v in pairs(card.cumulative_qtys) do
                                    local duplicate = create_card('Code', G.consumeables, nil, nil, nil, nil, k, 'rin_negative')
                                    duplicate:set_edition({negative = true}, true)
                                    duplicate:setQty(card.ability.extra.copies * (v or 1))
                                    duplicate:create_stack_display()
                                    duplicate:set_cost()
                                    duplicate.no_omega = true
                                    duplicate:add_to_deck()
                                    G.consumeables:emplace(duplicate)
                                end
                                card.cumulative_qtys = nil
                            end
                        end
                        return true
                    end, 0.2, nil, 'after')
                    return true
                end, 0.2, nil, 'after')
            end
            return nil, true
        end
    end
end
}

local ayanami_blurbs = {
"Let the night sky reign!",
"The zodiac aligns tonight.",
"May the nebulae bring new life.",
"Sing along with me!",
"The galaxy shall be under my jurisdiction.",
"Twinkle, twinkle, little star..."
}

SMODS.Joker {
key = 'ayanami',
loc_txt = {
    name = 'Ayanami',
    text = {
        'Using {C:attention}non-{C:dark_edition}Negative {C:attention}specific-hand {C:planet}Planets',
        'creates {C:attention}#1# {C:dark_edition}Negative{} copies',
        'Using {C:dark_edition}Negative {C:planet}Planets',
        'creates {C:attention}#2# {C:dark_edition}Negative {C:spectral}Black Holes',
        ' ',
        caption('The throne of death is not for a merciful fool like you.'),
        faceart('raidoesthings, jenwalter666'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {planets = 5, black_holes = 3}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
jumbo_mod = 3,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenayanami',
in_pool = function()
    return #SMODS.find_card('j_jen_oracle') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.planets, center.ability.extra.black_holes}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Planet' and ((context.consumeable.ability.hand_type or context.consumeable.ability.hand_types) or (context.consumeable.gc and context.consumeable:gc().ayanami)) then
        local quota = (context.consumeable:getEvalQty())
        local card_key = context.consumeable:gc().key
        local isnegative = (context.consumeable.edition or {}).negative
        if isnegative then
            card.cumulative_blackholes = (card.cumulative_blackholes or 0) + quota
        else
            if not card.cumulative_qtys then card.cumulative_qtys = {} end
            card.cumulative_qtys[card_key] = (card.cumulative_qtys[card_key] or 0) + quota
        end
        if jl.njr(context) then
            card:speak(ayanami_blurbs, G.C.SECONDARY_SET.Planet)
            Q(function()
                Q(function()
                    if card then
                        if card.cumulative_qtys then
                            for k, v in pairs(card.cumulative_qtys) do
                                local duplicate = create_card('Planet', G.consumeables, nil, nil, nil, nil, k, 'ayanami_negativeplanet')
                                duplicate.no_forced_edition = true
                                duplicate:set_edition({negative = true}, true)
                                duplicate.no_forced_edition = nil
                                duplicate:setQty(card.ability.extra.planets * (v or 1))
                                duplicate:create_stack_display()
                                duplicate:set_cost()
                                duplicate.no_omega = true
                                duplicate:add_to_deck()
                                G.consumeables:emplace(duplicate)
                            end
                            card.cumulative_qtys = nil
                        end
                        if (card.cumulative_blackholes or 0) > 0 then
                            local blackhole = create_card('Planet', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'ayanami_blackhole')
                            blackhole.no_forced_edition = true
                            blackhole:set_edition({negative = true}, true)
                            blackhole.no_forced_edition = nil
                            blackhole:setQty(card.ability.extra.black_holes * (card.cumulative_blackholes or 1))
                            blackhole:create_stack_display()
                            blackhole:set_cost()
                            blackhole.no_omega = true
                            blackhole:add_to_deck()
                            G.consumeables:emplace(blackhole)
                            card.cumulative_blackholes = nil
                        end
                    end
                    return true
                end, 0.2, nil, 'after')
                return true
            end, 0.2, nil, 'after')
        end
        return nil, true
    end
end
}

SMODS.Joker {
key = 'ratau',
loc_txt = {
    name = 'Ratau',
    text = {
        'Values on {C:attention}consumables',
        'are {C:attention}multiplied{} by {C:attention}#1#',
        'when they are created',
        '{C:inactive}(If possible, as some values can\'t be modified)',
        '{C:inactive}(Not all cards are affected)',
        ' ',
        caption('You still have the chance to mend your past, so don\'t waste it like I did.'),
        faceart('raidoesthings'),
        origin('Cult of the Lamb'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {modifier = 2},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
jumbo_mod = 3,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenratau',
in_pool = function()
    return #SMODS.find_card('j_jen_elder') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.modifier}}
end
}

SMODS.Joker {
key = 'cosmo',
loc_txt = {
    name = 'Cosmo',
    text = {
        '{C:attention}Enhanced cards{} can be selected',
        '{C:attention}regardless of the selection limit',
        '{C:inactive,s:0.75}(ex. you can select any number of enhanced cards alongside 5 other unenhanced cards)',
        ' ',
        lore('A socially-anxious pastry, but Sprout keeps him company!'),
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
unique = true,
atlas = 'jencosmo'
}

SMODS.Joker {
key = 'toodles',
loc_txt = {
    name = 'Toodles',
    text = {
        '{C:attention}8s{} have a(n) {C:green}#1# in 88 chance',
        'to give {C:chips}+88{} Chips',
        ' ',
        lore('The most hyperactive 8-ball kid you\'ll ever see!'),
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 3,
rarity = 1,
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jentoodles',
loc_vars = function(self, info_queue, center)
    return {vars = {G.GAME.probabilities.normal * 8.8}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.play then
        if context.other_card and not context.other_card:norank() and context.other_card:get_id() == 8 then
            return {
                chip_mod = 88,
                chips = 88,
                colour = G.C.CHIPS,
                card = card
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'murphy',
loc_txt = {
    name = 'Murphy',
    text = {
        '{C:attention}9{}s give {X:jen_RGB,C:white,s:1.5}^^1.09{C:chips} Chips',
        'when scored',
        ' ',
        lore('Jack of all cards, a master of bananas. "Bananarama" as he says.'),
        caption('That\'s just a bunch of balls!'),
        faceart('jenwalter666'),
        '{C:cry_ascendant,E:1}https://www.twitch.tv/murphyobv'
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = twitch,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenmurphy',
calculate = function(self, card, context)
    if context.cardarea == G.play then
        if context.other_card and not context.other_card:norank() and context.other_card:get_id() == 9 then
            return {
                ee_chips = 1.09,
                colour = G.C.CHIPS,
                card = card
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'roffle',
loc_txt = {
    name = 'Roffle',
    text = {
        'Grants {C:green}the Coin',
        'Whenever any {C:attention}Joker{} is {C:attention}triggered{},',
        'generate {C:spectral,E:1}Mana{} for {C:green}the Coin',
        ' ',
        lore('A wise card player. Particularly fond friends with the Wee Joker.'),
        caption('WEEEEEEEE!!'),
        faceart('jenwalter666'),
        '{C:cry_ascendant,E:1}https://www.twitch.tv/roffle'
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = twitch,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenroffle',
abilitycard = 'c_jen_roffle_c',
calculate = function(self, card, context)
    if context.post_trigger and context.other_joker ~= self then
        for k, v in ipairs(G.consumeables.cards) do
            if v.gc and v:gc() and v:gc().key == 'c_jen_roffle_c' and not (v.edition or {}).negative then
                if jl.njr(context) then Q(function() card:juice_up(0.5, 0.5) return true end) end
                v.ability.mana = v.ability.mana + 1
                card.cumulative_mana = (card.cumulative_mana or 0) + 1
                if card.cumulative_mana <= 1 then
                    QR(function()
                        if card then
                            if card.cumulative_mana then
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = '+' .. number_format(card.cumulative_mana) .. ' Mana', colour = G.C.SECONDARY_SET.Spectral})
                                card.cumulative_mana = nil
                            end
                        end
                    return true end, 15)
                end
            end
        end
    end
end,
}

local function numtags()
if not G.GAME.tags then return 0 end
local tags = 0
for k, v in pairs(G.GAME.tags) do
    tags = tags + 1
end
return tags
end

SMODS.Joker {
key = 'kyle',
loc_txt = {
    name = 'Kyle Skreene',
    text = {
        '{X:jen_RGB,C:white,s:1.5}+^^#1#{C:mult} Mult',
        'for every currently-held {C:attention}Tag',
        '{C:inactive}(Currently {X:jen_RGB,C:white,s:1.5}^^#2#{C:inactive})',
        ' ',
        caption('The tags pile doesn\'t'),
        caption('stop from getting higher.'),
        faceart('Luigicat11'),
        origin('Homestuck')
    }
},
config = {extra = {tetration = 0.2}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenkyle',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.tetration, 1 + (numtags() * center.ability.extra.tetration)}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        local tags = numtags()
        if tags > 0 then
            local num = 1 + (tags*card.ability.extra.tetration)
            return {
                message = '^^' .. num .. ' Mult',
                colour = G.C.jen_RGB,
                EEmult_mod = num,
                card = card
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'johnny',
loc_txt = {
    name = 'Johnny',
    text = {
        '{X:dark_edition,C:mult}^#1#{C:mult} Mult',
        'Using {C:spectral}Black Holes {C:green}increases{} this by {C:attention}#2#',
        'Using {C:spectral}White Holes {C:purple}multiplies{} this by {C:attention}#3#',
        ' ',
        caption('Now, step into the hat. Yes, just like that.'),
        faceart('BondageKat')
    }
},
config = {big_num_scaler = true, extra = {em = 1.5, blackhole_factor = 0.5, whitehole_factor = 3}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenjohnny',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.em, center.ability.extra.blackhole_factor, center.ability.extra.whitehole_factor}}
end,
calculate = function(self, card, context)
    if not context.blueprint then
        if context.using_consumeable and context.consumeable then
            local improved = false
            local eval = context.consumeable:getEvalQty()
            if context.consumeable:gc().key == 'c_black_hole' then
                card.ability.extra.em = card.ability.extra.em + (card.ability.extra.blackhole_factor * eval)
                improved = true
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = '+' .. number_format(card.ability.extra.blackhole_factor * eval), colour = G.C.DARK_EDITION})
            elseif context.consumeable:gc().key == 'c_cry_white_hole' then
                card.ability.extra.em = card.ability.extra.em * (card.ability.extra.whitehole_factor ^ eval)
                improved = true
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'x' ..number_format(card.ability.extra.whitehole_factor ^ eval), colour = G.C.DARK_EDITION})
            end
            if improved then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = '^' .. number_format(card.ability.extra.em) .. ' Mult', colour = G.C.FILTER})
                return nil, true
            end
        end
    end
    if context.cardarea == G.jokers and context.joker_main then
        if to_big(card.ability.extra.em) > to_big(1) then
            return {
                message = '^' .. number_format(card.ability.extra.em) .. ' Mult',
                colour = G.C.DARK_EDITION,
                Emult_mod = card.ability.extra.em,
                card = card
            }, true
        end
    end
end
}

local kori_captions = {
normal = {
    'Wh-?? Did someone transport me to ANOTHER universe??',
    'There\'s some familiar faces here, from what I\'ve seen of the collection. Maybe I\'ll get to say "hi"?',
    'Will I ever go back to my home?'
},
scared = {
    "S-so much power... I... haven't seen anything like this since before the incident...",
    "H-hey! Don't overload the system with me in it! ...Pretty please?",
    "With... *that* kind of raw strength... I could finally dispose of the demon haunting my dreams."
},
marble = {
    "What is this artefact...? Gah- it's... it's... drawing out the demon...!!"
}
}

local function kori_strength(power)
local level = 1
for i = 1, 6 do
    local req = 10^(i + 1)
    if power > req then
        level = level + 1
        power = power - req
    else
        break
    end
end
return { op = level, no = power + 3 }
end



SMODS.Joker {
key = 'guilduryn',
loc_txt = {
    name = 'Guilduryn',
    text = {
        '{C:attention}Gold 7{}s give',
        '{X:dark_edition,C:mult}^7{C:mult} Mult{} when scored',
        '{C:planet}Hand level-ups{} are {C:attention}redirected',
        'to your {C:attention}most played hand',
        '{C:inactive}(Currently {C:attention}#1#{C:inactive})',
        ' ',
        lore('Prideful and zealous; his gold is as shiny as his connection with his sister Hydrangea.'),
        caption('Leader of the Seven Sins at your service~!'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = sevensins.guilduryn,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenguilduryn',
loc_vars = function(self, info_queue, center)
    return {vars = {localize(jl.favhand(), 'poker_hands')}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.play then
        if context.other_card and context.other_card.ability.name == 'Gold Card' and context.other_card:get_id() == 7 then
            return {
                message = '^7 Mult',
                e_mult = 7,
                colour = G.C.MULT,
                card = card
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'hydrangea',
loc_txt = {
    name = 'Hydrangea',
    text = {
        '{C:attention}7{}s reduce the {C:attention}current Blind',
        'by {C:attention}7%{} when scored',
        ' ',
        lore('A brute with a pinch of impatience, getting on her bad side is not uncommon.'),
        caption('Whatever you\'re bugging me about better be important...'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = sevensins.hydrangea,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenhydrangea',
calculate = function(self, card, context)
    if context.cardarea == G.play then
        if context.other_card and not context.other_card:norank() and jl.scj(context) and context.other_card:get_id() == 7 then
            if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
                card_status_text(card, '-7% Blind Size', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
            end
            change_blind_size(to_big(G.GAME.blind.chips) / to_big(1.07), (G.SETTINGS.FASTFORWARD or 0) > 1, (G.SETTINGS.FASTFORWARD or 0) > 1)
            return nil, true
        end
    end
end
}

SMODS.Joker {
key = 'heisei',
loc_txt = {
    name = 'Heisei',
    text = {
        '{C:attention}7{}s raise {C:chips}Chips{} to the {X:dark_edition,C:white}power{} of',
        '{C:green}1 plus a tenth of your {C:money}money{} when scored,',
        '{C:red,E:1}but also takes half of your money',
        '{C:inactive}(No effect if you have $0 or less)',
        ' ',
        lore('Sly and sneaky; socialising with you one day, pickpocketing you the next.'),
        caption('Enough about me, what is it that you desire?'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = sevensins.heisei,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenheisei',
immutable = true,
calculate = function(self, card, context)
    if context.cardarea == G.play and context.individual then
        if context.other_card:get_id() == 7 then
            local val = G.GAME.dollars
            if to_big(val) > to_big(0) then
                ease_dollars(-math.floor(to_big(G.GAME.dollars) / to_big(2)))
                return {
                    Echip_mod = (1 + (val/10)),
                    card = card
                }, true
            end
        end
    end
end
}

SMODS.Joker {
key = 'soryu',
loc_txt = {
    name = 'Soryu',
    text = {
        '{C:attention}Retrigger every Joker once',
        'for every {C:attention}7 of {C:hearts}Hearts',
        'in played hand',
        '{C:inactive}(Also considers Wilds and any Joker effects)',
        ' ',
        lore('As elegant as they are flirty.'),
        caption('Patience is the key, dear. I don\'t do my work in one day, after all.'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 20,
rarity = 4,
misc_badge = sevensins.soryu,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jensoryu',
calculate = function(self, card, context)
    if not context.blueprint and not context.repetition then
        if context.retrigger_joker_check and not context.retrigger_joker then
            local reps = 0
            if G.play and G.play.cards and next(G.play.cards) then
                for k, v in pairs(G.play.cards) do
                    if not v:norankorsuit() and v:get_id() == 7 and v:is_suit('Hearts') then
                        reps = reps + 1
                    end
                end
            end
            if reps > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = reps,
                    card = card
                }
            end
        end
    end
end
}

SMODS.Joker {
key = 'shikigami',
loc_txt = {
    name = 'Shikigami',
    text = {
        'Scored {C:attention}7{}s create',
        '{C:attention}7 copies{} of themselves',
        ' ',
        lore('The punching bag of the group, and also the shameful reason of their banishment.'),
        caption('Why are we cards?? Where even are we?!'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 20,
rarity = 4,
misc_badge = sevensins.shikigami,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenshikigami',
calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        if context.other_card:get_id() == 7 then
            local sevens = {}
            for i = 1, 7 do
                local seven = copy_card(context.other_card, nil, nil, G.playing_card)
                seven:add_to_deck()
                seven:start_materialize()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(sevens, seven)
            end
            for k, seven in pairs(sevens) do
                if seven ~= context.other_card then
                    table.insert(G.playing_cards, seven)
                    G.deck:emplace(seven)
                end
            end
            return nil, true
        end
    end
end
}

local leviathan_blurbs = {
dull = {
    'My axe is dull!',
    "I can't cut through it!",
    "Axe's dull; can't slice this obstacle!",
    'I need a whetstone!',
    'Find me a grindstone, please.',
    'Need to sharpen my axe!',
    'You expecting me to slay this thing with a dull axe?',
    "I can't do anything if my axe will just bounce off!",
    'Grindstone, please?',
    'Stop trying to get me to use a dull axe and just GET A WHETSTONE ALREADY!',
    "Not now, axe's not ready.",
    'I blame Shikigami for this...'
},
sharpen = {
    'Good as new.',
    'Bring me more of those whetstones, yeah?',
    'Gotta keep my axe sharp.',
    'Sharpened!',
    'Looks ready to cut again.',
    'I kind of like that noise.',
    "Can't have my axe becoming dull!",
    'I prefer something sharp over something blunt.',
    'Ready for another swing.',
    "Thanks for the whetstone, Shikigami."
}
}

local leviathan_maxsharpness = 3

SMODS.Joker {
key = 'leviathan',
loc_txt = {
    name = 'Leviathan',
    text = {
        '{X:inactive}Axe{} {X:inactive}Sharpness{} : {C:attention}#1#{C:inactive} / ' .. tostring(leviathan_maxsharpness) .. '',
        ' ',
        'If played hand contains {C:attention}only one card{}, and that',
        'card is a {C:attention}Steel 7 of any suit{},',
        '{C:red}destroy it{} and then set the',
        '{C:attention}current Blind size{} to {C:attention}1',
        'If the only card is instead a {C:attention}Stone Card{},',
        "{C:red}destroy it{} and {C:attention}sharpen Leviathan's axe{} by {C:attention}1{} point",
        ' ',
        lore('She wields a devastating axe, just as sharp as her wits.'),
        caption('Are you going to co-operate, or are you just going to stand there?'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {axesharpness = leviathan_maxsharpness}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 2375,
rarity = 'jen_extraordinary',
misc_badge = sevensins.leviathan,
unlocked = true,
discovered = true,
debuff_immune = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
unique = true,
immutable = true,
atlas = 'jenleviathan',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.axesharpness}}
end,
calculate = function(self, card, context)
    if context.destroying_card and not context.blueprint and not context.retrigger_joker then
        if context.full_hand and #context.full_hand == 1 then
            if context.full_hand[1]:get_id() == 7 and context.full_hand[1].ability.name == 'Steel Card' then
                if card.ability.extra.axesharpness > 0 then
                    Q(function()
                        card:juice_up(0.8, 0.2)
                        G.GAME.blind:juice_up(3,3)
                        play_sound('slice1', 0.96+math.random()*0.08)
                        change_blind_size(1)
                        return true
                    end)
                    card.ability.extra.axesharpness = math.max(0, card.ability.extra.axesharpness - 1)
                    return true
                else
                    local rng = math.random(#leviathan_blurbs.dull)
                    if rng ~= 1 and #SMODS.find_card('j_jen_shikigami') <= 0 then
                        rng = rng - 1
                    end
                    local blurb = leviathan_blurbs.dull[rng]
                    card_status_text(card, blurb, nil, 0.05*card.T.h, G.C.RED, 0.6, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
                    if rng == #leviathan_blurbs.dull and #SMODS.find_card('j_jen_shikigami') > 0 then
                        local shiki = SMODS.find_card('j_jen_shikigami')[1]
                        if shiki then
                            card_status_text(shiki, "What?! What did I do?", nil, 0.05*shiki.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(card, "Nothing, I just like riling you up.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(shiki, "Oh, harr, harr, harr... real funny...", nil, 0.05*shiki.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(card, "Although I might actually blame you if you don't shut up.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(shiki, "I'M NOT DOING ANYTHING WRONG-", nil, 0.05*shiki.T.h, G.C.RED, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(card, "I said, shut up.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(shiki, "...Hmph...", nil, 0.05*shiki.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            card_status_text(card, "Better.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        end
                    end
                end
            elseif context.full_hand[1].ability.name == 'Stone Card' and card.ability.extra.axesharpness < leviathan_maxsharpness then
                card.ability.extra.axesharpness = math.min(card.ability.extra.axesharpness + 1, leviathan_maxsharpness)
                local rng = math.random(#leviathan_blurbs.sharpen)
                if rng ~= 1 and #SMODS.find_card('j_jen_shikigami') <= 0 then
                    rng = rng - 1
                end
                local blurb = leviathan_blurbs.sharpen[rng]
                card_status_text(card, blurb, nil, 0.05*card.T.h, G.C.RED, 0.6, 0.6, nil, nil, 'bm', 'jen_grindstone')
                if rng == #leviathan_blurbs.sharpen and #SMODS.find_card('j_jen_shikigami') > 0 then
                    local shiki = SMODS.find_card('j_jen_shikigami')[1]
                    if shiki then
                        card_status_text(shiki, "Huh? What whetstone?", nil, 0.05*shiki.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(card, "This one.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(shiki, "What are you- I didn't get you that!", nil, 0.05*shiki.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(card, "I know, that's the point.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(shiki, "...What?", nil, 0.05*shiki.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(card, "The point is that you hardly help.", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(shiki, "OH COME ON!", nil, 0.05*shiki.T.h, G.C.RED, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        card_status_text(card, "Heheheh...", nil, 0.05*card.T.h, G.C.GREY, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                    end
                end
                return true
            end
        end
    end
end
}

SMODS.Joker {
key = 'behemoth',
loc_txt = {
    name = 'Behemoth',
    text = {
        '{X:black,C:red,s:3}^^^#1#{C:purple} Chips & Mult{} if played hand',
        'contains {C:attention}four or more 7s',
        ' ',
        lore('Like a hibernating bear; lazy and slow, but obliteration is merely a single mistake away.'),
        caption('Don\'t poke a tiger in its rest; not even a cub...'),
        faceart('raidoesthings'),
        au('Prophecy of the Broken Crowns')
    }
},
config = {extra = {pentation = 1.77}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = sevensins.behemoth,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenbehemoth',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.pentation}}
end,
calculate = function(self, card, context)
    if context.joker_main then
        local cards = G.play.cards
        local sevens = 0
        for k, v in pairs(cards) do
            if v:get_id() == 7 then
                sevens = sevens + 1
                if sevens >= 4 then break end
            end
        end
        if sevens >= 4 then
            return {
                message = 'Hrraaaaagh!!! (^^^' .. card.ability.extra.pentation .. ' Chips & Mult)',
                EEEmult_mod = card.ability.extra.pentation,
                EEEchip_mod = card.ability.extra.pentation,
                colour = G.C.BLACK,
                card = card
            }, true
        end
    end
end
}

local cuc = Card.use_consumeable

function Card:do_jen_astronomy(hand, mod)
local cen = self.gc and self:gc()
if cen and not cen.cant_astronomy then
    mod = mod or 1
    local pos = -1
    for i = 1, #G.handlist do
        if G.handlist[i] == hand then
            pos = i
            break
        end
    end
    local iterations = 1
    if Jen.hv('astronomy', 3) then
        for k, v in ipairs(G.consumeables.cards) do
            if v.gc then
                if v:gc().set == 'Planet' then
                    iterations = iterations + v:getEvalQty()
                elseif Jen.hv('astronomy', 4) then
                    iterations = iterations + (v:getEvalQty()/2)
                end
            end
        end
    end
    iterations = iterations * mod
    if iterations > mod then
        jl.th(hand)
        fastlv(self, hand, nil, iterations - mod)
    end
    local forehand = G.handlist[pos + 1]
    local backhand = G.handlist[pos - 1]
    local forehand2 = G.handlist[pos + 2]
    local backhand2 = G.handlist[pos - 2]
    if Jen.hv('astronomy', 1) then
        if forehand then
            if Jen.config.verbose_astronomicon then jl.th(forehand) end
            fastlv(self, forehand, not Jen.config.verbose_astronomicon, iterations)
        end
        if backhand then
            if Jen.config.verbose_astronomicon then jl.th(backhand) end
            fastlv(self, backhand, not Jen.config.verbose_astronomicon, iterations)
        end
        if Jen.hv('astronomy', 12) then
            if forehand2 then
                if Jen.config.verbose_astronomicon then jl.th(forehand2) end
                fastlv(self, forehand2, not Jen.config.verbose_astronomicon, iterations)
            end
            if backhand2 then
                if Jen.config.verbose_astronomicon then jl.th(backhand2) end
                fastlv(self, backhand2, not Jen.config.verbose_astronomicon, iterations)
            end
        end
    end
    if Jen.hv('astronomy', 2) then
        if Jen.config.verbose_astronomicon then
            jl.h('Non-Adjacent Hands', '+', '+', '+' .. number_format(0.1 * iterations), true)
            delay(1)
        end
        for k, v in ipairs(G.handlist) do
            if v ~= (forehand or '') and v ~= (backhand or '') then
                fastlv(self, v, true, 0.1 * iterations)
            end
        end
    end
end
end

function Card:use_consumeable(area, copier)
for k, v in ipairs(G.consumeables.cards) do
    if self:gc().key ~= 'c_jen_reverse_fool' and self:gc().key ~= 'c_cry_pointer' and not string.find(self:gc().key, 'c_jen_blank') and self.ability.set == v.ability.set and string.find(v:gc().key, 'c_jen_blank') and not v.changing_from_blank then
        v.changing_from_blank = true
        card_eval_status_text(v, 'extra', nil, nil, nil, {
            message = 'Copied!',
            colour = G.C.FILTER,
        })
        Q(function() v:flip();play_sound('tarot1');return true end)
        delay(1.5)
        Q(function() v:flip();play_sound('tarot2');v:set_ability(G.P_CENTERS[self:gc().key]);v.changing_from_blank = nil;return true end)
    end
end
if self.gc and self:gc() then
    local cen = self:gc()
    if self.was_in_pack_area and Jen.hv('reserve', 4) and cen.set ~= 'jen_omegaconsumable' then
        Q(function()
            local card2 = create_card(cen.set, G.consumeables, nil, nil, nil, nil, cen.key, 'reserve4')
            card2.no_omega = true
            play_sound('jen_draw')
            card2:add_to_deck()
            G.consumeables:emplace(card2)
        return true end)
        if Jen.hv('reserve', 5) and jl.chance('reserve5_roll', 3, true) then
            G.GAME.pack_choices = G.GAME.pack_choices + 1
            local card2 = create_card(cen.set, G.pack_cards, nil, nil, nil, nil, nil, 'reserve6')
            card2.no_omega = true
            card2:add_to_deck()
            G.pack_cards:emplace(card2)
        end
        if Jen.hv('reserve', 6) then
            Q(function()
                local card2 = create_card(cen.set, G.consumeables, nil, nil, nil, nil, nil, 'reserve6')
                card2.no_omega = true
                play_sound('jen_draw')
                card2:add_to_deck()
                G.consumeables:emplace(card2)
            return true end)
        end
    end
    if cen.set == 'Colour' then
        if Jen.hv('colour', 2) then
            n_random_colour_rounds(math.max(0, self.ability.partial_rounds or 0))
        end
        if Jen.hv('colour', 10) or (Jen.hv('colour', 3) and (self.edition or {}).polychrome) then
            for k, v in ipairs(G.consumeables.cards) do
                if v:gc().set == 'Colour' then
                    for i = 1, math.ceil(math.max(self.ability.upgrade_rounds or 1, 1) / 2) do
                        trigger_colour_end_of_round(v)
                    end
                end
            end
        end
        if Jen.hv('colour', 11) then
            for k, v in ipairs(G.consumeables.cards) do
                if v:gc().set == 'Colour' then
                    for i = 1, math.max(self.ability.val or 1, 1) do
                        trigger_colour_end_of_round(v)
                    end
                end
            end
        end
        if Jen.hv('colour', 12) and (self.edition or {}).negative then
            local no_colours = 1
            for k, v in ipairs(G.consumeables.cards) do
                if v:gc().set == 'Colour' then
                    no_colours = no_colours + 1
                end
            end
            for k, v in ipairs(G.consumeables.cards) do
                if v:gc().set == 'Colour' then
                    for i = 1, math.min(1e5, math.ceil(((math.max(self.ability.upgrade_rounds or 1, 1) + math.max(self.ability.partial_rounds or 0, 0) + 1) * (math.max(v.ability.upgrade_rounds or 1, 1) + math.max(v.ability.partial_rounds or 0, 0) + 1)) * (((self.ability.val or 0) + 1)^math.min(1.5, (1 + (no_colours/20)))))) do
                        trigger_colour_end_of_round(v)
                    end
                end
            end
        end
        if Jen.hv('colour', 4) then
            self:blackhole(((self.ability.partial_rounds or 0) * 0.5) + ((self.ability.upgrade_rounds or 0) * 0.25) + ((self.ability.val or 0) * ((self.ability.upgrade_rounds or 0) * 5)))
        end
    elseif cen.set == 'Planet' then
        if Jen.hv('singularity', 2) and not (self.edition or {}).negative then
            Q(function()
                local qty = self:getEvalQty() * (Jen.hv('singularity', 9) and 3 or 1)
                local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'singularity2_blackhole')
                card2.no_omega = true
                if qty > 1 then
                    card2:setQty(qty)
                    card2:create_stack_display()
                end
                card2:set_edition({negative = true}, true)
                play_sound('jen_draw')
                card2:add_to_deck()
                G.consumeables:emplace(card2)
                qty = nil
            return true end)
        end
        if self.ability.hand_type then
            self:do_jen_astronomy(self.ability.hand_type, self:getEvalQty())
        elseif self.ability.hand_types then --suit planets
            for k, v in ipairs(self.ability.hand_types) do
                self:do_jen_astronomy(v, self:getEvalQty())
            end
        end
    elseif cen.key == 'c_black_hole' then
        if Jen.hv('singularity', 3) then
            for k, v in pairs(G.GAME.suits) do
                level_up_suit(self, k, true, (Jen.hv('singularity', 6) and 300 or Jen.hv('singularity', 4) and 25 or 1) * self:getEvalQty())
            end
            for k, v in pairs(G.GAME.ranks) do
                level_up_rank(self, k, true, (Jen.hv('singularity', 6) and 300 or Jen.hv('singularity', 4) and 25 or 1) * self:getEvalQty())
            end
        end
        if Jen.hv('singularity', 4) then
            black_hole_effect(self, ((Jen.hv('singularity', 6) and 300 or 25) * self:getEvalQty()) - self:getEvalQty())
        end
        if Jen.hv('singularity', 5) then
            local successful_rolls = 0
            local rolls_remaining = self:getEvalQty()
            while successful_rolls < 100 and rolls_remaining > 1 do
                if jl.chance('singularity5_roll', 10, true) then
                    successful_rolls = successful_rolls + 1
                end
                rolls_remaining = rolls_remaining - 1
            end
            if successful_rolls > 0 then
                for i = 1, successful_rolls do
                    Q(function()
                        local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'singularity5_success')
                        card2.no_omega = true
                        play_sound('jen_draw')
                        card2:add_to_deck()
                        G.consumeables:emplace(card2)
                    return true end)
                end
            end
        end
        if Jen.hv('singularity', 7) then
            for k, v in pairs(G.GAME.hands) do
                G.GAME.hands[k].l_chips = G.GAME.hands[k].l_chips * (to_big(2) ^ self:getEvalQty())
                G.GAME.hands[k].l_mult = G.GAME.hands[k].l_mult * (to_big(2) ^ self:getEvalQty())
            end
        end
        if Jen.hv('singularity', 8) then
            for k, v in pairs(G.GAME.suits) do
                G.GAME.suits[k].l_chips = G.GAME.suits[k].l_chips * (to_big(2) ^ self:getEvalQty())
                G.GAME.suits[k].l_mult = G.GAME.suits[k].l_mult * (to_big(2) ^ self:getEvalQty())
            end
            for k, v in pairs(G.GAME.ranks) do
                G.GAME.ranks[k].l_chips = G.GAME.ranks[k].l_chips * (to_big(2) ^ self:getEvalQty())
                G.GAME.ranks[k].l_mult = G.GAME.ranks[k].l_mult * (to_big(2) ^ self:getEvalQty())
            end
        end
    elseif cen.key == 'c_jen_soul_omega' then
        self:setQty(1)
    end
end
cuc(self, area, copier)
end

local function numfoodjokers()
if not G.jokers then return 0 end
local amount = 0
for k, v in pairs(Cryptid.food) do
    local amnt = #SMODS.find_card(v)
    if amnt > 0 then
        amount = amount + (amnt * (1))
    end
end
return amount
end

local peppino_desc = {
'{X:dark_edition,C:red}^x2{C:red} Mult{} for every',
'{C:attention}food Joker{} in your possession',
'{C:inactive}(Currently {X:dark_edition,C:red}^#1#{C:red} Mult{C:inactive})',
' ',
lore('Sometimes, high anxiety is an asset.'),
caption('Okay, you look-a right-e here!'),
caption('I baked that into a pizza ONCE-a, and-a nobody can ever know-a!'),
caption('Not even the health inspector... Capeesh-e?'),
faceart('jenwalter666'),
origin('Pizza Tower')
}

SMODS.Joker {
key = 'peppino',
loc_txt = {
    name = 'Peppino Spaghetti',
    text = peppino_desc
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = gaming,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenpeppino',
loc_vars = function(self, info_queue, center)
    return {vars = {2 ^ numfoodjokers()}}
end,
calculate = function(self, card, context)
    local food = numfoodjokers()
    if context.cardarea == G.jokers and context.joker_main and food > 0 then
        local power = 2 ^ food
        return {
            message = '^' .. power .. ' Mult',
            Emult_mod = power,
            colour = G.C.DARK_EDITION
        }, true
    end
end
}

local function totalnoise()
return #((G.jokers or {}).cards or {}) + #((G.hand or {}).cards or {})
end

SMODS.Joker {
key = 'noise',
loc_txt = {
    name = 'The Noise',
    text = {
        'Retrigger {C:attention}all{} scored cards {C:attention}once',
        'for every {C:attention}Joker{} you have {C:green}plus',
        '{C:attention}once{} for every card in your hand',
        '{C:inactive}(Currently {C:attention}#1#{C:inactive} time(s))',
        ' ',
        lore('Mostly annoying, sometimes sinister.'),
        caption('Hey-a! Howsabout a nice ride in this'),
        caption('washing machine here? Admission is freeeee!'),
        faceart('jenwalter666'),
        origin('Pizza Tower')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = gaming,
dangerous = true,
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
unique = true,
atlas = 'jennoise',
loc_vars = function(self, info_queue, center)
    return {vars = {totalnoise()}}
end,
calculate = function(self, card, context)
    if not context.blueprint_card then
        if context.repetition then
            if context.cardarea == G.play then
                return {
                    message = 'Woag!',
                    repetitions = totalnoise(),
                    colour = G.C.YELLOW,
                    nopeus_again = true,
                    card = card
                }
            end
        end
    end
end
}

SMODS.Joker {
key = 'arin',
loc_txt = {
    name = 'Commander Arin',
    text = {
        'Generates {C:attention}three Boosters',
        'whenever you {C:money}cash out',
        ' ',
        lore('To you, it\'s a sleep mask. To him, it\'s goggles that provide insight to victory.'),
        caption('The army of Z-Tech shall prosper.'),
        faceart('raidoesthings'),
        origin('Plants vs. Zombies')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 2375,
rarity = 'jen_extraordinary',
unique = true,
wee_incompatible = true,
immutable = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenarin'
}

SMODS.Joker {
key = 'lugia',
loc_txt = {
    name = 'Lugia',
    text = {
        'Generates {C:attention}two Vouchers',
        'whenever you {C:money}cash out',
        ' ',
        lore('Momosan really wanted this one. Monké.'),
        faceart('jenwalter666'),
        origin('Pokémon')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 2375,
rarity = 'jen_extraordinary',
wee_incompatible = true,
unique = true,
immutable = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenlugia'
}

SMODS.Joker {
key = 'swabbie',
loc_txt = {
    name = 'Swabbie',
    text = {
        'Grants the {C:green}ability{} to',
        '{C:money}sell{} playing cards',
        ' ',
        caption('Neh-heh-yeh-yeh-heh-yeh!'),
        faceart('crazy_dave_aka_crazy_dave'),
        origin('Plants vs. Zombies')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
misc_badge = gaming,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
unique = true,
atlas = 'jenswabbie',
abilitycard = 'c_jen_swabbie_c'
}

local function sellvalueofhighlightedhandcards()
if not G.hand then return 0 end
local value = 0
for k, v in pairs(G.hand.highlighted) do
    value = value + (v.sell_cost or 0)
end
return value
end

SMODS.Joker {
key = 'poppin',
loc_txt = {
    name = 'Paupovlin "Poppin" Revere',
    text = {
        'You can choose {C:attention}any number of cards',
        'after opening {C:attention}any Booster Pack',
        '{C:attention}Booster Packs{} have {C:green}+#1#{} additional card(s)',
        ' ',
        lore('Equipped with a jack-in-the-box that contains just about any tool to overcome any obstacle.'),
        caption('I am the most well-equipped ladybug in all of Synnia!'),
        faceart('jenwalter666'),
        origin('Poppin & Jupa')
    }
},
config = {extra = {extrachoices = 1}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenpoppin',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.extrachoices}}
end
}

local cor = Card.open

function Card:open()
local orig = self.ability.extra or 1
local poppins = #SMODS.find_card('j_jen_poppin')
if poppins > 0 then
    for k, v in pairs(SMODS.find_card('j_jen_poppin')) do
        orig = orig + v.ability.extra.extrachoices
    end
    self.config.choose = math.floor(orig)
    self.ability.extra = math.floor(orig)
end
cor(self)
Q(function()
    if poppins > 0 then
        G.GAME.pack_choices = math.floor(self.ability.extra)
    end
    return true
end, 0.5, 'REAL')
end

local rai_desc = ((SMODS.Mods['sdm0sstuff'] or {}).can_load and
{
    '{C:attention}Jokers{} without an edition',
    'become {C:dark_edition}Negative{} when added to possession',
    '{X:green,C:white}Synergy:{} {X:jen_RGB,C:white,s:1.5}+^^#1#{C:mult} Mult',
    'for every {X:attention,C:black}Burger{} owned',
    '{C:inactive}(Currently {X:jen_RGB,C:white,s:1.5}^^#2#{C:inactive})',
    ' ',
    lore('"Spontaneous combustion" is their way of saying "getting bored".'),
    caption('#3#'),
    faceart('jenwalter666'),
    origin('Bloody Bunny')
}
or
{
    '{C:attention}Jokers{} without an edition',
    'become {C:dark_edition}Negative{} when added to possession',
    ' ',
    lore('"Spontaneous combustion" is their way of saying "getting bored".'),
    caption('#3#'),
    faceart('jenwalter666'),
    origin('Bloody Bunny')
}
)

SMODS.Joker {
key = 'rai',
loc_txt = {
    name = 'Rai',
    text = rai_desc
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0 },
config = {extra = {bouigah = 0.88}},
cost = 20,
rarity = 4,
misc_badge = jenfriend,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenrai',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.bouigah, 1 + (center.ability.extra.bouigah * #SMODS.find_card('j_sdm_burger')), Jen.sinister and "OKAYOKAYOKAY I GET YOUR POINT!!!" or 'I do things. If I do not, I will spontaneously combust.'}}
end,
calculate = function(self, card, context)
    if (context.jen_adding_card or context.buying_card) and not context.blueprint and not (context.card or {}).edition and (context.card or {}) ~= card then
        if context.card.ability.set == 'Joker' and not context.card.about_to_turn_negative_from_rai then
            context.card.about_to_turn_negative_from_rai = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = context.card.ability.name == 'Burger' and 'Bouigah!' or 'Negation!',
                colour = G.C.DARK_EDITION,
            })
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.card.about_to_turn_negative_from_rai = nil
                    context.card:set_edition({negative = true}, true)
                    return true
                end
            }))
        end
    end -- synergy removed at the request of SDM_0
end
}

local koslo_flavour = {'Bam!', 'Pow!', 'Boom!', 'Kapow!', 'Chik-bhwm!'}

SMODS.Joker {
key = 'koslo',
loc_txt = {
    name = 'Koslo Jarfel',
    text = {
        '{C:attention}Retrigger{} scored {C:attention}8{}s',
        '{C:attention}88{} times',
        ' ',
        "{C:inactive,s:0.9,E:1}A friend of Jen's for over a decade, and counting.",
        faceart('jenwalter666'),
        origin('CRAFTWORLD')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 20,
rarity = 4,
wee_incompatible = true,
misc_badge = jenfriend,
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenkoslo',
calculate = function(self, card, context)
    if not context.blueprint_card then
        if context.repetition then
            if context.cardarea == G.play then
                if context.other_card:get_id() == 8 then
                    return {
                        message = koslo_flavour[math.random(#koslo_flavour)],
                        repetitions = 88,
                        nopeus_again = true,
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end
end
}

SMODS.Joker {
key = 'jen',
loc_txt = {
    name = 'Jen Walter',
    text = {
        '{C:blue}+1 Chip{C:inactive,E:1}...?',
        ' ',
        "{C:inactive,s:1.8,E:1}#1#",
        faceart('jenwalter666'),
        origin('CRAFTWORLD')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 1,
fusable = true,
rarity = 1,
misc_badge = iconic,
wee_incompatible = true,
unlocked = true,
unique = true,
immutable = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenjen',
in_pool = function()
    return #SMODS.find_card('j_jen_wondergeist') + #SMODS.find_card('j_jen_wondergeist2') <= 0
end,
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.gods() and 'i feel funny...' or "i'm trying..."}}
end,
calculate = function(self, card, context)
    if not context.blueprint_card then
        if context.joker_main then
            if next(SMODS.find_card('j_jen_rai')) and next(SMODS.find_card('j_jen_koslo')) then
                return {
                    message = '^1e100 Mult',
                    Emult_mod = 1e100,
                    colour = G.C.DARK_EDITION
                }, true
            elseif next(SMODS.find_card('j_jen_rai')) or next(SMODS.find_card('j_jen_koslo')) then
                return {
                    message = 'x777',
                    Xchip_mod = 777,
                    colour = G.C.CHIPS
                }, true
            else
                return {
                    message = '+1',
                    chip_mod = 1,
                    colour = G.C.CHIPS
                }, true
            end
        end
    end
end
}



local function landa_mod()
if not G.jokers or not G.deck then return 1 end
return (1 + #G.jokers.cards) * (1 + (#G.deck.cards / 100))
end

SMODS.Joker {
key = 'landa',
loc_txt = {
    name = 'Landa Veris',
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
}



local agares_blurbs = {
'Go, Darkclaw!',
'Excellent find, Razorbeak.',
'Most peculiar...',
'As ethereal as my familiars.',
'Go fetch, Darkclaw.',
'Razorbeak, recon now!'
}

SMODS.Joker {
key = 'agares',
loc_txt = {
    name = 'Witness Agares',
    text = {
        'Using a {C:attention}non-{C:dark_edition}Negative {C:spectral}Spectral',
        'creates {C:attention}#1# {C:dark_edition}Negative{} copies',
        '{C:inactive}(POINTER:// excluded)',
        ' ',
        lore('Knowledgeable like Clauneck, commander of two familiars.'),
        caption('#2#'),
        faceart('jenwalter666')
    }
},
config = {extra = {copies = 2}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0 },
cost = 20,
rarity = 4,
jumbo_mod = 3,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenagares',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.copies, Jen.sinister and 'RAZORBEAK! DARKCLAW! GET OUT OF THERE!!' or 'Razorbeak, keep watch. Darkclaw, track what we need to find.'}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Spectral' and context.consumeable:gc().key ~= 'c_cry_pointer' then
        local quota = (context.consumeable:getEvalQty())
        local card_key = context.consumeable:gc().key
        local isnegative = (context.consumeable.edition or {}).negative
        if not isnegative then
            if not card.cumulative_qtys then card.cumulative_qtys = {} end
            card.cumulative_qtys[card_key] = (card.cumulative_qtys[card_key] or 0) + quota
            if jl.njr(context) then
                card:speak(agares_blurbs, G.C.SECONDARY_SET.Spectral)
                Q(function()
                    Q(function()
                        if card then
                            if card.cumulative_qtys then
                                for k, v in pairs(card.cumulative_qtys) do
                                    local duplicate = create_card('Spectral', G.consumeables, nil, nil, nil, nil, k, 'jess_negative')
                                    duplicate.no_forced_edition = true
                                    duplicate:set_edition({negative = true}, true)
                                    duplicate.no_forced_edition = nil
                                    duplicate:setQty(card.ability.extra.copies * (v or 1))
                                    duplicate:create_stack_display()
                                    duplicate:set_cost()
                                    duplicate.no_omega = true
                                    duplicate:add_to_deck()
                                    G.consumeables:emplace(duplicate)
                                end
                                card.cumulative_qtys = nil
                            end
                        end
                        return true
                    end, 0.2, nil, 'after')
                    return true
                end, 0.2, nil, 'after')
            end
            return nil, true
        end
    end
end
}

SMODS.Joker {
key = 'spice',
loc_txt = {
    name = 'Spice',
    text = {
        'Using a {C:attention}non-{C:dark_edition}Negative {C:tarot}Tarot',
        'creates {C:attention}#1# {C:dark_edition}Negative{} copies',
        '{C:inactive}(The Fool excluded)',
        ' ',
        "{C:inactive,E:1}#2#",
        faceart('jenwalter666')
    }
},
config = {extra = {copies = 2}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
sinis = { x = 2, y = 0 },
cost = 20,
rarity = 4,
jumbo_mod = 3,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenspice',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.copies, Jen.sinister and 'Okay, WTF?!' or 'I can whack animals from behind.'}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Tarot' and context.consumeable:gc().key ~= 'c_fool' then
        local quota = (context.consumeable:getEvalQty())
        local card_key = context.consumeable:gc().key
        local isnegative = (context.consumeable.edition or {}).negative
        if not isnegative then
            if not card.cumulative_qtys then card.cumulative_qtys = {} end
            card.cumulative_qtys[card_key] = (card.cumulative_qtys[card_key] or 0) + quota
            if jl.njr(context) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Whack!', colour = G.C.SECONDARY_SET.Tarot})
                Q(function()
                    Q(function()
                        if card then
                            if card.cumulative_qtys then
                                for k, v in pairs(card.cumulative_qtys) do
                                    local duplicate = create_card('Tarot', G.consumeables, nil, nil, nil, nil, k, 'spice_negative')
                                    duplicate.no_forced_edition = true
                                    duplicate:set_edition({negative = true}, true)
                                    duplicate:setQty(card.ability.extra.copies * (v or 1))
                                    duplicate:create_stack_display()
                                    duplicate:set_cost()
                                    duplicate.no_omega = true
                                    duplicate:add_to_deck()
                                    G.consumeables:emplace(duplicate)
                                end
                                card.cumulative_qtys = nil
                            end
                        end
                        return true
                    end, 0.2, nil, 'after')
                    return true
                end, 0.2, nil, 'after')
            end
            return nil, true
        end
    end
end
}

local alice_blurbs = {
"Purrfect!",
"For the lulz!",
"Dis is gonna be bonkers!",
"LOL!",
"LMAO!",
"1337!",
"KEK!",
"Hehehehehehehehehehehe!",
"HAHAHAHA!",
"I'm not malware if I'm just joking around!",
"Oops, looks like I moved a file!",
"Memes!",
"01001100 01001111 01001100",
"01001100 01001101 01000001 01001111",
"Remember dial-up?",
"\"AOL?\" More like \"LOL\"!",
"Oooh, nice file!",
"What if I move this to here?",
"Might've fried a circuitboard over here.",
"That's purrfectly meowtastic!",
"lol, internet",
"Let me take a byte out of that catnip.",
"Meow.",
"MEOW!",
"This computer is now Alice-certified!"
}

SMODS.Joker {
key = 'alice',
loc_txt = {
    name = 'Alice Reverie',
    text = {
        '{C:cry_code}Codes {C:planet}level up',
        '{C:attention}all hands 3 times{} when used or sold',
        ' ',
        "{C:cry_code,E:1}#1#",
        "{C:cry_code,E:1}#2#",
        faceart('ThreeCubed')
    }
},
fusable = true,
wee_incompatible = true,
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
atlas = 'jenalice',
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.gods() and "Huh. What's th1s-c0d3" or "Hiii :3!!! This place is purrfect", Jen.gods() and "-d0-00111111-" or "for some shenanigans!"}}
end,
calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Code' then
        local quota = (context.consumeable:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + (quota*3)
        if jl.njr(context) then
            card:speak(alice_blurbs, G.C.SET.Code)
            card:apply_cumulative_levels()
        end
        return nil, true
    elseif context.selling_card and not context.selling_self and context.card.ability.set == 'Code' then
        local quota = (context.card:getEvalQty())
        card.cumulative_lvs = (card.cumulative_lvs or 0) + (quota*3)
        if jl.njr(context) then
            card:speak(alice_blurbs, G.C.SET.Code)
            card:apply_cumulative_levels()
        end
        return nil, true
    end
end
}

local granddad_palette = {
HEX('155fd9'),
HEX('ff8170'),
HEX('ffffff'),
HEX('6c0700')
}

function Card:grand_dad()
Q(function() self:juice_up(0.5, 0.5) return true end)
local rnd = math.random(6)
local obj = self.edition or {}
play_sound_q('jen_grand' .. rnd, obj.jen_wee and Jen.config.wee_sizemod or obj.jen_jumbo and (1/Jen.config.wee_sizemod) or 1, 0.5)
card_status_text(self, rnd == 2 and 'Flintstones?!' or rnd == 6 and 'Gruhh- Dad!' or 'Grand Dad!', nil, 0.05*self.T.h, granddad_palette[math.random(#granddad_palette)], 0.6, 0.6, nil, nil, 'bm')
end

SMODS.Joker {
key = '7granddad',
loc_txt = {
    name = '7 GRAND DAD',
    text = {
        'This Joker has a {C:jen_RGB,E:1}strange reaction',
        'to scored {C:attention}7{}s',
        ' ',
        "{C:inactive,E:1}PUSH START BUTTON !",
        "{C:inactive,E:1}1992    1",
        faceart('jenwalter666'),
        origin('Vinesauce')
    }
},
config = {},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
misc_badge = annoying,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
wee_incompatible = true,
atlas = 'jen7granddad',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.shopslots}}
end,
add_to_deck = function(self, card, from_debuff)
    card:grand_dad()
end,
remove_from_deck = function(self, card, from_debuff)
    card:grand_dad()
end,
calculate = function(self, card, context)
    if context.cardarea == G.play then
        if context.other_card and context.other_card:get_id() == 7 and jl.scj(context) then
            card:grand_dad()
            local palette = granddad_palette[math.random(#granddad_palette)]
            local rnd = pseudorandom(pseudoseed('granddad'), 1, 7)
            if rnd == 1 then
                return {
                    message = '+777',
                    chips = 777,
                    colour = palette,
                    card = card
                }, true
            elseif rnd == 2 then
                return {
                    message = '+777 Mult',
                    mult = 777,
                    colour = palette,
                    card = card
                }, true
            elseif rnd == 3 then
                return {
                    message = '+$7',
                    dollars = 7,
                    colour = palette,
                    card = card
                }, true
            elseif rnd == 4 then
                return {
                    message = 'x7',
                    x_chips = 7,
                    colour = palette,
                    card = card
                }, true
            elseif rnd == 5 then
                return {
                    message = 'x7 Mult',
                    x_mult = 7,
                    colour = palette,
                    card = card
                }, true
            elseif rnd == 6 then
                return {
                    message = '^1.77',
                    e_chips = 1.77,
                    colour = palette,
                    card = card
                }, true
            else
                return {
                    message = '^1.77 Mult',
                    e_mult = 1.77,
                    colour = palette,
                    card = card
                }, true
            end
        end
    end
end
}

SMODS.Joker {
key = 'gamingchair',
loc_txt = {
    name = '{C:jen_RGB}Gaming Chair',
    text = {
        '{C:red}Fixed {C:green}60% chance{} to {C:attention}immediately defeat',
        '{C:attention}Blinds{} when starting a round',
        ' ',
        lore('Get a good gaming chair.'),
        faceart('jenwalter666')
    }
},
config = {},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 250,
rarity = 'jen_wondrous',
misc_badge = gaming,
unique = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
debuff_immune = true,
immutable = true,
wee_incompatible = true,
atlas = 'jengamingchair',
calculate = function(self, card, context)
    if not context.blueprint_card and jl.njr(context) and context.setting_blind then
        if jl.chance('gamingchair', 1.6666666666666666666666666666667, true) then
            card:speak('Good Gaming Chair!', G.C.jen_RGB)
            Q(function()
                Q(function()
                    Q(function()
                        update_operator_display_custom(' ', G.C.WHITE)
                        jl.hcm('Gaming', 'Chair')
                        Q(function()
                            G.GAME.chips = G.GAME.blind.chips
                            G.STATE = G.STATES.HAND_PLAYED
                            G.STATE_COMPLETE = true
                            end_round()
                        return true end)
                        delay(3)
                        jl.ch()
                        update_operator_display()
                    return true end)
                return true end)
            return true end)
        end
    end
end
}

local nyx_maxenergy = 5

SMODS.Joker {
key = 'nyx',
loc_txt = {
    name = 'Nyx Equinox',
    text = {
        '{X:inactive}Energy{} : {C:attention}#1#{C:inactive} / ' .. tostring(nyx_maxenergy) .. '',
        'Selling a {C:attention}Joker {C:inactive}(excluding this one){} or {C:attention}consumable{} will',
        '{C:attention}create a new random one{} of the {C:attention}same type/rarity',
        '{C:inactive}(Does not require slots, but may overflow, retains edition)',
        '{C:inactive}(Does not work on jokers better than Exotic)',
        '{C:inactive,s:1.35}(Currently {C:attention,s:1.35}#2#{C:inactive,s:1.35})',
        ' ',
        'Recharges {C:attention}' .. math.ceil(nyx_maxenergy/3) .. ' energy{} at',
        'the end of every {C:attention}round',
        ' ',
        "{C:inactive,s:1.2,E:1}#3#",
        faceart('ThreeCubed'),
        origin('Pokémon')
    }
},
config = {extra = {energy = nyx_maxenergy}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 250,
fusable = true,
unique = true,
debuff_immune = true,
rarity = 'jen_wondrous',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
wee_incompatible = true,
atlas = 'jennyx',
abilitycard = 'c_jen_nyx_c',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.energy, (G.GAME or {}).nyx_enabled and 'ENABLED' or 'DISABLED', Jen.gods() and "Give me-... the marble. I-I've... earned it." or "Don't you wanna seem like you're divine?"}}
end,
calculate = function(self, card, context)
    if not context.individual and not context.repetition and not card.debuff and context.end_of_round and not context.blueprint then
        card.ability.extra.energy = math.min(card.ability.extra.energy + math.ceil(nyx_maxenergy/3), nyx_maxenergy)
        card_status_text(card, card.ability.extra.energy .. '/' .. nyx_maxenergy, nil, 0.05*card.T.h, G.C.GREEN, 0.6, 0.6, nil, nil, 'bm', 'generic1')
    elseif context.selling_card and not context.selling_self then
        if (G.GAME or {}).nyx_enabled then
            if card.ability.extra.energy > 0 then
                local c = context.card
                local RARE = c:gc().rarity or 1
                local legendary = false
                if RARE == 1 then
                    RARE = 0
                elseif RARE == 2 then
                    RARE = 0.9
                elseif RARE == 3 then
                    RARE = 0.99
                elseif RARE == 4 then
                    RARE = nil
                    legendary = true
                end
                local valid = c.ability.set ~= 'Joker' or not Jen.overpowered(RARE)
                if not c:gc().immune_to_nyx and valid and not c.playing_card then
                    local new = 'n/a'
                    local AREA = c.area
                    if c.ability.set == 'Joker' then
                        new = create_card(c.ability.set, AREA, legendary, RARE, nil, nil, nil, 'nyx_replacement')
                    else
                        new = create_card(c.ability.set, AREA, nil, nil, nil, nil, nil, 'nyx_replacement')
                    end
                    if c.ability.set == 'Booster' and new.ability.set ~= 'Booster' then
                        new:set_ability(jl.rnd('paragon_booster_equilibrium', nil, G.P_CENTER_POOLS.Booster), true, nil)
                    end
                    if c.edition then
                        new:set_edition(c.edition)
                    end
                    if c.ability.set ~= 'Joker' and c:getQty() > 1 then
                        new:setQty(c:getQty())
                        new:create_stack_display()
                    end
                    Q(function()
                        new:add_to_deck()
                        AREA:emplace(new)
                    return true end)
                    if jl.njr(context) and not context.blueprint then
                        Q(function()
                            card.ability.extra.energy = card.ability.extra.energy - 1
                            card_status_text(card, card.ability.extra.energy .. '/' .. nyx_maxenergy, nil, 0.05*card.T.h, G.C.FILTER, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                        return true end)
                    end
                    return nil, true
                end
            elseif jl.njr(context) then
                card_status_text(card, 'No energy!', nil, 0.05*card.T.h, G.C.RED, 0.6, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
            end
        end
    end
end
}

SMODS.Joker {
key = 'watto',
loc_txt = {
    name = 'Watto',
    text = {
        '{C:money}Selling{} a card adds a {C:attention}hundredth',
        'of its value to this Joker\'s {X:jen_RGB,C:white,s:1.5}^^Mult',
        '{C:inactive}(Currently {X:jen_RGB,C:white,s:1.5}^^#1#{C:inactive})',
        ' ',
        '{C:inactive,s:2,E:1}That\'s a dub.',
        faceart('jenwalter666'),
        origin('Star Wars'),
        '{C:cry_ascendant,E:1}https://www.youtube.com/@AutoWatto'
    }
},
config = {big_num_scaler = true, tetmult = 0},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
misc_badge = youtube,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenwatto',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.tetmult + 1}}
end,
calculate = function(self, card, context)
    if context.selling_card and context.card ~= card then
        card.ability.tetmult = card.ability.tetmult + (context.card.sell_cost/100)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = '^^' .. number_format(card.ability.tetmult + 1) .. ' Mult', colour = G.C.FILTER})
        return nil, true
    elseif context.cardarea == G.jokers and context.joker_main then
        local num = 1 + (card.ability.tetmult)
        if num > 1 then
            return {
                message = '^^' .. num .. ' Mult',
                colour = G.C.jen_RGB,
                EEmult_mod = num,
                card = card
            }
        end
    end
end
}

SMODS.Joker {
key = 'survivor',
loc_txt = {
    name = 'The Survivor',
    text = {
        '{C:planet}Levels up{} the {C:attention}lowest level poker hand',
        'by the {C:attention}sum of your remaining',
        '{C:blue}hands {C:attention}and {C:red}discards{} at',
        'the {C:attention}end of the round',
        '{C:inactive}(Prioritises lower-ranking hands)',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jensurvivor',
calculate = function(self, card, context)
    if not context.individual and not context.repetition and not card.debuff and context.end_of_round then
        card.cumulative_lvs = (card.cumulative_lvs or 0) + (G.GAME.current_round.hands_left + G.GAME.current_round.discards_left)
        if jl.njr(context) then
            card:apply_cumulative_levels(jl.lowhand())
        end
        return nil, true
    end
end
}

SMODS.Joker {
key = 'monk',
loc_txt = {
    name = 'The Monk',
    text = {
        '{C:attention}Retrigger{} scored cards,',
        "using the {C:attention}card's rank",
        'as the {C:attention}number of times to retrigger',
        '{C:inactive}(ex. 9 = 9 times, Jack = 11 times, Ace = 14 times, etc.)',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
longful = true,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
unique = true,
wee_incompatible = true,
atlas = 'jenmonk',
calculate = function(self, card, context)
    if context.repetition then
        if context.cardarea == G.play then
            if context.other_card and context.other_card.ability.name ~= 'Stone Card' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = context.other_card:get_id(),
                    colour = G.C.ORANGE,
                    card = card
                }, true
            end
        end
    end
end
}

local hunter_prizes = { 'c_jen_solace', 'c_jen_sorrow', 'c_jen_singularity', 'c_jen_pandemonium', 'c_jen_spectacle' }

local hunter_thresholds = { 10, 7, 5, 3, 1 }

SMODS.Joker {
key = 'hunter',
loc_txt = {
    name = 'The Hunter',
    text = {
        'Whenever {C:blue}current hands{} are below your {C:blue}maximum hands{},',
        '{C:attention}refill{} your {C:blue}hands{} to the maximum',
        '{C:red,s,E:1}Succumbs to the Rot after #1#',
        'When this Joker {C:red}dies to the Rot{},',
        '{C:attention}create random {C:spectral}Spirits',
        'equal to the {C:attention}cumulative number of',
        '{C:blue}hands{} that this Joker has replenished',
        '{C:inactive}(Currently #2#)',
        '{C:inactive}(Selling this card at 7 rounds remaining creates Rot, but gives {C:red}no rewards{C:inactive})',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
config = {rounds_left = 10, hands_replenished = 0},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 20,
rarity = 4,
no_doe = true,
no_mysterious = true,
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
wee_incompatible = true,
jumbo_mod = 3,
atlas = 'jenhunter',
loc_vars = function(self, info_queue, center)
    return {vars = {tostring(center.ability.rounds_left) .. ' round' .. ((math.abs(center.ability.rounds_left) > 1 or math.abs(center.ability.rounds_left) == 0) and 's' or '') .. (center.ability.rounds_left <= 0 and '...?' or ''), center.ability.hands_replenished}}
end,
update = function(self, card, front)
    if card.added_to_deck and card.children.center and card.children.floating_sprite then
        for k, v in ipairs(hunter_thresholds) do
            if card.ability.rounds_left <= v then
                card.children.center:set_sprite_pos({x = 0, y = k - 1})
                card.children.floating_sprite:set_sprite_pos({x = 1, y = k - 1})
            else
                break
            end
        end
    end
end,
calculate = function(self, card, context)
    if not context.blueprint then
        if context.selling_self and card.ability.rounds_left < 8 then
            card:flip()
            card:juice_up(2, 0.8)
            card_status_text(card, 'Dead!', nil, 0.05*card.T.h, G.C.BLACK, 2, 0, 0, nil, 'bm', 'jen_gore6')
            Q(function()
                local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jen_rot', 'hunter_rot_death')
                card2:add_to_deck()
                G.jokers:emplace(card2)
                card:set_eternal(nil)
                card2:set_eternal(true)
                play_sound('jen_gore5')
                return true end
            )
        elseif not context.individual and not context.repetition and not context.retrigger_joker then
            if G.GAME.round_resets.hands <= 0 then G.GAME.round_resets.hands = 1 end
            if not card.hunter_prep then
                card.hunter_prep = true
                Q(function()
                    Q(function()
                        card.hunter_prep = nil
                        if G.GAME.current_round.hands_left < G.GAME.round_resets.hands then
                            card.ability.hands_replenished = (card.ability.hands_replenished or 0) + (G.GAME.round_resets.hands - G.GAME.current_round.hands_left)
                            ease_hands_played(G.GAME.round_resets.hands - G.GAME.current_round.hands_left)
                        end
                    return true end)
                return true end)
            end
            if context.end_of_round then
                card.hunter_prep = nil
                card.ability.rounds_left = card.ability.rounds_left - 1
                local rl = card.ability.rounds_left
                card_status_text(card, tostring(card.ability.rounds_left), nil, nil, G.C.RED, nil, nil, nil, nil, nil, 'generic1')	
                if rl > 7 then
                    card:juice_up(0.6, 0.1)
                elseif rl > 5 then
                    if rl == 7 then
                        play_sound_q('jen_gore1')
                    end
                    card:juice_up(0.6, 0.1)
                elseif rl > 3 then
                    if rl == 5 then
                        play_sound_q('jen_gore3')
                    end
                    card:juice_up(0.6, 0.1)
                elseif rl > 1 then
                    if rl == 3 then
                        play_sound_q('jen_gore8')
                    end
                    card:juice_up(0.6, 0.1)
                    play_sound_q('jen_heartbeat')
                elseif rl > 0 then
                    if rl == 1 then
                        play_sound_q('jen_gore4')
                    end
                    card:juice_up(1.8, 0.3)
                    play_sound_q('jen_heartbeat')
                else
                    card:juice_up(2, 0.8)
                    play_sound_q('jen_heartbeat')
                    local rolls = math.min(5, math.ceil(math.abs(rl) / 3)) + 2
                    local DELAY = 360
                    local DELAY_OFFSET = 0
                    local CHANCE = math.max(15, 40.1 - (math.abs(rl) / 10))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            if DELAY <= 0 then
                                if jl.chance('hunter_rot', CHANCE) then
                                    card:flip()
                                    card:juice_up(2, 0.8)
                                    card_status_text(card, 'Dead!', nil, 0.05*card.T.h, G.C.BLACK, 2, 0, 0, nil, 'bm', 'jen_gore6')
                                    G.E_MANAGER:add_event(Event({
                                        func = function()
                                            local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jen_rot', 'hunter_rot_death')
                                            card2:add_to_deck()
                                            G.jokers:emplace(card2)
                                            card:set_eternal(nil)
                                            card2:set_eternal(true)
                                            play_sound('jen_gore5')
                                            return true
                                        end
                                    }))
                                    for i = 1, card.ability.hands_replenished do
                                        Q(function()
                                            local card3 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, pseudorandom_element(hunter_prizes, pseudoseed('hunter_prizecards')), 'hunter_prizecard')
                                            card3:add_to_deck()
                                            G.consumeables:emplace(card3)
                                            return true
                                        end, 0.1)
                                    end
                                    Q(function() card:start_dissolve() return true end, 1)
                                    rolls = 0
                                    DELAY = 360
                                else
                                    if rolls == 1 then
                                        card:juice_up(0.6, 0.1)
                                        card_status_text(card, localize('k_safe_ex'), nil, 0.05*card.T.h, G.C.FILTER, math.min(1.5, 0.8 + (rolls / 10)), 0, 0, nil, 'bm', 'generic1')
                                    else
                                        card:juice_up(rolls/10, rolls/60)
                                        card_status_text(card, '...', nil, 0.05*card.T.h, G.C.RED, math.min(1.5, 0.8 + (rolls / 10)), 0, 0, nil, 'bm', 'jen_heartbeat')
                                    end
                                    rolls = rolls - 1
                                    DELAY_OFFSET = DELAY_OFFSET + 30
                                    DELAY = 360 + DELAY_OFFSET
                                end
                            else
                                DELAY = DELAY - ((math.log(G.SETTINGS.GAMESPEED)+1)^2)
                            end
                        return rolls <= 0 and DELAY <= 0
                    end} ))
                end
            end
        end
    end
end
}

SMODS.Joker {
key = 'gourmand',
loc_txt = {
    name = 'The Gourmand',
    text = {
        'Retrigger the {C:attention}leftmost{} and',
        '{C:attention}rightmost{} Jokers {C:attention}#1#{} times',
        '{C:inactive,s:0.6}(Retriggers 2nd left/rightmost joker instead if 1st is debuffed)',
        ' ',
        lore('He\'s a pretty fat boy.'),
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
config = {extra = {absolute_unit = 25}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
jumbo_mod = 3,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jengourmand',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.absolute_unit}}
end,
calculate = function(self, card, context)
    if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
        if context.other_card == (G.jokers.cards[1].debuff and G.jokers.cards[2] or G.jokers.cards[1]) or context.other_card == ((G.jokers.cards[#G.jokers.cards].debuff and G.jokers.cards[#G.jokers.cards - 1]) and G.jokers.cards[#G.jokers.cards - 1] or G.jokers.cards[#G.jokers.cards]) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.absolute_unit,
                card = card
            }
        else
            return nil, true
        end
    end
end
}

SMODS.Joker {
key = 'rivulet',
loc_txt = {
    name = 'The Rivulet',
    text = {
        'Retrigger {C:attention}all Jokers{}, using its {C:attention}order {C:inactive}(left-to-right)',
        'in the Joker tray as the {C:attention}number of times to retrigger',
        '{C:inactive}(ex. retrigger leftmost joker 1 time, next joker 2 times, one after 3 times, etc.)',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
unique = true,
wee_incompatible = true,
atlas = 'jenrivulet',
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
            local retrigger_amount = to_big(0)
            for i = 1, #G.jokers.cards do
                if context.other_card == G.jokers.cards[i] then
                    retrigger_amount = i
                end
            end
            if context.other_card == G.jokers.cards[retrigger_amount] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = retrigger_amount,
                    card = card
                }
            else
                return nil, true
            end
        end
    end
}

local max_karma = 10

SMODS.Joker {
key = 'saint',
loc_txt = {
    name = 'The Saint',
    text = {
        '{C:spectral}Gateway{} will {C:attention}not destroy Jokers{} when used',
        'After using {C:attention}' .. tostring(max_karma) .. ' {C:spectral}Gateways{}, {C:jen_RGB}attune{} this Joker',
        '{C:inactive,s:1.5}[{C:attention,s:1.5}#1#{C:inactive,s:1.5}/' .. tostring(max_karma) .. ']',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
config = {extra = {karma = 0}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 20,
rarity = 4,
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
wee_incompatible = true,
atlas = 'jensaint',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.karma}}
end,
calculate = function(self, card, context)
    if not context.blueprint and jl.njr(context) and context.using_consumeable and context.consumeable and context.consumeable:gc().key == 'c_cry_gateway' then
        if context.consumeable._saint_karma_done then return nil, true end
        context.consumeable._saint_karma_done = true
        local quota = context.consumeable:getEvalQty()
        card.ability.extra.karma = card.ability.extra.karma + quota
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = '+' .. quota .. ' Karma', colour = G.C.PALE_GREEN})
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = (tostring(card.ability.extra.karma) .. ' / ' .. tostring(max_karma)), colour = G.C.GREEN})
        if card.ability.extra.karma >= max_karma then
            card_status_text(card, '!!!', nil, 0.05*card.T.h, G.C.DARK_EDITION, 0.6, 0.6, 2, 2, 'bm', 'jen_enlightened')
            G.E_MANAGER:add_event(Event({
                delay = 0.1,
                func = function()
                    card:flip()
                    play_sound('card1')
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                delay = 1,
                func = function()
                    card:flip()
                    card:juice_up(1, 1)
                    play_sound('card1')
                    card:set_ability(G.P_CENTERS['j_jen_saint_attuned'])
                    return true
                end
            }))
        end
    end
end
}

SMODS.Joker {
key = 'saint_attuned',
loc_txt = {
    name = 'The Saint {C:jen_RGB}(Attuned)',
    text = {
        '{C:spectral}Gateway{} will {C:attention}not destroy Jokers{} when used',
        '{C:cry_ascendant}Yawetag{} also has {C:attention}no negative effect{} when used',
        '{X:black,C:red,s:3}^^^3{C:purple} Chips & Mult',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 2, y = 0 },
cost = 100,
rarity = 'jen_transcendent',
unlocked = true,
discovered = true,
no_doe = true,
immutable = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jensaint',
calculate = function(self, card, context)
    if context.joker_main then
        return {
            message = '^^^3 Chips & Mult',
            EEEmult_mod = 3,
            EEEchip_mod = 3,
            colour = G.C.BLACK,
            card = card
        }, true
    end
end
}

local totalownedcards_areastocheck = {
'hand',
'jokers',
'consumeables',
'deck',
'discard',
'play'
}

local function totalownedcards()
local amnt = 0
for k, v in pairs(totalownedcards_areastocheck) do
    if G[v] and G[v].cards then
        if G[v] == (G.consumeables or {}) then
            for kk, vv in pairs(G[v].cards) do
                amnt = amnt + vv:getQty()
            end
        else
            amnt = amnt + #G[v].cards
        end
    end
end
return amnt
end

SMODS.Joker {
key = 'artificer',
loc_txt = {
    name = 'The Artificer',
    text = {
        "Grants the {C:green}ability{} to {C:red}destroy",
        "selected {C:attention}playing cards",
        "in exchange for {C:attention}varying benefits/upgrades",
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
wee_incompatible = true,
unique = true,
atlas = 'jenartificer',
abilitycard = 'c_jen_artificer_c',
}

SMODS.Joker {
key = 'rot',
loc_txt = {
    name = 'The Rot',
    text = {
        'Clogs up your Joker slots',
        '{C:attention}Duplicates itself{} at the end of every {C:attention}Ante',
        ' ',
        '{C:inactive,s:1.25,E:1}*Better get rid of it before it starts killing your framerate...*',
        faceart('jenwalter666'),
        origin('Rain World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 1,
rarity = 'jen_junk',
no_mysterious = true,
no_doe = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
debuff_immune = true,
wee_incompatible = true,
edition_immune = 'negative',
atlas = 'jenrot',
calculate = function(self, card, context)
    if not context.individual and not context.repetition and not card.debuff and context.end_of_round and not context.blueprint and G.GAME.blind.boss and not (G.GAME.blind.config and G.GAME.blind.config.bonus) then
        local rot = copy_card(card)
        rot:add_to_deck()
        G.jokers:emplace(rot)
    end
end
}

local crimbo_quotes = {
normal = {
    'Can you see as well as the one without eyes?',
    'I could take him.',
    'Do you think that the clouds have silver thoughts?'
},
gods = {
    'I understand, though I won\'t like it.',
    'Could I convince you otherwise?'
},
fuse = {
    'I guess not.',
    'This is terrible.'
}
}

SMODS.Joker {
key = 'crimbo',
loc_txt = {
    name = '{C:jen_RGB}Crimbo',
    text = {
        'All cards currently in hand',
        '{C:attention}also contribute to scoring',
        '{C:inactive,s:0.8}(Cards in played hand score in order first, then hand cards in order)',
        ' ',
        '{C:inactive,E:1}#1#',
        faceart('CrimboJimbo')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 20,
rarity = 4,
fusable = true,
misc_badge = {
    colour = G.C.CRY_ASCENDANT,
    text_colour = G.C.EDITION,
    text = {
        'Ko-Fi Juggernaut',
        'CrimboJimbo',
        '£600+ Donated'
    }
},
unique = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
wee_incompatible = true,
atlas = 'jencrimbo',
loc_vars = function(self, info_queue, center)
    return {vars = {Jen.gods() and crimbo_quotes.gods[math.random(#crimbo_quotes.gods)] or crimbo_quotes.normal[math.random(#crimbo_quotes.normal)]}}
end,
}

function add_crimbo_cards(scoring_hand)
if not (G.GAME.blind and G.GAME.blind.name == "The Card" and not G.GAME.blind.disabled) and (next(SMODS.find_card('j_jen_crimbo')) or next(SMODS.find_card('j_jen_faceless'))) then
    for i = 1, #G.hand.cards do
        if not G.hand.cards[i]:gc().unhighlightable then
            table.insert(scoring_hand, G.hand.cards[i])
        end
    end
end
if not (G.GAME.blind and G.GAME.blind.name == "The Card" and not G.GAME.blind.disabled) and next(SMODS.find_card('j_jen_faceless')) then
    for i = 1, #G.deck.cards do
        if not G.deck.cards[i]:gc().unhighlightable then
            table.insert(scoring_hand, G.deck.cards[i])
        end
    end
end
end

function is_scoring_area(area)
if area == G.play then return true end
if next(SMODS.find_card('j_jen_crimbo')) then
    return area == G.hand
end
if next(SMODS.find_card('j_jen_faceless')) then
    return area == G.hand or area == G.deck
end
end

SMODS.Joker {
key = 'jimbo',
loc_txt = {
    name = '{C:chips}J{C:attention}imb{C:mult}o',
    text = {
        '{C:mult}+444,444,444{}, {X:mult,C:white}x44,444,444{},',
        '{X:mult,C:dark_edition}^4,444,444{}, {X:jen_RGB,C:white}^^444,444{},',
        '{X:black,C:red}^^^44,444{} and {X:black,C:purple}^^^^4,444{} Mult',
        '{C:inactive,s:0.7,E:1}Hey, buddy! I figured I might as well hop in and have fun!',
        faceart('LocalThunk'),
        origin('Balatro')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 888888,
rarity = 'jen_transcendent',
no_doe = true,
misc_badge = secret,
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
immutable = true,
debuff_immune = true,
wee_incompatible = true,
atlas = 'jenjimbo',
calculate = function(self, card, context)
    if context.joker_main then
        if not context.retrigger_joker then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Hee-hee!', colour = G.C.CHIPS})
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Hoo-hoo!', colour = G.C.MULT})
        end
        return {
            message = 'Haa-haa!',
            mult_mod = 444444444,
            Xmult_mod = 44444444,
            Emult_mod = 4444444,
            EEmult_mod = 444444,
            EEEmult_mod = 44444,
            hypermult_mod = {4, 4444},
            colour = G.C.FILTER,
            card = card
        }, true
    end
end
}

SMODS.Joker {
key = 'dandy',
loc_txt = {
    name = '{C:red}Dand{C:attention}icus {C:money}"Dan{C:green}dy" {C:spectral}Danc{C:tarot}ifer',
    text = {
        '{C:attention}All cards and Jokers{} are',
        '{C:attention}immune{} to debuffs {C:attention}whatsoever',
        ' ',
        "{C:inactive,E:1}*The star of the show at Gardenview Center!*",
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
config = {},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 13,
rarity = 'cry_epic',
unique = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
debuff_immune = true,
wee_incompatible = true,
atlas = 'jendandy'
}

local function voucherscount()
if not G.GAME.used_vouchers then return 0 end
local count = 0
for k, v in pairs(G.GAME.used_vouchers) do
    if v then
        count = count + 1
    end
end
return count
end

SMODS.Joker {
key = 'betmma',
loc_txt = {
    name = 'Betmma',
    text = {
        '{X:jen_RGB,C:white,s:1.5}+^^#1#{C:mult} Mult{} for every {C:attention}unique Voucher redeemed',
        '{C:inactive}(Currently {X:jen_RGB,C:white,s:1.5}^^#2#{C:inactive})',
        ' ',
        "{C:inactive,s:1.5,E:1}It's time for redemption.",
        faceart('jenwalter666')
    }
},
config = {big_num_scaler = true, extra = {tet = 0.1}},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
blueprint_compat = true,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenbetmma',
loc_vars = function(self, info_queue, center)
    local qty = voucherscount()
    return {vars = {center.ability.extra.tet, 1 + (qty * center.ability.extra.tet)}}
end,
calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        local vouchers = voucherscount()
        if vouchers > 0 then
            local num = 1 + (vouchers*card.ability.extra.tet)
            return {
                message = '^^' .. number_format(num) .. ' Mult',
                colour = G.C.jen_RGB,
                EEmult_mod = num,
                card = card
            }, true
        end
    end
end
}

SMODS.Joker {
key = 'boxten',
loc_txt = {
    name = '{C:tarot}Boxten',
    text = {
        '{C:attention}Retrigger{} every Joker {C:attention}#1#{} time(s)',
        'Increases by {C:attention}1{} whenever a {C:attention}10{} scores',
        ' ',
        "{C:inactive,s:0.9,E:1}*The key on the back of his head tends to spin when he\'s focused or thinking.*",
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
config = {retrig = 1},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 250,
rarity = 'jen_wondrous',
wee_incompatible = true,
dangerous = true,
unlocked = true,
discovered = true,
immutable = true,
unique = true,
debuff_immune = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jenboxten',
loc_vars = function(self, info_queue, center)
    return {vars = {math.floor(center.ability.retrig)}}
end,
calculate = function(self, card, context)
    if not context.blueprint_card then
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card:gc().key ~= 'j_jen_boxten' then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.retrig,
                card = card
            }
        elseif jl.njr(context) and context.cardarea == G.play and jl.scj(context) then
            if context.other_card and context.other_card:get_id() == 10 then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = '+1 Retrigger', colour = G.C.FILTER})
                card.ability.retrig = card.ability.retrig + 1
            end
        end
    end
end
}

SMODS.Joker {
key = 'goob_lefthand',
loc_txt = {
    name = "Goob's {C:mult}Left Hand",
    text = {
        '{C:red}Discard{} all cards to the {C:attention}left',
        'of this card when {C:attention}playing a hand',
        'No effect if on the right side of the right hand',
        ' ',
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 0,
rarity = 'jen_miscellaneous',
wee_incompatible = true,
no_doe = true,
no_mysterious = true,
unlocked = true,
discovered = true,
immutable = true,
unique = true,
uncopyable = true,
debuff_immune = true,
unhighlightable = true,
unchangeable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jengoob_lefthand'
}

goob_blurbs = {
addtohand = {
    'Free hugs!',
    'Gorsh!',
    "It's time for hugs!",
    "Come here! Hehehe!",
    "Yyyoop!",
    "Hu-hahahahaha!",
    "Hehehehehe!"
},
hug = {
    "Get over here! Teeheehee!",
    "Huuuuug!",
    "Never hugged cards before!",
    "Group hug!",
    "Let's cuddle!",
    "Hugs!",
    "Let me turn that frown upside down!",
    "Hugs are the best medicine to a frown!",
},
play = {
    "Sorry, coming through!",
    "Excuse me!",
    "Need to make space!",
    "Sorry, cards!",
    "This way, please!",
    "Swoop!",
    "This is fun!",
    "Cleaning it up!",
    "Don't worry, I'm gentle!",
    "Pardon me!",
    "I apologise!",
    "We need other cards!",
    "I'm sure Scraps will look after those cards!",
    "Don't worry Goob, it's just cards...",
    "Silly me!"
},
discard = {
    "How about... this?",
    "Maybe this!",
    "Nope, this one!",
    "Thiiiiis!",
    "How's this fit on you?",
    "Like makeup for paper!",
    "Even cards need to dress to impress!",
    "This is getting better and better!",
    "Hmm...! What would Scraps choose?",
    "This one!",
    "Curvy...!",
    "I like it when it looks perfect!",
    "Let's try this!",
    "This?",
    "Nope, another one...",
    "Nah, this one!",
    "Hmmm...",
    "Decisions, decisions...",
    "I did Scraps's makeup, but this is hard!",
    "Oops, maybe this one..."
},
hands_lost = {
    "Oof!",
    "D'aaooww!",
    "Aaagh!",
    "My hands!",
    "Owww!",
    "Aaoowww!",
    "AAAAA-hoo-hoo-hooiee!",
    "Geeeoowwwch!"
}
}

SMODS.Joker {
key = 'goob',
loc_txt = {
    name = '{C:chips,s:1.21}G{C:mult,s:0.79}o{C:chips,s:1.3}o{C:mult,s:0.9}b',
    text = {
        'After drawing the {C:attention}first hand{}, this Joker',
        'adds his {C:chips}h{C:mult}a{C:chips}n{C:mult}d{C:chips}s',
        'to your hand which you can use to {C:green}randomise{} or {C:red}discard',
        'cards based on the {C:attention}arrangement{} of them in hand',
        'At the {C:attention}end of round{},',
        'the cards {C:attention}inbetween this Joker\'s {C:chips}h{C:mult}a{C:chips}n{C:mult}d{C:chips}s',
        'will {C:planet}upgrade your poker hands{} based on what poker hands',
        '{C:attention}could be made{} with those cards from {C:attention}all the possible choices',
        ' ',
        lore('He\'s a goofy goober; one who shows the kids that'),
        lore('hugs are one of the best medicines for a frown!'),
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
config = {active = false, missinghands = false},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 12,
rarity = 'cry_epic',
unlocked = true,
discovered = true,
experimental = true,
longful = true,
immutable = true,
debuff_immune = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immune_to_vermillion = true,
unique = true,
atlas = 'jengoob',
update = function(self, card, front)
    if card.added_to_deck then
        if card.children.floating_sprite and card.children.center then
            if ((G.GAME or {}).blind or {}).in_blind and card.ability.active then
                card.children.center:set_sprite_pos({x = 0, y = 0})
                card.children.floating_sprite:set_sprite_pos({x = 2, y = 0})
            else
                card.children.center:set_sprite_pos({x = 0, y = 0})
                card.children.floating_sprite:set_sprite_pos({x = 1, y = 0})
            end
        end
    end
end,
remove_from_deck = function(self, card, from_debuff)
    if not from_debuff and #SMODS.find_card('j_jen_goob', true) <= 1 then
        local leftie = jl.fc('j_jen_goob_lefthand', 'all')
        if leftie then leftie:destroy() end
        local rightie = jl.fc('j_jen_goob_righthand', 'all')
        if rightie then rightie:destroy() end
    end
end,
calculate = function(self, card, context)
    if not context.blueprint and jl.njr(context) then
        -- Pre-play behavior: discard cards to the left of the left hand when play is pressed
        if context.press_play and card.ability.active then
            local lh = jl.fc and jl.fc('j_jen_goob_lefthand', 'hand') or nil
            if lh and G and G.hand and G.hand.cards then
                local did_discard = false
                for i = 1, #G.hand.cards do
                    local tar = G.hand.cards[i]
                    if tar then
                        if tar == lh then
                            break
                        else
                            if not tar.highlighted and tar:xpos() < lh:xpos() then
                                if not did_discard then
                                    did_discard = true
                                    if goob_blurbs and goob_blurbs.discard then
                                        card:speak(goob_blurbs.discard, G.C.RED)
                                    end
                                end
                                draw_card(G.hand, G.discard, 100, 'down', false, tar)
                                Q(function()
                                    play_sound('tarot1')
                                    if lh.juice_up then lh:juice_up(0.5, 0.8) end
                                return true end)
                            end
                        end
                    end
                end
            end
        end
        if context.setting_blind and not Jen.goob_busy then
            Jen.goob_busy = true
            local leftie = jl.fc('j_jen_goob_lefthand', 'all')
            if leftie then leftie:destroy() end
            local rightie = jl.fc('j_jen_goob_righthand', 'all')
            if rightie then rightie:destroy() end
            card:speak(goob_blurbs.addtohand, G.C.CRY_BLOSSOM)
            Q(function()
                local lefthand = create_playing_card(nil, G.hand, nil, i ~= 1, {G.C.CHIPS})
                lefthand:set_ability(G.P_CENTERS['j_jen_goob_lefthand'], true, nil)
                local righthand = create_playing_card(nil, G.hand, nil, i ~= 1, {G.C.MULT})
                righthand:set_ability(G.P_CENTERS['j_jen_goob_righthand'], true, nil)
                Jen.goob_busy = nil
                Q(function() save_run() return true end)
            return true end)
        end
        if not context.jen_adding_card then
            local lh = jl.fc('j_jen_goob_lefthand', 'all') or {}
            local rh = jl.fc('j_jen_goob_righthand', 'all') or {}
            local lhih = (lh.area or {}) == G.hand
            local rhih = (rh.area or {}) == G.hand
            if next(lh) and next(rh) and lhih and rhih then
                if context.pre_discard and card.ability.active then
                    local to_randomise = {}
                    for i = 1, #G.hand.cards do
                        local tar = G.hand.cards[i]
                        if tar then
                            if not tar.highlighted and tar ~= rh and tar:xpos() > rh:xpos() then
                                table.insert(to_randomise, tar)
                            end
                        end
                    end
                    if #to_randomise > 0 then
                        card:speak(goob_blurbs.discard, G.C.BLUE)
                        delay(0.5)
                        Q(function()
                            rh:juice_up(0.5, 0.8)
                            play_sound('tarot1')
                        return true end)
                    end
                    jl.randomise(to_randomise)
                end
                if not context.individual and not context.repetition and context.end_of_round then
                    card:speak(goob_blurbs.hug, G.C.CRY_BLOSSOM)
                    local hugging = {}
                    for i = 1, #G.hand.cards do
                        local tar = G.hand.cards[i]
                        if tar then
                            if tar ~= lh and tar ~= rh and tar:xpos() > lh:xpos() and tar:xpos() < rh:xpos() then
                                table.insert(hugging, tar)
                            elseif tar == rh then
                                break
                            end
                        end
                    end
                    local hands = evaluate_poker_hand(hugging)
                    if hands then
                        for k, v in pairs(hands) do
                            if G.GAME.hands[k] and next(v) then
                                for i = 1, #v do
                                    for ii = 1, #v[i] do
                                        if type(v[i][ii].highlight) == 'function' then
                                            Q(function()
                                                v[i][ii]:highlight(true)
                                                play_sound('card3')
                                            return true end, .9)
                                        end
                                    end
                                end
                                delay(0.5)
                                jl.th(k)
                                for i = 1, #v do
                                    for ii = 1, #v[i] do
                                        if type(v[i][ii].highlight) == 'function' then
                                            local lvmod = (v[i][ii]:norankorsuit() and 0.01 or ((v[i][ii].base.id or 2)/100))
                                            v[i][ii]:do_jen_astronomy(k, lvmod)
                                            Q(function() if v[i][ii] then v[i][ii]:juice_up(0.5, 0.8) end return true end)
                                            fastlv(v[i][ii], k, nil, lvmod)
                                        end
                                    end
                                end
                                delay(0.5)
                                for i = 1, #v do
                                    for ii = 1, #v[i] do
                                        if type(v[i][ii].highlight) == 'function' then
                                            Q(function()
                                                v[i][ii]:highlight(false)
                                                play_sound('card3', 0.8)
                                            return true end, .9)
                                        end
                                    end
                                end
                            end
                        end
                        jl.ch()
                    end
                end
            end
        end
    end
end
}

SMODS.Joker {
key = 'goob_righthand',
loc_txt = {
    name = "Goob's {C:chips}Right Hand",
    text = {
        '{C:blue}Randomise{} all cards to the {C:attention}right',
        'of this card when {C:attention}discarding',
        'No effect if on the left side of the left hand',
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 0,
rarity = 'jen_miscellaneous',
wee_incompatible = true,
no_doe = true,
no_mysterious = true,
unlocked = true,
discovered = true,
immutable = true,
unique = true,
uncopyable = true,
debuff_immune = true,
unhighlightable = true,
unchangeable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
atlas = 'jengoob_righthand'
}

local rd_blurbs = {
razzle = {
    active = {
        "It's my turn!",
        "Oh, it's time to shine!",
        "Let's gooo!",
        "Smile!",
        "Let's get the show on the road!",
        "I'm ready!",
        "Oh, I'm so in!"
    },
    trigger = {
        "Oh, what fun!",
        "Onto the next one!",
        "Teehee!",
        "Talk about a checkmate!",
        "I'm having so much fun!",
        "More!",
        "Hahahaha!",
        "I'm the mask of comedy for a reason!"
    }
},
dazzle = {
    active = {
        "...",
        "Oh... it's my turn, now?",
        "... Oh dear...",
        "Oh, no...",
        "Sigh...",
        "Is now the best time...?",
        "I never asked for this..."
    },
    trigger = {
        "Oh, the misery...",
        "Why...?",
        "Please, make it stop...!",
        "There's more...?",
        "Do I have to...?",
        "Hhm...",
        "When is it over? The tragedy..."
    }
}
}

SMODS.Joker {
key = 'razzledazzle',
loc_txt = {
    name = 'Razzle {C:inactive}& {C:black}Dazzle',
    text = {
        '{C:attention}Oscillates{} between {C:attention}Razzle{} or {C:attention}Dazzle{} at the {C:attention}end of shop',
        '{X:inactive}==Razzle==',
        '{X:red,C:white}x2{C:red} discards{}, {C:hearts}L{C:diamonds}i{C:hearts}g{C:diamonds}h{C:hearts}t{} suits give {X:mult,C:white}x3{} Mult',
        '{C:spectral}Solace{} will give {X:blue,C:white}twice{} as many {C:blue}hands{} when used',
        '{X:black,C:white}==Dazzle==',
        '{X:blue,C:white}x2{C:blue} hands{}, {C:spades}D{C:clubs}a{C:spades}r{C:clubs}k{} suits give {X:chips,C:white}x3{} Chips',
        '{C:spectral}Sorrow{} will give {X:red,C:white}thrice{} as many {C:red}discards{} when used',
        lore('Despite their contrasting personalities,'),
        lore('they can relate to one another very well!'),
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
config = {curmode = 'none'},
wee_incompatible = true,
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
unique = true,
atlas = 'jenrazzledazzle',
update = function(self, card, front)
    if card.added_to_deck and card.ability and card.ability.curmode and card.children and card.children.center and card.children.floating_sprite then
        if card.ability.curmode == 'razzle' then
            card.children.center:set_sprite_pos({x = 0, y = 1})
            card.children.floating_sprite:set_sprite_pos({x = 1, y = 1})
        elseif card.ability.curmode == 'dazzle' then
            card.children.center:set_sprite_pos({x = 0, y = 2})
            card.children.floating_sprite:set_sprite_pos({x = 1, y = 2})
        elseif card.ability.curmode ~= 'razzle' then
            card.children.center:set_sprite_pos({x = 0, y = 0})
            card.children.floating_sprite:set_sprite_pos({x = 1, y = 0})
        end
    end
end,
calculate = function(self, card, context)
    if not context.blueprint then
        if jl.njr(context) then
            if context.ending_shop then
                if card.ability.curmode == 'none' or card.ability.curmode == 'dazzle' then
                    card.ability.curmode = 'razzle'
                    card:speak(rd_blurbs.razzle.active, G.C.WHITE)
                    Q(function() card:juice_up(1, 1) play_sound('jen_e_ink',1,0.7) return true end)
                elseif card.ability.curmode == 'razzle' then
                    card.ability.curmode = 'dazzle'
                    card:speak(rd_blurbs.dazzle.active, G.C.BLACK)
                    Q(function() card:juice_up(1, 1) play_sound('negative',1,0.7) return true end)
                end
            elseif context.setting_blind then
                if card.ability.curmode == 'razzle' then
                    card:speak('x2 Discards', G.C.RED)
                    ease_discard(G.GAME.round_resets.discards)
                elseif card.ability.curmode == 'dazzle' then
                    card:speak('x2 Hands', G.C.BLUE)
                    ease_hands_played(G.GAME.round_resets.hands)
                end
            end
            if context.using_consumeable and context.consumeable then
                local key = context.consumeable:gc().key
                if card.ability.curmode == 'razzle' then
                    if key == 'c_jen_solace' then
                        card:speak(rd_blurbs.razzle.trigger, G.C.WHITE)
                        G.GAME.round_resets.hands = G.GAME.round_resets.hands + (context.consumeable.ability.extra.add * context.consumeable:getEvalQty())
                        ease_hands_played(context.consumeable.ability.extra.add * context.consumeable:getEvalQty())
                    end
                elseif card.ability.curmode == 'dazzle' then
                    if key == 'c_jen_sorrow' then
                        card:speak(rd_blurbs.dazzle.trigger, G.C.BLACK)
                        G.GAME.round_resets.discards = G.GAME.round_resets.discards + (context.consumeable.ability.extra.add * 2 * context.consumeable:getEvalQty())
                        ease_discard(context.consumeable.ability.extra.add * 2 * context.consumeable:getEvalQty())
                    end
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            if card.ability.curmode == 'razzle' and (context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds')) then
                return {
                    x_mult = (context.other_card:is_suit('Hearts') and context.other_card:is_suit('Diamonds')) and 9 or 3,
                    colour = G.C.WHITE,
                    card = card
                }, true
            elseif card.ability.curmode == 'dazzle' and (context.other_card:is_suit('Clubs') or context.other_card:is_suit('Spades')) then
                return {
                    x_chips = (context.other_card:is_suit('Clubs') and context.other_card:is_suit('Spades')) and 9 or 3,
                    colour = G.C.BLACK,
                    card = card
                }, true
            end
        end
    end
end
}

function manage_level_colour(level, force)
local new_colour = G.C.WHITE
level = to_big(level)
if not G.C.HAND_LEVELS[number_format(level)] or force then 
    if level >= to_big(1e300) ^ 16 then
        new_colour = G.C.jen_RGB
    elseif level >= to_big(1e200) ^ 8 then
        new_colour = G.C.CRY_ASCENDANT
    elseif level >= to_big(1e150) ^ 4 then
        new_colour = G.C.CRY_VERDANT
    elseif level >= to_big(1e110) ^ 2 then
        new_colour = G.C.CRY_TWILIGHT
    elseif level >= to_big(1e75) ^ 1.5 then
        new_colour = G.C.CRY_EMBER
    elseif level >= to_big(1e40) ^ 1.25 then
        new_colour = G.C.CRY_AZURE
    elseif level >= to_big(1e30) ^ 1.125 then
        new_colour = G.C.CRY_BLOSSOM
    elseif level >= to_big(1e20) then
        new_colour = G.C.CRY_EXOTIC
    elseif level >= to_big(1e10) then
        new_colour = G.C.EDITION
    elseif level > to_big(7200) then
        new_colour = G.C.DARK_EDITION
    elseif level >= to_big(1) then
        local lv_num = to_number(level)
        local r, g, b = hsv(0.05 * lv_num, 0.05 * math.ceil(lv_num / 360), 1)
        local r2, g2, b2 = hsv(0.05 * lv_num, 0.05 * math.ceil(lv_num / 360), 0.05 * math.ceil(lv_num / 360))
        new_colour = {r, b, g, 1}
        if not G.C.HAND_LEVELS['!' .. number_format(level)] then G.C.HAND_LEVELS['!' .. number_format(level)] = {r2, b2, g2, 1} end
    end
    G.C.HAND_LEVELS[number_format(level)] = new_colour
end
if #G.C.HAND_LEVELS > 1e4 and G.GAME then
    local colours_still_in_use = {}
    for k, v in pairs(G.GAME.hands) do
        local str = number_format(to_big(v.level))
        if G.C.HAND_LEVELS[str] then
            colours_still_in_use[str] = true
        end
    end
    for k, v in pairs(G.GAME.ranks) do
        local str = number_format(to_big(v.level))
        if G.C.HAND_LEVELS[str] then
            colours_still_in_use[str] = true
        end
    end
    for k, v in pairs(G.GAME.suits) do
        local str = number_format(to_big(v.level))
        if G.C.HAND_LEVELS[str] then
            colours_still_in_use[str] = true
        end
    end
    for k, v in pairs(G.C.HAND_LEVELS) do
        if not colours_still_in_use[k] and k ~= '0' and k ~= '1' and k ~= '2' and k ~= '3' and k ~= '4' and k ~= '5' and k ~= '6' and k ~= '7' then
            G.C.HAND_LEVELS[k] = nil
        end
    end
end
return new_colour
end

local a13_sum = {}

local lusr = level_up_suit

function level_up_suit(card, suit, instant, amount, dontautoclear)
amount = to_big(amount or 1)
if not instant then
    jl.h(localize(suit, 'suits_plural'), G.GAME.suits[suit].chips, G.GAME.suits[suit].mult, G.GAME.suits[suit].level)
end
if lusr then lusr(card, suit, instant, amount) end
G.GAME.suits[suit].level = math.max(G.GAME.suits[suit].level + amount, 0)
G.GAME.suits[suit].chips = math.max(G.GAME.suits[suit].chips + (G.GAME.suits[suit].l_chips * amount), 0)
G.GAME.suits[suit].mult = math.max(G.GAME.suits[suit].mult + (G.GAME.suits[suit].l_mult * amount), 0)
manage_level_colour(G.GAME.suits[suit].level)
if amount > to_big(0) then
    add_malice(15 * amount)
end
if not instant then
    if (G.SETTINGS.FASTFORWARD or 0) > 0 then
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end, 0.2, nil, 'after')
        jl.h(localize(suit, 'suits_plural'), G.GAME.suits[suit].chips, G.GAME.suits[suit].mult, G.GAME.suits[suit].level, true)
    else
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end, 0.2, nil, 'after')
        jl.hm(G.GAME.suits[suit].mult, true)
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            return true
        end, 0.9, nil, 'after')
        jl.hc(G.GAME.suits[suit].chips, true)
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = nil
            return true
        end, 0.9, nil, 'after')
        jl.hlv(G.GAME.suits[suit].level)
    end
    delay(1.3)
    if not dontautoclear then jl.ch() end
end
end

local lurr = level_up_rank

function level_up_rank(card, rank, instant, amount, dontautoclear)
amount = to_big(amount or 1)
if not instant then
    jl.h(rank .. 's', G.GAME.ranks[rank].chips, G.GAME.ranks[rank].mult, G.GAME.ranks[rank].level)
end
if lurr then lurr(card, rank, instant, amount) end
G.GAME.ranks[rank].level = math.max(G.GAME.ranks[rank].level + amount, 0)
G.GAME.ranks[rank].chips = math.max(G.GAME.ranks[rank].chips + (G.GAME.ranks[rank].l_chips * amount), 0)
G.GAME.ranks[rank].mult = math.max(G.GAME.ranks[rank].mult + (G.GAME.ranks[rank].l_mult * amount), 0)
manage_level_colour(G.GAME.ranks[rank].level)
if amount > to_big(0) then
    add_malice(15 * amount)
end
if not instant then
    if (G.SETTINGS.FASTFORWARD or 0) > 0 then
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end, 0.2, nil, 'after')
        jl.h(rank .. 's', G.GAME.ranks[rank].chips, G.GAME.ranks[rank].mult, G.GAME.ranks[rank].level, true)
    else
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end, 0.2, nil, 'after')
        jl.hm(G.GAME.ranks[rank].mult, true)
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            return true
        end, 0.9, nil, 'after')
        jl.hc(G.GAME.ranks[rank].chips, true)
        Q(function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = nil
            return true
        end, 0.9, nil, 'after')
        jl.hlv(G.GAME.ranks[rank].level)
    end
    delay(1.3)
    if not dontautoclear then jl.ch() end
end
end

-- Store reference to original level_up_hand function before we override it
local luhr = _G.level_up_hand
function level_up_hand(card, hand, instant, amount, no_astronomy, no_astronomy_omega, no_jokers)
amount = to_big(amount)

-- Performance optimization: Skip expensive operations when called from Black Hole
local is_black_hole_call = (card and card.ability and card.ability.name == 'Black Hole') or 
                           (G.GAME and G.GAME._black_hole_processing)

if not no_astronomy and to_big(amount) > to_big(0) and not is_black_hole_call then
        if Jen.hv('astronomy', 9) then
            amount = amount * 5
        elseif Jen.hv('astronomy', 8) then
            amount = amount * 2
        end
    end
if to_big(amount) > to_big(0) and not is_black_hole_call then
    if #SMODS.find_card('j_jen_guilduryn') > 0 and hand ~= jl.favhand() then
        for k, v in ipairs(G.jokers.cards) do
            if (G.SETTINGS.STATUSTEXT or 0) < 1 and v.gc and v:gc().key == 'j_jen_guilduryn' then
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = 'Redirected!', colour = G.C.MONEY})
                break
            end
        end
        hand = jl.favhand()
        if not instant then
            jl.th(hand)
        end
    end
end
luhr(card, hand, instant, amount)
if to_big(amount) > to_big(0) and not is_black_hole_call then
    add_malice(25 * amount)
end
manage_level_colour(G.GAME.hands[hand].level)
if not no_jokers and not is_black_hole_call then
    jl.jokers({jen_lving = true, lvs = amount, lv_hand = hand, lv_instant = instant, card = card})
end
if to_big(amount) < to_big(0) and Jen.hv('astronomy', 11) and not no_astronomy and not is_black_hole_call then
        local refund = math.abs(amount) / 4
        local fav = jl.favhand()
        if Jen.config.verbose_astronomicon then jl.th(fav) end
        fastlv(card, fav, not Jen.config.verbose_astronomicon, refund, true)
    end
    if to_big(amount) > to_big(0) and Jen.hv('astronomy', 12) and not no_astronomy and not is_black_hole_call then
        local dividend = amount / 10
        local fav = jl.favhand()
        if Jen.config.verbose_astronomicon then jl.th(fav) end
        fastlv(card, fav, not Jen.config.verbose_astronomicon, dividend, true)
    end
    if Jen.hv('astronomy', 13) and to_big(amount) >= to_big(1) and not no_astronomy_omega and not is_black_hole_call then
        local pos = jl.handpos(hand)
        --local edi = ((card or {}).edition or {}).key or 'e_base'
        --if edi == 'e_negative' then edi = 'e_base' end
        --if not a13_sum[edi] then a13_sum[edi] = {} end
        if G.handlist[pos + 1] then
            --if not astronomyomega_cumulative[G.handlist[pos + 1]] then astronomyomega_cumulative[G.handlist[pos + 1]] = 0 end
            if Jen.config.verbose_astronomicon_omega then jl.th(G.handlist[pos + 1]) end
            fastlv(card, G.handlist[pos + 1], not Jen.config.verbose_astronomicon_omega, amount / 2, true)
        end
    end
--[[if card then
    if card.base then
        if card.base.value and G.GAME.ranks[card.base.value] and card.base.suit and G.GAME.suits[card.base.suit] then
            level_up_rank(card, card.base.value, instant, amount, true, true)
            level_up_suit(card, card.base.suit, instant, amount, true)
        end
    end
end]]
end

local astro_blurbs = {
'*Yawn*...',
'Good night...',
'Sweet dreams...',
"If only it wasn't so noisy around here...",
'My nap will have to wait...',
'Nap time...',
'Nap time... I think?',
'So tired...',
'Bed time.'
}

SMODS.Joker {
key = 'astro',
loc_txt = {
    name = '{C:cry_twilight}Astro',
    text = {
        '{C:planet}Hand level-ups{} have an {C:green}initial #1#% chance{} to {C:attention}repeat',
        'Repetitions {C:attention}continue until the chance fails',
        'Repetition chance decreases by {C:red}' .. Jen.config.astro.decrement * 100 .. '%{} per success,',
        '{C:attention}resets to initial chance{} after failure',
        'Using {C:attention}non-{C:dark_edition}Negative {C:planet}Neutron Stars{}, {C:red}visibly leveling down hands',
        'or {C:attention}applying editions to hands with {C:planet}Planets{} increases the {C:green}initial chance{} by {C:attention}+' .. Jen.config.astro.increment * 100 .. '%{}, up to a {C:attention}maximum of 100%',
        'If {C:green}initial chance{} is {C:attention}100%{}, the decrease on repetition chance is {C:attention}reduced to ' .. Jen.config.astro.decrement * 50 .. '%',
        '{C:inactive,s:0.8}(Chance upgrades and repetition processes are retriggerable)',
        '{C:inactive,s:0.8}(Chance decrease is ' .. Jen.config.astro.retrigger_mod .. 'x stronger during retriggers)',
        '{C:inactive,s:0.8}(Unaffected by probability alterations, ex. Oops! All 6s)',
        ' ',
        "{C:inactive,s:0.9,E:1}*Dandy's closest friend! ...Right?*",
        faceart('jenwalter666'),
        origin('Dandy\'s World')
    }
},
config = {neutrons = 0, maxed = false},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 50,
rarity = 'cry_exotic',
dangerous = true,
unlocked = true,
discovered = true,
immutable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
unique = true,
wee_incompatible = true,
atlas = 'jenastro',
loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.maxed and 100 or ((Jen.config.astro.initial + (Jen.config.astro.increment * center.ability.neutrons)) * 100)}}
end,
calculate = function(self, card, context)
    if not context.blueprint_card and not context.destroying_card and not context.cry_ease_dollars and not context.post_trigger then
        if context.jen_lving and context.card then
            if not card.ability.maxed and to_big(context.lvs) < to_big(0) and not context.lv_instant then
                if (G.SETTINGS.STATUSTEXT or 0) < 1 then  card:speak(localize('k_upgrade_ex'), G.C.CRY_ASCENDANT) end
                card.ability.neutrons = card.ability.neutrons - context.lvs
                if to_big((Jen.config.astro.initial + (Jen.config.astro.increment * card.ability.neutrons))) >= to_big(1) then
                    card.ability.maxed = true
                    card_status_text(card, 'Maxed out!', nil, 0.05*card.T.h, G.C.EDITION, 0.6, 0.6, 2, 2, 'bm', 'jen_enlightened')
                end
                return nil, true
            elseif not context.card.astro_in_effect then
                context.card.astro_in_effect = true
                local odds = math.min(1, card.ability.maxed and 1 or (Jen.config.astro.initial + (Jen.config.astro.increment * card.ability.neutrons)))
                if context.lvs and to_big(context.lvs) > to_big(0) then
                    local times = 0
                    local firstpass = false
                    if (G.SETTINGS.STATUSTEXT or 0) < 1 then 
                        if jl.njr(context) then 
                            card:speak(astro_blurbs, G.C.CRY_TWILIGHT)
                        else
                            card:speak(localize('k_again_ex'))
                        end
                    end
                    while true do
                        if odds >= 1 or (odds > 0 and jl.chance('astro_rng', 1/odds, true)) then
                            times = times + 1
                            odds = odds - ((Jen.config.astro.decrement / (card.ability.maxed and 2 or 1) * (context.retrigger_joker and Jen.config.astro.retrigger_mod or 1)))
                        else
                            if times > 0 then
                                if context.card and context.card.speak and (G.SETTINGS.STATUSTEXT or 0) < 1 then context.card:speak('x' .. times, G.C.CRY_TWILIGHT) else card:speak('x' .. times, G.C.CRY_TWILIGHT) end
                                level_up_hand(context.card, context.lv_hand, context.lv_instant, context.lvs * times, true, true, true)
                                add_malice(5 * context.lvs * times)
                            else
                                if context.card and context.card.speak and (G.SETTINGS.STATUSTEXT or 0) < 1 then context.card:speak(localize('k_nope_ex'), G.C.FILTER) else card:speak(localize('k_nope_ex'), G.C.FILTER) end
                            end
                            break
                        end
                    end
                end
                if not card.ability.maxed and context.card and context.card.gc and context.card:gc().set == 'Planet' and (context.card:gc().key == 'c_cry_nstar' or next((context.card.edition or {}))) and not (context.card.edition or {}).negative then
                    if (G.SETTINGS.STATUSTEXT or 0) < 1 then card:speak(localize('k_upgrade_ex'), G.C.CRY_ASCENDANT) end
                    card.ability.neutrons = card.ability.neutrons + context.card:getEvalQty()
                    if (Jen.config.astro.initial + (Jen.config.astro.increment * card.ability.neutrons)) >= 1 then
                        card.ability.maxed = true
                        card_status_text(card, 'Maxed out!', nil, 0.05*card.T.h, G.C.EDITION, 0.6, 0.6, 2, 2, 'bm', 'jen_enlightened')
                    end
                end
                context.card.astro_in_effect = nil
                return nil, true
            end
        end
    end
end
}

SMODS.Joker {
    key = 'godsmarble',
    loc_txt = {
        name = 'Godsmarble',
        text = {
            '{C:dark_edition,s:2.5,E:1}???',
            ' ',
            lore('An otherworldly artefact in CRAFTWORLD that exerts'),
            lore('incomprehensible levels of unbearable pain'),
            lore('to everything within a one kilometre radius'),
            lore('around itself, though it seems to be tame'),
            lore('towards a very few selection of beings,'),
            lore('like Kosmos or Jen Walter.'),
            faceart('jenwalter666'),
            origin('CRAFTWORLD')
        }
    },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    fusable = true,
    cost = 3,
    rarity = 3,
    cant_scare = true,
    unlocked = true,
    discovered = true,
    unique = true,
    debuff_immune = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    wee_incompatible = true,
    atlas = 'jengodsmarble',
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            ease_ante(1, true, true)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            ease_ante(-1, true, true)
        end
    end
}

SMODS.Joker {
    key = 'pawn',
    loc_txt = {
        name = '{C:green}The Pawn of Pandemonium',
        text = {
            '{C:clubs}Clubs{} give',
            jl.tetmult('#1#') .. ' Mult when scored',
            ' ',
            lore('See no evil.'),
            faceart('raidoesthings')
        }
    },
    config = {
        tet = 1.5
    },
    fusable = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenpawn',
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.tet
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Clubs') then
                return {
                    ee_mult = card.ability.tet,
                    colour = G.C.jen_RGB,
                    card = card
                }, true
            end
        end
    end
}

SMODS.Joker {
    key = 'knight',
    loc_txt = {
        name = '{C:money}The Knight of Starvation',
        text = {
            '{C:diamonds}Diamonds{} give',
            jl.tetmult('#1#') .. ' Mult when scored',
            ' ',
            lore('Speak no evil.'),
            faceart('raidoesthings')
        }
    },
    config = {
        tet = 1.5
    },
    fusable = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenknight',
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.tet
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Diamonds') then
                return {
                    ee_mult = card.ability.tet,
                    colour = G.C.jen_RGB,
                    card = card
                }, true
            end
        end
    end
}

SMODS.Joker {
    key = 'jester',
    loc_txt = {
        name = '{C:blue}The Jester of Epidemics',
        text = {
            '{C:spades}Spades{} give',
            jl.tetmult('#1#') .. ' Mult when scored',
            ' ',
            lore('Hear no evil.'),
            faceart('raidoesthings')
        }
    },
    config = {
        tet = 1.5
    },
    fusable = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenjester',
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.tet
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Spades') then
                return {
                    ee_mult = card.ability.tet,
                    colour = G.C.jen_RGB,
                    card = card
                }, true
            end
        end
    end
}

SMODS.Joker {
    key = 'arachnid',
    loc_txt = {
        name = '{C:tarot}The Arachnid of War',
        text = {
            '{C:hearts}Hearts{} give',
            jl.tetmult('#1#') .. ' Mult when scored',
            ' ',
            lore('Think no evil.'),
            faceart('raidoesthings')
        }
    },
    config = {
        tet = 1.5
    },
    fusable = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenarachnid',
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.tet
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') then
                return {
                    ee_mult = card.ability.tet,
                    colour = G.C.jen_RGB,
                    card = card
                }, true
            end
        end
    end
}

SMODS.Joker {
    key = 'reign',
    loc_txt = {
        name = '{C:dark_edition}The Reign of Regicide',
        text = {
            'All {C:attention}Jokers{} to the {C:green}left',
            'of this {C:attention}Joker{} become {C:purple}Eternal',
            'All {C:attention}Jokers{} to the {C:green}right',
            'of this {C:attention}Joker{} {C:red}lose{} {C:purple}Eternal',
            'Removes {C:blue}Perishable{}, {C:attention}Pinned{},',
            '{C:money}Rental{} and {C:red}Debuffs{} from all {C:attention}Jokers',
            '{C:dark_edition}+1e100{} Joker slots, {C:attention}retrigger{} all Jokers {C:attention}#1#{} times',
            '{C:inactive}(Stickers update whenever jokers are calculated)',
            ' ',
            '{C:inactive,s:1.25,E:1}Rule no evil.',
            faceart('raidoesthings')
        }
    },
    config = {
        extra = {
            special = 3
        }
    },
    fusable = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenreign',
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.extra.special
        }}
    end,
    calculate = function(self, card, context)
        if not context.blueprint and card.added_to_deck and not context.retrigger_joker_check and not context.retrigger_joker and G.jokers and G.jokers.cards then
            for i=1, #G.jokers.cards do
                local other_card = G.jokers.cards[i]
                if other_card and other_card ~= card then
                    if card.T.x + card.T.w/2 > other_card.T.x + other_card.T.w/2 then
                        other_card:set_eternal(true)
                    else
                        other_card:set_eternal(nil)
                    end
                    if other_card.ability then
                        other_card.ability.perishable = nil
                    end
                    other_card.debuff = nil
                    other_card:set_rental(nil)
                    other_card.pinned = nil
                end
            end
        end
        if context.retrigger_joker_check and not context.retrigger_joker then
            if context.other_card ~= card and context.other_card:gc().key ~= 'j_jen_kosmos' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.special,
                    card = card
                }
            end				
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit_before_reign = G.jokers.config.card_limit
        G.jokers.config.card_limit = 1e100
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = (G.jokers.config.card_limit_before_reign or 5)
    end
}

SMODS.Joker {
    key = 'feline',
    loc_txt = {
        name = '{C:blood}The Feline of Quietus',
        text = {
            '{C:attention}Face cards{} give',
            jl.tetmult('#1#') .. ' Mult when scored',
            ' ',
            lore('Do no evil.'),
            faceart('raidoesthings')
        }
    },
    config = {
        tet = 1.5
    },
    fusable = true,
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenfeline',
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.tet
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                    ee_mult = card.ability.tet,
                    colour = G.C.jen_RGB,
                    card = card
                }, true
            end
        end
    end
}

SMODS.Joker {
    key = 'fateeater',
    loc_txt = {
        name = 'The Fateeater of Grim Nights',
        text = {
            '{C:tarot}Tarot{} cards permanently add',
            'either {X:blue,C:white}x#1#{} or {C:blue}+#2# Chips',
            'to all {C:attention}playing cards{} when used',
            '{C:inactive}(Uses whichever one that gives the better upgrade)',
            'When any card reaches {C:attention}1e100 chips or more{},',
            '{C:red}reset it to zero{}, {C:planet}level up all hands #3# time(s)',
            'and create a {C:dark_edition}Negative {C:spectral}Soul',
            'Grants an {C:green}ability{} which {C:red}devours {C:tarot}Tarot{} cards',
            'to {C:attention}provide a random amount of',
            '{C:planet}levels{}, {C:chips}+Chips{}, {C:mult}+Mult{},',
            '{X:chips,C:white}xChips{}, {X:mult,C:white}xMult{},',
            '{X:dark_edition,C:chips}^Chips{} and {X:dark_edition,C:red}^Mult',
            'to {C:attention}every poker hand, scaling with {C:attention}Ante',
            ' ',
            '{C:inactive,s:1.25,E:1}Foretell no evil.',
            faceart('raidoesthings')
        }
    },
    config = {extra = {chips_additive = 100, chips_mult = 2, levelup = 10}},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenfateeater',
    abilitycard = 'c_jen_fateeater_c',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips_mult, center.ability.extra.chips_additive, center.ability.extra.levelup}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Tarot' and (#G.hand.cards > 0 or #G.deck.cards > 0) then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '...', colour = G.C.MULT})
            local e100cards = {}
            if #G.hand.cards > 0 then
                for k, v in pairs(G.hand.cards) do
                    if not v.ability.perma_bonus then v.ability.perma_bonus = 0 end
                    local res1 = 0
                    local res2 = 0
                    for i = 1, context.consumeable:getEvalQty() do
                        res1 = v.ability.perma_bonus * card.ability.extra.chips_mult
                        res2 = v.ability.perma_bonus + card.ability.extra.chips_additive
                        v.ability.perma_bonus = math.max(res1, res2)
                    end
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = '+' .. v.ability.perma_bonus, colour = G.C.CHIPS})
                    if v.ability.perma_bonus >= 1e100 then table.insert(e100cards, v) end
                end
            end
            if #G.deck.cards > 0 then
                for k, v in pairs(G.deck.cards) do
                    if not v.ability.perma_bonus then v.ability.perma_bonus = 0 end
                    local res1 = v.ability.perma_bonus * card.ability.extra.chips_mult
                    local res2 = v.ability.perma_bonus + card.ability.extra.chips_additive
                    v.ability.perma_bonus = math.max(res1, res2)
                    if v.ability.perma_bonus >= 1e100 then table.insert(e100cards, v) end
                end
            end
            local ecs = #e100cards
            if ecs > 0 then
                card_status_text(card, '!!!', nil, 0.05*card.T.h, G.C.DARK_EDITION, 0.6, 0.6, 2, 2, 'bm', 'jen_enlightened')
                jl.th('all')
                Q(function() play_sound('tarot1'); card:juice_up(0.8, 0.5); G.TAROT_INTERRUPT_PULSE = true; return true end, 0.2, nil, 'after')
                jl.hcm('+', '+', true)
                jl.hlv('+' .. number_format(card.ability.extra.levelup * ecs))
                delay(1.3)
                for k, v in pairs(G.GAME.hands) do
                    fastlv(v, k, true, card.ability.extra.levelup * ecs)
                end
                jl.ch()
                for k, v in pairs(e100cards) do
                    v.ability.perma_bonus = 0
                end
                Q(function()
                    local soul = jl.card('c_soul')
                    soul.no_forced_edition = true
                    soul:set_edition({negative = true})
                    soul.no_forced_edition = nil
                    soul:setQty(ecs)
                    if ecs > 1 then soul:create_stack_display() end
                    soul:set_cost()
                    soul:add_to_deck()
                    G.consumeables:emplace(soul)
                    return true
                end, 0.2, nil, 'after')
            end
            return nil, true
        end
    end
}

SMODS.Joker {
    key = 'foundry',
    loc_txt = {
        name = 'The Foundry of Armaments',
        text = {
            'Non-{C:dark_edition}editioned{} cards are',
            '{C:attention}given a random {C:dark_edition}Edition',
            '{C:inactive,s:0.8}(Some editions are excluded from the pool)',
            '{C:inactive,s:0.8}(UNO cards excluded)',
            'Grants an {C:green}ability{} which {C:red}smelts {C:spectral}Spectral{} cards',
            'to {C:attention}provide a random amount of',
            '{C:planet}levels{}, {C:chips}+Chips{}, {C:mult}+Mult{},',
            '{X:chips,C:white}xChips{}, {X:mult,C:white}xMult{},',
            '{X:dark_edition,C:chips}^Chips{} and {X:dark_edition,C:red}^Mult',
            'to {C:attention}every poker hand, scaling with {C:attention}Ante',
            ' ',
            '{C:inactive,s:1.25,E:1}Forge no evil.',
            faceart('raidoesthings')
        }
    },
    config = {},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenfoundry',
    abilitycard = 'c_jen_foundry_c'
}

SMODS.Joker {
    key = 'broken',
    loc_txt = {
        name = 'The Broken Collector of the Fragile',
        text = {
            '{C:attention}Doubles{} the values of',
            '{C:attention}all Jokers{} whenever',
            'a Joker that is {C:red}not {C:blue}Common{} or {C:green}Uncommon{} is {C:money}sold{},',
            'then {C:attention}retrigger all add-to-inventory effects{} of {C:attention}all Jokers',
            '{C:inactive}(Not all values can be doubled, not all Jokers can be affected)',
            'Grants an {C:green}ability{} which {C:red}shatters {C:planet}Planet{} cards',
            'to {C:attention}provide a random amount of',
            '{C:planet}levels{}, {C:chips}+Chips{}, {C:mult}+Mult{},',
            '{X:chips,C:white}xChips{}, {X:mult,C:white}xMult{},',
            '{X:dark_edition,C:chips}^Chips{} and {X:dark_edition,C:red}^Mult',
            'to {C:attention}every poker hand, scaling with {C:attention}Ante',
            ' ',
            '{C:inactive,s:1.25,E:1}Collect no evil.',
            faceart('raidoesthings')
        }
    },
    config = {},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 125,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenbroken',
    abilitycard = 'c_jen_broken_c',
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and context.card ~= card and context.card:gc().rarity ~= 1 and context.card:gc().rarity ~= 2 then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '...', colour = G.C.PURPLE})
            for k, v in pairs(G.jokers.cards) do
                if v ~= card and v ~= context.card then
                    if not v:gc().immutable then
                        v:remove_from_deck()
                        for a, b in pairs(v.ability) do
                            if a == 'extra' then
                                if type(v.ability.extra) == 'number' then
                                    v.ability.extra = v.ability.extra * 2
                                elseif type(v.ability.extra) == 'table' and next(v.ability.extra) then
                                    for c, d in pairs(v.ability.extra) do
                                        if type(d) == 'number' then
                                            v.ability.extra[c] = d * 2
                                        end
                                    end
                                end
                            elseif a ~= 'order' and type(b) == 'number' and ((a == 'x_mult' and b > 1) or b > 0 ) then
                                v.ability[a] = b * 2
                            end
                        end
                        v:add_to_deck()
                    end
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'paragon',
    loc_txt = {
        name = 'The {C:dark_edition}Paragon{} of {C:cry_epic}Darkness',
        text = {
            '{X:inactive}Energy{} : {C:attention}#1#{C:inactive} / ' .. tostring(nyx_maxenergy*3) .. '',
            'Selling a {C:attention}Joker {C:inactive}(excluding this one){} or {C:attention}consumable{} will',
            '{C:attention}create a new random one{} of the {C:attention}same type/rarity',
            '{C:inactive}(Does not require slots, but may overflow, retains edition)',
            '{C:inactive}(Does not work on fusions or jokers better than Exotic)',
            '{C:inactive,s:1.35}(Currently {C:attention,s:1.35}#2#{C:inactive,s:1.35})',
            ' ',
            'Recharges {C:attention}' .. math.ceil(nyx_maxenergy) .. ' energy{} at',
            'the end of every {C:attention}round',
            ' ',
            "{C:inactive,s:1.2,E:1}-Wo--r-sh-ip y--ou---r g--o-ddess---...",
            faceart('ThreeCubed')
        }
    },
    config = {extra = {energy = nyx_maxenergy * 3}},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 400,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    no_doe = true,
    unique = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenparagon',
    abilitycard = 'c_jen_nyx_c',
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.energy, (G.GAME or {}).nyx_enabled and 'ENABLED' or 'DISABLED'}}
    end,
    calculate = function(self, card, context)
        if not context.individual and not context.repetition and not card.debuff and context.end_of_round and not context.blueprint then
            card.ability.extra.energy = math.min(card.ability.extra.energy + nyx_maxenergy, nyx_maxenergy*3)
            card_status_text(card, card.ability.extra.energy .. '/' .. nyx_maxenergy*3, nil, 0.05*card.T.h, G.C.GREEN, 0.6, 0.6, nil, nil, 'bm', 'generic1')
        elseif context.selling_card and not context.selling_self then
            if (G.GAME or {}).nyx_enabled then
                if card.ability.extra.energy > 0 then
                    local c = context.card
                    local RARE = c:gc().rarity or 1
                    local legendary = false
                    if RARE == 1 then
                        RARE = 0
                    elseif RARE == 2 then
                        RARE = 0.9
                    elseif RARE == 3 then
                        RARE = 0.99
                    elseif RARE == 4 then
                        RARE = nil
                        legendary = true
                    end
                    local valid = c.ability.set ~= 'Joker' or not Jen.overpowered(RARE)
                    if not c:gc().immune_to_nyx and valid and not c.playing_card then
                        local new = 'n/a'
                        local AREA = c.area
                        if c.ability.set == 'Joker' then
                            new = create_card(c.ability.set, AREA, legendary, RARE, nil, nil, nil, 'nyx_replacement')
                        else
                            new = create_card(c.ability.set, AREA, nil, nil, nil, nil, nil, 'nyx_replacement')
                        end
                        if c.ability.set == 'Booster' and new.ability.set ~= 'Booster' then
                            new:set_ability(jl.rnd('paragon_booster_equilibrium', nil, G.P_CENTER_POOLS.Booster), true, nil)
                        end
                        if c.edition then
                            new:set_edition(c.edition)
                        end
                        if c.ability.set ~= 'Joker' and c:getQty() > 1 then
                            new:setQty(c:getQty())
                            new:create_stack_display()
                        end
                        Q(function()
                            new:add_to_deck()
                            AREA:emplace(new)
                        return true end)
                        if jl.njr(context) and not context.blueprint then
                            Q(function()
                                card.ability.extra.energy = card.ability.extra.energy - 1
                                card_status_text(card, card.ability.extra.energy .. '/' .. nyx_maxenergy, nil, 0.05*card.T.h, G.C.FILTER, 0.6, 0.6, nil, nil, 'bm', 'generic1')
                            return true end)
                        end
                        return nil, true
                    end
                elseif jl.njr(context) then
                    card_status_text(card, 'No energy!', nil, 0.05*card.T.h, G.C.RED, 0.6, 0.6, nil, nil, 'bm', 'cancel', 1, 0.9)
                end
            end
        end
    end
}

local astrophage_blurbs = {
    'M O R E . . .',
    'P O W E R   U P .',
    'A S C E N D .',
    'G L O R I O U S .',
    'S T R O N G E R . . .',
    "I   G R O W .",
    "S A V O U R   T H E   P O W E R .",
    'F U E L   T O   T H E   F I R E . . .',
    'C R U S H .',
    'A S S I M I L A T E .'
}

SMODS.Joker {
    key = 'astrophage',
    loc_txt = {
        name = 'The {C:planet}Astrophage{} of the {C:red}Other Side',
        text = {
            '{C:planet}Planets level up',
            '{C:attention}all hands 30 times',
            'when used or sold',
            'Whenever a {C:attention}non-{C:dark_edition}Negative{}, {C:attention}non-{C:planet}Planet',
            'consumable is used or sold,',
            'create {C:attention}5 {C:dark_edition}Negative {C:planet}Planet{} cards',
            'Poker hands gain {X:purple,C:edition}^2{C:chips} Chips{} & {C:mult}Mult{} when leveling up',
            mayoverflow,
            ' ',
            "{C:red,s:0.9,E:1}E X C E L L E N T .",
            faceart('HexaCryonic')
        }
    },
    config = {},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 250,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenastrophage',
    calculate = function(self, card, context)
        if not context.cry_ease_dollars and not context.post_trigger and context.jen_lving then
            if to_big(context.lvs) > to_big(0) then
                local modifier = to_big(2) ^ context.lvs
                G.GAME.hands[context.lv_hand].chips = to_big(G.GAME.hands[context.lv_hand].chips) ^ modifier
                G.GAME.hands[context.lv_hand].mult = to_big(G.GAME.hands[context.lv_hand].mult) ^ modifier
                delay(0.5)
                Q(function() card:juice_up(0.5, 0.5) return true end)
                play_sound_q('talisman_echip')
                play_sound_q('talisman_emult')
                jl.hcm('^' .. number_format(modifier), '^' .. number_format(modifier), true)
                if not context.lv_instant then jl.hcm(G.GAME.hands[context.lv_hand].chips, G.GAME.hands[context.lv_hand].mult) end
                delay(0.5)
            end
        end
        if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Planet' then
            local quota = (context.consumeable:getEvalQty())
            card.cumulative_lvs = (card.cumulative_lvs or 0) + (quota*30)
            if jl.njr(context) then
                card:speak(astrophage_blurbs, G.C.RED)
                card:apply_cumulative_levels()
            end
            return nil, true
        elseif context.selling_card and not context.selling_self and context.card.ability.set == 'Planet' then
            local quota = (context.card:getEvalQty())
            card.cumulative_lvs = (card.cumulative_lvs or 0) + (quota*30)
            if jl.njr(context) then
                card:speak(astrophage_blurbs, G.C.RED)
                card:apply_cumulative_levels()
            end
            return nil, true
        elseif context.using_consumeable or context.selling_card then
            local target = context.consumeable or context.card
            if not (target.edition or {}).negative and target.ability and target.ability.consumeable and target.ability.set ~= 'Planet' then
                if jl.njr(context) then
                    card:speak(astrophage_blurbs, G.C.RED)
                end
                for i = 1, 5 * target:getEvalQty() do
                    Q(function()
                        local new = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'astrophage_planet')
                        new.no_forced_edition = true
                        new:set_edition({negative = true}, true)
                        new.no_omega = true
                        new:add_to_deck()
                        G.consumeables:emplace(new)
                    return true end)
                end
            end
            return nil, true
        end
    end
}

local nexus_blurbs = {
    '01001000 01000101 01001100 01010000',
    '01000100 01001001 01000101',
    '01001011 01001001 01001100 01001100',
    '01000100 01000101 01000001 01010100 01001000',
    '01010011 01000001 01010100 01000001 01001110',
    '01011010 01000101 01010010 01001111',
    '01000001 01010011 01001000',
    '01001111 01010111 01001111',
    '01001101 01000101 01001111 01010111',
    '01000010 01001100 01001111 01001111 01000100',
    '01010000 01000001 01001001 01001110'
}

SMODS.Joker {
    key = 'nexus',
    loc_txt = {
        name = 'The {C:cry_code}Nexus{} of {C:spectral}Data',
        text = {
            '{C:cry_code}Codes {C:planet}level up',
            '{C:attention}all hands 30 times',
            'when used or sold',
            'Whenever a {C:attention}non-{C:dark_edition}Negative{}, {C:attention}non-{C:cry_code}Code',
            'consumable is used or sold,',
            'create {C:attention}5 {C:dark_edition}Negative {C:cry_code}Code{} cards',
            mayoverflow,
            ' ',
            "{C:cry_code,s:0.9,E:1}: 01 000 01 1 : 0 1010 1 00 : 83 : 010 1001 0 : 01 0 0110 0 :",
            faceart('ThreeCubed')
        }
    },
    config = {},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 250,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jennexus',
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Code' then
            local quota = (context.consumeable:getEvalQty())
            card.cumulative_lvs = (card.cumulative_lvs or 0) + (quota*30)
            if jl.njr(context) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = nexus_blurbs[math.random(#nexus_blurbs)], colour = G.C.SET.Code})
                card:apply_cumulative_levels()
            end
            return nil, true
        elseif context.selling_card and not context.selling_self and context.card.ability.set == 'Code' then
            local quota = (context.card:getEvalQty())
            card.cumulative_lvs = (card.cumulative_lvs or 0) + (quota*30)
            if jl.njr(context) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = nexus_blurbs[math.random(#nexus_blurbs)], colour = G.C.SET.Code})
                card:apply_cumulative_levels()
            end
            return nil, true
        elseif context.using_consumeable or context.selling_card then
            local target = context.consumeable or context.card
            if not (target.edition or {}).negative and target.ability and target.ability.consumeable and target.ability.set ~= 'Code' then
                if jl.njr(context) then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = nexus_blurbs[math.random(#nexus_blurbs)], colour = G.C.SET.Code})
                end
                for i = 1, 5 * target:getEvalQty() do
                    Q(function()
                        local new = create_card('Code', G.consumeables, nil, nil, nil, nil, nil, 'nexus_code')
                        new.no_forced_edition = true
                        new:set_edition({negative = true}, true)
                        new.no_omega = true
                        new:add_to_deck()
                        G.consumeables:emplace(new)
                    return true end)
                end
            end
            return nil, true
        end
    end
}

SMODS.Joker {
    key = 'bulwark',
    loc_txt = {
        name = 'The {C:edition}Bulwark{} of {C:inactive}The Unknown',
        text = {
            '{C:jen_RGB,E:1}Moire{}, {C:cry_exotic,E:1}Blood{} and {C:cry_exotic,E:1}Bloodfoil',
            'are {C:attention}250 times{} more likely to naturally appear',
            ' ',
            caption('#1#'),
            faceart('laviolive')
        }
    },
    config = {off_op = 0},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    drama = { x = 3, y = 0 },
    cost = 1e4,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenbulwark',
    loc_vars = function(self, info_queue, center)
        return {vars = {Jen.dramatic and 'I... what...?' or 'Leave this realm, for I do not wish to hurt you.'}}
    end
}

SMODS.Joker {
    key = 'faceless',
    loc_txt = {
        name = 'The {C:cry_ascendant}Faceless{} Tyrant',
        text = {
            '{C:attention}All playing cards{} contribute to scoring',
            'Cards in played hand that are already scoring will {C:attention}score twice',
            '{C:inactive}(Order : Scoring hand > Hand cards > Deck cards > Played hand)',
            ' ',
            caption('#1#'),
            faceart('CrimboJimbo')
        }
    },
    config = {off_op = 0},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    cost = 250,
    misc_badge = {
        colour = G.C.CRY_ASCENDANT,
        text_colour = G.C.EDITION,
        text = {
            'Ko-Fi Juggernaut',
            'CrimboJimbo',
            '£600+ Donated'
        }
    },
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenfaceless',
    loc_vars = function(self, info_queue, center)
        return {vars = {crimbo_quotes.fuse[math.random(#crimbo_quotes.fuse)]}}
    end
}

local charred_captions = {
    'Nothing... truly... lasts... forever.',
    'I will... char... you... down... to your... very... essence.',
    'You... did... this... to me... you... monster.',
    'Everything... will... succumb... to the... blazing... inferno.',
    'No... more... second... chances.',
    'Just... a... hollow... shell.',
    'Burn... them... all.'
}

SMODS.Joker {
    key = 'charred',
    loc_txt = {
        name = 'The Charred Cremator',
        text = {
            'Using a {C:attention}non-{C:dark_edition}Negative {C:jen_RGB,E:1}Omega {C:attention}consumable',
            'creates {C:attention}2 {C:dark_edition}Negative{} copies,',
            'a {C:attention}Booster{} and a {C:attention}Voucher',
            ' ',
            caption('#1#'),
            faceart('Maxie')
        }
    },
    misc_badge = {
        colour = G.C.almanac,
        text_colour = G.C.CRY_BLOSSOM,
        text = {
            'Bishop of Kosmos',
            'Maxie'
        }
    },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    --drama = { x = 3, y = 0 },
    cost = 1e3,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jencharred',
    loc_vars = function(self, info_queue, center)
        return {vars = {charred_captions[math.random(#charred_captions)]}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'jen_omegaconsumable' and context.consumeable:gc().key ~= 'c_jen_soul_omega' then
            local quota = (context.consumeable:getEvalQty())
            local card_key = context.consumeable:gc().key
            local isnegative = (context.consumeable.edition or {}).negative
            if not isnegative then
                if not card.cumulative_qtys then card.cumulative_qtys = {} end
                card.cumulative_qtys[card_key] = (card.cumulative_qtys[card_key] or 0) + quota
                if jl.njr(context) then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = '. . .', colour = G.C.CRY_EMBER})
                    Q(function()
                        Q(function()
                            if card then
                                if card.cumulative_qtys then
                                    for k, v in pairs(card.cumulative_qtys) do
                                        local duplicate = create_card('Spectral', G.consumeables, nil, nil, nil, nil, k, 'charred_negative')
                                        duplicate.no_forced_edition = true
                                        duplicate:set_edition({negative = true}, true)
                                        duplicate.no_forced_edition = nil
                                        duplicate:setQty(2 * (v or 1))
                                        duplicate:create_stack_display()
                                        duplicate:set_cost()
                                        duplicate.no_omega = true
                                        duplicate:add_to_deck()
                                        G.consumeables:emplace(duplicate)
                                    end
                                    card.cumulative_qtys = nil
                                end
                            end
                            return true
                        end, 0.2, nil, 'after')
                        return true
                    end, 0.2, nil, 'after')
                    Q(function()
                        if card then
                            local duplicate = create_card('Booster', G.consumeables, nil, nil, nil, nil, k, 'charred_pack')
                            if duplicate.gc and duplicate:gc().set ~= 'Booster' then
                                duplicate:set_ability(jl.rnd('charred_booster_equilibrium', nil, G.P_CENTER_POOLS.Booster), true, nil)
                                duplicate:set_cost()
                            end
                            duplicate:add_to_deck()
                            G.consumeables:emplace(duplicate)
                        end
                        return true
                    end, 0.2, nil, 'after')
                    Q(function()
                        if card then
                            local duplicate = create_card('Voucher', G.consumeables, nil, nil, nil, nil, k, 'charred_voucher')
                            if duplicate.gc and duplicate:gc().set ~= 'Voucher' then
                                duplicate:set_ability(jl.rnd('charred_voucher_equilibrium', nil, G.P_CENTER_POOLS.Voucher), true, nil)
                                duplicate:set_cost()
                            end
                            duplicate:add_to_deck()
                            G.consumeables:emplace(duplicate)
                        end
                        return true
                    end, 0.2, nil, 'after')
                end
                return nil, true
            end
        end
    end
}

local inhabited_quotes = {
normal = {
    "YOU WILL LOSE",
    "DON'T EVEN TRY",
    "WE WILL STOP YOU",
    "He glares at the blinds with conviction."
},
scared = {
    "...H-how are you doing t-that...?",
    "This is... unsettling...",
    "S-... So much power..."
}
}

SMODS.Joker {
    key = 'inhabited',
    loc_txt = {
        name = 'The {C:fuchsia}Inhabited {C:dark_edition}Storm{} of {C:edition}Paranormality',
        text = {
            '{C:attention}Steel{} cards give',
            '{X:almanac,C:edition,s:2.5}#1#(P+1){} Chips & Mult',
            'when scored',
            '{C:inactive}(P = order/position of card in played hand, max. 5)',
            '{C:inactive}(P equals 1 if card is not played)',
            "{C:cry_ascendant,s:1.5,E:1}#2#" .. caption('#3#') .. lore('#4#'),
            faceart('ocksie')
        }
    },
    misc_badge = {
        colour = G.C.almanac,
        text_colour = G.C.CRY_BLOSSOM,
        text = {
            'Bishop of Kosmos',
            'ocksie'
        }
    },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    drama = { x = 3, y = 0 },
    cost = 250,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jeninhabited',
    loc_vars = function(self, info_queue, center)
        local selection = Jen.dramatic and inhabited_quotes.scared[math.random(#inhabited_quotes.scared)] or inhabited_quotes.normal[math.random(#inhabited_quotes.normal)]
        return {vars = {'{P-1}', (Jen.config.show_captions and not (Jen.dramatic or selection == inhabited_quotes.normal[4])) and selection or '', Jen.dramatic and selection or '', (not Jen.dramatic and selection == inhabited_quotes.normal[4]) and selection or ''}}
    end,
    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if context.other_card.ability.name == 'Steel Card' then
                    local ORDER = 1
                    for k, v in ipairs(G.play.cards) do
                        if v == context.other_card then
                            ORDER = k
                            break
                        end
                    end
                    ORDER = math.min(ORDER, 5)
                    if ORDER == 1 then
                        return {
                            x_chips = 2,
                            x_mult = 2,
                            colour = G.C.PURPLE,
                            card = card
                        }, true
                    elseif ORDER == 2 then
                        return {
                            e_chips = 3,
                            e_mult = 3,
                            colour = G.C.PURPLE,
                            card = card
                        }, true
                    elseif ORDER == 3 then
                        return {
                            ee_chips = 4,
                            ee_mult = 4,
                            colour = G.C.PURPLE,
                            card = card
                        }, true
                    elseif ORDER == 4 then
                        return {
                            eee_chips = 5,
                            eee_mult = 5,
                            colour = G.C.PURPLE,
                            card = card
                        }, true
                    elseif ORDER >= 5 then
                        return {
                            hyper_chips = {ORDER - 1, ORDER + 1},
                            hyper_mult = {ORDER - 1, ORDER + 1},
                            colour = G.C.PURPLE,
                            card = card
                        }, true
                    end
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'cracked',
    loc_txt = {
        name = '{C:stone}The {C:darkstone}Cracked {C:stone}Misery',
        text = {
            '{C:attention}Stone{} cards give',
            'the {C:chips}Chips{} and {C:mult}Mult{} of',
            '{C:attention}all poker hands{} added together,',
            'then {X:jen_RGB,C:white}tetrate{} {C:chips}Chips{} and {C:mult}Mult',
            'by the {C:attention}sum of the levels{} of all poker hands plus one',
            "{C:inactive,E:1}#1#",
            faceart('ocksie')
        }
    },
    config = {},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    drama = { x = 3, y = 0 },
    cost = 50,
    rarity = 'jen_ritualistic',
    unlocked = true,
    discovered = true,
    no_doe = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jencracked',
    loc_vars = function(self, info_queue, center)
        return {vars = {'*Her eyes are looking around, as if she wants to say something...*'}}
    end,
    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if context.other_card.ability.name == 'Stone Card' then
                    local total_chips = to_big(0)
                    local total_mult = to_big(0)
                    local total_level = to_big(1)
                    for k, v in pairs(G.GAME.hands) do
                        total_chips = total_chips + to_big(v.chips)
                        total_mult = total_mult + to_big(v.mult)
                        total_level = total_level + to_big(v.level)
                    end
                    return {
                        chips = total_chips,
                        mult = total_mult,
                        ee_chips = total_level,
                        ee_mult = total_level,
                        colour = G.C.JOKER_GREY,
                        card = card
                    }, true
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'wondergeist',
    loc_txt = {
        name = 'Jen Walter the Wondergeist',
        text = {
            '{C:attention}Poker hands{} gain',
            '{X:jen_RGB,C:white,s:3}^^2{} Chips and Mult',
            'when leveled up',
            ' ',
            '{C:inactive,s:1.25,E:1}i feel... otherworldly...!',
            faceart('jenwalter666'),
            origin('CRAFTWORLD')
        }
    },
    config = {},
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    fusable = true,
    no_doe = true,
    cost = 5e5,
    unique = true,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    permaeternal = true,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenwondergeist',
    calculate = function(self, card, context)
        if not context.cry_ease_dollars and not context.post_trigger and context.jen_lving then
            if to_big(context.lvs) > to_big(0) then
                local iterations = math.min(1e3, to_number(context.lvs))
                jen_start_wg_job({
                    hand_key = context.lv_hand,
                    op = 2,
                    operand = 2,
                    iterations = iterations,
                    batch_size = 50, -- Increased from 25 for better performance
                    card = card,
                    lv_instant = context.lv_instant,
                    label = '^^2'
                })
                -- UI ping removed for performance optimization
                -- Q(function()
                -- 	card:juice_up(0.6, 0.8)
                -- 	card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'WG ^^2', colour = G.C.FILTER})
                -- 	play_sound('jen_misc1')
                -- return true end)
                -- totalling tracked per job key inside queue
            end
            return nil, true
        end
    end
}

SMODS.Joker {
    key = 'wondergeist2',
    loc_txt = {
        name = 'Jen Walter the Wondergeist {C:cry_ember}(Ascended)',
        text = {
            '{C:attention}Poker hands{} gain',
            '{X:black,C:red,s:4}^^^3{} Chips & Mult',
            'when leveled up',
            ' ',
            "{C:inactive,s:1.25,E:1}my body feels so... delicate, but strong at the same time...?",
            faceart('jenwalter666'),
            origin('CRAFTWORLD')
        }
    },
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
    no_doe = true,
    cost = 5e8,
    unique = true,
    rarity = 'jen_transcendent',
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    permaeternal = true,
    immutable = true,
    unique = true,
    debuff_immune = true,
    atlas = 'jenwondergeist2',
    calculate = function(self, card, context)
        if not context.cry_ease_dollars and not context.post_trigger and context.jen_lving then
            if to_big(context.lvs) > to_big(0) then
                local iterations = math.min(1e3, to_number(context.lvs))
                jen_start_wg_job({
                    hand_key = context.lv_hand,
                    op = 3,
                    operand = 3,
                    iterations = iterations,
                    batch_size = 25, -- Increased from 10 for better performance
                    card = card,
                    lv_instant = context.lv_instant,
                    label = '^^^3'
                })
                -- UI ping removed for performance optimization
                -- Q(function()
                -- 	card:juice_up(0.9, 1.2)
                -- 	card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'WG ^^^3', colour = G.C.FILTER})
                -- 	play_sound('jen_misc1')
                -- return true end)
                -- totalling tracked per job key inside queue
            end
            return nil, true
        end
    end
}

SMODS.Joker {
key = 'amalgam',
loc_txt = {
    name = 'The {C:green}A{C:money}m{C:blue}a{C:tarot}l{C:red}g{C:blood}a{C:edition}m{C:cry_ascendant}a{C:cry_azure}t{C:cry_ember}i{C:cry_epic}o{C:cry_verdant}n{}, {C:dark_edition}Puppet{} of {C:blood}Kosmos',
    text = {
        'Generates {X:inactive,C:blood}Malice',
        'when you {C:money}sell{} a Joker,',
        '{C:attention}scaled{} based on {C:attention}current operator{}',
        'and the sold Joker\'s {C:attention}rarity',
        '{C:inactive}({X:red,C:white}#1#{C:inactive}, {X:cry_epic,C:white}#2#{C:inactive}, {X:tarot,C:white}#3#{C:inactive}, {X:cry_exotic,C:white}#4#{C:inactive}, {X:black,C:white}#5#{C:inactive}, {X:cry_ember,C:white}#6#{C:inactive}, {X:cry_azure,C:white}#7#{C:inactive}, {X:jen_RGB,C:white}#8#{C:inactive})',
        lore('The only thing they can feel and think of is pain. Pain down to the planck time.'),
        faceart('raidoesthings')
    }
},
config = {},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
cost = 2e100,
rarity = 'jen_omegatranscendent',
cant_scare = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
immune_to_vermillion = true,
no_doe = true,
no_mysterious = true,
debuff_immune = true,
dissolve_immune = true,
permaeternal = true,
unique = true,
atlas = 'jenamalgam',
loc_vars = function(self, info_queue, center)
    return {vars = {get_amalgam_value('3'), get_amalgam_value('cry_epic'), get_amalgam_value('4'), get_amalgam_value('cry_exotic'), get_amalgam_value('jen_ritualistic'), get_amalgam_value('jen_wondrous'), get_amalgam_value('jen_extraordinary'), get_amalgam_value('jen_transcendent')}}
end
}

SMODS.Joker {
key = 'kosmos',
loc_txt = {
    name = '{C:blood}K{C:cry_ember}o{C:blood}s{C:cry_ember}m{C:blood}o{C:cry_ember}s',
    text = {
        '{X:inactive,C:blood}Malice{} : {C:almanac}#1#{}#3#{C:inactive}#2#',
        ' ',
        '{C:red,E:1,s:2}?????',
        ' ',
        '{C:inactive,s:1.5,E:1}Baa.',
        faceart('jenwalter666'),
        origin('Cult of the Lamb'),
        au('ReiGN OF THe KiNGSLAYeR')
    }
},
config = {},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 6666,
rarity = 'jen_omnipotent',
cant_scare = true,
unlocked = true,
discovered = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
immune_to_vermillion = true,
no_doe = true,
no_mysterious = true,
debuff_immune = true,
dissolve_immune = true,
permaeternal = true,
unique = true,
atlas = 'jenkosmos',
loc_vars = function(self, info_queue, center)
    return {vars = {number_format(get_max_malice()) == '0' and '' or get_malice(), number_format(get_max_malice()) == '0' and '' or get_max_malice(), number_format(get_max_malice()) == '0' and 'Maxed out' or ' / '}}
end
}

SMODS.Joker {
key = 'sigil',
loc_txt = {
    name = '{s:3,E:1,C:dark_edition}Jen\'s Sigil',
    text = {
        '{C:cry_twilight,E:1,s:3}?????',
        ' ',
        lore('A sharp blue G-shaped swirl, the very same icon'),
        lore('that is burnt onto the back of Jen Walter\'s head.'),
        lore('He knows not why he bears such a symbol, but all'),
        lore('he does know is that he feels like a chosen one with it.'),
        lore('The sigil on his head bears untold, unawoken power.'),
        faceart('jenwalter666'),
        origin('CRAFTWORLD')
    }
},
pos = { x = 0, y = 0 },
soul_pos = { x = 1, y = 0 },
cost = 1e9,
rarity = 'jen_omegatranscendent',
cant_scare = true,
unlocked = true,
discovered = true,
fusable = true,
blueprint_compat = false,
eternal_compat = true,
perishable_compat = false,
immutable = true,
immune_to_vermillion = true,
no_doe = true,
no_mysterious = true,
debuff_immune = true,
dissolve_immune = true,
permaeternal = true,
unique = true,
atlas = 'jensigil'
}