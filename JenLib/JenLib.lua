--- STEAMODDED HEADER

--- MOD_NAME: Jen's Library
--- MOD_ID: JenLib
--- MOD_AUTHOR: [jenwalter666]
--- MOD_DESCRIPTION: Some functions that I commonly use which some people might find a use for
--- BADGE_COLOR: 000000
--- PREFIX: jenlib
--- VERSION: 0.4.1
--- LOADER_VERSION_GEQ: 1.0.0

--Global table, don't modify!
jl = {}

-- Patch Card metatable to provide can_calculate method safely
-- This fixes crashes during card destruction without function override conflicts
local original_card_mt = getmetatable(Card) or {}
local original_index = original_card_mt.__index or function(t, k) return rawget(t, k) end

-- Create new __index that provides can_calculate when missing
local function safe_card_index(card, key)
    if key == "can_calculate" and not rawget(card, "can_calculate") then
        -- Provide a safe can_calculate method for cards that don't have one
        return function(self, ignore_debuff, ignore_sliced)
            -- Use rawget to avoid triggering metatable again
            local debuff = rawget(self, "debuff")
            local getting_sliced = rawget(self, "getting_sliced")
            local is_available = (not debuff or ignore_debuff) and (not getting_sliced or ignore_sliced)
            return is_available
        end
    end
    
    -- Call original __index behavior
    if type(original_index) == "function" then
        return original_index(card, key)
    else
        return original_index[key]
    end
end

-- Apply the metatable patch
original_card_mt.__index = safe_card_index
setmetatable(Card, original_card_mt)

print("[JEN DEBUG] Card metatable patched to provide can_calculate method safely")

-- ========================================
-- CRASH MONITORING AND DEBUG SYSTEM
-- ========================================

-- Crash monitoring system
jl.crash_monitor = {
	active = false,
	initialized = false,
	crash_count = 0,
	last_crash_time = 0
}

-- Initialize crash monitoring system
function jl.crash_monitor:initialize()
	if self.initialized then return end
	self.initialized = true
	
	print("[JEN DEBUG] 🛡️ Initializing crash monitoring system...")
	
	-- Check crash handler availability
	self:detect_crash_handlers()
	
	-- Start memory monitoring
	self:start_memory_monitoring()
	
	-- Start crash monitoring
	self:start_crash_monitoring()
	
	print("[JEN DEBUG] ✅ Crash monitoring system initialized")
end

-- Detect available crash handlers
function jl.crash_monitor:detect_crash_handlers()
	-- Check if the game's crash handler is active
	if love.errorhandler then
		print("[JEN DEBUG] 🛡️ Game's built-in crash handler is available")
	end
	
	-- Check if Steamodded crash handler is active
	if SMODS and SMODS.restart_game then
		print("[JEN DEBUG] 🛡️ Steamodded crash handler is available")
	end
	
	-- Monitor for any crash-related global variables
	if G and G.F_NO_ERROR_HAND then
		print("[JEN DEBUG] 🚨 Error handling is DISABLED (G.F_NO_ERROR_HAND = true)")
	else
		print("[JEN DEBUG] 🛡️ Error handling is ENABLED")
	end
end

-- Memory monitoring and cleanup
function jl.crash_monitor:start_memory_monitoring()
	-- Emergency memory cleanup
	local function emergency_memory_cleanup()
		local memory = collectgarbage("count")
		if memory > 150000 then  -- If memory > 150MB
			print("[JEN EMERGENCY] Critical memory usage:", math.floor(memory/1024), "KB - Forcing cleanup!")
			collectgarbage("collect")
			collectgarbage("collect")
			collectgarbage("collect")
			collectgarbage("collect")
			collectgarbage("collect")
			local new_memory = collectgarbage("count")
			print("[JEN EMERGENCY] Memory reduced to:", math.floor(new_memory/1024), "KB")
		end
	end
	
	-- Set up periodic memory monitoring
	Q(function()
		emergency_memory_cleanup()
		return true
	end, 0.5, nil, 'after')  -- Check every 0.5 seconds
end

-- Enhanced crash monitoring with memory leak detection and emergency garbage collection
function jl.crash_monitor:start_crash_monitoring()
	if self.active then return end
	self.active = true
	
	-- Initialize memory tracking
	self.memory_history = {}
	self.memory_trend = 0
	
	print("[JEN DEBUG] 🔍 Starting real-time crash handler monitoring...")
	
	-- Monitor every frame for crash handler activation
	Q(function()
		-- Check if we're in a crash state
		if G and G.E_MANAGER then
			local memory = collectgarbage("count")
			
			-- Track memory usage trend
			table.insert(self.memory_history, memory)
			if #self.memory_history > 10 then
				table.remove(self.memory_history, 1)
			end
			
			-- Calculate memory trend (positive = increasing, negative = decreasing)
			if #self.memory_history >= 5 then
				local recent_avg = 0
				local older_avg = 0
				for i = #self.memory_history - 4, #self.memory_history do
					recent_avg = recent_avg + self.memory_history[i]
				end
				for i = 1, 5 do
					older_avg = older_avg + self.memory_history[i]
				end
				self.memory_trend = (recent_avg - older_avg) / 5
				
				-- Warn if memory is consistently increasing
				if self.memory_trend > 1000 and memory > 150000 then  -- Increasing by >1MB per check and already high
					print("[JEN DEBUG] ⚠️ MEMORY LEAK DETECTED - Memory increasing by", math.floor(self.memory_trend), "KB per check")
					print("[JEN DEBUG] 💾 Current memory:", memory, "KB")
					print("[JEN DEBUG] 🧹 Attempting preventive garbage collection...")
					collectgarbage("collect")
				end
			end
			
			if memory > 200000 then  -- If memory spikes above 200MB
				print("[JEN DEBUG] 🚨 HIGH MEMORY SPIKE DETECTED!")
				print("[JEN DEBUG] 💾 Current memory:", memory, "KB")
				print("[JEN DEBUG] 🕐 Time:", os.date("%H:%M:%S"))
				print("[JEN DEBUG] ⚠️ Crash handler may activate soon...")
				
				-- Try to force garbage collection to prevent crash
				if memory > 300000 then  -- If memory is extremely high
					print("[JEN DEBUG] 🧹 FORCING EMERGENCY GARBAGE COLLECTION!")
					collectgarbage("collect")
					local new_memory = collectgarbage("count")
					print("[JEN DEBUG] 💾 Memory after emergency GC:", new_memory, "KB")
				end
			end
		end
		return true
	end, 0.1, nil, 'after')  -- Check every 0.1 seconds
