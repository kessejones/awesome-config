local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local widgets = require("widgets")

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

local function new(_args)
    local watch_widget = wibox.widget({
        widget = awful.widget.watch(memory_script, 15, function(widget, stdout)
            local parts = gears.string.split(stdout, " ")
            local total = tonumber(parts[1])
            local used = tonumber(parts[2])

            local text = humam_readable(used)
            if used >= (math.floor(total * 0.9)) then
                text = '<span background="#f38ba8" foreground="#1e1e2e">' .. text .. "</span>"
            end

            widget:set_markup(text)
        end),
        font = beautiful.font_text_with_size(beautiful.wibar_widget_font_size, "Bold"),
        spaccing = dpi(3),
    })

    local widget = widgets.bar_item()

    widget:setup({
        watch_widget,
        layout = wibox.layout.fixed.horizontal,
    })

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
