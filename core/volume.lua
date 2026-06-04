local audio = require("modules.audio")

audio.sink_subscribe(function()
    local volume = audio.sink_get_volume()
    local muted = audio.is_sink_muted()

    audio.emit_sink_volume_changed(volume, muted)
end)
