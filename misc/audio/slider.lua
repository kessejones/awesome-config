local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local str = require("helpers.string")

local M = {}

function M.new(args)
    args = args or {}

    local widget_slider = wibox.widget({
        widget = wibox.widget.slider,
        handle_shape = gears.shape.circle,
        bar_color = beautiful.transparent,
        handle_color = beautiful.border_focus,
        handle_border_color = beautiful.border_normal,
        handle_border_width = dpi(3),
        handle_width = dpi(25),
        margins = { left = 10, right = 10 },
    })

    local widget_progressbar = wibox.widget({
        widget = wibox.widget.progressbar,
        shape = gears.shape.rounded_bar,
        bar_color = beautiful.border_normal,
        background_color = beautiful.border_normal,
        color = beautiful.border_focus,
        value = 0,
        max_value = 100,
        bar_border_width = 0,
        margins = {
            top = dpi(8),
            bottom = dpi(8),
        },
    })

    local widget_slider_wrapper = wibox.widget({
        widget_progressbar,
        widget_slider,
        layout = wibox.layout.stack,
        forced_height = dpi(5),
        forced_width = dpi(175),
    })

    local widget_icon = wibox.widget({
        widget = wibox.widget.textbox,
        markup = args.icon or "",
        font = beautiful.font_icon_with_size(beautiful.topbar_icon_size),
        align = "center",
        valign = "center",
    })

    local widget_text = wibox.widget({
        widget = wibox.widget.textbox,
        markup = "  0%",
        font = beautiful.font_text_with_size(12),
        align = "center",
        valign = "center",
    })

    widget_slider:connect_signal("property::value", function(c)
        if args.on_change and type(args.on_change) == "function" then
            args.on_change(c.value)
        end

        widget_text.markup = str.pad_left(c.value, 3, " ") .. "%"
        widget_progressbar.value = c.value
    end)

    local widget = wibox.widget({
        layout = wibox.container.margin,
        left = dpi(10),
        right = dpi(10),
        top = dpi(15),
        {
            widget_icon,
            widget_slider_wrapper,
            widget_text,
            layout = wibox.layout.fixed.horizontal,
            forced_width = dpi(250),
            spacing = dpi(10),
        },
        set_value = function(self, value)
            widget_slider.value = value
            widget_text.markup = str.pad_left(value, 3, " ") .. "%"
        end,
        set_icon = function(self, value)
            widget_icon.markup = value
        end,
    })

    return widget
end

return M
