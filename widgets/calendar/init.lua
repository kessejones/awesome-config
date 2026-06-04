local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

local key = require("libs.key")

local Year = require("widgets.calendar.year")

local function new(args)
    local screen = args.screen

    local today = os.date("*t")

    local popup = awful.popup({
        screen = screen,
        ontop = true,
        visible = false,
        hide_on_right_click = true,
        widget = wibox.container.background,
        bg = beautiful.bg_color,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
        placement = function(c)
            awful.placement.top(c, { margins = dpi(40) })
        end,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end,
    })

    local year_widget = Year.new(today.year)

    popup:setup({
        year_widget,
        widget = wibox.container.margin,
        left = dpi(20),
        right = dpi(20),
        top = dpi(10),
        bottom = dpi(10),
    })

    popup:connect_signal("property::visible", function()
        if not popup.visible then
            year_widget.date = { year = today.year }
        end
    end)

    return popup
end

return setmetatable({
    new = new,
}, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
