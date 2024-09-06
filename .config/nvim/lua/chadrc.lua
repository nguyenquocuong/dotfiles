-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "chadracula-evondev",
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

M.mason = {
	command = true,
	pkgs = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"prettier",

		-- c/cpp stuff
		"clangd",
		"clang-format",
		"codelldb",

		-- golang stuff
		"gopls",
		"gofumpt",
		"goimports",

		-- rust
		"rust-analyzer",

		"terraform-ls",
	},
}

return M
