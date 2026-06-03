local M = {}

local concat = table.concat

function M.quote(value)
    return "'" .. tostring(value):gsub("'", [['"'"']]) .. "'"
end

function M.quote_expand(value)
    return '"' .. tostring(value)
        :gsub("\\", "\\\\")
        :gsub('"', '\\"')
        :gsub("`", "\\`")
        .. '"'
end

function M.argv(args)
    local quoted = {}

    for i = 1, #args do
        quoted[i] = M.quote(args[i])
    end

    return concat(quoted, " ")
end

function M.command(command)
    return "sh -c " .. M.quote(command)
end

function M.join(commands, separator)
    return concat(commands, separator or " && ")
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

function M.if_not_running(process, command)
    return "pgrep -x " ..
        M.quote(process) .. " >/dev/null || " .. (command or process)
end

function M.exec(command)
    hl.exec_cmd(M.command(command))
end

function M.exec_once(process, command)
    M.exec(M.if_not_running(process, command))
end

function M.exec_chain(commands)
    M.exec(M.chain(commands))
end

function M.exec_pipe(commands)
    M.exec(M.pipe(commands))
end

return M
