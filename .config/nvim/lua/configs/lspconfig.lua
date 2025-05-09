-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")
local nvlsp = require("nvchad.configs.lspconfig")

local servers = {
	html = {},
	cssls = {},
	bashls = {},
	zls = {},

	ts_ls = {
		on_attach = function(client, bufnr)
			nvlsp.on_attach(client, bufnr)

			vim.keymap.set("n", "fO", function()
				vim.lsp.client.exec_cmd(client, {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				})
			end, { buffer = bufnr })
		end,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
		init_options = {
			preferences = {
				importModuleSpecifierPreference = "relative",
				importModuleSpecifierEnding = "minimal",
			},
		},
	},

	eslint = {
		on_attach = nvlsp.on_attach,
		capabilities = nvlsp.capabilities,
	},

	terraformls = {
		on_attach = nvlsp.on_attach,
		capabilities = nvlsp.capabilities,
		filetypes = { "terraform", "tf" },
	},

	clangd = {
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
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
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
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
	vim.lsp.enable(name) -- nvim v0.11.0 or above required
	vim.lsp.config(name, opts) -- nvim v0.11.0 or above required
end

-- lspconfig.rust_analyzer.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     ["rust-analyzer"] = {
--       checkOnSave = {
--         command = "clippy",
--       },
--     },
--   },
-- })
