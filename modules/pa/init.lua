local gears = require("gears")
local config_path = gears.filesystem.get_configuration_dir()

package.cpath = package.cpath .. ";" .. config_path .. "/modules/pa/result/lib/?.so;"

local ok, module = pcall(require, "libpa")

if ok then
    module.status = ok
    return module
end

return { status = ok }
