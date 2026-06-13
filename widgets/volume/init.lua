local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local ui = require("helpers.ui")
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
        font = beautiful.font_text_with_size(beautiful.wibar_widget_font_size, "Bold"),
    })

    local widget = widgets.bar_item()
    widget:setup({
        icon,
        {
            label,
            left = dpi(5),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    })

    -- -- local widget_tooltip = awful.tooltip({
    -- --     margins = beautiful.tooltip_margins,
    -- -- })

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

    ui.add_hover_cursor(widget, "hand2")

    gears.timer.delayed_call(function()
        label.markup = string.format("%d%%", modules.audio.sink_get_volume() or 0)
    end)

    modules.audio.on_sink_volume_changed(function(_, volume, muted)
        if muted then
            icon.image = beautiful.get_asset("assets/volume-off.png")
        else
            icon.image = beautiful.get_asset("assets/volume-on.png")
        end

        label.markup = string.format("%d%%", volume or 0)
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
