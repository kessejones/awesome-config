pcall(require, "luarocks.loader")

require("error_handling")
require("awful.autofocus")

local theme = require("themes")

require("beautiful").init(theme)

require("core")
