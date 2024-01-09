pcall(require, "luarocks.loader")

require("error_handling")
require("awful.autofocus")
local theme = require("theme")
require("beautiful").init(theme)
require("core")
