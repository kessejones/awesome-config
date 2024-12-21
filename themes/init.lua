local gears = require('gears')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local theme_assets = require("beautiful.theme_assets")
local themes_path = gfs.get_configuration_dir() .. "themes"

local helpers = require("helpers")
local colors = require('themes.catppuccin')

local theme = gears.table.merge(colors, {})

local conf = gfs.get_xdg_config_home()
if gfs.file_readable(conf .. "wallpaper.png") then
    theme.wallpaper = conf .. "wallpaper.png"
else
    theme.wallpaper = themes_path .. "/assets/wallpaper.png"
end

-- helpers for all themes
theme.get_asset = function(str)
    return string.format("%s/%s/%s", themes_path, theme.theme_name, str)
end

theme.font_icon_with_size = function(size)
    return string.format("%s %d", theme.font_icon, size or 1)
end

theme.font_text_with_size = function(size, type)
    type = type or ""
    return string.format("%s %s %d", theme.font_name, type, size or theme.font_size)
end

theme.theme_name = "catppuccin"

theme.font_size = 11
theme.font_name = "Cascadia Code NF"
theme.font = theme.font_text_with_size(theme.font_size)
theme.font_icon = "Material Icons"

-- titlebar
theme.titlebar_bg_focus = theme.xcolorbase
theme.titlebar_bg = theme.xcolorbase

-- background colors
theme.bg_normal = theme.xcolorbase
theme.bg_focus = theme.xcolorS0
theme.bg_urgent = colors.xcolor10
theme.bg_minimize = colors.xcolorO2
theme.bg_systray = theme.xcolormantle
theme.systray_icon_spacing = dpi(10)
-- theme.systray_icon_size = dpi(20)

-- foreground colors
theme.fg_normal = theme.xcolorT2
theme.fg_focus = theme.xcolor5
theme.fg_urgent = theme.xcolor10
theme.fg_minimize = theme.xcolor10

-- border
theme.useless_gap = 8
theme.border_width = 5
theme.border_normal = theme.xcolorS0
theme.border_focus = theme.xcolor11
theme.border_marked = theme.xcolor6

-- menu
theme.menu_font = theme.font_text_with_size(11, "SemiBold")
theme.menu_bg_focus = theme.xcolorbase
theme.menu_fg_focus = theme.xcolor2
theme.menu_border_width = dpi(2)
theme.menu_border_color = theme.border_focus
theme.submenu = " "
theme.menu_height = dpi(37)
theme.menu_width = dpi(194)

-- tagslist
theme.taglist_spacing = dpi(2)
theme.taglist_bg_focus = theme.xcolorbase
theme.taglist_disable_icon = true
theme.taglist_font = theme.font_text_with_size(11)
theme.taglist_fg_focus = theme.xcolor2
theme.taglist_fg_empty = theme.xcolorS2
theme.taglist_fg_occupied = "#526c96"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.xcolor2)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.taglist_fg_occupied)

-- Edge Snap
theme.snap_bg = theme.xcolor5
theme.snap_border_width = dpi(5)
theme.snap_shape = helpers.ui.rrect(0)

-- Hotkey Popup
theme.hotkeys_shape = helpers.ui.rrect(12)
theme.hotkeys_border_color = theme.xcolor5
theme.hotkeys_modifiers_fg = theme.xcolorO2
theme.hotkeys_font = theme.font_text_with_size()
theme.hotkeys_description_font = theme.font_text_with_size(9)

-- Layoutlist
theme.layoutlist_shape_selected = helpers.ui.rrect(7)

-- Tabs
theme.mstab_bar_height = 1
theme.mstab_dont_resize_slaves = true
theme.mstab_bar_padding = dpi(10)
theme.mstab_border_radius = dpi(6)
theme.mstab_bar_ontop = false
theme.mstab_tabbar_position = "top"
theme.mstab_tabbar_style = "default"
theme.mstab_bar_disable = true

-- notifications
theme.notification_spacing = dpi(4)
theme.notification_bg = theme.xcolorbase
theme.notification_border_width = theme.border_width
theme.notification_max_width = 400
theme.notification_max_height = 400
theme.notification_width = 400
theme.notification_height = 50
theme.notification_font = theme.font_text_with_size()
theme.notification_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, theme.border_radius)
end

-- tooltips
theme.tooltip_border_color = theme.border_focus
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal
theme.tooltip_border_width = theme.border_width
theme.tooltip_margins = 10
theme.tooltip_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, theme.border_radius)
end

-- winbar
theme.wibar_border_color = theme.border_normal
theme.wibar_widget_bg = theme.xcolormantle
theme.wibar_widget_font_size = theme.font_size

-- topbar
theme.topbar_icon_size = 16

-- awesome icon
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.xcolorS2)

return theme
