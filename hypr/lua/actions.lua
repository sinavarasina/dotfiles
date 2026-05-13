-- ============================================================
--  lua/actions.lua — Custom Scripts & Actions
-- ============================================================

local M = {}
local home = os.getenv("HOME")

function M.screenshot_full()
    return function()
        local path = home .. "/Pictures/Screenshots/Screenshot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
        local filename = path:match("([^/]+)$")
        local cmd = string.format('sh -c \'grim - | tee "%s" | wl-copy && notify-send "Screenshot" "Saved as %s"\'', path,
            filename)
        hl.exec_cmd(cmd)
    end
end

function M.screenshot_area()
    return function()
        local path = home .. "/Pictures/Screenshots/Screenshot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
        local filename = path:match("([^/]+)$")
        local cmd = string.format(
            'sh -c \'area=$(slurp) && grim -g "$area" - | tee "%s" | wl-copy && notify-send "Screenshot Area" "Saved as %s"\'',
            path, filename)
        hl.exec_cmd(cmd)
    end
end

function M.color_picker()
    return function()
        local cmd =
        'sh -c \'color=$(slurp -p) && grim -g "$color" -t ppm - | convert - -format "%%[pixel:p{0,0}]" txt:- | tail -n 1 | cut -d" " -f4 | wl-copy && notify-send "Color Picker" "Copied to clipboard"\''
        hl.exec_cmd(cmd)
    end
end

function M.kill_active()
    return function()
        local cmd = 'sh -c "kill $(hyprctl activewindow | grep -o \\"pid: [0-9]*\\" | cut -d\\" \\" -f2)"'
        hl.exec_cmd(cmd)
    end
end

return M
