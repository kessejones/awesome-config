package.cpath = package.cpath .. ";/home/kesse/src/pa/target/debug/?.so;"
local pa = require("libpa")

pa.subscribe(function()
    local command = [[
        awesome.emit_signal('signal::audio-event', nil)
    ]]

    io.popen(string.format('awesome-client "%s"', command))
end)
