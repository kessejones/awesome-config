local M = {}

function M.add_placement(c, placement)
    if placement == "left" then
        c.placement_values.right = false
        c.placement_values.right = false
    end
end

function M.init_placement(c)
    c.placement_values = {
        centered = true,
        top = false,
        bottom = false,
        left = false,
        right = false,
    }
end

return M
