local joker = {
  name = "Lucky Charm",
  config = {
    extra = {mult_chance = 3, mult = 20, money_chance = 8, money = 20}
  },
  pos = {x = 8, y = 1},
  rarity = 1,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = true,
  loc_txt = {
    name = "Lucky Charm",
    text = {
      "{C:green}#1# in #3#{} chance",
      "for {C:mult}+#2#{} Mult",
      "{C:green}#1# in #5#{} chance",
      "to win {C:money}$#4#",
      "at end of round"
    }
  },
  loc_vars = function(self, info_queue, center)
    local new_numerator, new_denominator = SMODS.get_probability_vars(center, 1, center.ability.extra.mult_chance, 'luckycharm_mult')
    local new_numerator_2, new_denominator_2 = SMODS.get_probability_vars(center, 1, center.ability.extra.money_chance, 'luckycharm_money')
    return {
      vars = {new_numerator, center.ability.extra.mult, new_denominator, center.ability.extra.money, new_denominator_2, new_numerator_2}
    }
  end,
  calculate = function(self, card, context)
    if context.forcetrigger then
      return {
        dollars = card.ability.extra.money,
        mult = card.ability.extra.mult
      }
    end
    if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
      if SMODS.pseudorandom_probability(card, 'lucky_charm_money', 1, card.ability.extra.money_chance, 'lucky_charm_money') then
        ease_dollars(card.ability.extra.money)
        return {
          message = localize('$')..card.ability.extra.money,
          colour = G.C.MONEY,
          delay = 0.45, 
          remove = true,
          card = card
        }
      end
    end
    
    if context.cardarea == G.jokers and context.joker_main  then
      if SMODS.pseudorandom_probability(card, 'lucky_charm_mult', 1, card.ability.extra.mult_chance, 'lucky_charm_mult') then
        return {
          message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
          mult_mod = card.ability.extra.mult
        }
      end
    end
  end
}

-- idk how to add this one

return joker
