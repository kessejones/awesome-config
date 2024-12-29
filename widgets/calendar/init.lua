local beautiful = require('beautiful')
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

local Year = require('widgets.calendar.year');

local Calander = {}

function Calander.new(s)
    local today = os.date("*t")

    local popup = awful.popup({
        screen = s,
        ontop = true,
        visible = false,
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
        year_widget:widget(),
        widget = wibox.container.margin,
        left = dpi(20),
        right = dpi(20),
        top = dpi(10),
        bottom = dpi(10),
    })

    popup:connect_signal("property::visible", function()
        local year = os.date("*t").year
        year_widget:set_year(year)
    end)

    return setmetatable({
        screen = s,
        widgets = {
            root = popup,
            year = year_widget,
        },
    }, { __index = Calander })
end

function Calander:show()
    self.widgets.root.visible = true
end

function Calander:toggle()
    self.widgets.root.visible = not self.widgets.root.visible
end

return Calander
