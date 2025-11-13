
local joker = {
    name = "Jester",
    config = {
        extra = {}
    },
    pos = {x = 6, y = 8},
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    demicoloncompat = true,
    loc_vars = function(self, info_queue, center)
        return {
            vars = {}
        }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
            local rank = context.full_hand[1]:get_id()
            local suit = context.full_hand[1].base.suit
            table.sort(G.deck.cards, function(a,b)
                if ((b:get_id() == rank or b.base.suit == suit) and not (a:get_id() == rank or a.base.suit == suit))then
                    return true
                else
                    return false
                end
            end)
            return {
                message = localize("k_searched_ex")
            }
        end
    end
}

return joker
