local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local modules = require("modules")
local widgets = require("widgets")

local key = require("libs.key")
local MouseButton = key.MouseButton

local function new(args)
    local screen = args.screen

    local icon = wibox.widget({
        widget = wibox.widget.imagebox,
        image = beautiful.get_asset("assets/volume-on.png"),
        resize = true,
    })

    local label = wibox.widget({
        widget = wibox.widget.textbox,
        markup = "0%",
        align = "center",
        valign = "center",
    })

    local widget = wibox.widget({
        {
            {
                {
                    {
                        icon,
                        {
                            label,
                            left = dpi(5),
                            widget = wibox.container.margin,
                        },
                        layout = wibox.layout.align.horizontal,
                    },
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
        margins = dpi(5),
    })

    -- local widget_tooltip = awful.tooltip({
    --     margins = beautiful.tooltip_margins,
    -- })

    local audio_menu = widgets.audio_menu({ screen = screen })
    widget:buttons(key.mouse_buttons({
        [key.no_mod(MouseButton.Left)] = function()
            audio_menu.visible = not audio_menu.visible
        end,
        [key.no_mod(MouseButton.Middle)] = function()
            modules.audio.sink_mute_toggle()
        end,
        [key.no_mod(MouseButton.Up)] = function()
            modules.audio.sink_volume_up()
            -- widget_tooltip.visible = true
        end,
        [key.no_mod(MouseButton.Down)] = function()
            modules.audio.sink_volume_down()
            -- widget_tooltip.visible = true
        end,
    }))

    label.markup = string.format("%d%%", modules.audio.sink_get_volume())

    modules.audio.on_sink_volume_changed(function(volume, muted)
        if muted then
            icon.image = beautiful.get_asset("assets/volume-off.png")
        else
            icon.image = beautiful.get_asset("assets/volume-on.png")
        end

        label.markup = string.format("%d%%", volume)
        --
        -- widget_tooltip.text = string.format("Volume %d%%", volume)
    end)

    -- local timerHover = gears.timer({
    --     timeout = 3,
    --     callback = function()
    --         widget_tooltip.visible = true
    --     end,
    -- })

    -- widget:connect_signal("mouse::enter", function()
    --     timerHover:start()
    -- end)
    --
    -- widget:connect_signal("mouse::leave", function()
    --     timerHover:stop()
    --     widget_tooltip.visible = false
    -- end)

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
