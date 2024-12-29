-- local gears = require("gears")
-- local beautiful = require("beautiful")
local wibox = require("wibox")
-- local xresources = require("beautiful.xresources")
-- local dpi = xresources.apply_dpi

local Button = {}

function Button.new(args)
    args = args or {}

    local text = wibox.widget({
        widget = wibox.widget.textbox,
        markup = args.markup,
        align = 'center',
        valign = 'center',
    })

    local background = wibox.widget({
        text,
        widget = wibox.container.background,

        border_width = args.border_width or 0,
        border_color = args.border_color,
        shape = args.shape,
        bg = args.bg,
        fg = args.fg,
    })

    local margin = wibox.widget({
        background,
        widget = wibox.container.margin,
        margin = args.margin,
    })

    return setmetatable({
        args = args,
        widgets = {
            text = text,
            background = background,
            margin = margin,
            root = margin,
        }
    }, { __index = Button })
end

function Button:buttons(args)
    self.widgets.margin:buttons(args)
end

function Button:widget()
    return self.widgets.root;
end

return Button
