local gears = require("gears")
local awful = require("awful")

local Modifiers = {
    Alt = "Mod1",
    Super = "Mod4",
    Shift = "Shift",
    Ctrl = "Control",
}

local MouseButton = {
    Left = 1,
    Right = 3,
    Middle = 2,
    Up = 4,
    Down = 5,
}

local M = {}

M.mod_key = Modifiers.Alt
M.modifiers = Modifiers
M.mouse_button = MouseButton

local function mods_key(key)
    if type(key) == "table" then
        return key[1], key[2]
    else
        return { M.mod_key }, key
    end
end

local function grabber_key(key, action)
    local mods, key_value = mods_key(key)
    return { mods, key_value, action, {} }
end

local function build_keybindinds(keys_list)
    local keys = {}
    for key, action in pairs(keys_list) do
        table.insert(keys, grabber_key(key, action))
    end
    return keys
end

function M.create(keys_list)
    local keys = {}
    for key, action in pairs(keys_list) do
        local mods, key_value = mods_key(key)
        local k = awful.key(mods, key_value, action, {})
        table.insert(keys, k)
    end
    return gears.table.join(unpack(keys))
end

function M.create_keygrabber(keys_list)
    return awful.keygrabber({
        keybindings = build_keybindinds(keys_list),
        stop_key = M.mod_key,
        stop_event = "release",
    })
end

function M.no_mod(key)
    return { {}, key }
end

function M.shifted(key)
    return { { M.mod_key, Modifiers.Shift }, key }
end

function M.mouse_buttons(buttons_list)
    local buttons = {}
    for key, action in pairs(buttons_list) do
        local mods, key_value = mods_key(key)
        local button = awful.button(mods, key_value, action)
        table.insert(buttons, button)
    end
    return gears.table.join(unpack(buttons))
end

return M
