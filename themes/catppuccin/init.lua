-- Mocha Color Theme from "github.com/catppuccin/catppuccin" --
--
local theme_assets = require("beautiful.theme_assets")
local gfs = require("gears.filesystem")

local themes_path = gfs.get_configuration_dir() .. "themes/catppuccin/"

local function theme_asset(str)
    return themes_path .. str
end

local theme = {}

-- Transparent Color --
theme.transparent = "#00000000"

-- Base --
theme.xcolorcrust = "#11111b"
theme.xcolormantle = "#181825"
theme.xcolorbase = "#1E1E2E"

-- Surface --
theme.xcolorS0 = "#313244"
theme.xcolorS1 = "#45475a"
theme.xcolorS2 = "#585b70"

-- Overlay --
theme.xcolorO0 = "#6c7086"
theme.xcolorO1 = "#7f849c"
theme.xcolorO2 = "#9399b2"

-- Text --
theme.xcolorT0 = "#a6adc8"
theme.xcolorT1 = "#bac2de"
theme.xcolorT2 = "#cdd6f4"

-- Lavender --
theme.xcolor1 = "#b4befe"
-- Blue --
theme.xcolor2 = "#89b4fa"
-- Sapphire --
theme.xcolor3 = "#74c7ec"
-- Sky --
theme.xcolor4 = "#89dceb"
-- Teal
theme.xcolor5 = "#94e2d5"
-- Green --
theme.xcolor6 = "#a6e3a1"
-- Yellow --
theme.xcolor7 = "#f9e2af"
-- Peach --
theme.xcolor8 = "#fab387"
-- Maroon --
theme.xcolor9 = "#eba0ac"
-- Red --
theme.xcolor10 = "#f38ba8"
-- Mauve --
theme.xcolor11 = "#cba6f7"
-- Pink --
theme.xcolor12 = "#f5c2e7"
-- Flamingo --
theme.xcolor13 = "#f2cdcd"
-- Rosewater --
theme.xcolor14 = "#f5e0dc"
-- Blue
theme.xcolor15 = "#2196f3"

-- Define the image to load
theme.titlebar_close_button_normal = theme_asset("titlebar/unfocus.svg")
theme.titlebar_close_button_focus = theme_asset("titlebar/close.svg")
theme.titlebar_close_button_normal_hover = theme_asset("titlebar/close_hover.svg")
theme.titlebar_close_button_focus_hover = theme_asset("titlebar/close_hover.svg")

theme.titlebar_minimize_button_normal = theme_asset("titlebar/unfocus.svg")
theme.titlebar_minimize_button_focus = theme_asset("titlebar/minimize.svg")
theme.titlebar_minimize_button_normal_hover = theme_asset("titlebar/minimize_hover.svg")
theme.titlebar_minimize_button_focus_hover = theme_asset("titlebar/minimize_hover.svg")

theme.titlebar_ontop_button_normal_inactive = theme_asset("titlebar/unfocus.svg")
theme.titlebar_ontop_button_focus_inactive = theme_asset("titlebar/ontop.svg")
theme.titlebar_ontop_button_normal_active = theme_asset("titlebar/ontop_unfocus_activated.png")
theme.titlebar_ontop_button_focus_active = theme_asset("titlebar/ontop_activated.png")

theme.titlebar_maximized_button_normal_active = theme_asset("catppuccin/titlebar/unfocus.svg")
theme.titlebar_maximized_button_focus_active = theme_asset("catppuccin/titlebar/maximize.svg")
theme.titlebar_maximized_button_normal_active_hover = theme_asset("catppuccin/titlebar/maximize_hover.svg")
theme.titlebar_maximized_button_focus_active_hover = theme_asset("catppuccin/titlebar/maximize_hover.svg")

theme.titlebar_maximized_button_normal_inactive = theme_asset("catppuccin/titlebar/unfocus.svg")
theme.titlebar_maximized_button_focus_inactive = theme_asset("catppuccin/titlebar/maximize.svg")
theme.titlebar_maximized_button_normal_inactive_hover = theme_asset("catppuccin/titlebar/maximize_hover.svg")
theme.titlebar_maximized_button_focus_inactive_hover = theme_asset("catppuccin/titlebar/maximize_hover.svg")

-- You can use your own layout icons like this:
theme.layout_floating = theme_asset("layouts/floating.png")
theme.layout_max = theme_asset("layouts/max.png")
theme.layout_fullscreen = theme_asset("layouts/max.png")
theme.layout_tile = theme_asset("layouts/tile-left.png")
theme.layout_tileleft = theme_asset("layouts/tile-right.png")
theme.layout_tiletop = theme_asset("layouts/tile-bottom.png")
theme.layout_tilebottom = theme_asset("layouts/tile-top.png")
theme.layout_dwindle = theme_asset("layouts/dwindle.png")
theme.layout_centered = theme_asset("layouts/centered.png")
theme.layout_mstab = theme_asset("layouts/mstab.png")
theme.layout_equalarea = theme_asset("layouts/equalarea.png")
theme.layout_machi = theme_asset("layouts/machi.png")
theme.layout_fairv = theme_asset("layouts/fairv.png")

-- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.xcolorS2)

return theme
