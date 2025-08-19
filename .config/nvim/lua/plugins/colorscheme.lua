return {
  {
    "folke/tokyonight.nvim",
    -- "navarasu/onedark.nvim",
    -- "rebelot/kanagawa.nvim",
    -- "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
