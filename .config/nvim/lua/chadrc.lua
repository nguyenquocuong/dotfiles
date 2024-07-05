-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "one_light",
	theme_toggle = { "chadracula-evondev", "one_light" },

	statusline = {
		theme = "vscode_colored",
		separator_style = "block",
	},

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},
}

return M
