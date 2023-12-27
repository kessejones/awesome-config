local awful = require("awful")

local config = {}

config.tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

config.apps = {
    launcher = "rofi -show-icons -show drun",
    terminal = "kitty",
    secondary_terminal = "kitty -e " .. os.getenv("SHELL"),
    webbrowser = "firefox",
    secondary_webbrowser = "brave-browser",
    discord = "discord",
    filemanager = "nemo",
}

config.layouts = {
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

return config
