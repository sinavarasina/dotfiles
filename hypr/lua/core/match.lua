local M = {}

function M.class(pattern)
    return { class = pattern, }
end

function M.title(pattern)
    return { title = pattern, }
end

function M.titled(class_pattern, title_pattern)
    return { class = class_pattern, title = title_pattern, }
end

return M
