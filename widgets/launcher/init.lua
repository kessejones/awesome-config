local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")

local default = require("config").apps
local ui = require("helpers.ui")
local freedesktop = require("libs.freedesktop")

local widgets = require("widgets")

local function new(_args)
    local awesome_menu = {
        {
            "Poweroff",
            function()
                awesome.spawn("systemctl poweroff")
            end,
        },
        {
            "Reboot",
            function()
                awesome.spawn("systemctl reboot")
            end,
        },
        { "Restart", awesome.restart },
        {
            "Quit",
            function()
                awesome.quit()
            end,
        },
        {
            "Keys",
            function()
                local hotkeys_popup = require("awful.hotkeys_popup")
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end,
        },
    }

    local terminal_menu = {
        { "Terminal", default.terminal },
    }

    local menu = freedesktop.menu.build({
        before = {
            { "System", awesome_menu },
            { "Terminal", terminal_menu },
        },
    })

    local launcher = awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = menu,
    })

    local widget = widgets.bar_item()

    widget:setup({
        launcher,
        layout = wibox.layout.fixed.horizontal,
    })

    ui.add_hover_cursor(widget, "hand2")

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}
        return new(args)
    end,
})
