-- note: while this is technically listed under the "en-us"
-- language, they will still be called "Colour" cards.
-- ha ha ha.

local art_credit = function (name)
  if mf_config["Programmer Art"] then return nil end
  if mf_config["Disable Art Credits"] then return nil end
  return "{s:0.8,C:inactive}Art by: "..name
end

local loc_stuff = {
  descriptions = {
    Joker = {
      j_mf_badlegaldefence = {
        name = "Bad Legal Defence",
        text = {
          "Create a {C:attention}Death{} {C:tarot}Tarot{}",
          "when {C:attention}Boss Blind{}",
          "is selected",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_basepaul_card = {
        name = "Basepaul Card",
        text = {
          "{X:mult,C:white} X#1# {} Mult. {X:mult,C:white} X#2# {} Mult",
          "instead for {C:red}Paul{}",
          "{C:inactive}(Who's Paul?)"
        }
      },
      j_mf_bladedance = {
        name = "Blade Dance",
        text = {
          "Adds {C:attention}#1#{} temporary",
          "{C:attention}Steel Cards{}",
          "to your deck when",
          "blind is selected",
        },
      },
      j_mf_blasphemy = {   
        name = "Blasphemy",
        text = {
          "{X:red,C:white} X#1# {} Mult",
          "{C:blue}-#2#{} hands",
          "when hand is played",
        },
      },
      j_mf_bloodpact = {
        name = "Blood Pact",
        text = {
          "{X:mult,C:white} X#1# {} Mult",
          "{C:red}Self destructs{} if you play",
          "a non-{C:hearts}Hearts{} card",
          art_credit("footlongdingledong"),
        }
      },
      j_mf_bowlingball = {
        name = "Bowling Ball",
        text = {
          "Played {C:attention}3s{}",
          "give {C:chips}+#1#{} Chips",
          "and {C:mult}+#2#{} Mult",
          "when scored",
          art_credit("footlongdingledong"),
        }
      },
      j_mf_cba = {
        name = "Card Buffer Advanced",
        text = {
          "{C:attention}Retrigger{} your first",
          "{C:dark_edition}Editioned{} Joker",
          "{C:inactive}(CBA excluded){}"
        }
      },
      j_mf_clipart = {
        name = "Clipart Joker",
        text = {
          "Create a {C:colourcard}Colour{} card",
          "when {C:attention}Blind{} is selected",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_colorem = {
        name = "Colorem",
        text = {
          "When a {C:colourcard}Colour{} card is used,",
          "{C:green}#1# in #2#{} chance to add a copy",
          "to your consumable area",
          "{C:inactive}(Must have room)",
        },
      },
      j_mf_coupon_catalogue = {
        name = "Coupon Catalogue",
        text = {
          "{C:mult}+#1#{} Mult for each",
          "{C:attention}Voucher{} purchased",
          "this run",
          "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        }
      },
      j_mf_css = {
        name = "CSS",
        text = {
          "Create a random {C:colourcard}Colour",
          "card when played hand",
          "contains a {C:attention}Flush",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_dramaticentrance = {    
        name = "Dramatic Entrance",
        text = {
          "{C:chips}+#1#{} Chips",
          "for the first hand",
          "of each round",
        },
      },
      j_mf_dropkick = {
        name = "Dropkick",
        text = {
          "{C:blue}+#1#{} hand when hand",
          "contains a {C:attention}Straight",
        },
      },
      j_mf_expansion_pack = {
        name = "Expansion Pack",
        text = {
          "When {C:attention}Blind{} is selected,",
          "create {C:attention}#1# {C:dark_edition}modded{C:attention} Joker",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_fleshprison = {
        name = "Flesh Prison",
        text = {
          "{C:red}X#1#{} {C:attention}Boss Blind{} size",
          "When {C:attention}Boss Blind{} is defeated,",
          "{C:red}self destructs{}, and creates",
          "a {C:dark_edition}Negative{} {C:spectral}The Soul{} card",
        }
      },
      j_mf_fleshpanopticon = {
        name = "Flesh Panopticon",
        text = {
          "{C:red}X#1#{} {C:attention}Boss Blind{} size",
          "When {C:attention}Boss Blind{} is defeated,",
          "{C:red}self destructs{}, and creates",
          "a {C:dark_edition}Negative{} {C:spectral}Gateway{} card"
        }
      },
      j_mf_globe = {
        name = "Globe",
        text = {
          "Create #1# {C:planet}Planet{} card",
          "when you {C:attention}reroll{} in the shop",
        }
      },
      j_mf_goldencarrot = {
        name = "Golden Carrot",
        text = {
          "Earn {C:money}$#1#{} at",
          "end of round",
          "{C:money}-$#2#{} given",
          "per hand played",
        }
      },
      j_mf_hallofmirrors = {
        name = "Hall of Mirrors",
        text = {
          "{C:attention}+#2#{} hand size for",
          "each {C:attention}6{} scored in",
          "the current round",
          "{C:inactive}(Currently {C:attention}+#1#{C:inactive} cards)"
        }
      },
      j_mf_hollow = {
        name = "Hollow Joker",
        text = {
          "{C:attention}#1#{} hand size",
          "{C:mult}+#2#{} Mult per hand",
          "size below {C:attention}#3#"
        }
      },
      j_mf_hyperbeam = {
        name = "Hyper Beam",
        text = {
          "{X:red,C:white} X#1# {} Mult",
          "{C:attention}Lose all discards",
          "when {C:attention}Blind{} is selected",
        },
      },
      j_mf_impostor = {
        name = "Impostor",
        text = {
          "{X:mult,C:white} X#1# {} Mult if the",
          "played hand has",
          "exactly one {C:red}red{} card"
        }
      },
      j_mf_jankman = {
        name = "Jankman",
        text = {
          "All {C:dark_edition}modded{} Jokers",
          "{C:inactive}(and also Jolly Joker){}",
          "each give {X:chips,C:white} X#1# {} Chips",
        }
      },
      j_mf_jester = {
        name = "Jester",
        text = {
          "{C:chips,s:1.1}+#1#{} Chips"
        }
      },
      j_mf_loadeddisk = {
        name = "Loaded Disk",
        text = {
          "Creates a {C:colourcard}Pink{} and",
          "a {C:colourcard}Yellow{} {C:colourcard}Colour{} card",
          "when sold",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_lollipop = {
        name = "Lollipop",
        text = {
          "{X:mult,C:white} X#1# {} Mult",
          "{X:mult,C:white} -X#2# {} Mult per",
          "round played",
        }
      },
      j_mf_luckycharm = {
        name = "Lucky Charm",
        text = {
          "{C:green}#1# in #3#{} chance",
          "for {C:mult}+#2#{} Mult",
          "{C:green}#6# in #5#{} chance",
          "to win {C:money}$#4#",
          "at end of round"
        }
      },
      j_mf_mashupalbum = {
        name = "Mashup Album",
        text = {
          "Gains {C:mult}+#3#{} Mult if played",
          "hand contains a {C:hearts}red{} flush",
          "Gains {C:chips}+#4#{} Chips if played",
          "hand contains a {C:spades}black{} flush",
          "{C:inactive}(Currently {C:mult}+#1#{C:inactive} and {C:chips}+#2#{C:inactive})"
        },
      },
      j_mf_mspaint = {
        name = "MS Paint Joker",
        text = {
          "{C:attention}+#1#{} hand size",
          "for the first hand",
          "of each blind"
        },
      },
      j_mf_paintcan = {
        name = "Paint Can",
        text = {
          "{C:green}#1# in #2#{} chance to add",
          "a round to {C:colourcard}Colour Cards{}",
          "when they gain a round",
        },
      },
      j_mf_pixeljoker = {
        name = "Pixel Joker",
        text = {
          "Played {C:attention}Aces{},",
          "{C:attention}4s{} and {C:attention}9s{} each give",
          "{X:mult,C:white} X#1# {} Mult when scored"
        },
      },
      j_mf_philosophical = {
        name = "Philosophical Joker",
        text = {
          "{C:dark_edition}+#1#{} Joker Slot"
        },
      },
      j_mf_rainbowjoker = {
        name = "Rainbow Joker",
        text = {
          "{C:colourcard}Colour{} cards give",
          "{X:mult,C:white} X#1#{} Mult",
          art_credit("footlongdingledong"),
        },
      },
      j_mf_recycling = {
        name = "Recycling",
        text = {
          "Create a random {C:planet}Planet{}",
          "or {C:tarot}Tarot{} card",
          "when any {C:attention}Booster{}",
          "{C:attention}Pack{} is skipped",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_rosetinted = {
        name = "Rose-Tinted Glasses",
        text = {
          "If {C:attention}first hand{} of round is",
          "a single {C:attention}2{}, destroy it and",
          "create a free {C:attention}Double Tag{}",
        }
      },
      j_mf_simplified = {
        name = "Simplified Joker",
        text = {
          "All {C:blue}Common{} Jokers",
          "each give {C:mult}+#1#{} Mult",
        }
      },
      j_mf_spiral = {
        name = "Spiral Joker",
        text = {
          "{C:mult}+(#1#+#2#cos(pi/#3# x {C:attention}$${C:mult})){} Mult",
          "{C:inactive}({C:attention}$${C:inactive} is your current money)",
          "{C:inactive}(Currently gives {C:mult}+#4#{C:inactive} Mult)"
        }
      },
      j_mf_stylemeter = {
        name = "Style Meter",
        text = {
          "Earn {C:money}$#1#{} at end",
          "of round for each",
          "{C:attention}Blind{} skipped this run",
          "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
        }
      },
      j_mf_teacup = {
        name = "Teacup",
        text = {
          "Upgrade the level of",
          "each {C:attention}played hand{}",
          "for the next {C:attention}#1#{} hands",
        },
      },
      j_mf_the_solo = {
        name = "The Solo",
        text = {
          "Gains {X:mult,C:white} X#2# {} Mult if played",
          "hand has only {C:attention}1{} card",
          "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
        }
      },
      j_mf_tonersoup = {
        name = "I Sip Toner Soup",
        text = {
          "Create a {C:tarot}Tarot{} card",
          "when a hand is played",
          "Destroyed when blind",
          "is defeated",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_treasuremap = {
        name = "Treasure Map",
        text = {
          "After {C:attention}#2#{} rounds,",
          "sell this card to",
          "earn {C:money}$#3#{}",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#)"
        },
      },
      j_mf_triangle = {
        name = "Triangle",
        text = {
          "Played cards each give",
          "{X:mult,C:white} X#1# {} Mult when scored",
          "if played hand is",
          "a {C:attention}Three of a Kind"
        },
      },
      j_mf_virtual = { 
        name = "Virtual Joker",
        text = {
          "{X:red,C:white} X#1# {} Mult",
          "Flips and shuffles all",
          "Joker cards when",
          "blind is selected"
        },
      },
      j_mf_marigold = {
        name = "Marigold",
        text = {
          "{C:attention}Retriggers{} played and held",
          "{C:attention}Marigold Cards{} #1# times",
          art_credit("marigold"),
        },
      },
      j_mf_yuckyrat = { 
        name = "Yucky Rat",
        text = {
          "Played {C:attention}unenhanced{} cards",
          "are converted to {C:attention}Yucky Cards{}.",
          "Gains {X:red,C:white} X#1# {} Mult for",
          "each card converted",
          "{C:inactive}(Currently {X:red,C:white} X#2# {C:inactive} Mult)"
        },
      },
      j_mf_hyperjimbo = { 
        name = "Hyperjimbo",
        text = {
          "{X:dark_edition,C:white,s:1.4} ^^#1# {s:1.4} Chips",
          "before scoring if {C:attention}played hand",
          "contains exactly {C:attention}4{} cards"
        },
      },
      j_mf_brass = {
        name = "Brass Joker",
        text = {
          "{C:attention}Retrigger{} the joker",
          "to the right once for every",
          "{C:attention}#4# Brass Cards{} destroyed",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        }
      },
      j_mf_allicantdo = {
        name = "All I Can't Do",
        text = {
          "{C:red}Debuffs{} first drawn hand",
          "Gains {X:red,C:white} X#1# {} Mult for",
          "each played {C:red}debuffed{} card",
          "{C:inactive}(Currently {X:red,C:white} X#2# {C:inactive})"
        }
      },
      j_mf_tealjoker = {
        name = "Teal Joker",
        text = {
          "Gives {X:chips,C:white} X#1# {} Chips",
          "for each {C:attention}Teal Card",
          "in your {C:attention}full deck",
          "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
        }
      },
      j_mf_gemstonejoker = {
        name = "Gemstone Joker",
        text = {
          "Earn {C:money}$#1#{} at end of round",
          "for each {C:attention}Gemstone Card{}",
          "in your {C:attention}full deck{}",
          "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
        }
      },
      j_mf_top10 = {
        name = "Top 10 Jokers from One through Ten",
        text = {
          "Earn {C:money}$#1#{} at end of round",
          "for each {C:green}unique digit{} displayed",
          "in {C:attention}current money{}",
          "{C:inactive}(They are 0, 1, 2, 3, 4, 5, 6, 7, 8, and 9.)",
        }
      },
      j_mf_junkmail = {
        name = "Junk Mail",
        text = {
          "Creates a {C:attention}Voucher{} which",
          "costs {C:money}#1#x{} as much at",
          "the start of each Shop",
        }
      },
      j_mf_stonejokerjoker = {
        name = "StoneJoker Joker",
        text = {
          "Creates a {C:dark_edition}Negative{}",
          "{C:spectral}Eternal{} {C:attention}Marble Joker{}",
          "at the end of each Shop",
        }
      },
      j_mf_flintandsteel = {
        name = "Flint and Steel",
        text = {
          "Upgrade the level of each",
          "{C:attention}played hand{} if scored hand contains",
          "a {C:attention}Stone Card{} and {C:attention}Steel Card{}",
        }
      },
      j_mf_talljoker = {
        name = "Tall Joker",
        text = {
          "{C:mult,s:1.1}+#1#{} Mult",
        },
      },
      j_mf_complexitycreep = {
        name = "Complexity Creep",
        text = {
          "Gains a random effect",
          "when spawned and when",
          "{C:attention}Boss Blind{} is selected"
        },
      },
      j_mf_selfinsert = {
        name = "Self Insert",
        text = {
          "effect customisable in settings..."
        }
      },
      j_mf_missingjoker = {
        name = "Missing Texture",
        text = {
          "Transforms into a",
          "{C:dark_edition}random joker{} for",
          "the duration of the blind",
          "when blind is selected"
        }
      },
      j_mf_rot_cartomancer = {
        name = "Cartomancer!",
        text = {
          "Create a {C:rotarot}45 Degree Rotated Tarot{} card",
          "when {C:attention}Blind{} is selected",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_widejoker = {
        name = "Wide Joker",
        text = {
          "{X:dark_edition,C:white}^#1#{} Mult",
        },
      },
      j_mf_monochrome = {
        name = "Monochrome Joker",
        text = {
          "{C:mult}+#1#{} Mult per round",
          "without a {C:colourcard}Colour Card",
          "{C:inactive}(Currently {C:mult}+#2#{C:inactive})",
          art_credit("footlongdingledong"),
        }
      },
      j_mf_farmmerge = {
        name = "Joke Merge Valley",
        text = {
          "Discarding exactly {C:attention}3 cards",
          "with the same rank {C:dark_edition}Merges",
          "them all with the {C:attention}rightmost",
          "discarded card"
        },
      },
      j_mf_broomcloset = {
        name = "The Broom Closet",
        text = {
          "{X:mult,C:white}X#1#{} Mult if no purchases",
          "were made in the last {C:attention}Shop{}",
          "{C:inactive}(Currently #2#)"
        },
      },
      j_mf_unregisteredhypercam = { 
        name = "Unregistered Hypercam 2",
        text = {
          "{X:dark_edition,C:white,s:1.4} ^^#1# {s:1.4} Mult",
          "before scoring",
        },
      },
      j_mf_blahaj = { 
        name = "Blåhaj",
        text = {
          "Swaps {C:chips}Chips{} and {C:mult}Mult{}"
        },
      },
      j_mf_wilddrawfour = { 
        name = "Wild Draw Four",
        text = {
          "{C:attention}+#2#{} hand size for",
          "each {C:attention}Wild Card{} scored",
          "in the current round",
          "{C:inactive}(Currently {C:attention}+#1#{C:inactive} cards)"
        },
      },
      j_mf_unpleasantcard = { 
        name = "Unpleasant Card",
        text = {
          "{X:chips,C:white} X#1# {} Chips",
          "{C:attention}Booster Packs{} are",
          "automatically skipped"
        },
      },
      j_mf_slotmachine = { 
        name = "Slot Machine",
        text = {
          "{C:green}#1# in #2#{} chance to retrigger",
          "scored {C:attention}7{} cards {C:attention}#3#{} times",
        },
      },
      j_mf_snake = {
        name = "Snake",
        text = {
          "After {C:attention}play{} or {C:attention}discard{},",
          "always draw {C:attention}#1#{} cards"
        }
      },
      j_mf_bookmove = {
        name = "Book Move",
        text = {
          "After {C:attention}#2#{} rounds,",
          "sell this card to create",
          "{C:attention}Hanging Chad{} and {C:attention}Photograph",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#, must have room)"
        },
      },
      j_mf_cueball = {
        name = "Cue Ball",
        text = {
          "{C:green}#1# in #2#{} chance for each played",
          "{C:attention}rankless card{} to create a",
          "{C:rotarot}45 Degree Rotated Tarot{} card when scored",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_blunder = {
        name = "Blunder",
        text = {
          "{X:mult,C:white} X#1# {} Mult",
          "Forces one card",
          "to be selected"
        },
      },
      j_mf_brilliant = {
        name = "Brilliant",
        text = {
          "If blind was beaten in",
          "one hand, create a",
          "random {C:spectral}Spectral{} card",
          "{C:inactive}(Must have room)"
        },
      },
      j_mf_lessfluff = {
        name = "Less Fluff",
        text = {
          "Destroys all other {C:dark_edition}Modded{} {C:attention}Jokers{}",
          "at the start of each {C:attention}Blind{}", 
          "and gains {X:mult,C:white} X#2# {} Mult for each",
          "{C:attention}Joker{} that was destroyed",
          "{C:inactive}(Currently {X:red,C:white} X#1# {C:inactive})"
        },
      },
      j_mf_sudoku = {
        name = "Sudoku Joker",
        text = {
          "{X:mult,C:white} X#1# {} Mult if each rank from {C:attention}A-9{}",
          "has been {C:attention}scored{}, resets when",
          "a {C:attention}Boss Blind{} is {C:red}defeated",
          "{C:inactive}(Currently {V:1}A{C:inactive}, {V:2}2{C:inactive}, {V:3}3{C:inactive}, {V:4}4{C:inactive}, {V:5}5{C:inactive}, {V:6}6{C:inactive}, {V:7}7{C:inactive}, {V:8}8{C:inactive}, {V:9}9{C:inactive})"
        },
      },
      j_mf_sapling = {
        name = "Fast-Growing Sapling",
        text = {
          "After {C:attention}#3#{} rounds,",
          "sell this card to set",
          "{C:attention}round score{} to {s:1.1,C:spectral}TREE(3){}",
          "{C:inactive}(Currently #4#, {}[{C:attention}#1#{C:inactive}#2#{}]{C:inactive})",
        }
      },
      j_mf_onesliptoolate = {
        name = "One Slip Too Late",
        text = {
          "{X:mult,C:white} xN {} Mult if {C:attention}poker hand{} contains",
          "exactly {C:attention}N{} cards, where {C:attention}N{} is the",
          "number of hands played this round",
          "{C:inactive}(N currently equals {C:attention}#1#{C:inactive})",
        }
      },
      j_mf_lightningstrikesthrice = {
        name = "Lightning Strikes Thrice",
        text = {
          "Retrigger {C:attention}on discard",
          "effects {C:attention}#1#{} times",
        }
      },
      j_mf_friendinsideme = {
        name = "Friend Inside Me",
        text = {
          "Once per {C:attention}ante{}, selling a {C:common}Common{}",
          "or {C:uncommon}Uncommon{} joker creates",
          "a joker of the next rarity",
          "{C:inactive}(Currently #1#)"
        }
      },
      j_mf_thewayhome = {
        name = "the way home",
        text = {
          "When {C:attention}blind{} is {C:attention}selected{};",
          "{C:green}#1# in #2#{} chance to",
          "gain {C:blue}#3#{} hands"
        }
      },
      j_mf_jackofalltrades = {
        name = "Jack of All Trades",
        text = {
          "Each {C:attention}Jack{} held",
          "in hand gives {C:mult}+#1#{} Mult,",
          "{C:chips}+#2#{} Chips, and {C:money}$#3#"
        },
      },
      j_mf_oopsallfives = {
        name = "Oops! All 5s",
        text = {
          "Reduces all {C:attention}listed",
          "{C:green,E:1,S:1.1}denominators{} by {C:green}1",
          "{C:inactive}(ex: {C:green}1 in 5{C:inactive} -> {C:green}1 in 4{C:inactive})"
        },
      },
      j_mf_passando = {
        name = "Passing Balatro in 5 Minutes",
        text = {
          "{X:attention,C:white}X2{} Speed",
          "Creates a {C:dark_edition}Negative{} {C:attention}Diet Cola",
          "for every {C:attention}2{} Blinds skipped",
          "{C:inactive}(Currently #1#/#2#)"
        },
      },
      j_mf_grep = {
        name = "grep",
        text = {
          "If {C:attention}first discard{} of round",
          "has only {C:attention}1{} card, shuffle",
          "all cards with {C:attention}matching",
          "{C:attention}rank or suit{} to",
          "the top of the {C:dark_edition}deck"
        }
      },
      j_mf_forge = {
        name = "Joker Forge",
        text = {
          "Creates a random {C:attention}Joker{}",
          "card once for every",
          "{C:attention}#3# Jokers{} sold",
          "{C:inactive}(Currently {}[{C:attention}#1#{C:inactive}#2#{}]{C:inactive})"
        }
      },
      j_mf_forgeslop = {
        name = "Forge Slop",
        text = {
          "Does not trigger {C:attention}Joker{}",
          "{C:attention}Forge{} when sold"
        }
      },
      j_mf_trianglewalker = {
        name = "Triangle, Planeswalker",
        text = {
          {
            "{X:black,C:white} +2 {}: Draw {C:attention}three{} cards",
          },
          {
            "{X:black,C:white} -3 {}: Destroy up to {C:attention}three{} selected cards",
          },
          {
            "{X:black,C:white} -11 {}: Make up to {C:attention}three{} selected",
            "{C:attention}playing cards{} {C:dark_edition}Polychrome{}",
          }
        }
      },
      j_mf_mindsculptor = {
        name = "Jimbo, the Mind Sculptor",
        text = {
          {
            "{X:black,C:white} +2 {}: Draw a card",
          },
          {
            "{X:black,C:white} 0 {}: Draw {C:attention}four{} cards, then {C:green}shuffle{} the",
            "{C:attention}three{} leftmost cards in hand into your deck",
          },
          {
            "{X:black,C:white} -1 {}: {C:green}Shuffle{} all cards held in hand into your deck",
          },
          {
            "{X:black,C:white} -12 {}: {C:red}Destroy{} all cards remaining in your deck",
          },
        }
      },
      j_mf_johnbalatro = {
        name = "John Balatro..?",
        text = {
          {
            "{X:black,C:white} +1 {}: Exactly {C:attention}five{} selected {C:attention}playing cards",
            "without {C:mult}Mult{} bonuses get {C:mult}+4{} Mult"
          },
          {
            "{X:black,C:white} -11 {}: {C:attention,E:1}Unleash{} John Balatro",
          },
        }
      },
      j_mf_johnbalatrotrue = {
        name = "John Balatro",
        text = {
          "{X:dark_edition,C:white,s:1.5}^2{} Mult",
          "before scoring"
        }
      },
      j_mf_dinner = {
        name = "DINNER!",
        text = {
          "Retrigger the {C:attention}Joker",
          "to the right for",
          "the next {C:attention}#1#{} rounds"
        }
      },
      j_mf_doubledscale = {
        name = "Doubled Scale",
        text = {
          "{C:attention}Scaling Jokers{} {C:green,E:1}scale",
          "{C:attention}twice{} as fast"
        }
      },
      -- ORTALAB SWAPS
      j_mf_clintcondition = {
        name = "Clint Condition",
        text = {
          "{X:chips,C:white} X#1# {} Chips. {X:chips,C:white} X#2# {} Chips",
          "instead for {C:chips}Clint{}",
          "{C:inactive}(Who's Clint?)"
        }
      },
      j_mf_sheetsuggestion = {
        name = "Sheet Suggestion",
        text = {
          "{C:mult,s:1.1}+#1#{} Mult",
          "{C:inactive}(funny flavour text)"
        }
      },

      j_mf_devilsknife = {
        name = "Devilsknife",
        text = {
          "Creates a {C:colourcard}Blue{} and",
          "a {C:colourcard}Lilac{} {C:colourcard}Colour{} card",
          "when sold",
          "{C:inactive}(Must have room)"
        },
      },

      j_mf_twotrucks = {
        name = "Two Trucks",
        text = {
          "Gains {X:chips,C:white} X#1# {} Chips for",
          "each unique pair in played hand",
          "{C:inactive}(Currently {X:chips,C:white} X#2# {} {C:inactive}Chips)",
        },
      },

      -- FAMILIAR SWAPS
      j_mf_jimbojjoker = {
        name = "Jimbo J. Joker",
        text = {
          "{X:mult,C:white} X#1# {} Mult"
        }
      },

      -- FINITY CROSSMOD
      j_mf_theneedle = {
        name = "The Needle",
        text = {
          "When {C:attention}Blind{} is selected,",
          "convert all but one {C:blue}Hand{}",
          "to {C:red}#1# discards{} each"
        }
      },

      -- THE DEVIOUS THREE WAY CROSSMOD
      j_mf_farmmergecivilisation = {
        name = "I Survive in Farm Merge Civilisation",
        text = {
          "At end of round, {C:dark_edition}Merge",
          "all cards together, and convert",
          "them all to the result"
        },
      },
    },
    Colour = {
      c_mf_black = {
        name = "Black",
        text = {
          "Add {C:dark_edition}Negative{} to a",
          "random {C:attention}Joker{} for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_deepblue = {
        name = "Deep Blue",
        text = {
          "Converts a random card in",
          "hand to {C:spades}Spades{} for every",
          "{C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_crimson = {
        name = "Crimson",
        text = {
          "Create a {C:red}Rare Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_seaweed = {
        name = "Seaweed",
        text = {
          "Converts a random card in",
          "hand to {C:clubs}Clubs{} for every",
          "{C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_brown = {
        name = "Brown",
        text = {
          "Destroys a random card in",
          "hand and gives {C:attention}$#5#{} for every",
          "{C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_grey = {
        name = "Grey",
        text = {
          "Create a {C:attention}Double Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_silver = {
        name = "Silver",
        text = {
          "Create a {C:dark_edition}Polychrome Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_white = {
        name = "White",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:colourcard}Colour{} card for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_red = {
        name = "Red",
        text = {
          "Converts a random card in",
          "hand to {C:hearts}Hearts{} for every",
          "{C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_orange = {
        name = "Orange",
        text = {
          "Converts a random card in",
          "hand to {C:diamonds}Diamonds{} for every",
          "{C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_yellow = {
        name = "Yellow",
        text = {
          "Gains {C:money}$#5#{} of",
          "{C:attention}sell value{}",
          "every {C:attention}#4# rounds",
          "{C:inactive}({}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_green = {
        name = "Green",
        text = {
          "Create a {C:dark_edition}Negative{}",
          "{C:green}Oops! All 5s{} for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_blue = {
        name = "Blue",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:planet}Planet{} card for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_lilac = {
        name = "Lilac",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:tarot}Tarot{} card for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_pink = {
        name = "Pink",
        text = {
          "Add {C:attention}1{} round to a random",
          "{C:colourcard}Colour{} card. Triggers once for",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_peach = {
        name = "Peach",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:rotarot}45 Degree Rotated Tarot{} card for",
          "every {C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_new_gold = {
        name = "Gold",
        text = {
          "Create a {C:dark_edition}Negative{} {C:spectral}Soul{}",
          "card for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      
      c_mf_purple = {
        name = "Magenta",
        text = {
          "Create an {C:cry_epic}Epic Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_moonstone = {
        name = "Moonstone",
        text = {
          "Create a {C:dark_edition}Jolly Joker{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_gold = {
        name = "Mutare Basi Ludum",
        text = {
          "Create a {C:dark_edition}Negative{} {C:cry_exotic}Gateway{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_ooffoo = {
        name = "00FF00",
        text = {
          "Create a {C:dark_edition}Negative{} {C:cry_code}Code{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_wordlegreen = {
        name = "Wordle Green",
        text = {
          "Create a {C:dark_edition}Negative{} {C:green}Alphabet{}",
          "card for every {C:attention}#4#{}",
          "round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_pastelpink = {
        name = "Pastel Pink",
        text = {
          "Create a {C:dark_edition}Negative{} {V:1}Silly{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_royalblue = {
        name = "Royal Blue",
        text = {
          "Create a {C:dark_edition}Negative{} {C:spectral}Seal Spectral{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_teal = {
        name = "Teal",
        text = {
          "Create a {C:dark_edition}Negative{} {C:spectral}Splash{}",
          "for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_blank = {
        name = "Blank",
        text = {
          "Create a {C:dark_edition}Negative{}",
          "{C:spectral}Joker Studio: Basic{}",
          "for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_amber = {
        name = "Amber",
        text = {
          "Create a {C:dark_edition}Negative{} {C:G.SP.C.travel_1}Travel{}",
          "card for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_respiceperprisma = {
        name = "Respice Per Prisma",
        text = {
          "Create a {C:dark_edition}Negative{}",
          "{C:spectral}Ringularity{} for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("astralightsky")
        },
      },
      c_mf_moss = {
        name = "Moss",
        text = {
          "Create a {C:dark_edition}Negative{} {C:myth_light}Myth{}",
          "card for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_caramel = {
        name = "Caramel",
        text = {
          "Create a {C:dark_edition}Negative{} {C:bakery}Bakery{}",
          "good for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
      c_mf_violet = {
        name = "Violet",
        text = {
          "Create a {C:dark_edition}Negative{} {C:spectral}Finity{}",
          "card for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
          art_credit("Multi")
        },
      },
    },
    Rotarot = {
      c_mf_rot_fool = {
        name = "The Fool!",
        text = {
          "Creates the last",
          "{C:rotarot}45 Degree Rotated Tarot{} or {C:colourcard}Colour{} ",
          "card used during this run",
          "{s:0.8,C:rotarot}The Fool!{s:0.8} excluded"
        }
      },
      c_mf_rot_magician = {
        name = "The Magician!",
        text = {
          "Enhances {C:attention}#1#{}",
          "selected cards to",
          "{C:attention}#2#s"
        }
      },
      c_mf_rot_high_priestess = {
        name = "The High Priestess!",
        text = {
          "Creates up to {C:attention}#1#",
          "random {C:colourcard}Colour{} cards",
          "{C:inactive}(Must have room)"
        }
      },
      c_mf_rot_empress = {
        name = "The Empress!",
        text = {
          "Enhances {C:attention}#1#",
          "selected cards to",
          "{C:attention}#2#s"
        }
      },
      c_mf_rot_emperor = {
        name = "The Emperor!",
        text = {
          "Creates up to {C:attention}#1#{} random",
          "{C:rotarot}45 Degree Rotated Tarot{} cards",
          "{C:inactive}(Must have room)"
        },
      },
      c_mf_rot_heirophant = {
        name = "The Hierophant!",
        text = {
          "Enhances {C:attention}#1#",
          "selected cards to",
          "{C:attention}#2#s"
        }
      },
      c_mf_rot_lovers = {
        name = "The Lovers!",
        text = {
          "Enhances {C:attention}#1#{}",
          "selected cards to",
          "{C:attention}#2#s"
        }
      },
      c_mf_rot_chariot = {
        name = "The Chariot!",
        text = {
          "Enhances {C:attention}#1#{} selected",
          "card into a",
          "{C:attention}#2#"
        }
      },
      c_mf_rot_justice = {
        name = "Justice!",
        text = {
          "Enhances {C:attention}#1#{} selected",
          "card into a",
          "{C:attention}#2#"
        }
      },
      c_mf_rot_hermit = {
        name = "The Hermit!",
        text = {
          "Sets money to next",
          "multiple of {C:money}$#1#",
          "{C:inactive}(No effect on multiples of {C:money}$#1#{C:inactive})"
        },
      },
      c_mf_rot_wheel = {
        name = "The Wheel of Fortune!",
        text = {
          "{C:green}#1# in #2#{} chance to add",
          "a random {C:negative}edition",
          "to a random {C:attention}Joker",
          "{C:inactive}All editions are weighted equally...{}"
        }
      },
      c_mf_rot_strength = {
        name = "Strength!",
        text = {
          "Randomises rank of up to",
          "{C:attention}#1#{} selected cards",
        },
      },
      c_mf_rot_hanged_man = {
        name = "The Hanged Man!",
        text = {
          "Destroys {C:attention}#1#{} random",
          "cards in hand",
        },
      },
      c_mf_rot_death = {
        name = "Death!",
        text = {
          "Select {C:attention}#1#{} cards,",
          "convert {C:attention}all{} selected cards",
          "into a {C:attention}random{} selected card"
        }
      },
      c_mf_rot_temperance = {
        name = "Temperance!",
        text = {
          "Add {C:money}$#1#{} of {C:attention}sell value",
          "to every {C:attention}Joker{} and",
          "{C:attention}Consumable{} card",
        },
      },
      c_mf_rot_devil = {
        name = "The Devil!",
        text = {
          "Enhances {C:attention}#1#{}",
          "selected cards to",
          "{C:attention}#2#s"
        }
      },
      c_mf_rot_tower = {
        name = "The Tower!",
        text = {
          "Enhances {C:attention}#1#{} selected",
          "card into a",
          "{C:attention}#2#"
        }
      },
      c_mf_rot_star = {
        name = "The Star!",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Enhanced",
          "{C:diamonds}Diamonds{} to your hand"
        }
      },
      c_mf_rot_moon = {
        name = "The Moon!",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Enhanced",
          "{C:clubs}Clubs{} to your hand"
        }
      },
      c_mf_rot_sun = {
        name = "The Sun!",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Enhanced",
          "{C:hearts}Hearts{} to your hand"
        }
      },
      c_mf_rot_judgement = {
        name = "Judgement!",
        text = {
          "Creates a random",
          "{C:dark_edition}modded{C:attention} Joker",
          "{C:inactive}(Must have room)"
        },
      },
      c_mf_rot_world = {
        name = "The World!",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Enhanced",
          "{C:spades}Spades{} to your hand"
        }
      },
    },
    Shape = {
      c_mf_cloud = {
        name = "Cloud",
        text = {
          "Create a {C:dark_edition}Negative{}",
          "{C:spectral}Philosophical Joker{} for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_spade = {
        name = "Spade",
        text = {
          "Converts a random card in {C:dark_edition}full deck{}",
          "to {C:spades}Spades{}. If it was already {C:spades}Spades{},",
          "{C:red}destroy{} the card instead. Triggers {C:attention}twice",
          "for every {C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_omega = {
        name = "Omega",
        text = {
          "Create an {C:dark_edition}Absolute Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_club = {
        name = "Club",
        text = {
          "Converts a random card in {C:dark_edition}full deck{}",
          "to {C:club}Clubs{}. If it was already {C:club}Clubs{},",
          "{C:red}destroy{} the card instead. Triggers {C:attention}twice",
          "for every {C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_rectangle = {
        name = "Rectangle",
        text = {
          "Adds a random {C:dark_edition}playing{}",
          "{C:dark_edition}card{} to hand for every",
          "{C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_squircle = {
        name = "Squircle",
        text = {
          "Create a {C:dark_edition}random{} {C:attention}Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_arrow = {
        name = "Arrow",
        text = {
          "Create a {C:dark_edition}Solar Tag{} for",
          "every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_circle = {
        name = "Circle",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:shape}Shape{} card for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_heart = {
        name = "Heart",
        text = {
          "Converts a random card in {C:dark_edition}full deck{}",
          "to {C:hearts}Hearts{}. If it was already {C:hearts}Hearts{},",
          "{C:red}destroy{} the card instead. Triggers {C:attention}twice",
          "for every {C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_diamond = {
        name = "Diamond",
        text = {
          "Converts a random card in {C:dark_edition}full deck{}",
          "to {C:diamond}Diamonds{}. If it was already {C:diamond}Diamonds{},",
          "{C:red}destroy{} the card instead. Triggers {C:attention}twice",
          "for every {C:attention}#4#{} round this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_dollar = {
        name = "Dollar",
        text = {
          "{C:red}Forcefully{} {C:money}sell{} a random {C:attention}Joker{} or",
          "{C:attention}consumable{} for {C:money}#1#x sell value{},",
          "increases by {C:money}1x{} every {C:attention}#4#{} round",
          "{C:inactive}(Forcefully selling bypasses Eternal){}",
          "{C:inactive}({}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_green = {
        name = "Green",
        text = {
          "Create a {C:dark_edition}Negative{}",
          "{C:green}Oops! All 6s{} for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_star = {
        name = "Star",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:rplanbet}Star?{} card for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_lilac = {
        name = "Lilac",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:tarot}Tarot{} card for every",
          "{C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_pause = {
        name = "Pause",
        text = {
          "Add {C:attention}1{} round to a all {C:colourcard}Colour{}",
          "cards for every {C:attention}#4#{} rounds this",
          "has been held, then {C:red}Halt{} them all",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_peach = {
        name = "Peach",
        text = {
          "Create a random {C:dark_edition}Negative{}",
          "{C:rotarot}45 Degree Rotated Tarot{} card for",
          "every {C:attention}#4#{} rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_gem = {
        name = "Gem",
        text = {
          "Create a {C:dark_edition}Negative{} {C:spectral}Fervour{}",
          "card for every {C:attention}#4#{} rounds",
          "this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
        },
      },
      
      c_mf_house = {
        name = "House",
        text = {
          "Create a {C:dark_edition}Reference{}",
          "{C:dark_edition}Tag{} for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_loss = {
        name = "Loss",
        text = {
          "Create a {C:dark_edition}Loss{}",
          "for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_prism = {
        name = "Prism",
        text = {
          "Create a {C:dark_edition}Negative{} {C:cry_exotic}Beyond{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
      c_mf_brackets = {
        name = "Brackets",
        text = {
          "Create a {C:dark_edition}Negative{} {C:cry_code}Code?{}",
          "card for every {C:attention}#4#{}",
          "rounds this has been held",
          "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})"
        },
      },
    },
    Spectral = {
      c_mf_soul2 = {
        name = "{s:2,E:4}The Soul {s:2,C:red,E:4}2",
        text = {
          "Creates a",
          "{C:dark_edition,s:3,E:1}Superlegendary{}",
          "Joker....",
        }
      }
    },
    Enhanced = {
      m_mf_yucky = {
        name = "Yucky Card",
				text = {
					"{C:green}#1# in #2#{} chance to",
					"be {C:red}destroyed{}",
					"after being scored",
				},
      },
      m_mf_teal = {
        name = "Teal Card",
        text = {
          "{X:chips,C:white} X#1# {} Chips",
          "while this card",
          "stays in hand"
        }
      },
      m_mf_styled = {
        name = "Styled Card",
        text = {
          "Gains a random {C:attention}Seal{}",
          "when drawn to hand"
        }
      },
      m_mf_monus = {
        name = "Monus Card",
        text = {
          "{C:chips}+#1#{} Chips",
          "per hand level"
        }
      },
      m_mf_cult = {
        name = "Cult Card",
        text = {
          "{C:mult}+#1#{} Mult",
          "per hand level"
        }
      },
      m_mf_marigold = {
        name = "Marigold Card",
        text = {
          "Earn {C:money}$#1#{} at",
          "end of round, plus",
          "{C:money}$#1#{} for each other",
          "{C:attention}Marigold Card{} in hand",
        }
      },
      m_mf_brass = {
        name = "Brass Card",
        text = {
          "{C:attention}Retriggers{} #1# additional",
          "times when scored",
					"{C:green}#2# in #3#{} chance to be",
					"{C:red}destroyed{} after being scored",
        }
      },
      m_mf_gemstone = {
        name = "Gemstone Card",
        text = {
          "{C:attention}+$#1#{} when scored",
          "no rank or suit"
        }
      },
    },
    Oddity = {
      c_mf_jimbophone = {
        name = "JimboPhone",
        text = {
          "Create {C:attention}#1#{} {C:mult}Joker{},",
          "does not need room",
          "{C:inactive}(Joker: +4 Mult)"
        },
      },
    },
    Voucher = {
      v_mf_paintroller = {
        name = "Paint Roller",
        text = {
          "{C:green}#1# in #2#{} chance to add",
          "{C:attention}1{} round to {C:colourcard}Colour Cards{}",
          "when they gain a round"
        },
      },
      v_mf_colourtheory = {
        name = "Colour Theory",
        text = {
          "Some {C:colourcard}Colour{} cards in",
          "packs are {C:dark_edition}Polychrome{}",
        },
      },
      v_mf_artprogram = {
        name = "Art Program",
        text = {
          "Some {C:colourcard}Colour{} cards in",
          "packs are {C:dark_edition}Negative{}",
        },
      },
      v_mf_superboss_ticket = {
        name = "The Ticket",
        text = {
          "Upgrades {C:attention}Ante #1#{}",
          "{C:inactive,s:0.8}Good luck!{}"
        },
      },
    },
    Back = {
      b_mf_grosmichel = {
        name = "Gros Michel Deck",
        text = {
          "Start run with {C:attention}Gros Michel"
        }
      },
      b_mf_philosophical = {
        name = "Philosophical Deck",
        text = {
          "Start run with 5",
          "{C:attention}Philosophical Jokers"
        }
      },
      b_mf_rainbow = {
        name = "Rainbow Deck",
        text = {
          "Start run with a {C:colourcard}White",
          "{C:colourcard}Colour{} card and the",
          "{C:tarot,T:v_mf_paintroller}Paint Roller{} Voucher",
        }
      },
      b_mf_blasphemy = {
        name = "Blasphemous Deck",
        text = {
          "Start run with a {C:dark_edition}Negative{}",
          "{C:spectral}Eternal{} {C:attention}Blasphemy"
        }
      },
    },
    Other = {
      undiscovered_colour = {
        name = "Not Discovered",
        text = {
          "Purchase or use",
          "this card in an",
          "unseeded run to",
          "learn what it does"
        }
      },
      p_mf_colour_normal_1 = {
        name = "Colour Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:colourcard} Colour{} cards to",
          "add to your consumeables"
        }
      },
      p_mf_colour_normal_2 = {
        name = "Colour Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:colourcard} Colour{} cards to",
          "add to your consumeables"
        }
      },
      p_mf_colour_jumbo_1 = {
        name = "Jumbo Colour Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:colourcard} Colour{} cards to",
          "add to your consumeables"
        }
      },
      p_mf_colour_mega_1 = {
        name = "Mega Colour Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:colourcard} Colour{} cards to",
          "add to your consumeables"
        }
      },
      p_mf_rotarot_normal_1 = {
        name = "45 Degree Rotated Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_normal_2 = {
        name = "45 Degree Rotated Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_normal_3 = {
        name = "45 Degree Rotated Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_normal_4 = {
        name = "45 Degree Rotated Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_jumbo_1 = {
        name = "45 Degree Rotated Jumbo Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_jumbo_2 = {
        name = "45 Degree Rotated Jumbo Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_mega_1 = {
        name = "45 Degree Rotated Mega Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_rotarot_mega_2 = {
        name = "45 Degree Rotated Mega Arcana Pack",
        text = {
          "Choose {C:attention}#1#{} of up to {C:attention}#2#",
          "{C:rotarot}45 Degree Rotated Tarot{}",
          "cards to be used immediately"
        }
      },
      p_mf_modded_normal_1 = {
        name = "Modded Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:dark_edition} Modded Joker{} cards",
        }
      },
      p_mf_modded_normal_2 = {
        name = "Modded Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:dark_edition} Modded Joker{} cards",
        }
      },
      p_mf_modded_jumbo_1 = {
        name = "Jumbo Modded Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:dark_edition} Modded Joker{} cards",
        }
      },
      p_mf_modded_mega_1 = {
        name = "Mega Modded Pack",
        text = {
          "Choose {C:attention}#1#{} of up to",
          "{C:attention}#2#{C:dark_edition} Modded Joker{} cards",
        }
      },
      tetr_explainer = {
        name = "Explanation",
        text = {
          "{X:dark_edition,C:white}^^n{} represents {C:attention}Tetration",
          "In this case, {X:dark_edition,C:white}n^^#1#{} can be",
          "calculated using {X:dark_edition,C:white}n^^#1# = n^n^#2#{}"
        }
      },
      planeswalker_explainer = {
        name = "Planeswalker",
        text = {
          "Starts with #1# {C:dark_edition}Loyalty{}.",
          "Once per round, you can {C:attention}activate{} an",
          "{C:dark_edition}ability{} by adjusting {C:dark_edition}Loyalty{}.",
          "{C:dark_edition}Loyalty{} cannot go below 0.",
        }
      },
			mf_halted = {
				name = "Halted",
				text = {
					"Cannot gain any more {C:attention}Rounds{}"
				},
			},
    },
    Blind = {
      bl_mf_bigger_blind = {
        name = "Bigger Blind",
      },
      bl_mf_violet_vessel_dx = {
        name = "Violet Vessel DX",
        text = {
          "EXTREMELY large blind"
        }
      },
      bl_mf_cerulean_bell_dx = {
        name = "Cerulean Bell DX",
        text = {
          "Forces 3 cards to",
          "always be selected"
        }
      },
      bl_mf_needle_dx = {
        name = "The Needle DX",
        text = {
          "Play only 1 hand,",
          "start with 1 discard"
        }
      },
      bl_mf_manacle_dx = {
        name = "The Manacle DX",
        text = {
          "-3 Hand Size"
        }
      },
      bl_mf_pillar_dx = {
        name = "The Pillar DX",
        text = {
          "Half of all cards played",
          "this run are debuffed"
        }
      },
      bl_mf_serpent_dx = {
        name = "The Serpent DX",
        text = {
          "Only redraw cards when",
          "hand is empty"
        }
      },
      bl_mf_club_dx = {
        name = "The Club DX",
        text = {
          "All non-Club cards",
          "are debuffed"
        }
      },
      bl_mf_goad_dx = {
        name = "The Goad DX",
        text = {
          "All non-Spades cards",
          "are debuffed"
        }
      },
      bl_mf_window_dx = {
        name = "The Window DX",
        text = {
          "All non-Diamonds cards",
          "are debuffed"
        }
      },
      bl_mf_head_dx = {
        name = "The Head DX",
        text = {
          "All non-Hearts cards",
          "are debuffed"
        }
      },
      bl_mf_arm_dx = {
        name = "The Arm DX",
        text = {
          "Set level of played",
          "poker hand to 0"
        }
      },
      bl_mf_wheel_dx = {
        name = "The Wheel DX",
        text = {
          "Only one card is",
          "drawn face up"
        }
      },
      bl_mf_house_dx = {
        name = "The House DX",
        text = {
          "First drawn hand",
          "is discarded"
        }
      },
      bl_mf_psychic_dx = {
        name = "The Psychic DX",
        text = {
          "Must not play 5 cards"
        }
      },
      bl_mf_hook_dx = {
        name = "The Hook DX",
        text = {
          "After hand is played,",
          "discard hand after draw"
        }
      },
    },
    Sleeve = {
      sleeve_mf_grosmichel = {
        name = "Gros Michel Sleeve",
        text = {
          "Start run with {C:attention}Gros Michel"
        }
      },
      sleeve_mf_grosmichel_alt = {
        name = "Gros Michel Sleeve",
        text = {
          "Start run with {C:attention}Cavendish"
        }
      },
      sleeve_mf_philosophical = {
        name = "Philosophical Sleeve",
        text = {
          "Start run with 5",
          "{C:attention}Philosophical Jokers"
        }
      },
      sleeve_mf_philosophical_alt = {
        name = "Philosophical Sleeve",
        text = {
          "Start run with 10",
          "{C:attention}Philosophical Jokers"
        }
      },
      sleeve_mf_rainbow = {
        name = "Rainbow Sleeve",
        text = {
          "Start run with a {C:colourcard}White",
          "{C:colourcard}Colour{} card and the",
          "{C:tarot}Paint Roller{} Voucher",
        }
      },
      sleeve_mf_rainbow_alt = {
        name = "Rainbow Sleeve",
        text = {
          "Start run with the",
          "{C:tarot}Colour Theory{} Voucher",
        }
      },
      sleeve_mf_blasphemy = {
        name = "Blasphemous Sleeve",
        text = {
          "Start run with a {C:dark_edition}Negative{}",
          "{C:spectral}Eternal{} {C:attention}Blasphemy"
        }
      },
      sleeve_mf_blasphemy_alt = {
        name = "Blasphemous Sleeve",
        text = {
          "Start run with a",
          "{C:dark_edition}Negative{} {C:attention}Blasphemy"
        }
      },
    },
    Tag = {
      tag_mf_colour = {
        name = "Painter's Tag",
        text = {
          "Gives a free",
          "{C:colourcard}Jumbo Colour Pack"
        }
      },
      tag_mf_rotarot = {
        name = "Rotarot Tag",
        text = {
          "Gives a free",
          "{C:rotarot}45 Degree Rotated Mega Arcana Pack"
        }
      },
      tag_mf_moddedpack = {
        name = "Modded Tag",
        text = {
          "Gives a free",
          "{C:dark_edition}Jumbo Modded Pack"
        }
      },
      tag_mf_clutch = {
        name = "Clutch Tag",
        text = {
          "{X:mult,C:white}X#1#{} Mult",
          "for the next {C:attention}Blind"
        }
      },
      tag_mf_absolute = {
        name = "Absolute Tag",
        text = {
          "Next shop Joker is free",
          "and becomes {C:dark_edition}Absolute"
        }
      },
      tag_mf_eclutch = {
        name = "{C:gold}Clutch Tag{}",
        text = {
          "{X:dark_edition,C:white}^#1#{} Mult",
          "for the next {C:attention}Blind"
        }
      },
      tag_mf_eabsolute = {
        name = "{C:gold}Absolute Tag{}",
        text = {
          "All shop items are {C:dark_edition}Absolute"
        }
      },
			tag_mf_emoddedpack = {
				name = "{C:gold}Modded Tag{}",
				text = { "Gives a free Editioned", "{C:dark_edition}Jumbo Modded Pack" },
			},
    },
    ComplexityCreep = { -- look having two versions is kind of annoying. oh well
      cc_plusmult = {
        name = "Effect",
        text = {
          "{C:mult}+#1#{} Mult",
          "#2#",
        }
      },
      cc_plusmult_if = {
        name = "Effect",
        text = {
          "{C:mult}+#1#{} Mult",
          "#2#",
          "#3#",
        }
      },
      cc_pluschips = {
        name = "Effect",
        text = {
          "{C:chips}+#1#{} Chips",
          "#2#",
        }
      },
      cc_pluschips_if = {
        name = "Effect",
        text = {
          "{C:chips}+#1#{} Chips",
          "#2#",
          "#3#",
        }
      },
      cc_xmult = {
        name = "Effect",
        text = {
          "{X:mult,C:white}X#1#{} Mult",
          "#2#",
        }
      },
      cc_xmult_if = {
        name = "Effect",
        text = {
          "{X:mult,C:white}X#1#{} Mult",
          "#2#",
          "#3#",
        }
      },
      cc_xchips = {
        name = "Effect",
        text = {
          "{X:chips,C:white}X#1#{} Chips",
          "#2#",
        }
      },
      cc_xchips_if = {
        name = "Effect",
        text = {
          "{X:chips,C:white}X#1#{} Chips",
          "#2#",
          "#3#",
        }
      },
      cc_emult = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^#1#{} Mult",
          "#2#",
        }
      },
      cc_emult_if = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^#1#{} Mult",
          "#2#",
          "#3#",
        }
      },
      cc_echips = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^#1#{} Chips",
          "#2#",
        }
      },
      cc_echips_if = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^#1#{} Chips",
          "#2#",
          "#3#",
        }
      },
      cc_eemult = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^^#1#{} Mult",
          "#2#",
        }
      },
      cc_eemult_if = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^^#1#{} Mult",
          "#2#",
          "#3#",
        }
      },
      cc_eechips = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^^#1#{} Chips",
          "#2#",
        }
      },
      cc_eechips_if = {
        name = "Effect",
        text = {
          "{X:dark_edition,C:white}^^#1#{} Chips",
          "#2#",
          "#3#",
        }
      },
      cc_dollars = {
        name = "Effect",
        text = {
          "Gives {C:money}$#1#{}",
          "#2#",
        }
      },
      cc_dollars_if = {
        name = "Effect",
        text = {
          "Gives {C:money}$#1#{}",
          "#2#",
          "#3#",
        }
      },
      cc_swapchipmult = {
        name = "Effect",
        text = {
          "Swaps {C:chips}Chips{} and {C:mult}Mult{}",
          "#2#",
        }
      },
      cc_swapchipmult_if = {
        name = "Effect",
        text = {
          "Swaps {C:chips}Chips{} and {C:mult}Mult{}",
          "#2#",
          "#3#",
        }
      },
      cc_createtarot = {
        name = "Effect",
        text = {
          "Creates a {C:tarot}Tarot Card",
          "#2#",
        }
      },
      cc_createtarot_if = {
        name = "Effect",
        text = {
          "Creates a {C:tarot}Tarot Card",
          "#2#",
          "#3#",
        }
      },
      cc_createplanet = {
        name = "Effect",
        text = {
          "Creates a {C:planet}Planet Card",
          "#2#",
        }
      },
      cc_createplanet_if = {
        name = "Effect",
        text = {
          "Creates a {C:planet}Planet Card",
          "#2#",
          "#3#",
        }
      },
      cc_copyconsumeable = {
        name = "Effect",
        text = {
          "Creates a {C:dark_edition}Negative{} copy of",
          "{C:attention}1{} random {C:attention}consumable{}",
          "card in your possession",
          "#2#",
        }
      },
      cc_copyconsumeable_if = {
        name = "Effect",
        text = {
          "Creates a {C:dark_edition}Negative{} copy of",
          "{C:attention}1{} random {C:attention}consumable{}",
          "card in your possession",
          "#2#",
          "#3#",
        }
      },
    },
  },
  misc = {
    v_dictionary = { -- uh is this right
      cc_mf_joker_trigger = { "every hand" },
      cc_mf_card_trigger = { "when a card is scored" },
      cc_mf_first_card_trigger = { "when the first card is scored" },
      cc_mf_face_card_trigger = { "when a face card is scored" },
      cc_mf_endofround = { "at end of round" },
      cc_mf_cardsold = { "when a card is sold" },
      cc_mf_shoproll = { "when shop is rerolled" },

      cc_mf_handtype = { "if hand contains a #3#" },
      cc_mf_odds = { "if a #4# in #3# chance passes" },
    },
    v_text = {
      ch_c_mf_superboss_active = { "Superboss is always active" },
    },
    dictionary = {
      k_colour = "Colour",
      b_colour_cards = "Colour Cards",
      k_colour_pack = "Colour Pack",
      k_plus_colour = "+1 Colour",
      k_plus_rotarot = "+1 45 Degree Rotated Tarot Card",
      b_take = "TAKE",
      k_death_caps = "DEATH",
      k_effect_added_ex = "Effect added!",
      k_merged_ex = "Merged!",
      k_swap_ex = "Swap!",
      k_noted_ex = "Noted!",
      k_equals_tree_three = "=TREE(3)",
      k_correct_ex = "Correct!",
      k_searched_ex = "Searched!",
      k_forged_ex = "Forged!",
      
      k_shape = "Shape?",
      b_shape_cards = "Shape? Cards",
      
      k_rotarot = "45 Degree Rotated Tarot",
      b_rotarot_cards = "45 Degree Rotated Tarot Cards",
      k_rotarot_pack = "45 Degree Rotated Arcana Pack",
      
      k_modded_pack = "Modded Pack",
      
      k_plus_voucher = "+1 Voucher",

      k_display_for_paul = "(for Paul)",
      k_display_for_paul_ex = "(for Paul!)",
      k_display_steel_cards = "Steel Cards",
      k_display_per_round = "per round",
      k_display_lose_all_hands = "(-9999 hands)",
      k_display_only_hearts = "(Only Hearts!)",
      k_display_enhanced = "(Enhanced)",
      k_display_per_voucher = "per Voucher",
      k_display_first_hand = "(first hand)",
      k_display_straight = "(Straight)",
      k_display_modded_joker = "Modded Joker",
      k_display_on_reroll = "(on reroll)",
      k_display_per_hand = "per hand",
      k_display_one_red_card = "(1 red card)",
      k_display_modded = "Modded",
      k_display_hand_size = "Hand Size",
      k_display_joker_slot = "Joker Slot",
      k_display_pack_skipped = "(Pack skipped)",
      k_display_play_debuffed = "(Play debuffed)",
      k_display_flint_and_steel = "(Flint and Steel!)",
      k_display_inactive = "(inactive)",
      k_display_upgrade_ex = "Upgrade!",
      k_display_four_cards = "(Four cards)",
      k_display_marigold_card = "(Marigold cards)",
      k_display_yucky = "(Yucky.)",

      mf_config_features = "Features",

      mf_config_progart = "Art Pack (requires restart)",
      mf_config_disablecred = "Disable Art Credits on cards",
      mf_config_jokers = "Jokers",
      mf_config_music = "Music",
      mf_config_colour_cards = "Colour Cards",
      mf_config_rotarot_cards = "45 Degree Rotated Tarot Cards",
      mf_config_achievements = "Achievements",
      mf_config_unfinished = "Unfinished Content",
      mf_config_huger_joker = "Huger Joker",
      mf_config_horse_sound = "Horse Sound",
      mf_config_superboss = "Superboss",
      mf_config_other_tags = "Other Tags",
      mf_config_other_packs = "Other Packs",
      
      mf_credits = "Credits",
      
      mf_config_maj = "My Awesome Joker",
    },
    labels = {
      colour = "Colour",
      shape = "Shape",
      mf_halted = "Halted",
    },
    achievement_names = {
      ach_mf_ten_colour_rounds = "10-ted",
      ach_mf_whos_paul = "Who's Paul?",
      ach_mf_jank_it_up = "Love that Janker",
      ach_mf_dropkick_ten_hands = "Going Infinite",
      ach_mf_negative_philosophical = "Deux Pipes",
      ach_mf_huge_and_pixel = "Anti-Aliased Allies",
    },
    achievement_descriptions = {
      ach_mf_ten_colour_rounds = 'Have a Colour Card with 10 triggers',
      ach_mf_whos_paul = "Trigger Basepaul Card's stronger effect",
      ach_mf_jank_it_up = "Have three copies of Jankman",
      ach_mf_dropkick_ten_hands = "Trigger Dropkick 5 times in one round",
      ach_mf_negative_philosophical = "Have a Negative Philosophical Joker",
      ach_mf_huge_and_pixel = "Have a Pixel Joker and a Huge Joker",
    },
    challenge_names = {
      c_mf_superboss_always = "Better Balatro II",
    },
  }
}

return loc_stuff
