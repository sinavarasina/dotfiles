local M = {}

function M.apply(items)
    for _, item in ipairs(items) do
        hl.env(item[1], item[2])
    end
end

return M
