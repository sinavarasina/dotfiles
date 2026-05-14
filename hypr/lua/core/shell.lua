local M = {}

function M.quote(value)
    return "'" .. tostring(value):gsub("'", [['"'"']]) .. "'"
end

function M.command(command)
    return "sh -c " .. M.quote(command)
end

function M.join(commands, separator)
    return table.concat(commands, separator or " && ")
end

function M.chain(commands)
    return M.join(commands, " && ")
end

function M.pipe(commands)
    return M.join(commands, " | ")
end

function M.mkdir_p(path)
    return "mkdir -p " .. M.quote(path)
end

function M.exec(command)
    hl.exec_cmd(M.command(command))
end

function M.exec_chain(commands)
    M.exec(M.chain(commands))
end

function M.exec_pipe(commands)
    M.exec(M.pipe(commands))
end

function M.double_quote(value)
    return '"' .. tostring(value)
        :gsub("\\", "\\\\")
        :gsub('"', '\\"')
        :gsub("`", "\\`")
        .. '"'
end

return M
