local wibox = require("wibox")

local function new(args)
    args = args or {}

    local text = wibox.widget({
        widget = wibox.widget.textbox,
        markup = args.markup,
        align = "center",
        valign = "center",
        id = "text",
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

    local widget = wibox.widget({
        background,
        widget = wibox.container.margin,
        margin = args.margin,

        set_text = function(self, value)
            local text_widget = self:get_children_by_id("text")[0]
            text_widget.markup = value
        end,
    })

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        return new(args)
    end,
})
