local awful = require("awful")
local gears = require("gears")
local config = require("config")
local default = require("default")
local helper = require("helpers.ui")

local ResizeOrientation = {
    Horizontal = 0,
    Vertical = 1,
}

local ResizeMode = {
    Decrease = -1,
    Increase = 1,
}

local Direction = {
    Left = "left",
    Up = "up",
    Down = "down",
    Right = "right",
}

local Modifiers = {
    Alt = "Mod1",
    Super = "Mod4",
    Shift = "Shift",
    Ctrl = "Control",
}

local modKey = Modifiers.Alt

local M = {}

M.Modifiers = Modifiers
M.modKey = modKey

local function keys_move_client_to_tag()
    local keys = {}

    for i, name in ipairs(config.tags) do
        local key = {
            { modKey },
            tostring(i),
            function()
                if client.focus then
                    -- move focused client to the "i" tag and set the focus to this tag
                    local t = awful.tag.find_by_name(awful.screen.focused(), name)
                    client.focus:move_to_tag(t)
                    t:view_only(t)
                end
            end,
        }

        table.insert(keys, key)
    end

    return keys
end

local function focus_client_direction(dir)
    if dir == Direction.Down or dir == Direction.Up then
        awful.client.focus.bydirection(dir)
        helper.move_cursor_to_window(client.focus)
        return
    end

    local client_focused = client.focus
    if client_focused and client_focused.maximized then
        awful.screen.focus_bydirection(dir)
    else
        awful.client.focus.bydirection(dir)
        if screen.count() > 1 and client_focused == client.focus then
            awful.screen.focus_bydirection(dir)
            gears.timer.delayed_call(function()
                if #awful.screen.focused().clients == 0 then
                    client.focus = nil
                else
                    helper.move_cursor_to_window(client.focus, true)
                end
            end)
        else
            helper.move_cursor_to_window(client.focus)
        end
    end
end

local function move_client_direction(dir, wide)
    wide = wide or false

    local client_focused = client.focus

    if client_focused.floating then
        local vertical_value = 90
        local horizontal_value = 80

        local value = 30
        if wide then
            if dir == Direction.Down or dir == Direction.Up then
                value = vertical_value
            else
                value = horizontal_value
            end
        end

        if dir == Direction.Down then
            local screen_in_direction = client_focused.screen:get_next_in_direction(dir)
            local screen = client_focused.screen
            local limit = screen.geometry.y + screen.geometry.height - client_focused.height
            if not screen_in_direction and client_focused.y + value > limit then
                return
            end
            client_focused.y = client_focused.y + value
        elseif dir == Direction.Up then
            local point_y = 0
            local screen_in_direction = client_focused.screen:get_next_in_direction(dir)

            if not screen_in_direction and client_focused.y - value < point_y then
                return
            end
            client_focused.y = client_focused.y - value
        elseif dir == Direction.Left then
            local point_x = 0
            local screen_in_direction = client_focused.screen:get_next_in_direction(dir)
            if not screen_in_direction and client_focused.x - value < point_x then
                return
            end
            client_focused.x = client_focused.x - value
        elseif dir == Direction.Right then
            local screen_in_direction = client_focused.screen:get_next_in_direction(dir)
            local screen = client_focused.screen
            local limit = screen.geometry.x + screen.geometry.width
            if not screen_in_direction and client_focused.x + client_focused.width + value > limit then
                return
            end
            client_focused.x = client_focused.x + value
        end
        return
    end

    if dir == Direction.Down or dir == Direction.Up then
        awful.client.swap.bydirection(dir)
        gears.timer.delayed_call(function()
            helper.move_cursor_to_window(client.focus)
        end)
        return
    end

    local x, y = client_focused.x, client_focused.y
    awful.client.swap.bydirection(dir)

    gears.timer.delayed_call(function()
        if x == client_focused.x and y == client_focused.y then
            local screen_in_direction = client_focused.screen:get_next_in_direction(dir)
            if screen_in_direction then
                client_focused:move_to_screen(screen_in_direction)
            end
        end

        gears.timer.delayed_call(function()
            helper.move_cursor_to_window(client_focused, true)
        end)
    end)
