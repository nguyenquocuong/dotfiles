return {
	-- LazyVim base (no extras)
	{ "folke/lazy.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				plugins = {
					spelling = { enabled = true }, -- shows spelling suggestions
				},
				win = {
					border = "single",
				},
			})
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	{
		"mg979/vim-visual-multi",
		branch = "master",
		lazy = false,
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
				["Find Subword Under"] = "<C-d>",
				["Add Cursor Down"] = "<C-j>",
				["Add Cursor Up"] = "<C-k>",
			}
		end,
	},
}
