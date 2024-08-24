local awful = require("awful")
local gears = require("gears")
local config = require("config")
local helper = require("helpers.ui")

local Key = require("libs.key")
local MouseButton = require("libs.key.mouse_button")

local apps = config.apps

local client_resize_relative = setmetatable({
    left = function(val, inc)
        if inc then
            return { x = -val, y = 0, w = val, h = 0 }
        else
            return { x = val, y = 0, w = -val, h = 0 }
        end
    end,
    right = function(val, inc)
        if inc then
            return { x = 0, y = 0, w = val, h = 0 }
        else
            return { x = 0, y = 0, w = -val, h = 0 }
        end
    end,
    up = function(val, inc)
        if inc then
            return { x = 0, y = -val, w = 0, h = val }
        else
            return { x = 0, y = val, w = 0, h = -val }
        end
    end,
    down = function(val, inc)
        if inc then
            return { x = 0, y = 0, w = 0, h = val }
        else
            return { x = 0, y = 0, w = 0, h = -val }
        end
    end,
    resize = function(rect)
        client.focus:relative_move(rect.x, rect.y, rect.w, rect.h)
    end,
}, {
    __call = function(tbl, dir, inc)
        local rect = tbl[dir](20, inc)
        tbl.resize(rect)
    end,
    __index = function()
        assert(false, "Invalid direction")
    end,
})

local client_relative_move = setmetatable({
    left = function(val)
        client.focus:relative_move(-val, 0, 0, 0)
    end,
    right = function(val)
        client.focus:relative_move(val, 0, 0, 0)
    end,
    up = function(val)
        client.focus:relative_move(0, -val, 0, 0)
    end,
    down = function(val)
        client.focus:relative_move(0, val, 0, 0)
    end,
}, {
    __call = function(tbl, dir, wide)
        local val = wide and 40 or 20
        tbl[dir](val)
    end,
    __index = function()
        assert(false, "Invalid direction")
    end,
})

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

            gears.timer.delayed_call(function()
                helper.move_cursor_to_window(client.focus, true)
            end)
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
    local c = client.focus
    local s = awful.screen.focused()

    if c ~= nil and c.fullscreen and s:get_next_in_direction(dir) == nil then
        return
    end

    awful.client.focus.global_bydirection(dir, c, true)
    gears.timer.delayed_call(function()
        if c == client.focus and s == awful.screen.focused() then
            return
        end
        if #awful.screen.focused().clients == 0 then
            client.focus = nil
        end
    end)
end

local function move_client_direction(dir, wide)
    local client_focused = client.focus
    local screen = client_focused.screen
    local tag = screen.selected_tag
    local layout = tag.layout

    -- NOTE: move window by relative position
    if client_focused.floating or layout.name == "floating" then
        client_relative_move(dir, wide)
        return
    end

    -- NOTE: move window by direction globally
    if wide then
        awful.client.swap.global_bydirection(dir)
        gears.timer.delayed_call(function()
            helper.move_cursor_to_window(client_focused, true)
        end)
        return
    end

    -- NOTE: move window by direction or move to screen in direction
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
    ["s"] = function()
        awful.spawn(apps.screenshot)
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
            client_resize_relative("left", true)
        end,
        ["l"] = function()
            client_resize_relative("right", true)
        end,
        ["j"] = function()
            client_resize_relative("down", true)
        end,
        ["k"] = function()
            client_resize_relative("up", true)
        end,
        ["r"] = function()
            awful.placement.centered()
        end,
        [Key.shifted("H")] = function()
            client_resize_relative("left", false)
        end,
        [Key.shifted("L")] = function()
            client_resize_relative("right", false)
        end,
        [Key.shifted("J")] = function()
            client_resize_relative("down", false)
        end,
        [Key.shifted("K")] = function()
            client_resize_relative("up", false)
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
    ["v"] = function()
        local tag = awful.screen.focused().selected_tag
        local layout = awful.tag.getproperty(tag, "layout")
        if layout.name == "fullscreen" then
            local original_layout = tag.original_layout
            awful.layout.set(original_layout)
        else
            tag.original_layout = layout
            awful.layout.set(awful.layout.suit.max.fullscreen)
        end
    end,
})

local client_keys = Key.create({
    ["g"] = function(c)
        if c.maximized then
            c.maximized = false
        end
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
                awful.tag.viewnext(s)
                c:move_to_tag(s.selected_tag)
                gears.timer.delayed_call(function()
                    helper.move_cursor_to_window(c, true)
                end)
            end
        end,
        ["p"] = function()
            local c = client.focus
            local s = awful.screen.focused()
            if c and s then
                awful.tag.viewprev(s)
                c:move_to_tag(s.selected_tag)
                gears.timer.delayed_call(function()
                    helper.move_cursor_to_window(c, true)
                end)
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
