local M = {}

function M.load(modules)
    for _, module in ipairs(modules or {}) do
        require(module)
    end
end

function M.load_named(prefix, names)
    for _, name in ipairs(names or {}) do
        require(prefix .. "." .. name)
    end
end

return M
