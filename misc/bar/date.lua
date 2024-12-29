local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local ui = require("helpers.ui")

local Key = require('libs.key')

local CalendarPopup = require('widgets.calendar')

local M = {}

function M.new(s)
    local textclock = wibox.widget.textclock("%d/%m/%Y - %H:%M")
    textclock.font = beautiful.font_text_with_size(beautiful.wibar_widget_font_size, "Bold")
    textclock.fg = beautiful.xcolorT0

    local widget = wibox.widget({
        {
            {
                {
                    textclock,
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

    local calendar_popup = CalendarPopup.new(s)

    widget:buttons(Key.mouse_buttons({
        [Key.no_mod(Key.MouseButton.Left)] = function ()
            calendar_popup:toggle()
        end
    }))

    ui.add_hover_cursor(widget, "hand2")

    return widget
end

return M
