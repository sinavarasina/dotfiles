local M = {}

function M.join(...)
    local parts = {}

    for _, part in ipairs({ ..., }) do
        if part and part ~= "" then
            table.insert(parts, part)
        end
    end

    return table.concat(parts, " + ")
end

return M
