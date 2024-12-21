-- *background:  #101319
-- *foreground:  #f4f3ee
-- *cursorColor: #f4f3ee
-- *color0:      #171b24
-- *color1:      #E34F4F
-- *color2:      #69bfce
-- *color3:      #e37e4f
-- *color4:      #5679E3
-- *color5:      #956dca
-- *color6:      #5599E2
-- *color7:      #f4f3ee
-- *color8:      #3A435A
-- *color9:      #DE2B2B
-- *color10:     #56B7C8
-- *color11:     #DE642B
-- *color12:     #3E66E0
-- *color13:     #885AC4
-- *color14:     #3F8CDE
-- *color15:     #DDDBCF

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
-- local helpers = require("helpers")

local themes_path = gfs.get_configuration_dir() .. "theme/"

local theme = {}

theme.transparent = "#00000000"

theme.color0 = '#171b24'
theme.color1 = '#E34F4F'
theme.color2 = '#69bfce'
theme.color3 = '#e37e4f'
theme.color4 = '#5679E3'
theme.color5 = '#956dca'
theme.color6 = '#5599E2'
theme.color7 = '#f4f3ee'
theme.color8 = '#3A435A'
theme.color9 = '#DE2B2B'
theme.color10 = '#56B7C8'
theme.color11 = '#DE642B'
theme.color12 = '#3E66E0'
theme.color13 = '#885AC4'
theme.color14 = '#3F8CDE'
theme.color15 = '#DDDBCF'

return theme
