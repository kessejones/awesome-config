local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local function new(_args)
    local widget = wibox.widget({
        {
            {
                {
                    id = "content",
                    widget = wibox.container.margin,
                    top = dpi(5),
                    bottom = dpi(5),
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
        id = "root",
    })

    widget.set_widget = function(self, w)
        local content = self:get_children_by_id("content")[1]
        wibox.widget.base.check_widget(w)
        if w then
            content:set_widget(w)
        else
            content:set_widget(wibox.widget({
                layout = wibox.layout.fixed.horizontal,
            }))
        end

        self:emit_signal("widget::layout_changed")
    end

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
