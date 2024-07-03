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
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function(_, opts)
			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "🛑", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)
		end,
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = false,
		config = function(_, opts)
			require("nvim-dap-virtual-text").setup(opts)
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		version = "^4",
		lazy = false,
		dependencies = { "rcarriga/nvim-dap-ui" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"
			local codelldb_bin = codelldb_path .. "/adapter/codelldb"

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_bin,
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input({
							prompt = "Path to executable: ",
							default = vim.fn.getcwd() .. "/",
							completion = "file",
						})
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- local on_attach = require("nvchad.configs.lspconfig").on_attach
			-- local on_init = require("nvchad.configs.lspconfig").on_init
			-- local capabilities = require("nvchad.configs.lspconfig").capabilities

			-- vim.g.rustaceanvim = {
			-- 	-- DAP configuration
			-- 	dap = {},
			-- }
		end,
	},
}
