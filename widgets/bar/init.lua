local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local widgets = require("widgets")

local separator = wibox.widget({
    widget = wibox.container.margin,
    left = dpi(5),
    right = dpi(5),
    {
        widget = wibox.widget.separator,
        color = beautiful.border_normal,
        orientation = "vertical",
        forced_width = 5,
    },
})

local function new(args)
    local screen = args.screen

    local wibar = awful.wibar({
        position = "top",
        screen = screen,
        height = dpi(38),
        type = "dock",
    })

    local launcher = widgets.launcher({ screen = screen })
    local taglist = widgets.taglist({ screen = screen })

    local date = widgets.date({ screen = screen })
    local volume = widgets.volume({ screen = screen })
    local systray = widgets.systray({ screen = screen })
    local layoutbox = widgets.layoutbox({ screen = screen })
    local memory = widgets.memory({ screen = screen })

    systray.visible = require("screen").primary == screen

    wibar:setup({
        layout = wibox.layout.align.horizontal,
        expand = "none",
        -- left
        {
            layout = wibox.container.margin,
            left = dpi(5),
            right = dpi(5),
            {
                layout = wibox.layout.align.horizontal,
                launcher,
                separator,
                taglist,
            },
        },
        -- center
        {
            layout = wibox.container.margin,
            left = dpi(5),
            right = dpi(5),
            {
                layout = wibox.layout.align.horizontal,
                date,
            },
        },
        -- right
        {
            layout = wibox.container.margin,
            left = dpi(5),
            right = dpi(5),
            {
                layout = wibox.layout.fixed.horizontal,
                memory,
                systray,
                volume,
                layoutbox,
            },
        },
    })

    return wibar
end

return setmetatable({
    new = new,
}, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