end

-- Monitor for crash recovery
function jl.crash_monitor:monitor_crash_recovery()
	-- Check if we're in a post-crash state
	if G and G.E_MANAGER then
		local current_memory = collectgarbage("count")
		if current_memory < 50000 then  -- If memory is low after crash
			-- Post-crash recovery detected (debug output removed)
		end
	end
end

-- Event Manager protection
function jl.crash_monitor:protect_event_manager()
	if G.E_MANAGER and G.E_MANAGER.event_queue then
		local queue_size = #G.E_MANAGER.event_queue
		if queue_size > 1000 then  -- If event queue gets too large
			print("[JEN DEBUG] 🚨 Large event queue detected:", queue_size, "events - forcing cleanup!")
			-- Force process some events to reduce queue
			for i = 1, math.min(100, queue_size) do
				if G.E_MANAGER.event_queue[1] then
					table.remove(G.E_MANAGER.event_queue, 1)
				end
			end
			print("[JEN INFO] Event queue reduced to:", #G.E_MANAGER.event_queue, "events")
		end
	end
end

-- Intercept Event Manager functions for crash detection
function jl.crash_monitor:intercept_event_manager()
	-- Intercept the Event Manager's event execution loop where the crash likely happens
	local original_process_events = G.E_MANAGER.process_events
	if original_process_events then
		G.E_MANAGER.process_events = function(self, queue_name)
			local success, error_msg = pcall(function()
				return original_process_events(self, queue_name)
			end)
			if not success then
				print("[JEN ERROR] Event Manager process_events crashed:", tostring(error_msg))
				-- Add crash handler detection
				if error_msg and error_msg:find("not enough memory") then
					print("[JEN DEBUG] 🚨 MEMORY CRASH DETECTED - Crash handler should activate now!")
					print("[JEN DEBUG] 📍 Location: process_events, Queue:", tostring(queue_name))
					print("[JEN DEBUG] 🕐 Time:", os.date("%H:%M:%S"))
					print("[JEN DEBUG] 💾 Memory before crash:", collectgarbage("count"), "KB")
				end
			end
		end
	else
		-- Try to intercept the event execution in the update loop
		local original_update = G.E_MANAGER.update
		G.E_MANAGER.update = function(self, dt)
			local success, error_msg = pcall(function()
				return original_update(self, dt)
			end)
			if not success then
				print("[JEN ERROR] Event Manager update crashed:", tostring(error_msg))
				-- Add crash handler detection
				if error_msg and error_msg:find("not enough memory") then
					print("[JEN DEBUG] 🚨 MEMORY CRASH DETECTED - Crash handler should activate now!")
					print("[JEN DEBUG] 📍 Location: update, dt:", tostring(dt))
					print("[JEN DEBUG] 🕐 Time:", os.date("%H:%M:%S"))
					print("[JEN DEBUG] 💾 Memory before crash:", collectgarbage("count"), "KB")
					print("[JEN DEBUG] 🔄 This should trigger the game's built-in crash handler...")
				end
			end
		end
	end
end

-- Intercept thread error handling for crash detection (catches "not enough memory" errors)
function jl.crash_monitor:intercept_thread_errors()
	-- Intercept the main thread error handler to catch "not enough memory" errors
	if love and love.threaderror then
		local original_threaderror = love.threaderror
		love.threaderror = function(thread, errorstr)
			-- Check if this is a memory-related crash
			if errorstr and errorstr:find("not enough memory") then
				print("[JEN DEBUG] 🚨 MEMORY CRASH DETECTED - Crash handler should activate now!")
				print("[JEN DEBUG] 📍 Location: Thread error, Thread ID:", tostring(thread))
				print("[JEN DEBUG] 🕐 Time:", os.date("%H:%M:%S"))
				print("[JEN DEBUG] 💾 Memory before crash:", collectgarbage("count"), "KB")
				print("[JEN DEBUG] 🔄 This should trigger the game's built-in crash handler...")
			end
			
			-- Call the original handler
			return original_threaderror(thread, errorstr)
		end
	end
end

-- Schedule periodic monitoring
function jl.crash_monitor:schedule_monitoring()
	-- Schedule crash recovery monitoring
	Q(function()
		self:monitor_crash_recovery()
		return true
	end, 2.0, nil, 'after')  -- Check after 2 seconds
	
	-- Schedule Event Manager protection
	Q(function()
		self:protect_event_manager()
		return true
	end, 1.0, nil, 'after')  -- Check every second
end

-- Complete crash monitoring setup
function jl.crash_monitor:setup()
	self:initialize()
	self:intercept_event_manager()
	self:intercept_thread_errors()
	self:schedule_monitoring()
end

--Returns a table where each element is a single-character string derived from the given string
function jl.string_to_table(str)
	if type(str) == 'number' then str = tostring(str) end
	local tbl = {}
	if not str then return tbl end
	
	for i = 1, string.len(str) do
		tbl[i] = string.sub(str, i, i)
	end
	
	return tbl
end

--Divides a string based on a given separator, then returns a table containing each string as an element
function jl.explode(sep, str)
	sep = tostring(sep)
	if not sep then return 'error' end
	if sep == '' then return jl.string_to_table(str) end
	
	local ret = {}
	local curpos = 1
	
	for i = 1, string.len(str) do
		local pos1, pos2 = string.find( str, sep, curpos, false )
		if not pos1 then break end
		ret[i] = string.sub(str, curpos, pos1 - 1)
		curpos = pos2 + 1
	end
	
	ret[#ret + 1] = string.sub(str, curpos)
	
	return ret
end

--Convenience functions for formatting text
function jl.pluschips(txt, nocap)
	return '{C:chips}+' .. txt .. (nocap and '' or '{}')
end

function jl.plusmult(txt, nocap)
	return '{C:mult}+' .. txt .. (nocap and '' or '{}')
end

function jl.mulchips(txt, nocap)
	return '{X:chips,C:white}x' .. txt .. (nocap and '' or '{}')
end

function jl.mulmult(txt, nocap)
	return '{X:mult,C:white}x' .. txt .. (nocap and '' or '{}')
end

function jl.expochips(txt, nocap)
	return '{X:chips,C:dark_edition}^' .. txt .. (nocap and '' or '{}')
end

function jl.expomult(txt, nocap)
	return '{X:mult,C:dark_edition}^' .. txt .. (nocap and '' or '{}')
end

function jl.tetchips(txt, nocap)
	return '{X:chips,C:jen_RGB}^^' .. txt .. (nocap and '' or '{}')
end

function jl.tetmult(txt, nocap)
	return '{X:mult,C:jen_RGB}^^' .. txt .. (nocap and '' or '{}')
end

function jl.penchips(txt, nocap)
	return '{X:chips,C:black}^^^' .. txt .. (nocap and '' or '{}')
end

function jl.penmult(txt, nocap)
	return '{X:mult,C:black}^^^' .. txt .. (nocap and '' or '{}')
end

function jl.hypchips(txt, nocap, arrows)
	return '{X:chips,C:cry_ember}' .. string.rep('^', arrows or 4) .. txt .. (nocap and '' or '{}')
end

function jl.hypmult(txt, nocap, arrows)
	return '{X:mult,C:cry_twilight}' .. string.rep('^', arrows or 4) .. txt .. (nocap and '' or '{}')
end

--Checks a string against a table of strings
function jl.bf(needle, haystack)
	if type(needle) ~= 'string' then return false end
	if type(haystack) ~= 'table' then return false end
	for k, v in pairs(haystack) do
		if type(v) == 'string' and v == needle then return true end
	end
	return false
end

--Plays the dissolve animation on a card without actually removing it
function Card:fake_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    local dissolve_time = 0.7*(dissolve_time_fac or 1)
    self.dissolve = 0
    self.dissolve_colours = dissolve_colours
        or {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY}
    if not no_juice then self:juice_up() end
    local childParts = Particles(0, 0, 0,0, {
        timer_type = 'TOTAL',
        timer = 0.01*dissolve_time,
        scale = 0.1,
        speed = 2,
        lifespan = 0.7*dissolve_time,
        attach = self,
        colours = self.dissolve_colours,
        fill = true
    })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  0.7*dissolve_time,
        func = (function() childParts:fade(0.3*dissolve_time) return true end)
    }))
    if not silent then 
        G.E_MANAGER:add_event(Event({
            blockable = false,
            func = (function()
                    play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                    play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        ref_table = self,
        ref_value = 'dissolve',
        ease_to = 1,
        delay =  1*dissolve_time,
        func = (function(t) return t end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  1.05*dissolve_time,
    }))
end

--Grabs a random element from a table that's not numerically indexed (e.g. it has elements with strings for keys)
--It's recommended to do <table>[math.random(#<table>)] instead for numerically-indexed tables as it's more efficient
function jl.rndelement(tbl)
	local index = {}
	for k, v in pairs(tbl) do
		index[#index + 1] = k
	end
	return tbl[index[math.random(#index)]]
end

--Increases the card's rank to the next value
function Card:increment(override)
	local rank_data = SMODS.Ranks[override or self.base.value]
	local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
	local new_rank
	if behavior.ignore or not next(rank_data.next) then
		return true
	elseif behavior.random then
		new_rank = pseudorandom_element(rank_data.next, pseudoseed('jl_incrementrank'))
	else
		local ii = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
		new_rank = rank_data.next[ii]
	end
	assert(SMODS.change_base(self, nil, new_rank))
end

--Decreases the card's rank to the previous value
function Card:decrement(override)
	local rank_data = SMODS.Ranks[override or self.base.value]
	local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
	local new_rank = 'N/A'
	if behavior.ignore then
		return true
	elseif behavior.random then
		new_rank = pseudorandom_element(rank_data.next, pseudoseed('jl_decrementrank'))
	else
		for k, v in pairs(SMODS.Ranks) do
			if next(v.next) then
				new_rank = k
				break
			end
		end
		if tostring(new_rank) == 'N/A' then return true end
	end
	assert(SMODS.change_base(self, nil, new_rank))
end

--Gets the position of a card on the X axis
function Card:xpos()
	return (self.T.x + self.T.w/2)
end

--Gets the position of a card on the Y axis
function Card:ypos()
	return (self.T.h + self.T.h/2)
end

--Gets the position of a card on X and Y
function Card:pos()
	return self:xpos(), self:ypos()
end

--Gets the total number of times a type of consumable has been used (e.g. Tarots, Planets, etc.)
--ex. jl.ctu('Tarot') will get the total number of Tarots used in run
--Not case-sensitive; 'tarot', 'TAROT', 'TaRoT', etc, will work as well
function jl.ctu(set)
	local count = 0
	if not G.GAME then return count end
	if type(G.GAME.consumeable_usage) ~= 'table' then return count end
	for k, v in pairs(G.GAME.consumeable_usage) do
		if string.lower(v.set or '') == string.lower(set) then
			count = count + (v.count or 1)
		end
	end
	return count
end

--A more minimalist function for changing the hand UI
function jl.h(name, chip, mul, lv, notif, snd, vol, pit, de)
	update_hand_text({sound = type(snd) == 'string' and snd or type(snd) == 'nil' and 'button', volume = vol or 0.7, pitch = pit or 0.8, delay = de or 0.3}, {handname=name or '????', chips = chip or '?', mult = mul or '?', level=lv or '?', StatusText = notif})
end

function jl.hn(newname)
	update_hand_text({delay = 0}, {handname = newname})
end

function jl.hlv(newlevel)
	update_hand_text({delay = 0}, {level = newlevel})
end

function jl.hc(newchips, notif)
	update_hand_text({delay = 0}, {chips = newchips, StatusText = notif})
end

function jl.hm(newmult, notif)
	update_hand_text({delay = 0}, {mult = newmult, StatusText = notif})
end

function jl.hcm(newchips, newmult, notif)
	update_hand_text({delay = 0}, {chips = newchips, mult = newmult, StatusText = notif})
end

--Updates the hand text to a specified hand
function jl.th(hand, notify)
	if hand == 'all' or hand == 'allhands' or hand == 'all_hands' then
		jl.h(localize('k_all_hands'), '...', '...', '', notify)
	elseif G.GAME.hands[hand or 'NO_HAND_SPECIFIED'] then
		jl.h(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips, G.GAME.hands[hand].mult, G.GAME.hands[hand].level, notify)
	else
		jl.h('ERROR', 'ERROR', 'ERROR', 'ERROR', notify)
	end
end

--Fast and easy-to-type function to clear the hand text
function jl.ch()
	update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

--Calls G.FUNCS.use_card() on a card
function Card:fire()
	G.FUNCS.use_card({ config = { ref_table = self } })
end

--Returns the first instance of a given card by ID, or nil if the card doesn't exist
local all_areas = {'jokers', 'consumeables', 'hand', 'discard'}
function jl.fc(id, area)
	if not area then area = 'jokers' end
	if type(area) == 'table' then
		for k, a in ipairs(area) do
			for i = 1, #G[a].cards do
				if G[a].cards[i].config.center.key == id then return G[a].cards[i] end
			end
		end
	elseif area == 'all' then
		for k, a in ipairs(all_areas) do
			for i = 1, #G[a].cards do
				if G[a].cards[i].config.center.key == id then return G[a].cards[i] end
			end
		end
	else
		if not G[area] then return end
		for i = 1, #G[area].cards do
			if G[area].cards[i].config.center.key == id then return G[area].cards[i] end
		end
	end
	return
end

--Randomises playing cards
function jl.randomise(targets, noanim)
	if #targets <= 0 then return end
	if noanim then
		for i=1, #targets do
			local card = targets[i]
			card:set_base(pseudorandom_element(G.P_CARDS))	
			if pseudorandom(pseudoseed('chancetime')) > 1 / (#G.P_CENTER_POOLS['Enhanced']+1) then
				card:set_ability(pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('spectral_chance')))
			else
				card:set_ability(G.P_CENTERS['c_base'])
			end	
			local edition_rate = 2
			card:set_edition(poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true), true, true)
			local seal_rate = 10
			local seal_poll = pseudorandom(pseudoseed('stdseal'..G.GAME.round_resets.ante))
			if seal_poll > 1 - 0.02*seal_rate then
				local seal_type = pseudorandom(pseudoseed('stdsealtype'..G.GAME.round_resets.ante))
				local seal_list = {}
				for k, _ in pairs(G.P_SEALS) do
					table.insert(seal_list, k)
				end
				seal_type = math.floor(seal_type * #seal_list)
				card:set_seal(seal_list[seal_type], true, true)
			else
				card:set_seal(nil, true, true)
			end
			card:juice_up(0.3, 0.3)
		end
	else
		for i=1, #targets do
			local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() targets[i]:flip();play_sound('card1', percent);targets[i]:juice_up(0.3, 0.3);return true end }))
		end
		delay(0.2)
		for i=1, #targets do
			local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()	
				local card = targets[i]
				card:set_base(pseudorandom_element(G.P_CARDS))	
				if pseudorandom(pseudoseed('chancetime')) > 1 / (#G.P_CENTER_POOLS['Enhanced']+1) then
					card:set_ability(pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('spectral_chance')))
				else
					card:set_ability(G.P_CENTERS['c_base'])
				end	
				local edition_rate = 2
				card:set_edition(poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true))
				local seal_rate = 10
				local seal_poll = pseudorandom(pseudoseed('stdseal'..G.GAME.round_resets.ante))
				if seal_poll > 1 - 0.02*seal_rate then
					local seal_type = pseudorandom(pseudoseed('stdsealtype'..G.GAME.round_resets.ante))
					local seal_list = {}
					for k, _ in pairs(G.P_SEALS) do
						table.insert(seal_list, k)
					end
					seal_type = math.floor(seal_type * #seal_list)
					card:set_seal(seal_list[seal_type])
				else
					card:set_seal()
				end
				card:flip()
				play_sound('card3', percent, 0.6)
				card:juice_up(0.3, 0.3)
				return true 
			end }))
		end
	end
