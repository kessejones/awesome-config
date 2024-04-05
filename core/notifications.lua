local naughty = require("naughty")
local beautiful = require("beautiful")
local menubar = require("menubar")

naughty.config.defaults.border_width = beautiful.notification_border_width
naughty.config.presets.critical.timeout = 0
naughty.config.presets.critical.bg = beautiful.xcolormantle

naughty.config.presets.low.border_color = beautiful.xcolor2
naughty.config.presets.normal.border_color = beautiful.xcolor1
naughty.config.presets.critical.border_color = beautiful.xcolor10

naughty.config.notify_callback = function(args)
    args.border_color = naughty.config.presets[args.urgency or "normal"].border_color or beautiful.xcolor6

    return args
end

naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then
        return
    end

    local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)

naughty.connect_signal("request::action_icon", function(a, context, hints)
    a.icon = menubar.utils.lookup_icon(hints.id)
end)
