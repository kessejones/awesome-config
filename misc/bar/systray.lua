local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local M = {}

function M.new()
    local systray = wibox.widget({
        widget = wibox.widget.systray,
        base_size = beautiful.systray_icon_size,
    })

    local widget = wibox.widget({
        {
            {
                systray,
                widget = wibox.container.margin,
            },
            widget = wibox.container.background,
            bg = beautiful.wibar_widget_bg,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 5)
            end,
        },
        widget = wibox.container.margin,
        margins = dpi(5),
    })

    return widget
end

return M
