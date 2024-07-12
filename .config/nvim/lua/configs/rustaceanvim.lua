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
			local opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "s", '<cmd>lua require("tree_climber_rust").init_selection()<CR>', opts)
			vim.keymap.set("x", "s", '<cmd>lua require("tree_climber_rust").select_incremental()<CR>', opts)
			vim.keymap.set("x", "S", '<cmd>lua require("tree_climber_rust").select_previous()<CR>', opts)

			-- Hover actions
			vim.keymap.set("n", "<C-space>", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, opts)

			-- Code action groups
			vim.keymap.set("n", "<Leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end, opts)
		end,
	},
	-- DAP configuration
	-- dap = { adapter = adapter },
}