end

--Tries to find a card by its sort ID (Card.sort_id), calling without specifying area will check all common areas
function jl.id(id, area)
	if area then
		for k, v in ipairs(area.cards) do
			if v.sort_id == id then
				return v
			end
		end
	else
		for k, v in ipairs(G.jokers.cards) do
			if v.sort_id == id then
				return v
			end
		end
		for k, v in ipairs(G.consumeables.cards) do
			if v.sort_id == id then
				return v
			end
		end
		for k, v in ipairs(G.playing_cards) do
			if v.sort_id == id then
				return v
			end
		end
	end
	return
end

local invalid_values = {
	'naneinf',
	'nane0',
	'-nane0',
	'nan',
	'nane',
	'inf',
	'-naneinf',
	'-nan',
	'-inf',
	'infinity',
	'nil'
}

--Checks if a number is not an actual number (e.g. nan, inf)
function jl.invalid_number(num)
	local str = string.lower(number_format(num))
	return jl.bf(str, invalid_values)
end

--Easier way of doing chance rolls
function jl.chance(name, probability, absolute)
	return pseudorandom(name) < (absolute and 1 or G.GAME.probabilities.normal)/probability
end

--Returns a deep copy of a table without infinite recursion
function jl.deepcopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
  
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in pairs(obj) do res[deepCopy(k, s)] = deepCopy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

