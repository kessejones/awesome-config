local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local audio = require("modules.audio")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local key = require("libs.key")
local MouseButton = key.MouseButton
local widgets = require("widgets")

local function new(args)
    local screen = args.screen

    local widget = awful.popup({
        screen = screen,
        ontop = true,
        visible = false,
        widget = wibox.container.background,
        bg = beautiful.bg_color,
        minimum_width = dpi(280),
        minimum_height = dpi(100),
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        placement = function(c)
            awful.placement.top_right(c, { margins = dpi(40) })
        end,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end,
    })

    local output_volume = widgets.slider({
        on_change = function(value)
            audio.sink_set_volume(value)
        end,
        icon = "",
    })

    output_volume:buttons(key.mouse_buttons({
        [key.no_mod(MouseButton.Up)] = function()
            output_volume.value = output_volume.value + 1
        end,
        [key.no_mod(MouseButton.Down)] = function()
            output_volume.value = output_volume.value - 1
        end,
    }))

    local input_volume = widgets.slider({
        on_change = function(value)
            audio.source_set_volume(value)
        end,
        icon = "",
    })

    input_volume:buttons(key.mouse_buttons({
        [key.no_mod(MouseButton.Up)] = function()
            input_volume.value = input_volume.value + 1
        end,
        [key.no_mod(MouseButton.Down)] = function()
            input_volume.value = input_volume.value - 1
        end,
    }))

    widget:setup({
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10),
        output_volume,
        input_volume,
    })

    widget:connect_signal("property::visible", function()
        if widget.visible == true then
            output_volume.value = audio.sink_get_volume()
            input_volume.value = audio.source_get_volume()
        end
    end)

    audio.on_sink_volume_changed(function(volume, muted)
        if muted then
            output_volume.icon = ""
        else
            output_volume.icon = ""
        end

        output_volume.value = volume
    end)

    local mouseLeaveTimer = gears.timer({
        timeout = 3,
        callback = function()
            widget.visible = false
        end,
    })

    widget:connect_signal("mouse::enter", function()
        mouseLeaveTimer:stop()
    end)

    widget:connect_signal("mouse::leave", function()
        mouseLeaveTimer:start()
    end)

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
