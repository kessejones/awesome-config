local awful = require("awful")
local Modifier = require("libs.key.modifier")

local config = {}

config.tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

config.apps = {
    launcher = "rofi -show-icons -show drun",
    terminal = "wezterm",
    secondary_terminal = "wezterm",
    webbrowser = "firefox",
    secondary_webbrowser = "brave-browser",
    discord = "discord",
    filemanager = "nemo",
    screenshot = "scrot -e 'xclip -selection clipboard -t image/png -i $f' -s",

    mouse_hint = "warpd --hint",
    mouse_hint2 = "warpd --hint2",
}

config.layouts = {
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}

config.mod_key = Modifier.Alt

return config
