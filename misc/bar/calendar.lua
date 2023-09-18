local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local M = {}

local styles = {
    month = {
        padding = 5,
        border_width = 0,
    },
    normal = {},
    focus = {
        fg_color = beautiful.xcolor2,
        markup = function(t)
            return "<b>" .. t .. "</b>"
        end,
    },
    header = {
        fg_color = beautiful.xcolor2,
        markup = function(t)
            local font = beautiful.font_text_with_size(18, "bold")
            return string.format('<span font_desc="%s">%s</span>', font, t)
        end,
    },
    weekday = {
        padding = 3,
    },
}

function M.new()
    local function decorate_cell(widget, flag, date)
        if flag == "monthheader" then
            flag = "header"
        end
        local props = styles[flag] or {}
        if props.markup and widget.get_text and widget.set_markup then
            widget:set_markup(props.markup(widget:get_text()))
        end

        local ret = wibox.widget({
            {
                widget,
                margins = (props.padding or 2) + (props.border_width or 0),
                widget = wibox.container.margin,
            },
            fg = props.fg_color or beautiful.xcolorT0,
            bg = props.bg_color or beautiful.xcolorbase,
            shape = props.shape,
            shape_border_color = props.border_color or beautiful.transparent,
            shape_border_width = props.border_width or 0,
            widget = wibox.container.background,
        })

        return ret
    end

    local widget = wibox.widget({
        widget = wibox.widget.calendar.month,
        date = os.date("*t"),
        font = beautiful.font_text_with_size(13, "bold"),
        -- long_weekdays = true,
        start_sunday = true,
        spaccing = dpi(3),
        fn_embed = decorate_cell,
    })

    return widget
end

return M
