local grect = require("gears.geometry").rectangle
local awful = require("awful")
local beautiful = require("beautiful")

local M = {}

--- @see https://github.com/awesomeWM/awesome/blob/master/lib/awful/client.lua#L308
--- @see https://github.com/awesomeWM/awesome/blob/master/lib/awful/client.lua#L342
function M.swap_bydirection(dir, c, stacked)
    local sel = c or awful.client.focus
    if sel then
        local cltbl = awful.client.visible(sel.screen, stacked)
        local geomtbl = {}
        for i, cl in ipairs(cltbl) do
            geomtbl[i] = cl:geometry()
        end
        local target = grect.get_in_direction(dir, geomtbl, sel:geometry())

        if target then
            cltbl[target]:swap(sel)
        else
            local screen_in_direction = sel.screen:get_next_in_direction(dir)
            if screen_in_direction then
                if dir == "left" then
                    sel.x = screen_in_direction.geometry.width - sel.width
                elseif dir == "right" then
                    sel.x = 0
                end
                sel:move_to_screen(screen_in_direction)
                awful.screen.focus(sel.screen)
            end
        end
    end
end

function M.update_border(c)
    if c.marked then
        c.border_color = beautiful.border_marked
    else
        if client.focus == c then
            c.border_color = beautiful.border_focus
        else
            c.border_color = beautiful.border_normal
        end
    end
end

return M