end

local function resize_client_by_orientation(orientation, mode, wide)
    wide = wide or false
    local focused = client.focus
    local screen_focused = awful.screen.focused()
    local current_tag = screen_focused.selected_tag

    local function layout_can_resize()
        return current_tag.layout ~= awful.layout.layouts[1]
    end

    local tile_step = 0.05
    local wide_vertical_value = 90
    local wide_horizontal_value = 80

    local grow_value = 30
    if wide then
        if orientation == ResizeOrientation.Vertical then
            grow_value = wide_vertical_value
        else
            grow_value = wide_horizontal_value
        end
    end

    if mode == ResizeMode.Decrease then
        grow_value = -grow_value
    end

    local function client_can_resize_width()
        local screen = focused.screen
        local limit = screen.geometry.x + screen.geometry.width

        local w = focused.width + grow_value
        if focused.x + w > limit then
            return false
        end

        return w >= (focused.size_hints.min_width or 0)
    end

    local function client_can_resize_height()
        local screen = focused.screen
        local limit = screen.geometry.y + screen.geometry.height
        local h = focused.height + grow_value
        if focused.y + h > limit then
            return false
        end

        return h >= (focused.size_hints.min_height or 0)
    end

    if orientation == ResizeOrientation.Horizontal then
        if focused.floating then
            if client_can_resize_width() then
                focused.width = focused.width + grow_value
            end
        else
            if layout_can_resize() then
                awful.tag.incmwfact(tile_step * mode)
            end
        end
    elseif orientation == ResizeOrientation.Vertical then
        if focused.floating then
            if client_can_resize_height() then
                focused.height = focused.height + grow_value
            end
        else
            if layout_can_resize() then
                awful.client.incwfact(tile_step * mode)
            end
        end
    end
end

function M.get_global_keys()
    local globalkeys = gears.table.join(
        -- launcher
        awful.key({ modKey }, "d", function()
            awful.spawn(default.launcher)
        end, { description = "open launcher", group = "apps" }),

        -- apps
        awful.key({ modKey }, "b", function()
            awful.spawn(default.webbrowser)
        end, { description = "open default webbrowser", group = "apps" }),
        awful.key({ modKey }, "e", function()
            awful.spawn(default.filemanager)
        end, { description = "open file manager", group = "apps" }),
        -- standard program
        awful.key({ modKey }, "Return", function()
            awful.spawn(default.terminal)
        end, { description = "open primary terminal (tmux)", group = "apps" }),
        awful.key({ modKey }, ";", function()
            awful.spawn(default.secondary_terminal)
        end, { description = "open secondary terminal", group = "apps" }),

        -- layouts
        awful.key({ modKey }, "u", function()
            awful.layout.inc(-1, screen.screen)
        end, { description = "next layout", group = "layout" }),
        awful.key({ modKey }, "i", function()
            awful.layout.inc(1, screen.screen)
        end, { description = "previous layout", group = "layout" }),

        -- client (focus by direction)
        awful.key({ modKey }, "h", function()
            focus_client_direction("left")
        end, { description = "focus left window", group = "client" }),
        awful.key({ modKey }, "l", function()
            focus_client_direction("right")
        end, { description = "focus right window", group = "client" }),
        awful.key({ modKey }, "j", function()
            focus_client_direction("down")
        end, { description = "focus down window", group = "client" }),
        awful.key({ modKey }, "k", function()
            focus_client_direction("up")
        end, { description = "focus up window", group = "client" }),

        -- awesome
        awful.key(
            { modKey, Modifiers.Shift },
            "r",
            awesome.restart,
            { description = "reload awesome", group = "awesome" }
        ),
        awful.key({ modKey, Modifiers.Shift }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

        -- client (resize)
        awful.key(
            { modKey },
            "r",
            awful.keygrabber({
                keybindings = {
                    {
                        { modKey },
                        "h",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Decrease)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "H",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Decrease, true)
                        end,
                    },
                    {
                        { modKey },
                        "l",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Increase)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "L",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Increase, true)
                        end,
                    },
                    {
                        { modKey },
                        "j",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Increase)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "J",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Increase, true)
                        end,
                    },
                    {
                        { modKey },
                        "k",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Decrease)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "K",
                        function()
                            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Decrease, true)
                        end,
                    },
                    {
                        { modKey },
                        "r",
                        function()
                            awful.placement.centered()
                        end,
                    },
                },
                stop_key = modKey,
                stop_event = "release",
            }),
            { description = "resize", group = "client" }
        ),

        -- tags (switch)
        awful.key({ modKey }, "p", function()
            local s = awful.screen.focused()
            awful.tag.viewprev(s)
        end, { description = "go to prev tag", group = "tags" }),
        awful.key({ modKey }, "n", function()
            local s = awful.screen.focused()
            awful.tag.viewnext(s)
        end, { description = "go to next tag", group = "tags" }),

        -- volume control
        awful.key({}, "XF86AudioMute", function()
            require("lib.pulseaudio").toggle_mute()
        end),
        awful.key({}, "XF86AudioRaiseVolume", function()
            require("lib.pulseaudio").volume_up()
        end),
        awful.key({}, "XF86AudioLowerVolume", function()
            require("lib.pulseaudio").volume_down()
        end)
    )

    -- tags (focus by index)
    for i = 1, #config.tags do
        globalkeys = gears.table.join(
            globalkeys,
            -- View tag only.
            awful.key({ modKey }, "#" .. i + 9, function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end, { description = "switch to tag #" .. i, group = "tags" })
        )
    end

    return globalkeys
