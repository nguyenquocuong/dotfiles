-- local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"
-- local codelldb_path = extension_path .. "/adapter/codelldb"
-- local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"
--
-- local cfg = require("rustaceanvim.config")
-- local adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)

vim.g.rustaceanvim = {
	-- LSP configuration
	server = {
		on_attach = function(client, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { silent = true, buffer = bufnr })

			-- Code action groups
			vim.keymap.set("n", "<Leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end, { silent = true, buffer = bufnr })
		end,
	},
	-- DAP configuration
	-- dap = { adapter = adapter },
}
