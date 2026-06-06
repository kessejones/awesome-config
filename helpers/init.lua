return setmetatable({}, {
    __index = function(_table, key)
        local ok, module = pcall(require, "helpers." .. key)

        if ok then
            return module
        end

        return nil
    end,
})
