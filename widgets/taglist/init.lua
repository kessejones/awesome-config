local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local wibox = require("wibox")
local gears = require("gears")
local dpi = xresources.apply_dpi

local ui = require("helpers.ui")
local config = require("config")
local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")

local function update_tag(item, tag)
    local widget = item:get_children_by_id("tag")[1]
    if tag.selected then
        widget.bg = beautiful.border_focus
        widget.shape_border_color = beautiful.border_focus
    elseif #tag:clients() > 0 then
        widget.bg = beautiful.xcolorS2
        widget.shape_border_color = widget.bg
    else
        widget.bg = beautiful.base
        widget.shape_border_color = beautiful.xcolorS2
    end
end

local function new(args)
    local screen = args.screen

    awful.tag(config.tags, screen, awful.layout.layouts[1])

    local taglist_buttons = require("libs.key").mouse_buttons({
        [Key.no_mod(MouseButton.Left)] = function(t)
            t:view_only()
        end,
        [MouseButton.Left] = function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end,
        [Key.no_mod(MouseButton.Up)] = function(t)
            awful.tag.viewnext(t.screen)
        end,
        [Key.no_mod(MouseButton.Down)] = function(t)
            awful.tag.viewprev(t.screen)
        end,
    })

    local move_to_action
    local move_to_cleanup

    local keygrabber = awful.keygrabber({
        stop_key = "Escape",
        stop_callback = function()
            if move_to_cleanup then
                move_to_cleanup()
            end
        end,
    })

    local function mouse_move_client_to(widget, tag)
        local function right_click()
            if move_to_cleanup then
                move_to_cleanup()
            end

            move_to_action = nil
            move_to_cleanup = nil
            local _screen = awful.screen.focused()
            local clients = _screen.selected_tag:clients()

            if #clients == 0 or tag.selected then
                return
            end

            widget.bg = beautiful.xcolor10

            move_to_cleanup = function()
                for _, c in ipairs(clients) do
                    c:disconnect_signal("button::press", move_to_action)
                end

                -- widget.bg = beautiful.xcolorS2
                update_tag(widget, tag)
                move_to_cleanup = nil
            end

            move_to_action = function(_self, _x, _y, button)
                if button == MouseButton.Left then
                    _self:move_to_tag(tag)
                    move_to_cleanup()
                    keygrabber:stop()
                end
            end

            for _, c in ipairs(clients) do
                c:connect_signal("button::press", move_to_action)
            end

            keygrabber:start()
        end

        local buttons = require("libs.key").mouse_buttons({
            [Key.no_mod(MouseButton.Right)] = right_click,
        })

        widget:add_button(buttons)
    end

    local taglist = awful.widget.taglist({
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            spacing = dpi(10),
        },
        widget_template = {
            id = "tag",
            widget = wibox.container.background,
            bg = beautiful.xcolorS2,
            forced_width = dpi(15),
            forced_height = dpi(15),
            shape = function(cr, width, height)
                gears.shape.circle(cr, width, height)
            end,
            shape_border_width = dpi(2),
            shape_border_color = beautiful.xcolorS2,
            create_callback = function(self, c3, _index, _object)
                update_tag(self, c3)
                ui.add_hover_cursor(self, "hand2")

                mouse_move_client_to(self, c3)
            end,
            update_callback = function(self, c3, _index, _object)
                update_tag(self, c3)
            end,
        },
    })

    local widget = wibox.widget({
        {
            {
                {
                    taglist,
                    widget = wibox.container.margin,
                    left = dpi(10),
                    right = dpi(10),
                    top = dpi(2),
                    bottom = dpi(2),
                },
                strategy = "exact",
                layout = wibox.container.constraint,
            },
            widget = wibox.container.background,
            bg = beautiful.wibar_widget_bg,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 5)
            end,
        },
        widget = wibox.container.margin,
        left = dpi(5),
        right = dpi(5),
        top = dpi(5),
        bottom = dpi(5),
    })

    return widget
end

return setmetatable({ new = new }, {
    __call = function(_table, args)
        args = args or {}

        return new(args)
    end,
})
