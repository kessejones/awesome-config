package.cpath = package.cpath .. ";" .. os.getenv("HOME") .. "/.config/awesome/modules/pa/result/lib/?.so;"
local pa = require("libpa")

-- print(package.cpath)
-- print(pa.sink_get_volume)

local sink = pa.sink_get_volume()
print(string.format("%d", sink))

-- local source = pa.source_get_volume()
-- print(string.format("%d", source))

-- pa.sink_set_mute(true)
-- pa.sink_set_volume(pa.sink_get_volume() + 1)
-- pa.sink_set_volume(pa.sink_get_volume() - 1)

-- pa.subscribe(function()
--     print("event")
-- end)