end

function M.get_client_keys()
    local keys_move_to_tag = keys_move_client_to_tag()

    local keys = gears.table.join(
        awful.key({ modKey }, "g", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "toggle fullscreen", group = "client" }),
        awful.key({ modKey }, "f", function(c)
            if c.fullscreen then
                c.fullscreen = false
            end
            c.maximized = not c.maximized
            c:raise()
        end, { description = "toggle maximized", group = "client" }),
        awful.key({ modKey }, "z", function(c)
            c.floating = not c.floating
        end, { description = "toggle floating", group = "client" }),

        awful.key({ modKey }, "q", function(c)
            c:kill()
        end, { description = "close", group = "client" }),

        -- move client by direction
        awful.key(
            { modKey },
            "m",
            awful.keygrabber({
                keybindings = gears.table.join({
                    {
                        { modKey },
                        "h",
                        function()
                            move_client_direction(Direction.Left)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "H",
                        function()
                            move_client_direction(Direction.Left, true)
                        end,
                    },
                    {
                        { modKey },
                        "l",
                        function()
                            move_client_direction(Direction.Right)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "L",
                        function()
                            move_client_direction(Direction.Right, true)
                        end,
                    },
                    {
                        { modKey },
                        "j",
                        function()
                            move_client_direction(Direction.Down)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "J",
                        function()
                            move_client_direction(Direction.Down, true)
                        end,
                    },
                    {
                        { modKey },
                        "k",
                        function()
                            move_client_direction(Direction.Up)
                        end,
                    },
                    {
                        { modKey, Modifiers.Shift },
                        "K",
                        function()
                            move_client_direction(Direction.Up, true)
                        end,
                    },
                    {
                        { modKey },
                        "n",
                        function()
                            local c = client.focus
                            local s = awful.screen.focused()
                            if c and s then
                                awful.tag.viewnext(awful.screen.focused())
                                c:move_to_tag(s.selected_tag)
                            end
                        end,
                    },
                    {
                        { modKey },
                        "p",
                        function()
                            local c = client.focus
                            local s = awful.screen.focused()
                            if c and s then
                                awful.tag.viewprev(awful.screen.focused())
                                c:move_to_tag(s.selected_tag)
                            end
                        end,
                    },
                    {
                        { modKey },
                        "m",
                        function()
                            awful.placement.centered(client.focus)
                        end,
                    },
                }, keys_move_to_tag),
                stop_key = modKey,
                stop_event = "release",
            }),
            { description = "move client by direction or tag index", group = "client" }
        )
    )

    return keys
end

function M.get_client_buttons()
    local buttons = gears.table.join(
        awful.button({}, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
        awful.button({ modKey }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ modKey }, 3, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    return buttons
end

return M
