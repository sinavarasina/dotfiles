local sh = require("lua.core.shell")

local M = {}

local default_duration = 5000
local concat = table.concat

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

local function resolve(kind)
    return icon[kind] or icon.info, color[kind] or color.info
end

local function push(kind, text, duration)
    local icon_id, color_value = resolve(kind)

    hl.notification.create({
        text = text,
        duration = duration or default_duration,
        icon = icon_id,
        color = color_value,
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

    local icon_id, color_value = resolve(kind)
    local message

    if opts.expand then
        message = sh.quote_expand(text)
    else
        message = sh.quote(text)
    end

    return concat({
        "hyprctl notify",
        tostring(icon_id),
        tostring(opts.duration or default_duration),
        sh.quote(color_value),
        message,
    }, " ")
end

return M
