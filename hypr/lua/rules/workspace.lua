-- lua/rules/workspace.lua — Workspace rules

local c = require("lua.core").c

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0, })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0, })
hl.workspace_rule({ workspace = "5", layout = c.layout.master, })
hl.workspace_rule({ workspace = "6", layout = c.layout.monocle, })
hl.workspace_rule({ workspace = "7", layout = c.layout.scrolling, })
