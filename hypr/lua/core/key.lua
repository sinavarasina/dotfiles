local M = {}

local concat = table.concat
local select = select

function M.join(...)
    local parts = {}
    local len = 0

    for i = 1, select("#", ...) do
        local part = select(i, ...)
        if part and part ~= "" then
            len = len + 1
            parts[len] = part
        end
    end

    return concat(parts, " + ")
end

return M
