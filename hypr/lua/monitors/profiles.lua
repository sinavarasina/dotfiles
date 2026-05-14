local path = require("lua.core.paths")

local M = {}

local function base(output, mode, position, scale)
    return {
        output = output,
        mode = mode,
        position = position or "auto",
        scale = scale or 1,
    }
end

function M.sdr(output, mode, position, scale)
    return base(output, mode, position, scale)
end

function M.icc(output, mode, position, scale)
    local spec = base(output, mode, position, scale)
    spec.bitdepth = 10
    spec.icc = path.file.icc
    return spec
end

function M.auto_cm(output, mode, position, scale)
    local spec = base(output, mode, position, scale)
    spec.bitdepth = 10
    spec.cm = "auto"
    return spec
end

function M.hdr(output, mode, position, scale)
    local spec = base(output, mode, position, scale)
    spec.bitdepth = 10
    spec.cm = "hdr"
    spec.sdrbrightness = 1.1
    return spec
end

return M
