local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local key = require("libs.key")
local MouseButton = require("libs.key").MouseButton

local Button = require('widgets.button')

local Year = {}

local styles = {
    yearheader = {
        fg_color = beautiful.xcolor2,
        markup = function(t)
            local font = beautiful.font_text_with_size(18, "bold")
            return string.format('<span font_desc="%s">%s</span>', font, t)
        end,

        widget = function (widget, props)
            local btn_prev = Button.new({
                markup = "Prev",
            })

            btn_prev:buttons(key.mouse_buttons({
                [key.no_mod(MouseButton.Left)] = function ()
                    awesome.emit_signal("signal::calendar::prev_year", {})
                end
            }))

            local btn_next = Button.new({
                markup = "Next",
            })

            btn_next:buttons(key.mouse_buttons({
                [key.no_mod(MouseButton.Left)] = function ()
                    awesome.emit_signal("signal::calendar::next_year", {})
                end
            }))

            return wibox.widget({
                {
                    {
                        layout = wibox.layout.align.horizontal,
                        btn_prev:widget(),
                        widget,
                        btn_next:widget(),
                    },
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
        end
    },
    month = {
        padding = 5,
        border_width = 0,
        border_color = "#ff0000",

        on_hover = function(widget)
            widget.border_width = dpi(2)
            widget.border_color = beautiful.border_normal
            widget.shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
            end
        end
    },
    normal = {
        padding = 5,
        on_hover = function(widget)
            widget.border_width = dpi(2)
            widget.border_color = beautiful.border_normal
            widget.shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
            end
        end
    },
    focus = {
        fg_color = beautiful.mantle,
        border_width = 1,
        border_color = beautiful.border_focus,
        border_radis = dpi(5),
        shape = function(cr, w, h)
            gears.shape.circle(cr, w, h)
        end,
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

function Year.new(year)
    local function decorate_cell(widget, flag, _date)
        if flag == "monthheader" then
            flag = "header"
        end

        local props = styles[flag] or {}
        if props.markup and widget.get_text and widget.set_markup then
            widget:set_markup(props.markup(widget:get_text()))
        end

        local ret = nil
        if props.widget then
            ret = props.widget(widget, props)
        else
            ret = wibox.widget({
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
        end

        if props.on_hover then
            local border_width = ret.border_width
            local border_color = ret.border_color
            local shape = ret.shape

            ret:connect_signal("mouse::enter", function()
                props.on_hover(ret)
            end)

            ret:connect_signal("mouse::leave", function()
                ret.border_width = border_width
                ret.border_color = border_color
                ret.shape = shape
            end)
        end

        return ret
    end

    local widget = wibox.widget({
        widget = wibox.widget.calendar.year,
        date = {
            year = year,
        },
        font = beautiful.font_text_with_size(13, "bold"),
        start_sunday = true,
        spaccing = dpi(3),
        fn_embed = decorate_cell,
    })

    awesome.connect_signal("signal::calendar::prev_year", function()
        widget.date = { year = widget.date.year - 1 }
    end)

    awesome.connect_signal("signal::calendar::next_year", function()
        widget.date = { year = widget.date.year + 1 }
    end)

    return setmetatable({
        widgets = {
            root = widget,
        },
    }, { __index = Year })
end

function Year:set_year(year)
    self.widgets.root.date = { year = year }
end

function Year:widget()
    return self.widgets.root
end

return Year