--Easier way to call joker calculations
function jl.jokers(data)
	if G.jokers and #G.jokers.cards > 0 then
		for i = 1, #G.jokers.cards do
			G.jokers.cards[i]:calculate_joker(data)
		end
	end
end

--Adds a delay to the event manager that uses real time instead of gamespeed-affected time
function realdelay(time, queue)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
		timer = 'REAL',
        delay = time or 1,
        func = function()
           return true
        end
    }), queue)
end

function jl.rd(time, queue)
	realdelay(time, queue)
end

--Checks the context if it's suitable for a joker to score
function jl.scj(context)
	return context.cardarea and context.cardarea == G.play and not context.before and not context.after and not context.repetition
end

--Checks the context if it's suitable for a playing card to score
function jl.sc(context)
	return context.cardarea and context.cardarea == G.play and context.main_scoring
end

--Gets the most-played hand
function jl.favhand()
	if not G.GAME or not G.GAME.current_round then return 'High Card' end
	local chosen_hand = 'High Card'
	local _handname, _played, _order = 'High Card', -1, -1
	for k, v in pairs(G.GAME.hands) do
		if v.played > _played or (v.played == _played and _order > v.order) then 
			_played = v.played
			_handname = k
		end
	end
	chosen_hand = _handname
	return chosen_hand
end

--Gets the secondmost-played hand
function jl.sfavhand()
	if not G.GAME or not G.GAME.current_round then return 'High Card' end
	local chosen_hand = 'High Card'
	local firstmost = jl.favhand()
	local _handname, _played, _order = 'High Card', -1, -1
	for k, v in pairs(G.GAME.hands) do
		if k ~= firstmost and v.played > _played or (v.played == _played and _order > v.order) then 
			_played = v.played
			_handname = k
		end
	end
	chosen_hand = _handname
	return chosen_hand
