local M = {}

local require = require

function M.load(modules)
    if not modules then
        return
    end

    for i = 1, #modules do
        require(modules[i])
    end
end

function M.load_named(prefix, names)
    if not names then
        return
    end

    local module_prefix = prefix .. "."
    for i = 1, #names do
        require(module_prefix .. names[i])
    end
end

return M
