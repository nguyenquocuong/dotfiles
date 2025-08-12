local lspconfig = require("lspconfig")

-- LSP keymaps (when server attaches)
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  keymap("n", "K", vim.lsp.buf.hover, opts)
  keymap("n", "gd", vim.lsp.buf.definition, opts)
  keymap("n", "gr", vim.lsp.buf.references, opts)
  keymap("n", "gi", vim.lsp.buf.implementation, opts)
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  keymap("n", "[d", vim.diagnostic.goto_prev, opts)
  keymap("n", "]d", vim.diagnostic.goto_next, opts)
end

-- Capabilities (for completion plugin like nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local servers = {
  lua_ls = {},
  html = {},
  cssls = {},
  bashls = {},
  zls = {},

  ts_ls = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      vim.keymap.set("n", "fO", function()
        vim.lsp.client.exec_cmd(client, {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        })
      end, { buffer = bufnr })
    end,
    -- on_init = nvlsp.on_init,
    capabilities,
    init_options = {
      preferences = {
        importModuleSpecifierPreference = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
  },

  eslint = {
    on_attach,
    capabilities,
  },

  terraformls = {
    on_attach,
    capabilities,
    filetypes = { "terraform", "tf" },
  },

  clangd = {
    on_attach,
    -- on_init = nvlsp.on_init,
    capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--offset-encoding=utf-16",
      "--query-driver=/usr/bin/clang*",
    },
    filetypes = { "c", "cpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  },

  gopls = {
    on_attach,
    -- on_init = nvlsp.on_init,
    capabilities,
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod" },
    root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
    settings = {
      gopls = {
        gofumpt = true,
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)       -- nvim v0.11.0 or above required
  vim.lsp.config(name, opts) -- nvim v0.11.0 or above required
end
