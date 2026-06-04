local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local ui = require("helpers.ui")

local widgets = require("widgets")

local function update_window_shape(c)
    c.shape = function(cr, w, h)
        local radius = 0
        if not c.fullscreen and not c.maximized then
            radius = beautiful.border_radius
        end
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end

local function show_window_titlebar(c)
    if c.titlebar then
        awful.titlebar.show(c)
    else
        c.titlebar = widgets.titlebar({ client = c })
        awful.titlebar.show(c)
    end
end

local function update_window_titlebar(c)
    if c.floating == false or c.requests_no_titlebar == true then
        awful.titlebar.hide(c)
    else
        show_window_titlebar(c)
    end
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

    if not c.fullscreen then
        update_window_shape(c)
    end

    local tag = awful.screen.focused().selected_tag
    if tag == nil then
        return
    end

    local layout = tag.layout
    -- NOTE: show titlebar if layout floating or client is floating
    if layout.name == "floating" or (c.floating and not c.requests_no_titlebar) then
        update_window_titlebar(c)
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

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        update_window_shape(c)
    end
end)

client.connect_signal("property::floating", function(c)
    c.ontop = c.floating
    update_window_titlebar(c)
end)

tag.connect_signal("property::layout", function(t)
    local layout = awful.tag.getproperty(t, "layout")
    if layout.name == "floating" then
        for _, client in ipairs(t:clients()) do
            show_window_titlebar(client)
        end
    else
        for _, client in ipairs(t:clients()) do
            update_window_titlebar(client)
        end
    end

    if layout.name == "fullscreen" then
        t.useless_gap = 0
    else
        t.useless_gap = beautiful.useless_gap
    end
end)

client.connect_signal("request::titlebars", function(c)
    show_window_titlebar(c)
end)

client.connect_signal("tagged", function(c)
    if awesome.startup then
        return
    end

    local tag = awful.screen.focused().selected_tag
    local layout = tag.layout
    if layout.name == "floating" then
        update_window_titlebar(c)
    else
        awful.titlebar.hide(c)
    end
end)

client.connect_signal("request::activate", function(c, origin)
    if origin == "client.focus.bydirection" or origin == "client.focus.global_bydirection" then
        ui.move_cursor_to_window(c, true)
    end
end)
