return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
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
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Automatically add closing tags for HTML and JSX
	{
		"windwp/nvim-ts-autotag",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
	},
}
