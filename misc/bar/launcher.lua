local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")

local default = require("config").apps
local ui = require("helpers.ui")
local freedesktop = require("libs.freedesktop")

local M = {}

function M.new()
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
        { "Terminal Tmux", default.terminal },
        { "Terminal Fish", default.secondary_terminal },
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
        clip_shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
    })

    local widget = wibox.widget({
        {
            {
                {
                    launcher,
                    widget = wibox.container.margin,
                    left = dpi(5),
                    right = dpi(5),
                    top = dpi(5),
                    bottom = dpi(5),
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
    })

    ui.add_hover_cursor(widget, "hand2")

    return widget
end

return M
