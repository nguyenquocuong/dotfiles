return {
  -- LSP Installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "pyright", "gopls" },
      })
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local servers = { "lua_ls", "ts_ls", "pyright", "gopls" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({})
      end
    end,
  },
}
