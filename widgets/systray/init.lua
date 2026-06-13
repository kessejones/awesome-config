local wibox = require("wibox")
local beautiful = require("beautiful")
local widgets = require("widgets")

local function new(_args)
    local systray = wibox.widget({
        widget = wibox.widget.systray,
        base_size = beautiful.systray_icon_size,
    })

    local widget = widgets.bar_item()

    widget:setup({
        systray,
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
