local awful = require("awful")
local beautiful = require("beautiful")

local keys = require("config.keys")

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.get_client_keys(),
            buttons = keys.get_client_buttons(),
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            maximized = false,
            floating = false,
            requests_no_titlebar = true,
        },
    },
    {
        rule = { class = "firefox" },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            maximized = false,
            floating = false,
            requests_no_titlebar = true,
        },
    },
    {
        rule_any = {
            type = { "dialog" },
            class = { "Gnome-calculator", "Steam", "firefox" },
        },
        except = { instance = "Navigator" },
        properties = {
            floating = true,
            requests_no_titlebar = false,
            placement = awful.placement.centered,
        },
    },
}
