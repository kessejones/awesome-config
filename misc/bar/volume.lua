local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local ui = require("helpers.ui")

local M = {}

function M.new(s)
    local icon = wibox.widget({
        widget = wibox.widget.imagebox,
        image = beautiful.get_asset("assets/volume-on.png"),
        resize = true,
    })

    local widget = wibox.widget({
        {
            {
                {
                    icon,
                    widget = wibox.container.margin,
                    left = dpi(5),
                    right = dpi(5),
                    top = dpi(3),
                    bottom = dpi(3),
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
        margins = dpi(5),
    })

    local audio_menu = require("misc.audio").new(s)
    local widget_tooltip = awful.tooltip({
        margins = beautiful.tooltip_margins,
    })

    widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            audio_menu.visible = not audio_menu.visible
        end),
        awful.button({}, 2, function()
            require("libs.pulseaudio").toggle_mute()
        end),
        awful.button({}, 4, function()
            require("libs.pulseaudio").volume_up()
            widget_tooltip.visible = true
        end),
        awful.button({}, 5, function()
            require("libs.pulseaudio").volume_down()
            widget_tooltip.visible = true
        end)
    ))

    require("libs.pulseaudio").on_volume_change(function(volume, muted)
        if muted then
            icon.image = beautiful.get_asset("catppuccin/assets/volume-off.png")
        else
            icon.image = beautiful.get_asset("catppuccin/assets/volume-on.png")
        end

        widget_tooltip.text = string.format("Volume %d%%", volume)
    end)

    ui.add_hover_cursor(widget, "hand2")

    widget:connect_signal("mouse::leave", function()
        widget_tooltip.visible = false
    end)

    return widget
end

return M
