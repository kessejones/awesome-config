local awful = require("awful")
local gears = require("gears")
local config = require("config")
local helper = require("helpers.ui")

local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")

local apps = config.apps

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

local M = {}

local function move_client_to_tag(tag_name)
    return function()
        if client.focus then
            local t = awful.tag.find_by_name(awful.screen.focused(), tag_name)
            client.focus:move_to_tag(t)
            t:view_only(t)
        end
    end
end

local function focus_tag(tag_index)
    return function()
        local screen = awful.screen.focused()
        local tag = screen.tags[tag_index]
        if tag then
            tag:view_only()
        end
    end
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
    local screen = client_focused.screen
    local tag = screen.selected_tag
    local layout = tag.layout

    if client_focused.floating or layout.name == "floating" then
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

local global_keys = Key.create({
    ["d"] = function()
        awful.spawn(apps.launcher)
    end,
    ["b"] = function()
        awful.spawn(apps.webbrowser)
    end,
    ["e"] = function()
        awful.spawn(apps.filemanager)
    end,
    ["Return"] = function()
        awful.spawn(apps.terminal)
    end,
    [";"] = function()
        awful.spawn(apps.secondary_terminal)
    end,
    ["u"] = function()
        awful.layout.inc(-1, screen.screen)
    end,
    ["i"] = function()
        awful.layout.inc(1, screen.screen)
    end,
    ["h"] = function()
        focus_client_direction("left")
    end,
    ["l"] = function()
        focus_client_direction("right")
    end,
    ["j"] = function()
        focus_client_direction("down")
    end,
    ["k"] = function()
        focus_client_direction("up")
    end,
    [Key.shifted("r")] = awesome.restart,
    [Key.shifted("q")] = awesome.quit,

    ["p"] = function()
        local s = awful.screen.focused()
        awful.tag.viewprev(s)
    end,
    ["n"] = function()
        local s = awful.screen.focused()
        awful.tag.viewnext(s)
    end,
    [Key.no_mod("XF86AudioMute")] = function()
        require("libs.pulseaudio").toggle_mute()
    end,
    -- [Key.no_mod("XF86AudioRaiseVolume")] = function()
    --     require("libs.pulseaudio").volume_up()
    -- end,
    -- [Key.no_mod("XF86AudioLowerVolume")] = function()
    --     require("libs.pulseaudio").volume_down()
    -- end,

    ["r"] = Key.create_keygrabber({
        ["h"] = function()
            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Decrease)
        end,
        ["l"] = function()
            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Increase)
        end,
        ["j"] = function()
            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Increase)
        end,
        ["k"] = function()
            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Decrease)
        end,
        ["r"] = function()
            awful.placement.centered()
        end,
        [Key.shifted("H")] = function()
            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Decrease, true)
        end,
        [Key.shifted("L")] = function()
            resize_client_by_orientation(ResizeOrientation.Horizontal, ResizeMode.Increase, true)
        end,
        [Key.shifted("J")] = function()
            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Increase, true)
        end,
        [Key.shifted("K")] = function()
            resize_client_by_orientation(ResizeOrientation.Vertical, ResizeMode.Decrease, true)
        end,
    }),
    ["1"] = focus_tag(1),
    ["2"] = focus_tag(2),
    ["3"] = focus_tag(3),
    ["4"] = focus_tag(4),
    ["5"] = focus_tag(5),
    ["6"] = focus_tag(6),
    ["7"] = focus_tag(7),
    ["8"] = focus_tag(8),
    ["9"] = focus_tag(9),
})

local client_keys = Key.create({
    ["g"] = function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
    ["f"] = function(c)
        if c.fullscreen then
            c.fullscreen = false
        end
        c.maximized = not c.maximized
        c:raise()
    end,
    ["z"] = function(c)
        c.floating = not c.floating
    end,
    ["q"] = function(c)
        c:kill()
    end,
    ["m"] = Key.create_keygrabber({
        ["h"] = function()
            move_client_direction(Direction.Left)
        end,
        ["l"] = function()
            move_client_direction(Direction.Right)
        end,
        ["j"] = function()
            move_client_direction(Direction.Down)
        end,
        ["k"] = function()
            move_client_direction(Direction.Up)
        end,
        [Key.shifted("H")] = function()
            move_client_direction(Direction.Left, true)
        end,
        [Key.shifted("L")] = function()
            move_client_direction(Direction.Right, true)
        end,
        [Key.shifted("K")] = function()
            move_client_direction(Direction.Up, true)
        end,
        [Key.shifted("J")] = function()
            move_client_direction(Direction.Down, true)
        end,
        ["n"] = function()
            local c = client.focus
            local s = awful.screen.focused()
            if c and s then
                awful.tag.viewnext(awful.screen.focused())
                c:move_to_tag(s.selected_tag)
            end
        end,
        ["p"] = function()
            local c = client.focus
            local s = awful.screen.focused()
            if c and s then
                awful.tag.viewprev(awful.screen.focused())
                c:move_to_tag(s.selected_tag)
            end
        end,
        ["m"] = function()
            awful.placement.centered(client.focus)
        end,
        ["1"] = move_client_to_tag("1"),
        ["2"] = move_client_to_tag("2"),
        ["3"] = move_client_to_tag("3"),
        ["4"] = move_client_to_tag("4"),
        ["5"] = move_client_to_tag("5"),
        ["6"] = move_client_to_tag("6"),
        ["7"] = move_client_to_tag("7"),
        ["8"] = move_client_to_tag("8"),
        ["9"] = move_client_to_tag("9"),
    }),
})

local client_buttons = Key.mouse_buttons({
    [Key.no_mod(MouseButton.Left)] = function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end,
    [MouseButton.Left] = function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end,
    [MouseButton.Right] = function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end,
})

function M.get_global_keys()
    return global_keys
end

function M.get_client_keys()
    return client_keys
end

function M.get_client_buttons()
    return client_buttons
end

return M
