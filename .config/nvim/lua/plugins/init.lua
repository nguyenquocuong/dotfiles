---@type NvPluginSpec
return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		config = function()
			require("configs.conform")
		end,
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
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
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"c",
				"cpp",
				"markdown",
				"markdown_inline",
				"go",
				"rust",
			},
			indent = {
				enable = true,
				-- disable = {
				--   "python"
				-- },
			},
		},
	},

	{
		"easymotion/vim-easymotion",
		lazy = false,
	},

	{
		"mg979/vim-visual-multi",
		lazy = false,
	},

	{
		"nvim-pack/nvim-spectre",
		lazy = false,
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		lazy = false,
		dependencies = { "rcarriga/nvim-dap-ui" },
		config = function()
			vim.g.rustaceanvim = {
				-- DAP configuration
				dap = {},
			}
		end,
	},
}
