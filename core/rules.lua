local awful = require("awful")
local beautiful = require("beautiful")

local keys = require("modules.keys")

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.client_keys,
            buttons = keys.client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            maximized = false,
            floating = false,
            requests_no_titlebar = true,
        },
    },
    {
        rule_any = {
            type = { "dialog" },
            class = { "Steam", "firefox" },
        },
        except = { instance = "Navigator" },
        properties = {
            floating = true,
            placement = awful.placement.centered,
        },
    },
    {
        rule_any = {
            role = { "PictureInPicture" },
            name = { "Picture-in-picture" },
        },
        properties = {
            focus = awful.client.focus.filter,
        },
    },
}
