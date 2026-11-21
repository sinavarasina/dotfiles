-- lua/core/workspace.lua — Adaptive gap scaling for special workspaces
--
-- monitor.width/height are physical px; reserved is {top,bottom,left,right}
-- in logical px.

local M = {}

local config  = nil   -- target usable fraction; nil / >= 1 = disabled
local rules   = {}    -- [monitor name] = rule handle
local applied = {}    -- [monitor name] = gaps signature ("t,r,b,l")
local bound   = false

local function round(n)
    return math.floor(n + 0.5)
end

-- Rule spec for one monitor, or nil when no gaps are needed.
local function rule_spec(name, monitor, scale_factor)
    local w = monitor.width or 0
    local h = monitor.height or 0
    if w <= 0 or h <= 0 then
        return nil
    end

    -- 90°/270° rotations (transform 1, 3, 5, 7)
    if (monitor.transform or 0) % 2 == 1 then
        w, h = h, w
    end

    local scale = (monitor.scale and monitor.scale > 0) and monitor.scale or 1
    w, h = w / scale, h / scale

    local res = monitor.reserved
    if type(res) == "table" then
        w = w - (res.left or 0) - (res.right or 0)
        h = h - (res.top or 0) - (res.bottom or 0)
    end
    if w <= 0 or h <= 0 then
        return nil
    end

    local margin = (1 - scale_factor) / 2
    local gx = round(w * margin)
    local gy = round(h * margin)
    if gx <= 0 and gy <= 0 then
        return nil
    end

    return {
        workspace = "s[true] m[" .. name .. "]",
        gaps_out  = { top = gy, right = gx, bottom = gy, left = gx, },
    }
end

local function sync()
    if not config then
        return
    end

    local wanted = {}
    for _, monitor in ipairs(hl.get_monitors() or {}) do
        local name = monitor.name
        if name and monitor.enabled ~= false then
            local spec = rule_spec(name, monitor, config)
            if spec then
                wanted[name] = spec
            end
        end
    end

    -- Update only rules whose gaps changed.
    for name, spec in pairs(wanted) do
        local gaps = spec.gaps_out
        local sig = gaps.top .. "," .. gaps.right .. "," .. gaps.bottom ..
            "," .. gaps.left
        if applied[name] ~= sig then
            applied[name] = sig
            rules[name] = hl.workspace_rule(spec)
        end
    end

    -- Disable rules of monitors that disappeared.
    for name, rule in pairs(rules) do
        if not wanted[name] then
            rule:set_enabled(false)
            rules[name] = nil
            applied[name] = nil
        end
    end
end

local function bind_events()
    if bound then
        return
    end
    bound = true

    hl.on("config.unload", function()
        for _, rule in pairs(rules) do
            rule:set_enabled(false)
        end
        rules   = {}
        applied = {}
        config  = nil
    end)

    hl.on("hyprland.start", sync)
    hl.on("monitor.added", sync)
    hl.on("monitor.removed", sync)
    hl.on("monitor.layout_changed", sync)
end

-- Apply proportional outer gaps (usable fraction) to special workspaces on
-- every active monitor.
function M.apply_special_scale(scale_factor)
    config = scale_factor or 1
    if config <= 0 or config >= 1 then
        config = nil
        return
    end

    bind_events()
    sync()
end

return M
