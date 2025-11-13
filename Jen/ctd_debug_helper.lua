-- CTD Debug Helper
-- Add this at the top of Jen.lua to track function calls that might be causing CTD
-- You can enable/disable different debug sections as needed

local CTD_DEBUG = {
    enabled = true,
    track_ante = true,
    track_rounds = true, 
    track_events = true,
    track_malice = true,
    log_file = "Jen/ctd_debug_detailed.log"
}

local function debug_log(message, category)
    if not CTD_DEBUG.enabled then return end
    local timestamp = os.date("[%H:%M:%S]")
    local log_message = timestamp .. " [" .. (category or "DEBUG") .. "] " .. message
    
    -- Print to console (if DebugPlus available)
    if print then print(log_message) end
    
    -- Try to write to file
    pcall(function()
        local file = io.open(CTD_DEBUG.log_file, "a")
        if file then
            file:write(log_message .. "\n")
            file:close()
        end
    end)
end

-- Function wrapper to trace calls
local function wrap_function(original_func, func_name)
    return function(...)
        if CTD_DEBUG.enabled then
            debug_log("ENTER: " .. func_name, "TRACE")
        end
        
        local success, result = pcall(original_func, ...)
        
        if success then
            if CTD_DEBUG.enabled then
                debug_log("EXIT: " .. func_name .. " (SUCCESS)", "TRACE")
            end
            return result
        else
            debug_log("ERROR in " .. func_name .. ": " .. tostring(result), "ERROR")
            error(result) -- Re-throw the error
        end
    end
end

-- Usage example - wrap the most suspicious functions:
--[[
-- Wrap ease_ante if it exists
if ease_ante and CTD_DEBUG.track_ante then
    local original_ease_ante = ease_ante
    ease_ante = wrap_function(original_ease_ante, "ease_ante")
end

-- Wrap add_malice if it exists  
if add_malice and CTD_DEBUG.track_malice then
    local original_add_malice = add_malice
    add_malice = wrap_function(original_add_malice, "add_malice")
end
]]--

-- Initialize debug log
if CTD_DEBUG.enabled then
    debug_log("=== CTD DEBUG SESSION " .. os.date() .. " ===", "INIT")
    debug_log("Log file location: " .. CTD_DEBUG.log_file, "INIT") 
    debug_log("Comprehensive CTD debug initialized - will track all critical game events", "INIT")
end

return CTD_DEBUG
