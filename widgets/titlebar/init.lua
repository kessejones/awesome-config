local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local function new(args)
    local c = args.client

    awful.titlebar.enable_tooltip = false

    local widget = awful.titlebar(c, {
        height = beautiful.titlebar_height,
        bg_normal = beautiful.xcolormantle,
    })

    local buttons = Key.mouse_buttons({
        [Key.no_mod(MouseButton.Left)] = function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end,
        [Key.no_mod(MouseButton.Right)] = function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end,
    })

    local maximze_button = awful.titlebar.widget.maximizedbutton(c)
    local ontop_button = awful.titlebar.widget.ontopbutton(c)
    local close_button = awful.titlebar.widget.closebutton(c)
    local icon_width = awful.titlebar.widget.iconwidget(c)

    local title_widget = awful.titlebar.widget.titlewidget(c)
    title_widget:set_font(beautiful.font_text_with_size(10, "bold"))

    widget:setup({
        { -- Left
            {
                layout = wibox.container.margin,
                margins = dpi(5),
                icon_width,
            },
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = title_widget,
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            {
                layout = wibox.container.margin,
                margins = dpi(5),
                {
                    {
                        layout = wibox.container.margin,
                        right = dpi(5),
                        ontop_button,
                    },
                    {
                        layout = wibox.container.margin,
                        right = dpi(5),
                        maximze_button,
                    },
                    {
                        layout = wibox.container.margin,
                        right = dpi(5),
                        close_button,
                    },
                    layout = wibox.layout.align.horizontal,
                },
            },
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
