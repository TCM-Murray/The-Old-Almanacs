-- thank you to haya_ for the horse anim code!!

SMODS.Atlas {
	key = "lst",
	path = "lightningstrikesthrice.png",
	px = 32, py = 32
}

local center_x = 71/2
local center_y = 95/2
local sprite_scale = 32

-- get a random dir
local function rand_dir()
	local dir = 2*math.pi*(G and G.GAME and pseudorandom('lst_gfx') or math.random())
	return {x = math.cos(dir), y = math.sin(dir), ang = math.deg(dir) % 360}
end

local joker = {
  name = "Lightning Strikes Thrice",
  config = {
    extra = {
      retriggers = 2,
      speed = 1.1,
    },
		immutable = { dir = { x = 1, y = 0, ang = 0 }, x = center_x-(sprite_scale/2), y = center_y-(sprite_scale/2), size = sprite_scale, atlas_dir = 0 },
  },
  pos = {x = 2, y = 8},
	soul_pos = { x = 1, y = 9, draw = function(card, scale_mod, rotate_mod)
		---@type Sprite
		local soul = card.children.floating_sprite
		soul.scale.x = 32*card.T.scale
		soul.scale.y = 32*card.T.scale
		soul.scale_mag = {0.5, 0.5}
		local im = card.ability.immutable
		if soul.atlas ~= G.ASSET_ATLAS["mf_lst"] then
			soul.atlas = G.ASSET_ATLAS["mf_lst"]
		end
		soul:set_sprite_pos({x = im.atlas_dir, y = 0})
		soul:draw_shader('dissolve', 0, nil, nil, card.children.center, nil, nil, im.x*(card.T.w/71), im.y*(card.T.h/95) + (0.1+0.03*math.sin(1.8*G.TIMERS.REAL)), nil, 0.6)
		soul:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, nil, im.x*(card.T.w/71), im.y*(card.T.h/95))
	end },
	update = function(self, card, dt)
		local delta = G.real_dt or dt
		-- update gfx position of card
		local im = card.ability.immutable
		local extra = card.ability.extra
		if not extra.speed then extra.speed = im.speed end
		im.x = im.x + im.dir.x*extra.speed*(delta*60)
		im.y = im.y + im.dir.y*extra.speed*(delta*60)
		local nextx = im.x
		local nexty = im.y
		-- bounce off borders
		local count = 0
		while ((nextx < 0 or (nextx+im.size) > 71) or (nexty < 0 or (nexty+im.size) > 95)) do
			if count > 50 then break end
			if count == 0 and mf_config["Horse Sound"] then play_sound("mf_horsebounce", (math.random()+math.random(9,10))/10, 0.2) end
			im.dir = rand_dir()
			nextx = im.x + im.dir.x*extra.speed*(delta*60)
			nexty = im.y + im.dir.y*extra.speed*(delta*60)
			im.atlas_dir = math.floor((im.dir.ang + 22.5) / 45) % 8
			count = count+1
		end
	end,
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_vars = function(self, info_queue, center)
		if mf_config["Horse Sound"] then
    	play_sound('mf_lightningstrikesthrice')
		end
    return {
      vars = { center.ability.extra.retriggers }
    }
  end,
  calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self and context.other_context.discard then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
		end
    if context.mf_seal_repetition and context.seal_context.discard then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
  end
}

return joker
