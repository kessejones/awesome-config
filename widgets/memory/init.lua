local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local widgets = require("widgets")
local memory = require("modules.memory")

local function new(_args)
    local textbox = wibox.widget({
        widget = wibox.widget.textbox,
        font = beautiful.font_text_with_size(beautiful.wibar_widget_font_size, "Bold"),
        spaccing = dpi(3),
    })

    memory.on_memory_updated(function(_, mem)
        local text = memory.humam_readable(mem.used)

        if mem.used >= (math.floor(mem.total * 0.9)) then
            text = '<span background="#f38ba8" foreground="#1e1e2e">' .. text .. "</span>"
        end

        textbox.markup = text
    end)

    local widget = widgets.bar_item()

    widget:setup({
        textbox,
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
