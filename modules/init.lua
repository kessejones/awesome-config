return setmetatable({}, {
    __index = function(_table, key)
        local ok, module = pcall(require, "modules." .. key)
        if ok then
            return module
        end

        return nil
    end,
})
