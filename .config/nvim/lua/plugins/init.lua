return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
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
				"http",
				"c",
				"cpp",
				"markdown",
				"markdown_inline",
				"go",
				"rust",
				"just",
				"zig",
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
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},

	{
		"mg979/vim-visual-multi",
		lazy = false,
	},

	-- {
	-- 	"nvim-pack/nvim-spectre",
	-- 	lazy = false,
	-- },

	{
		"NoahTheDuke/vim-just",
		ft = { "just" },
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("configs.nvim-surround")
		end,
	},
}
