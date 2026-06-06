local awful = require("awful")
local audio = require("modules.audio")
local gears = require("gears")

local config_path = gears.filesystem.get_configuration_dir()
local command = config_path .. "/modules/pa/run.sh"
awful.spawn.easy_async_with_shell(command, function() end)

audio.listen_events(function()
    local volume = audio.sink_get_volume()
    local muted = audio.is_sink_muted()

    audio.emit_sink_volume_changed(volume, muted)
end)
