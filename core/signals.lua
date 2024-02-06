local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helper = require("helpers")
local ch = require("helpers.client")
local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local function window_rounded(c)
    c.shape = function(cr, w, h)
        local radius = 0
        if not c.fullscreen and not c.maximized then
            radius = beautiful.border_radius
        end
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end

local function request_titlebar(c)
    if c.requests_no_titlebar == true then
        awful.titlebar.hide(c)
        return
    end

    local window_height = c.height
    local window_x = c.x
    local window_y = c.y

    awful.titlebar.enable_tooltip = false
    local top_titlebar = awful.titlebar(c, {
        height = beautiful.titlebar_height,
        bg_normal = beautiful.xcolormantle,
    })

    local buttons = Key.mouse_buttons({
        [Key.no_mod(MouseButton.Left)] = function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end,
        [Key.no_mod(MouseButton.Right)] = function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end,
    })

    local maximze_button = awful.titlebar.widget.maximizedbutton(c)
    local ontop_button = awful.titlebar.widget.ontopbutton(c)
    local close_button = awful.titlebar.widget.closebutton(c)
    local icon_width = awful.titlebar.widget.iconwidget(c)

    local title_widget = awful.titlebar.widget.titlewidget(c)
    title_widget:set_font(beautiful.font_text_with_size(10, "bold"))

    top_titlebar:setup({
        { -- Left
            {
                layout = wibox.container.margin,
                margins = dpi(5),
                icon_width,
            },
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = title_widget,
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            {
                layout = wibox.container.margin,
                margins = dpi(5),
                {
                    {
                        layout = wibox.container.margin,
                        right = dpi(5),
                        ontop_button,
                    },
                    {
                        layout = wibox.container.margin,
                        right = dpi(5),
                        maximze_button,
                    },
                    {
                        layout = wibox.container.margin,
                        right = dpi(5),
                        close_button,
                    },
                    layout = wibox.layout.align.horizontal,
                },
            },
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })

    c.height = window_height
    c.x = window_x
    c.y = window_y
end

client.connect_signal("manage", function(c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    -- NOTE: demaximize windows when new window is opened
    if not c.floating then
        local function filter_maximized(filter_c)
            return (filter_c.maximized == true or filter_c.fullscreen == true)
                and filter_c.screen == c.screen
                and filter_c.first_tag == c.first_tag
        end

        for iter_c in awful.client.iterate(filter_maximized) do
            iter_c.maximized = false
            iter_c.fullscreen = false
        end
    end

    local t = awful.screen.focused().selected_tag
    local layout = t.layout

    -- NOTE: show titlebar if layout floating or client is floating
    if layout.name == "floating" or (c.floating and not c.requests_no_titlebar) then
        request_titlebar(c)
    end
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

client.connect_signal("property::geometry", function(c)
    window_rounded(c)
end)

client.connect_signal("property::fullscreen", function(c)
    window_rounded(c)
end)

client.connect_signal("property::floating", function(c)
    c.ontop = c.floating
    if c.floating then
        local g = c.screen.geometry
        local sw, sh = g.width, g.height

        ch.set_bordered_size(c, sw / 2, sh / 2)

        gears.timer.delayed_call(function()
            awful.placement.centered(c)
        end)
        request_titlebar(c)
    else
        awful.titlebar.hide(c)
    end
end)

screen.connect_signal("property::geometry", helper.wallpaper.set)

screen.connect_signal("primary_changed", function()
    awesome.emit_signal("wibar::systray")
end)

tag.connect_signal("property::layout", function(t)
    local layout = awful.tag.getproperty(t, "layout")
    if layout.name == "floating" then
        for _, client in ipairs(t:clients()) do
            if not client.floating then
                request_titlebar(client)
            end
        end
    else
        for _, client in ipairs(t:clients()) do
            if not client.floating then
                awful.titlebar.hide(client)
            end
        end
    end

    if layout.name == "fullscreen" then
        t.useless_gap = 0
    else
        t.useless_gap = beautiful.useless_gap
    end
end)

client.connect_signal("request::titlebars", function(c)
    request_titlebar(c)
end)

client.connect_signal("tagged", function(c)
    if awesome.startup then
        return
    end

    local tag = awful.screen.focused().selected_tag
    local layout = tag.layout
    if layout.name == "floating" then
        request_titlebar(c)
    else
        awful.titlebar.hide(c)
    end
end)
