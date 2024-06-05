local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

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
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},

	{
		"mfussenegger/nvim-dap",
		config = function()
			require("core.utils").load_mappings("dap")
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install copilot
	{
		"zbirenbaum/copilot.lua",
		-- Lazy load when event occurs. Events are triggered
		-- as mentioned in:
		-- https://vi.stackexchange.com/a/4495/20389
		event = "InsertEnter",
		-- You can also have it load at immediately at
		-- startup by commenting above and uncommenting below:
		-- lazy = false
		opts = overrides.copilot,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

  {
    "easymotion/vim-easymotion",
    event = "BufRead",
    lazy = false,
    config = function()
      require("custom.configs.vim-easymotion")
    end,
  },

	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },
	{
		"mg979/vim-visual-multi",
		lazy = false,
	},
  {
    "nvim-pack/nvim-spectre",
    lazy = false,
  },

	{
		"Shatur/neovim-tasks",
		ft = { "h", "cpp", "cmake" },
		config = function()
			local Path = require("plenary.path")

			require("tasks").setup({
				default_params = { -- Default module parameters with which `neovim.json` will be created.
					cmake = {
						cmd = "cmake", -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
						build_dir = tostring(Path:new("{cwd}", "build", "{os}-{build_type}")), -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
						build_type = "Debug", -- Build type, can be changed using `:Task set_module_param cmake build_type`.
						dap_name = "codelldb", -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
						args = { -- Task default arguments.
							configure = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
						},
					},
				},
				save_before_run = false, -- If true, all files will be saved before executing a task.
				params_file = "neovim.json", -- JSON file to store module and task parameters.
				quickfix = {
					pos = "botright", -- Default quickfix position.
					height = 12, -- Default height.
				},
				dap_open_command = function()
					local dap, dapui = require("dap"), require("dapui")

					dapui.setup()

					dap.configurations.cpp = {
						{
							name = "Launch",
							type = "codelldb",
							request = "launch",
							stopOnEntry = false,
							args = {},
							runInTerminal = true,
						},
					}

					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
			})
		end,
	},
}

return plugins
