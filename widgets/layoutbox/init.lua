local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local ui = require("helpers.ui")

local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")

local function new(args)
    local screen = args.screen

    local layoutbox = awful.widget.layoutbox(screen)
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

    widget:buttons(Key.mouse_buttons({
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

    ui.add_hover_cursor(widget, "hand2")

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
