local awful = require("awful")
local wibox = require("wibox")
local beautiful = require "beautiful"
local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi

local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")
local tags = require("misc.bar.tags")

local M = {}

function M.new(s)
    local wibar = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(38),
        type = "dock",
    })

    local tagslist = tags.new(s)

    local launcher = require("misc.bar.launcher").new()
    local volume = require("misc.bar.volume").new(s)
    local date = require("misc.bar.date").new(s)
    local layoutbox = require("misc.bar.layoutbox").new(s)
    local battery = require("misc.bar.battery").new()
    local systray = require("misc.bar.systray").new()
    local memory = require("misc.bar.memory").new()

    systray.visible = screen.primary == s

    layoutbox:buttons(Key.mouse_buttons({
        [Key.no_mod(MouseButton.Left)] = function()
            awful.layout.inc(1)
        end,
        [Key.no_mod(MouseButton.Right)] = function()
            awful.layout.inc(-1)
        end,
        [Key.no_mod(MouseButton.Up)] = function()
            awful.layout.inc(1)
        end,
        [Key.no_mod(MouseButton.Down)] = function()
            awful.layout.inc(-1)
        end,
    }))

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
                tagslist,
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
                battery,
                layoutbox,
            },
        },
    })

    s.wibar = wibar

    return wibar
end

return M
