EremelUtility = {}
EremelUtility.page_cycler_values = {}

G.FUNCS.eremel_default = function(e)
    local args = e.config.pass_through
    local page_from = EremelUtility.page_cycler_values[args.key].page
    local page_to = EremelUtility.page_cycler_values[args.key].page + e.config.direction
    if page_to == 0 then page_to = args.total_pages
    elseif page_to > args.total_pages then page_to = 1 end
    EremelUtility.page_cycler_values[args.key].page = page_to
    EremelUtility.page_cycler_values[args.key].text = localize('k_page')..' '..EremelUtility.page_cycler_values[args.key].page..'/'..args.total_pages
    
    
    if e.config.switch_func and type(e.config.switch_func) == 'function' then
        e.config.switch_func({from = page_from, to = page_to})
    else
        sendInfoMessage('No switch_func provided', 'EremelUtility')
        sendInfoMessage(tprint({from = page_from, to = page_to}), 'EremelUtility')
    end
end

function EremelUtility.page_cycler(args)
    args = args or {}
    args.left = args.left or '<'
    args.right = args.right or '>'
    args.colour = args.colour or HEX('3FC7EB')
    args.button_colour = args.button_colour or G.C.WHITE
    args.button = args.button or 'eremel_default'
    args.switch_func = args.switch_func
    args.hover = args.hover or true
    args.object_table = args.object_table -- REQUIRED
    args.page_size = args.page_size -- REQUIRED
    args.page_label = args.page_label -- REQUIRED
    args.label_colour = args.label_colour or G.C.WHITE
    args.scale = args.scale or 0.5
    args.button_w = args.button_w or 3
    args.w = args.w or 8
    args.shadow = args.shadow or true

    local error = {n=G.UIT.C, config = {r=0.1, colour = G.C.RED, align = 'cm', padding = 0.1}, nodes = {}}
    if not args.key then
        error.nodes[#error.nodes + 1] = {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = 'Page Cycler missing key', scale = args.scale, colour = G.C.BLACK, shadow = true}}}}
    end
    if not args.object_table then
        error.nodes[#error.nodes + 1] = {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = 'Page Cycler missing object_table', scale = args.scale, colour = G.C.BLACK, shadow = true}}}}
    end
    if not args.page_size then
        error.nodes[#error.nodes + 1] = {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = 'Page Cycler missing page_size', scale = args.scale, colour = G.C.BLACK, shadow = true}}}}
    end
    
    if #error.nodes > 0 then return error end
    
    args.total_pages = math.ceil(table.size(args.object_table)/args.page_size)

    if not args.page_label then
        EremelUtility.page_cycler_values[args.key] = {page = 1}
        EremelUtility.page_cycler_values[args.key].text = localize('k_page')..' '..EremelUtility.page_cycler_values[args.key].page..'/'..args.total_pages
        args.page_label = EremelUtility.page_cycler_values[args.key]
    end 

    local cycler = {n=G.UIT.R, config = {align = 'cm', minh = args.h or nil}, nodes = {
        table.size(args.object_table) > args.page_size and {n=G.UIT.C, config={pass_through = args, switch_func = args.switch_func, r = 0.1, colour = args.colour, minw = args.button_w * args.scale, align = 'tm', shadow = args.shadow, direction = -1, button = args.button, hover = args.hover, minh = 0.5}, nodes = {
            {n=G.UIT.T, config = {text = args.left, scale = args.scale, colour = args.button_colour}}
        }} or nil,
        table.size(args.object_table) > args.page_size and {n=G.UIT.C, config = {align = 'cm', minw = args.w * args.scale}, nodes = {
            {n=G.UIT.O, config = {object = DynaText({
                string = {{ref_table = args.page_label, ref_value = 'text'}},
                scale = args.scale,
                colours = {args.label_colour},
                pop_in_rate = 0,
                silent = true
            })}}
        }} or nil,
        table.size(args.object_table) > args.page_size and {n=G.UIT.C, config={pass_through = args, switch_func = args.switch_func, r = 0.1, colour = args.colour, minw = args.button_w * args.scale, align = 'tm', shadow = args.shadow, direction = 1, button = args.button, hover = args.hover, minh = 0.5}, nodes = {
            {n=G.UIT.T, config = {text = args.right, scale = args.scale, colour = args.button_colour}}
        }} or nil,
    }}

    return cycler
end

function EremelUtility.create_toggle(args)
    args = args or {}
    args.active_colour = args.active_colour or HEX('3FC7EB')
    args.inactive_colour = args.inactive_colour or G.C.BLACK
    args.w = args.w or 3
    args.h = args.h or 0.5
    args.scale = args.scale or 1
    args.label = args.label or 'TEST?'
    args.label_scale = args.label_scale or 0.4
    args.ref_table = args.ref_table or {}
    args.ref_value = args.ref_value or 'test'
    args.left = args.left or false
    args.right = args.right or true
    args.info_above = args.info_above or false

    local error = {n=G.UIT.C, config = {r=0.1, colour = G.C.RED, align = 'cm', padding = 0.1}, nodes = {}}

    if args.left and args.right then
        error.nodes[#error.nodes + 1] = {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = 'Left and Right selected', scale = args.scale, colour = G.C.BLACK, shadow = true}}}}
    end

    if #error.nodes > 0 then return error end

    local check = Sprite(0,0,0.5*args.scale,0.5*args.scale,G.ASSET_ATLAS["icons"], {x=1, y=0})
    check.states.drag.can = false
    check.states.visible = false

    local info = nil
    if args.info then 
        info = {}
        for k, v in ipairs(args.info) do 
            table.insert(info, {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
            {n=G.UIT.T, config={text = v, scale = 0.25, colour = G.C.UI.TEXT_LIGHT}}
            }})
        end
        info =  {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes=info}
    end

    local toggle = {n=G.UIT.C, config = {align = 'cm', minw = 0.3*args.w}, nodes = {
        {n=G.UIT.C, config = {align = 'cm', r=0.1, colour = G.C.BLACK}, nodes={
            {n=G.UIT.C, config={align = "cm", r = 0.1, padding = 0.03, minw = 0.4*args.scale, minh = 0.4*args.scale, outline_colour = args.outline or G.C.WHITE, outline = 1.2*args.scale, line_emboss = 0.5*args.scale, ref_table = args,
                colour = args.inactive_colour,
                button = 'toggle_button', button_dist = 0.2, hover = true, toggle_callback = args.callback, func = 'toggle', focus_args = {funnel_to = true}}, nodes={
                {n=G.UIT.O, config={object = check}},
            }}
        }}
    }}

    local label = {n=G.UIT.C, config={align = args.left and 'cr' or 'cl', minw = args.w}, nodes={
        {n=G.UIT.T, config={text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT}},
        {n=G.UIT.B, config={w = 0.1, h = 0.1}},
    }}

    local t = 
        {n=args.col and G.UIT.C or G.UIT.R, config={align = args.left and 'cr' or 'cl', padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = {funnel_from = true}}, nodes={
            args.left and label or nil,
            toggle,
            args.right and label or nil
        }}

    if args.info then 
        t = {n=args.col and G.UIT.C or G.UIT.R, config={align = "cm"}, nodes={
        args.info_above and info or nil,
        t,
        args.info_above and nil or info,
        }}
    end
    return t
end

function table.size(table)
    local size = 0
    for _,_ in pairs(table) do
        size = size + 1
    end
    return size
end