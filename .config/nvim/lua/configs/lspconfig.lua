-- LSP keymaps (when any server attaches).
-- An autocmd instead of per-server on_attach, so nvim-lspconfig's own on_attach
-- (e.g. ts_ls and clangd user commands) is not replaced.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    -- In Rust buffers, rustaceanvim sets these (configs/rustaceanvim.lua)
    if vim.bo[bufnr].filetype ~= "rust" then
      keymap("n", "K", vim.lsp.buf.hover, opts)
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "gi", vim.lsp.buf.implementation, opts)
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
    keymap("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    keymap("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)

    if client.name == "ts_ls" then
      keymap("n", "fO", function()
        client:exec_cmd({
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(bufnr) },
          title = "",
        }, { bufnr = bufnr })
      end, opts)
    end
  end,
})

-- Capabilities (for completion plugin like nvim-cmp), shared by all servers
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  vim.lsp.config("*", { capabilities = cmp_lsp.default_capabilities() })
end

local servers = {
  html = {},
  cssls = {},
  bashls = {},
  pyright = {},
  zls = {},

  ruff = {
    init_options = {
      settings = {
        logLevel = 'debug'
      }
    }
  },

  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell lua_ls to use LuaJIT runtime (what Neovim uses)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false, -- turn off prompt for third party libraries
        },
        telemetry = { enable = false },
      },
    },
  },

  ts_ls = {
    init_options = {
      preferences = {
        importModuleSpecifierPreference = "relative",
        importModuleSpecifierEnding = "minimal",
      },
    },
  },

  terraformls = {
    filetypes = { "terraform", "tf" },
  },

  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--offset-encoding=utf-16",
      "--query-driver=/usr/bin/clang*",
    },
    filetypes = { "c", "cpp" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
  },

  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
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
  vim.lsp.config(name, opts) -- nvim v0.11.0 or above required
  vim.lsp.enable(name)       -- nvim v0.11.0 or above required
end