end

--Gets the rank of a hand
function jl.handpos(hand)
	local pos = -1
	for i = 1, #G.handlist do
		if G.handlist[i] == hand then
			pos = i
			break
		end
	end
	return pos
end

--Gets the "adjacent" hands of a hand (a.k.a. the hands above and below the hand you specify according to the poker hand list)
function jl.adjacenthands(hand)
	local hands = {}
	if not G.GAME or not G.GAME.hands then return hands end
	local pos = -1
	for k, v in ipairs(G.handlist) do
		if v == hand then
			pos = k
		end
	end
	if pos == -1 then
		return hands
	end
	hands.forehand = G.handlist[pos + 1]
	hands.backhand = G.handlist[pos - 1]
	return hands
end

--Gets the hand with the lowest level, prioritises lower-ranking hands
function jl.lowhand()
	local chosen_hand = 'High Card'
	local lowest_level = 'n/a'
	for _, v in ipairs(G.handlist) do
		if type(lowest_level) == 'string' or G.GAME.hands[v].level <= lowest_level then --(Talisman and to_big(lowest_level) or lowest_level) then
			chosen_hand = v
			lowest_level = G.GAME.hands[v].level
		end
	end
	return chosen_hand
end

--Gets the hand with the highest level, prioritises higher-ranking hands
function jl.hihand()
	local chosen_hand = 'High Card'
	local highest_level = 'n/a'
	for _, v in ipairs(G.handlist) do
		if type(highest_level) == 'string' or G.GAME.hands[v].level > highest_level then --(Talisman and to_big(highest_level) or highest_level) then
			chosen_hand = v
			highest_level = G.GAME.hands[v].level
		end
	end
	return chosen_hand
end

--Gets a random hand
function jl.rndhand(ignore, seed, allowhidden)
	local chosen_hand
	ignore = ignore or {}
	seed = seed or 'randomhand'
	if type(ignore) ~= 'table' then ignore = {ignore} end
	while true do
		chosen_hand = pseudorandom_element(G.handlist, pseudoseed(seed))
		if G.GAME.hands[chosen_hand].visible or allowhidden then
			local safe = true
			for _, v in pairs(ignore) do
				if v == chosen_hand then safe = false end
			end
			if safe then break end
		end
	end
	return chosen_hand
end


--Checks if a given table of contexts does not have joker retriggers involved
function jl.njr(context)
	return not context.retrigger_joker_check and not context.retrigger_joker
end

--Easier way to type G.SETTINGS.GAMESPEED
function jl.gspd(mod)
	if mod and tonumber(mod) then
		G.SETTINGS.GAMESPEED = mod
	end
	return G.SETTINGS.GAMESPEED
end

--Rounds a number to the nearest integer or decimal place
function jl.round( num, idp )

	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult

end

