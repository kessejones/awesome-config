local gears = require("gears")

--- @see https://github.com/lcpz/lain/blob/master/widget/mem.lua#L23-L36
local function get_memory_data()
    local mem = {}
    for line in io.lines("/proc/meminfo") do
        for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
            if k == "MemTotal" then
                mem.total = math.floor(v / 1024 + 0.5)
            elseif k == "MemFree" then
                mem.free = math.floor(v / 1024 + 0.5)
            elseif k == "Cached" then
                mem.cached = math.floor(v / 1024 + 0.5)
            elseif k == "MemAvailable" then
                mem.available = math.floor(v / 1024 + 0.5)
            end
        end
    end

    mem.used = mem.total - mem.available
    return mem
end

local oberver = gears.object()

local function emit_memory_updated()
    local mem = get_memory_data()
    oberver:emit_signal("memory::updated", mem)
end

gears.timer({
    timeout = 10,
    autostart = true,
    call_now = true,
    callback = emit_memory_updated,
})

local function on_memory_updated(callback)
    if type(callback) == "function" then
        oberver:connect_signal("memory::updated", callback)
        emit_memory_updated()
    end
end

local function humam_readable(value)
    local suffixes = { "M", "G", "T", "P", "E", "Z", "Y" }
    local suffix = 1
    while value > 1024 do
        value = value / 1024
        suffix = suffix + 1
    end
    return string.format("%.2f %sB", value, suffixes[suffix])
end

return {
    get_memory_data = get_memory_data,
    on_memory_updated = on_memory_updated,
    humam_readable = humam_readable,
}
