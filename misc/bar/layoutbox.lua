local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local ui = require("helpers.ui")

local M = {}

function M.new(s)
    local layoutbox = awful.widget.layoutbox(s)
    layoutbox._layoutbox_tooltip.margins = beautiful.tooltip_margins

    local widget = wibox.widget({
        {
            {
                {
                    layoutbox,
                    widget = wibox.container.margin,
                    left = dpi(5),
                    right = dpi(5),
                    top = dpi(5),
                    bottom = dpi(5),
                },
                strategy = "exact",
                layout = wibox.container.constraint,
            },
            widget = wibox.container.background,
            bg = beautiful.wibar_widget_bg,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 5)
            end,
        },
        widget = wibox.container.margin,
        left = dpi(5),
        right = dpi(5),
        top = dpi(5),
        bottom = dpi(5),
    })

    ui.add_hover_cursor(widget, "hand2")

    return widget
end

return M
