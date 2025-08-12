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
}
