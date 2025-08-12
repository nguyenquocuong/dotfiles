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
    end
  }
}
