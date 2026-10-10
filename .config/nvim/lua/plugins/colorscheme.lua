return {
  {
    "folke/tokyonight.nvim",
    -- "navarasu/onedark.nvim",
    -- "rebelot/kanagawa.nvim",
    -- "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Let the WezTerm background show through
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl)
        -- The completion menu ignores the floats style; keep only the selected item solid
        hl.Pmenu = { fg = hl.Pmenu.fg, bg = "NONE" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
