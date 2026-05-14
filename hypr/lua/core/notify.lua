local sh = require("lua.core.shell")

local M = {}

local icon = {
    info    = 1,
    warning = 2,
    error   = 3,
}

local color = {
    info    = "rgb(86cecb)",
    warning = "rgb(ffaa00)",
    error   = "rgb(e12885)",
}

local function push(kind, text, duration)
    hl.notification.create({
        text = text,
        duration = duration or 5000,
        icon = icon[kind] or icon.info,
        color = color[kind] or color.info,
    })
end

function M.info(text, duration)
    push("info", text, duration)
end

function M.warn(text, duration)
    push("warning", text, duration)
end

function M.error(text, duration)
    push("error", text, duration)
end

function M.command(kind, text, opts)
    opts = opts or {}

    local message
    if opts.expand then
        message = sh.double_quote(text)
    else
        message = sh.quote(text)
    end

    return table.concat({
        "hyprctl notify",
        tostring(icon[kind] or icon.info),
        tostring(opts.duration or 5000),
        sh.quote(color[kind] or color.info),
        message,
    }, " ")
end

return M
