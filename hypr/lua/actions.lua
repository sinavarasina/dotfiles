-- lua/actions.lua — Custom scripts & actions

local core = require("lua.core")

local path = core.path
local sh = core.shell
local notify = core.notify

local M = {}

local function get_screenshot_path()
    local filename = "Screenshot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
    return path.dir.screenshots .. "/" .. filename, filename
end

function M.screenshot_full()
    return function()
        local file, filename = get_screenshot_path()

        sh.exec_chain({
            sh.mkdir_p(path.dir.screenshots),
            "grim - | tee " .. sh.quote(file) .. " | wl-copy",
            notify.command("info", "Screenshot saved as " .. filename),
        })
    end
end

function M.screenshot_area()
    return function()
        local file, filename = get_screenshot_path()

        sh.exec_chain({
            sh.mkdir_p(path.dir.screenshots),
            "area=$(slurp)",
            "grim -g \"$area\" - | tee " .. sh.quote(file) .. " | wl-copy",
            notify.command("info", "Screenshot area saved as " .. filename),
        })
    end
end

function M.color_picker()
    return function()
        sh.exec_chain({
            "area=$(slurp -p)",
            [[hex=$(grim -g "$area" -t ppm - | convert - txt:- | sed -n '2s/.*\(#[0-9A-Fa-f]\{6,8\}\).*/\1/p')]],
            [[test -n "$hex"]],
            [[printf '%s' "$hex" | wl-copy]],
            notify.command("info", "$hex copied to clipboard", { expand = true, }),
        })
    end
end

function M.force_kill_active()
    return function()
        local w = hl.get_active_window()
        if w == nil then
            notify.warn("No active window")
            return
        end

        local class = w.class or "unknown"
        local title = w.title or "unknown"
        local pid = w.pid

        if pid == nil then
            notify.error("Cannot force kill: active window has no PID")
            return
        end

        local prompt = "Force kill " .. class .. ": " .. title .. "?"
        local cmd = string.format(
            [[answer=$(printf 'No\nYes\n' | wofi --dmenu --prompt %s); [ "$answer" = "Yes" ] && kill -9 %s && %s]],
            sh.quote(prompt),
            sh.quote(pid),
            notify.command("error", "Force killed " .. class)
        )

        sh.exec(cmd)
    end
end

return M
