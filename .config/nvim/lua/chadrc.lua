-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "chadracula-evondev",
	theme_toggle = { "chadracula-evondev", "one_light" },

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},
}

M.ui = {
	statusline = {
		theme = "vscode_colored",
		separator_style = "block",
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
		"eslint-lsp",

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
