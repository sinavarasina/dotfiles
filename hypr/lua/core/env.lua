local M = {}

local set_env = hl.env

function M.apply(items)
    for i = 1, #items do
        local item = items[i]
        set_env(item[1], item[2])
    end
end

return M
