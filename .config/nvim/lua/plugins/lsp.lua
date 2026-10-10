return {
  -- LSP Installer
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "eslint",
          "pyright",
          "gopls",
          "ruff",
        },
        -- rustaceanvim starts rust-analyzer itself; a second instance doubles diagnostics
        automatic_enable = {
          exclude = { "rust_analyzer" },
        },
      })
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")
    end,
  },
}
