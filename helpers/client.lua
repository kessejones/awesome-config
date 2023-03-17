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

function M.set_width(c, width)
    c.width = width - (2 * c.border_width)
end

function M.set_height(c, height)
    c.height = height - (2 * c.border_width)
end

function M.set_bordered_size(c, width, height)
    M.set_height(c, height)
    M.set_width(c, width)
end

return M
