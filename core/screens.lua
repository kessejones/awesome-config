local awful = require("awful")
local modules = require("modules")

awful.screen.connect_for_each_screen(function(screen)
    modules.screen.init(screen)
end)