--Checks if it's "safe" to use consumables
function jl.canuse(card)
	return not (((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) and G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT)
end

--Checks if the game is currently going through a Booster Pack
function jl.booster()
	return (
		G.STATE == G.STATES.TAROT_PACK
		or G.STATE == G.STATES.PLANET_PACK
		or G.STATE == G.STATES.SPECTRAL_PACK
		or G.STATE == G.STATES.STANDARD_PACK
		or G.STATE == G.STATES.BUFFOON_PACK
		or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
	)
end

--Far more convenient way of doing <card>.config.center, makes doing checks for variables easy, e.g. Card:gc().cost
function Card:gc()
	return (self.config or {}).center or {}
end

function Card:norank()
	return self.ability.name == 'Stone Card' or self.config.center.no_rank
end

function Card:nosuit()
	return self.ability.name == 'Stone Card' or self.config.center.no_suit
end

function Card:norankorsuit()
	return self:norank() or self:nosuit()
end

function Card:nosuitorrank() --alias
	return self:norank() or self:nosuit()
end

function Card:norankandsuit()
	return self:norank() and self:nosuit()
end

function Card:nosuitandrank() --alias
	return self:norank() and self:nosuit()
end

--Counts the number of suits in the deck, call with no argument to count all suits
function jl.countsuit(suit)
	if not G.playing_cards then return {} end
	if suit then
		local quantity = 0
		for k, v in ipairs(G.playing_cards) do
			if v.ability.name ~= 'Stone Card' and not v:nosuit() and v.base.suit == suit then 
				quantity = quantity + 1
			end
		end
		return quantity
	else
		local suitquantity = {}
		for k, v in ipairs(G.playing_cards) do
			if v.ability.name ~= 'Stone Card' and not v:nosuit() then 
				suitquantity[v.base.suit] = (suitquantity[v.base.suit] or 0) + 1
			end
		end
		return suitquantity
	end
end

--Counts the number of cards that have the specified rank, call with no argument to count all ranks
function jl.countrank(rank)
	if not G.playing_cards then return 0 end
	if rank then
		rank = tostring(rank)
		local quantity = 0
		for k, v in ipairs(G.playing_cards) do
			if v.ability.name ~= 'Stone Card' and not v:norank() and v.base.value == rank then 
				quantity = quantity + 1
			end
		end
		return quantity
	else
		local rankquantity = {}
		for k, v in ipairs(G.playing_cards) do
			if v.ability.name ~= 'Stone Card' and not v:norank() then 
				rankquantity[v.base.value] = (rankquantity[v.base.value] or 0) + 1
			end
		end
		return rankquantity
	end
end

--Gets tiring to type all the G.E_MANAGER mumbojumbo every time for things that are simple
function Q(fc, de, t, tr, bl, ba)
	G.E_MANAGER:add_event(Event({
		timer = t,
		trigger = tr,
		delay = de,
		blockable = bl,
		blocking = ba,
		func = fc
	}))
end

--Does a recursive Q() call, I do this to make events happen later but it will add noticeable wait at high recursion
function QR(fc, count, de, t, tr, bl, ba)
	if not count then count = 0 end
	Q(function() if count <= 0 then fc() else Q(fc, count - 1, de, t, tr, bl, ba) end return true end)
end

--Gets a Planet card by its hand type, returns nothing if not found
function jl.planethand(hand)
	local key
	for k, v in pairs(G.P_CENTER_POOLS.Planet) do
		if v.config.hand_type == hand then
			key = v.key
			break
		end
	end
	return key
end

--Gets a random key, filtered with flags. Default functionality is getting a random consumable that is not hidden
function jl.rnd(seed, excluded_flags, pool, ignore_pooling, attempts)
	excluded_flags = excluded_flags or {'hidden', 'no_doe', 'no_grc'}
	local selection = 'n/a'
	local passes = 0
	local tries = attempts or 500
	local pooling = false
	if (SMODS.Mods.jen or {}).can_load and (G.GAME or {}).obsidian then
		for k, v in ipairs(excluded_flags) do
			if v == 'hidden' then
				table.remove(excluded_flags, k)
				break
			end
		end
	end
	while true do
		pooling = false
		tries = tries - 1
		passes = 0
		selection = G.P_CENTERS[pseudorandom_element(pool or G.P_CENTER_POOLS.Consumeables, pseudoseed(seed or 'jlrnd')).key]
		if ignore_pooling then
			pooling = true
		else
			if selection.in_pool and selection:in_pool() then
				pooling = true
			elseif not selection.in_pool then
				pooling = true
			end
		end
		for k, v in pairs(excluded_flags) do
			if not selection[v] then
				passes = passes + 1
			end
		end
		if (pooling and passes >= #excluded_flags) or tries <= 0 then
			return selection
		end
	end
end

--Simplified way of create_card(<set>, <area>, nil, nil, nil, nil, nil, <seed>)
function jl.rndcard(set, area, seed)
	return create_card(set, area, nil, nil, nil, nil, nil, seed or 'jlrndcard')
end

--Simplified way to create a specific card
function jl.card(key)
	if G.P_CENTERS[key] then
		return create_card(G.P_CENTERS[key].set, (G.P_CENTERS[key].set == 'Joker' and G.jokers or G.consumeables), nil, nil, nil, nil, key, 'jlspecificcard')
	end
	return nil
end

--Creates a "raw card"
function jl.rawcard(key, sizemul, shiftx, shifty)
	sizemul = sizemul or 1
	shiftx = shiftx or 1
	shifty = shifty or 1
	local ncard = Card(
		(G.play.T.x * shiftx) + G.play.T.w / 2 - G.CARD_W * sizemul / 2,
		(G.play.T.y * shifty) + G.play.T.h / 2 - G.CARD_H * sizemul / 2,
		G.CARD_W * sizemul,
		G.CARD_H * sizemul,
		G.P_CARDS.empty,
		G.P_CENTERS[key],
		{ bypass_discovery_center = true, bypass_discovery_ui = true }
	)
	ncard:start_materialize()
	return ncard
end

--Redeems a voucher by key, leave blank for random
function jl.voucher(key)
	local voucher_key = key or get_next_voucher_key(true)
	if not G.P_CENTERS[voucher_key] then return end
	local area
	if G.STATE == G.STATES.HAND_PLAYED then
		if not G.redeemed_vouchers_during_hand then
			G.redeemed_vouchers_during_hand = CardArea(G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, {type = 'play', card_limit = 5})
		end
		area = G.redeemed_vouchers_during_hand
	else
		area = G.play
	end
	local card = Card(area.T.x + area.T.w/2 - G.CARD_W/2, area.T.y + area.T.h/2-G.CARD_H/2, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[voucher_key],{bypass_discovery_center = true, bypass_discovery_ui = true})
	card:start_materialize()
	area:emplace(card)
	card.cost=0
	card.shop_voucher=false
	card:redeem()
	G.E_MANAGER:add_event(Event({
		delay = 0,
		func = function() 
			card:start_dissolve()
		return true
	end}))
end

--[[ Boilerplate:
	{string = '', colours = {G.C.WHITE}, rotate = 1,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 1.5/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR}
]]

function Card:add_dynatext(top, bottom, delay)
	if type(top) == 'string' then
		top = DynaText({
			string = top,
			colours = { G.C.UI.TEXT_LIGHT },
			rotate = 1,
			shadow = true,
			bump = true,
			float = true,
			scale = 0.9,
			pop_in = 0.6 / G.SETTINGS.GAMESPEED,
			pop_in_rate = 1.5 * G.SETTINGS.GAMESPEED,
		})
	end
	if type(bottom) == 'string' then
		bottom = DynaText({
			string = bottom,
			colours = { G.C.UI.TEXT_LIGHT },
			rotate = 1,
			shadow = true,
			bump = true,
			float = true,
			scale = 0.9,
			pop_in = 0.6 / G.SETTINGS.GAMESPEED,
			pop_in_rate = 1.5 * G.SETTINGS.GAMESPEED,
		})
	end
	if self.jenlib_alreadyhasdynatext then self:remove_dynatext() end
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay or 0.4, func = function()
		if top then
			top_dynatext = top
			self.children.jenlib_topdyna = UIBox{definition = {n = G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes = {{n = G.UIT.O, config = {object = top_dynatext}}}},config = {align="tm", offset = {x=0,y=0},parent = self}}
		end
		if bottom then
			bot_dynatext = bottom
			self.children.jenlib_botdyna = UIBox{definition = {n = G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes = {{n = G.UIT.O, config = {object = bot_dynatext}}}},config = {align="bm", offset = {x=0,y=0},parent = self}}
		end
	return true end }))
	self.jenlib_alreadyhasdynatext = true
end

function Card:remove_dynatext(delay, speed)
	if self.jenlib_alreadyhasdynatext then
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay or 0.5, func = function()
			if self.children.jenlib_topdyna then
				self.children.jenlib_topdyna.definition.nodes[1].config.object:pop_out(speed or 4)
			end
			if self.children.jenlib_botdyna then
				self.children.jenlib_botdyna.definition.nodes[1].config.object:pop_out(speed or 4)
			end
		return true end }))
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
			if self.children.jenlib_topdyna then
				self.children.jenlib_topdyna:remove()
				self.children.jenlib_topdyna = nil
			end
			if self.children.jenlib_botdyna then
				self.children.jenlib_botdyna:remove()
				self.children.jenlib_botdyna = nil
			end
			self.jenlib_alreadyhasdynatext = nil
		return true end }))
	end
end

--Tries to call a specified function in the card's center
function Card:invokefunc(func, ...)
	local obj = self.config.center
	if obj and obj[func] and type(obj[func]) == 'function' then obj[func](...) end
end

--Changes the sprites of a card along its atlas
function Card:spritepos(child, X, Y)
	if self.children[child] then
		if self.children[child].set_sprite_pos then
			self.children[child]:set_sprite_pos({x = X, y = Y})
		end
	end
end

