local awful = require("awful")
local audio = require("modules.audio")
local gears = require("gears")

local function handler()
    local volume = audio.sink_get_volume()
    local muted = audio.is_sink_muted()

    audio.emit_sink_volume_changed(volume, muted)
end

local function native_subscriber()
    local config_path = gears.filesystem.get_configuration_dir()
    local command = config_path .. "modules/pa/run.sh"
    awful.spawn.easy_async_with_shell(command, function() end)
end

audio.listen_events(handler)

gears.timer({
    timeout = 3,
    autostart = true,
    single_shot = true,
    callback = function()
        handler()
        native_subscriber()
    end,
})
