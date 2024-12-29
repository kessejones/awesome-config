do
    local awful = require("awful")
    local gears = require("gears")
    local beautiful = require("beautiful")

    awful.menu.original_new = awful.menu.new

    function awful.menu.new(...)
        local ret = awful.menu.original_new(...)
        ret.wibox.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
        return ret
    end
end

require("core.layouts")
require("core.screens")
require("core.rules")
require("core.signals")
require("core.bindings")
require("core.volume")
require("core.battery")
require("core.notifications")
