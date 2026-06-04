return setmetatable({}, {
    __index = function(_tbl, key)
        local ok, module = pcall(require, "widgets." .. key)
        if ok then
            return module
        end

        return nil
    end,
})
