local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local M = {}

local humam_readable = function(value)
    local suffixes = { "M", "G", "T", "P", "E", "Z", "Y" }
    local suffix = 1
    while value > 1024 do
        value = value / 1024
        suffix = suffix + 1
    end
    return string.format("%.2f %sB", value, suffixes[suffix])
end

local memory_script = "bash -c \"free -m | grep Mem | awk '{print $2, $3}'\""

function M.new()
    local watch_widget = wibox.widget({
        widget = awful.widget.watch(memory_script, 15, function(widget, stdout)
            local parts = gears.string.split(stdout, " ")
            local total = tonumber(parts[1])
            local used = tonumber(parts[2])

            local text = humam_readable(used)
            if used >= (math.floor(total * 0.9)) then
                text = '<span background="#f38ba8" foreground="#1e1e2e">' .. text .. '</span>'
            end

            widget:set_markup(text)
        end),
        font = beautiful.font_text_with_size(beautiful.wibar_widget_font_size, "Bold"),
        spaccing = dpi(3),
    })

    local widget = wibox.widget({
        {
            {
                {
                    watch_widget,
                    widget = wibox.container.margin,
                    top = dpi(2),
                    bottom = dpi(2),
                    left = dpi(10),
                    right = dpi(10),
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

    return widget
end

return M
