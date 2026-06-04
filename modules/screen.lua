local gears = require("gears")
local beautiful = require("beautiful")

local widgets = require("widgets")

local function set_wallpaper(screen)
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(screen)
    end

    gears.wallpaper.maximized(wallpaper, screen, true)
end

local function init(screen)
    set_wallpaper(screen)
    screen.wibar = widgets.bar({ screen = screen })
end

return {
    init = init,
    set_wallpaper = set_wallpaper,
}
