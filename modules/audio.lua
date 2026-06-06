local naughty = require("naughty")
local dbus = require("dbus")
local gears = require("gears")
local pa = require("modules.pa")

if not pa.status then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Audio Setup",
        text = "error to load libpa",
    })
end

local function sink_volume_up()
    pa.sink_set_volume(pa.sink_get_volume() + 1)
end

local function sink_volume_down()
    pa.sink_set_volume(pa.sink_get_volume() - 1)
end

local function sink_mute_toggle()
    local muted = pa.sink_is_muted()
    pa.sink_set_mute(not muted)
end

local function source_mute_toggle()
    local muted = pa.source_is_muted()
    pa.source_set_mute(not muted)
end

local function is_sink_muted()
    return pa.sink_is_muted()
end

local function is_source_muted()
    return pa.source_is_muted()
end

local observer = gears.object()

local function listen_events(callback)
    dbus.connect_signal("org.awesomewm.audio", callback)
end

local function on_sink_volume_changed(callback)
    if type(callback) == "function" then
        observer:connect_signal("signal::sink-volume-changed", callback)
    end
end

local function on_source_volume_changed(callback)
    if type(callback) == "function" then
        observer:connect_signal("signal::source-volume-changed", callback)
    end
end

local function emit_sink_volume_changed(volume, muted)
    observer:emit_signal("signal::sink-volume-changed", volume, muted)
end

local function emit_source_volume_changed(volume, muted)
    observer:emit_signal("signal::source-volume-changed", volume, muted)
end

return {
    sink_get_volume = pa.sink_get_volume,
    sink_set_volume = pa.sink_set_volume,

    source_get_volume = pa.source_get_volume,
    source_set_volume = pa.source_set_volume,

    sink_volume_up = sink_volume_up,
    sink_volume_down = sink_volume_down,

    sink_mute_toggle = sink_mute_toggle,
    source_mute_toggle = source_mute_toggle,

    is_sink_muted = is_sink_muted,
    is_source_muted = is_source_muted,

    listen_events = listen_events,

    on_sink_volume_changed = on_sink_volume_changed,
    on_source_volume_changed = on_source_volume_changed,

    emit_sink_volume_changed = emit_sink_volume_changed,
    emit_source_volume_changed = emit_source_volume_changed,
}