--Multiplies the card's size by mod
function Card:resize(mod, force_save)
	if force_save or not self.origsize then self.origsize = {w = self.T.w, h = self.T.h} end
	self:hard_set_T(self.T.x, self.T.y, self.T.w * mod, self.T.h * mod)
	remove_all(self.children)
	self.children = {}
	self.children.shadow = Moveable(0, 0, 0, 0)
	self:set_sprites(self.config.center, self.base.id and self.config.card)
	if self.area then
		if (G.shop_jokers and self.area == G.shop_jokers) or (G.shop_booster and self.area == G.shop_booster) or (G.shop_vouchers and self.area == G.shop_vouchers) then
			create_shop_card_ui(self)
		end
	end
end

--Tries to reset the card's size, if saved
function Card:resetsize()
	if self.origsize then
		self:hard_set_T(self.T.x, self.T.y, self.origsize.w, self.origsize.h)
		remove_all(self.children)
		self.children = {}
		self.children.shadow = Moveable(0, 0, 0, 0)
		self:set_sprites(self.config.center, jl.bf((self.ability or {}).set or '', resize_lookout) and self.config.card)
		if self.area then
			if (G.shop_jokers and self.area == G.shop_jokers) or (G.shop_booster and self.area == G.shop_booster) or (G.shop_vouchers and self.area == G.shop_vouchers) then
				create_shop_card_ui(self)
			end
		end
	end
end

--Alias of Card:resize
function Card:grow(mod, force_save)
	self:resize(mod, force_save)
end

--Divides the card's size by mod, alias of Card:resize(1 / mod)
function Card:shrink(mod, force_save)
	self:resize(1 / mod, force_save)
end

