local beautiful = require("beautiful")
local wibox = require("wibox")
local ui = require("helpers.ui")

local Key = require("libs.key")
local widgets = require("widgets")

local function new(args)
    local textclock = wibox.widget.textclock("%d/%m/%Y - %H:%M")
    textclock.font = beautiful.font_text_with_size(beautiful.wibar_widget_font_size, "Bold")
    textclock.fg = beautiful.xcolorT0

    local widget = widgets.bar_item()

    widget:setup({
        textclock,
        layout = wibox.layout.fixed.horizontal,
    })

    local calendar_popup = widgets.calendar({ screen = args.screen })

    widget.calendar_popup = calendar_popup

    widget:buttons(Key.mouse_buttons({
        [Key.no_mod(Key.MouseButton.Left)] = function()
            calendar_popup.visible = not calendar_popup.visible
        end,
    }))

    ui.add_hover_cursor(widget, "hand2")

    return widget
end

return setmetatable({
    new = new,
}, {
    __call = function(_table, args)
        return new(args or {})
    end,
})
