local naughty = require("naughty")

package.cpath = package.cpath .. ";" .. os.getenv("HOME") .. "/src/pa/target/debug/?.so;"
local ok, pa = pcall(require, "libpa")

if not ok then
    naughty.notify({
        text = "error to load libpa",
    })
end

local function sink_get_volume()
    return pa.sink_get_volume()
end

local function sink_set_volume(percent)
    pa.sink_set_volume(percent)
end

local function source_get_volume()
    return pa.source_get_volume()
end

local function source_set_volume(percent)
    pa.source_set_volume(percent)
end

local function sink_volume_up()
    sink_set_volume(pa.sink_get_volume() + 1)
end

local function sink_volume_down()
    sink_set_volume(pa.sink_get_volume() - 1)
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

local function sink_subscribe(callback)
    awesome.connect_signal("signal::audio-event", callback)

    -- local cmd = [[bash -c "LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\""]]
    --
    -- awful.spawn.easy_async({
    --     "pkill",
    --     "--full",
    --     "--uid",
    --     os.getenv("USER"),
    --     "^pactl subscribe",
    -- }, function()
    --     awful.spawn.with_line_callback(cmd, {
    --         stdout = function(_line)
    --             callback()
    --         end,
    --     })
    -- end)
end

local function on_sink_volume_changed(callback)
    if type(callback) == "function" then
        awesome.connect_signal("signal::sink-volume-changed", callback)
    end
end

local function on_source_volume_changed(callback)
    if type(callback) == "function" then
        awesome.connect_signal("signal::source-volume-changed", callback)
    end
end

local function emit_sink_volume_changed(volume, muted)
    awesome.emit_signal("signal::sink-volume-changed", volume, muted)
end

local function emit_source_volume_changed(volume, muted)
    awesome.emit_signal("signal::source-volume-changed", volume, muted)
end

return {
    sink_get_volume = sink_get_volume,
    sink_set_volume = sink_set_volume,

    source_get_volume = source_get_volume,
    source_set_volume = source_set_volume,

    sink_volume_up = sink_volume_up,
    sink_volume_down = sink_volume_down,

    sink_mute_toggle = sink_mute_toggle,
    source_mute_toggle = source_mute_toggle,

    is_sink_muted = is_sink_muted,
    is_source_muted = is_source_muted,

    sink_subscribe = sink_subscribe,

    on_sink_volume_changed = on_sink_volume_changed,
    on_source_volume_changed = on_source_volume_changed,

    emit_sink_volume_changed = emit_sink_volume_changed,
    emit_source_volume_changed = emit_source_volume_changed,
}
