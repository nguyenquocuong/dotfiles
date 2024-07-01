local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = { "html", "cssls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		on_init = on_init,
		capabilities = capabilities,
	})
end

-- typescript
lspconfig.tsserver.setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
})

lspconfig.terraformls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "terraform", "tf" },
})

lspconfig.clangd.setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
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
})

lspconfig.gopls.setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
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
})

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
