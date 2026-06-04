local awful = require("awful")
local audio = require("modules.audio")

audio.sink_subscribe(function()
    local volume = audio.sink_get_volume()
    local muted = audio.is_sink_muted()

    audio.emit_sink_volume_changed(volume, muted)
end)

awful.spawn.easy_async(os.getenv("HOME") .. "/.config/awesome/scripts/audio-listener.sh", function() end)
