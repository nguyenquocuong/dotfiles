-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require("nvchad.configs.lspconfig")

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
	})
end

-- typescript
lspconfig.ts_ls.setup({
	on_attach = function(client, bufnr)
		nvlsp.on_attach(client, bufnr)

		vim.keymap.set("n", "fO", function()
			vim.lsp.buf.execute_command({
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
				title = "",
			})
		end, { buffer = bufnr })
	end,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
})

lspconfig.eslint.setup({
	on_attach = nvlsp.on_attach,
	capabilities = nvlsp.capabilities,
})

lspconfig.terraformls.setup({
	on_attach = nvlsp.on_attach,
	capabilities = nvlsp.capabilities,
	filetypes = { "terraform", "tf" },
})

lspconfig.clangd.setup({
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
})

lspconfig.gopls.setup({
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
