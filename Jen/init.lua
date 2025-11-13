-- Lightweight orchestrator for Jen modularization
local M = {}

-- Gate profiler via config if available
local function profiler_enabled()
    return (SMODS and SMODS.current_mod and SMODS.current_mod.config and SMODS.current_mod.config.profile_load) or (Jen and Jen.config and Jen.config.profile_load)
end

function M.bootstrap()
    -- Lazy containers
    local tok = jl.profile_start('init/bootstrap')
    M.data = M.data or {}
    M.modules = M.modules or {}
    jl.profile_end('init/bootstrap', tok)
end

function M.load_data()
    local tok = jl.profile_start('init/load_data')
    -- Safe require for data tables
    local ok, data_cards = pcall(function() return require('Jen/data/cards') end)
    if ok then M.data.cards = data_cards end
    jl.profile_end('init/load_data', tok)
end

function M.register_cards()
    if not M.data or not M.data.cards then return end
    local tok = jl.profile_start('init/register_cards')
    local ok, cards = pcall(function() return require('Jen/cards') end)
    if ok and cards and cards.register_from_data then
        cards.register_from_data(M.data.cards)
    end
    jl.profile_end('init/register_cards', tok)
end

function M.run()
    if profiler_enabled() then jl.profiler.enabled = true end
    M.bootstrap()
    M.load_data()
    M.register_cards()
    if profiler_enabled() then jl.profiler.report(0.2) end
end

return M