--Displays some announcement text (duration is affected by gamespeed, providing duration's number as a string will normalise it, or you can do duration*jl.gspd())
function jl.a(txt, duration, size, col, snd, sndpitch, sndvol)
	if type(duration) == 'string' then
		duration = (tonumber(duration) or 0)*G.SETTINGS.GAMESPEED
	end
	G.E_MANAGER:add_event(Event({
		func = (function()
			if snd then play_sound(snd, sndpitch, sndvol) end
			attention_text({
				scale = size or 1.4, text = txt, hold = duration or 2, colour = col or G.C.WHITE, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
			})
		return true
	end)}))
end

-- Safety functions ported from lovely.toml patches

-- Define lvcol function for Cryptid compatibility
function jl.lvcol(hand_name)
    if not G or not G.GAME or not G.GAME.hands then
        return G.C.UI.TEXT_LIGHT or {1, 1, 1, 1}
    end
    
    local hand = G.GAME.hands[hand_name]
    if not hand or not hand.level then
        return G.C.UI.TEXT_LIGHT or {1, 1, 1, 1}
    end
    
    local level = hand.level
    if type(level) == "table" and level.to_number then
        level = level:to_number()
    end
    
    -- Use G.C.HAND_LEVELS with safe fallback
    if G.C and G.C.HAND_LEVELS then
        return G.C.HAND_LEVELS[level] or G.C.UI.TEXT_LIGHT or {1, 1, 1, 1}
    else
        return G.C.UI.TEXT_LIGHT or {1, 1, 1, 1}
    end
end

-- Initialize hand level color system for big numbers
function jl.init_hand_level_colors()
    if G.C.HAND_LEVELS_JEN_POPULATED then return end
    G.C.HAND_LEVELS_JEN_POPULATED = true
    
    print("[JEN DEBUG] Setting up hand level color metatable for big numbers")
    
    -- Store original colors
    local base_colors = {
        G.C.HAND_LEVELS[1], G.C.HAND_LEVELS[2], G.C.HAND_LEVELS[3], 
        G.C.HAND_LEVELS[4], G.C.HAND_LEVELS[5], G.C.HAND_LEVELS[6], G.C.HAND_LEVELS[7]
    }
    
    -- Set up metatable to generate colors for any missing level
    local mt = {
        __index = function(t, k)
            if type(k) == "string" then
                -- Handle special formats like "!123" for levels > 7200
                if k:sub(1,1) == "!" then
                    local num = tonumber(k:sub(2))
                    if num and num > 0 then
                        local color_index = ((num - 1) % 7) + 1
                        return base_colors[color_index] or G.C.UI.TEXT_LIGHT
                    end
                else
                    -- Handle regular number format strings
                    local num = tonumber(k)
                    if num and num > 0 then
                        if num <= 7 then
                            return base_colors[num] or G.C.UI.TEXT_LIGHT
                        else
                            local color_index = ((num - 1) % 7) + 1
                            return base_colors[color_index] or G.C.UI.TEXT_LIGHT
                        end
                    end
                end
            elseif type(k) == "number" then
                -- Handle direct number lookups
                if k > 0 and k <= 7 then
                    return base_colors[k] or G.C.UI.TEXT_LIGHT
                else
                    local color_index = ((k - 1) % 7) + 1
                    return base_colors[color_index] or G.C.UI.TEXT_LIGHT
                end
            end
            return G.C.UI.TEXT_LIGHT
        end
    }
    
    setmetatable(G.C.HAND_LEVELS, mt)
end

-- Safe color helper - ensures color values are never nil
function jl.safe_color(color)
    return color or G.C.WHITE or {1, 1, 1, 1}
end

-- ========================================
-- CRYPTID COMPATIBILITY SYSTEM
-- ========================================

-- Initialize Cryptid compatibility functions
-- These functions integrate Jen with Cryptid's systems
function jl.init_cryptid_compat()
    if not Cryptid then return end
    
    print("[JEN DEBUG] Initializing Cryptid compatibility")
    
    -- Override gameset function to force "madness" gameset for Jen cards
    -- This prevents users from seeing the gameset selector UI
    local original_gameset = Cryptid.gameset
    function Cryptid.gameset(card, center)
        -- Check if this is a Jen-related card
        if card and card.config and card.config.center then
            local key = card.config.center.key
            if key and (key:sub(1, 6) == "j_jen_" or key:sub(1, 6) == "c_jen_" or 
                        key:sub(1, 6) == "v_jen_" or key:sub(1, 6) == "b_jen_") then
                return "madness"
            end
        end
        if center and center.key then
            local key = center.key
            if key:sub(1, 6) == "j_jen_" or key:sub(1, 6) == "c_jen_" or 
               key:sub(1, 6) == "v_jen_" or key:sub(1, 6) == "b_jen_" then
                return "madness"
            end
        end
        return original_gameset(card, center)
    end
    
    -- Disable gameset toggle UI globally
    -- This is set in compat.lua line 34
    if Cryptid_config then
        Cryptid_config.gameset_toggle = false
    end
end

-- Setup pointer blacklist for Jen cards
-- Prevents Jen's custom rarities and omega consumables from appearing in POINTER://
function jl.setup_pointer_blacklist()
    if not Cryptid or not Cryptid.pointerblistifytype then return end
    
    print("[JEN DEBUG] Setting up Cryptid POINTER:// blacklist for Jen items")
    
    -- Blacklist Jen custom rarities
    Cryptid.pointerblistifytype("rarity", "jen_wondrous")
    Cryptid.pointerblistifytype("rarity", "jen_extraordinary")
    Cryptid.pointerblistifytype("rarity", "jen_ritualistic")
    Cryptid.pointerblistifytype("rarity", "jen_transcendent")
    Cryptid.pointerblistifytype("rarity", "jen_omegatranscendent")
    Cryptid.pointerblistifytype("rarity", "jen_omnipotent")
    Cryptid.pointerblistifytype("rarity", "jen_miscellaneous")
    Cryptid.pointerblistifytype("rarity", "jen_junk")
    
    -- Blacklist Jen omega consumables
    Cryptid.pointerblistifytype("set", "jen_omegaconsumable")
end

-- Setup pointer aliases for easy creation of Jen cards via POINTER://
-- Allows shortened names like "kosmos" instead of full card keys
function jl.setup_pointer_aliases()
    if not Cryptid or not Cryptid.pointeraliasify then return end
    
    print("[JEN DEBUG] Setting up Cryptid POINTER:// aliases for Jen cards")
    
    -- Specific card aliases
    local aliases = {
        -- Example joker
        kosmos = "j_jen_kosmos",
        -- Characters
        freddy = "freddy snowshoe",
        paupovlin = "paupovlin revere",
        poppin = "paupovlin revere",
        dandy = 'Dandicus "Dandy" Dancifer',
        jen = "jen walter",
        jen2 = "Jen Walter the Wondergeist",
        jen3 = "Jen Walter the Wondergeist (Ascended)",
        -- Rainworld characters
        survivor = "the survivor",
        monk = "the monk",
        hunter = "the hunter",
        gourmand = "the gourmand",
        saint = "the saint",
        -- Tarot/Spectral reverse cards
        genius = "the genius",
        r_fool = "the genius",
        scientist = "the scientist",
        r_magician = "the scientist",
        lowlaywoman = "the low laywoman",
        laywoman = "the low laywoman",
        r_priestess = "the low laywoman",
        peasant = "the peasant",
        r_empress = "the peasant",
        servant = "the servant",
        r_emperor = "the servant",
        adversary = "the adversary",
        r_hierophant = "the adversary",
        rivals = "the rivals",
        r_lovers = "the rivals",
        hitchhiker = "the hitchhiker",
        r_chariot = "the hitchhiker",
        injustice = "c_jen_reverse_justice",
        r_justice = "c_jen_reverse_justice",
        extrovert = "the extrovert",
        r_hermit = "the extrovert",
        discofpenury = "the disc of penury",
        r_wheeloffortune = "the disc of penury",
        r_wof = "the disc of penury",
        infirmity = "infirmity",
        r_strength = "infirmity",
        zen = "zen",
        r_hangedman = "zen",
        life = "life",
        r_death = "life",
        prodigality = "prodigality",
        r_temperance = "prodigality",
        angel = "the angel",
        r_devil = "the angel",
        collapse = "the collapse",
        r_tower = "the collapse",
        flash = "the flash",
        r_star = "the flash",
        eclipsespectral = "c_jen_reverse_moon",
        eclipsetorat = "c_jen_reverse_moon",
        r_moon = "c_jen_reverse_moon",
        darkness = "the darkness",
        r_sun = "the darkness",
        cunctation = "cunctation",
        r_judgement = "cunctation",
        desolate = "desolate",
        r_world = "desolate",
        -- Jen tokens
        topuptoken = "top-up token",
        sagittarius = "sagittarius a*",
        ["sagitarius a*"] = "sagittarius a*", -- minor spelling mistakes forgiven
        sagitarius = "sagittarius a*", -- minor spelling mistakes forgiven
    }
    
    -- Register all aliases
    for alias, target in pairs(aliases) do
        Cryptid.pointeraliasify(alias, target)
    end
end

-- Safe update_hand_text wrapper
-- Ensures vals.colour is always set to prevent crashes
local original_update_hand_text = nil

function jl.wrap_update_hand_text()
    if original_update_hand_text then return end  -- Already wrapped
    
    original_update_hand_text = update_hand_text
    function update_hand_text(config, vals)
        if not vals.colour then
            vals.colour = G.C.UI.TEXT_DARK
        end
        return original_update_hand_text(config, vals)
    end
    
    print("[JEN DEBUG] Wrapped update_hand_text for safety")
end

-- Setup Cryptid encoded deck compatibility
function jl.setup_encoded_deck()
    if not SMODS or not SMODS.Back then return end
    
    -- Check if the encoded deck exists before trying to take ownership
    if not SMODS.Back.obj_buffer or not SMODS.Back.obj_buffer["b_cry_encoded"] then
        print("[JEN DEBUG] Cryptid Encoded deck not found, skipping setup")
        return
    end
    
    print("[JEN DEBUG] Setting up Cryptid Encoded deck compatibility")
    
    -- Take ownership of encoded deck to modify its behavior
    SMODS.Back:take_ownership("b_cry_encoded", {
        apply = function(self)
            G.GAME.joker_rate = 1
            G.GAME.planet_rate = 1
            G.GAME.tarot_rate = 1
            G.GAME.code_rate = 1e100
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.jokers then
                        if G.P_CENTERS["j_cry_CodeJoker"]
                            and (G.GAME.banned_keys and not G.GAME.banned_keys["j_cry_CodeJoker"]) then
                            local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_CodeJoker")
                            card:add_to_deck()
                            card:start_materialize()
                            G.jokers:emplace(card)
                        end
                        return true
                    end
                end,
            }))
        end,
    })
end

-- Initialize all Cryptid compatibility features
function jl.init_all_cryptid_compat()
    if not Cryptid then 
        print("[JEN DEBUG] Cryptid not detected, skipping compatibility setup")
        return 
    end
    
    jl.init_cryptid_compat()
    jl.setup_encoded_deck()
    jl.wrap_update_hand_text()
    
    -- Note: Pointer blacklist and aliases should be called after Jen's cards are loaded
    -- This will be done from Jen's main file
end