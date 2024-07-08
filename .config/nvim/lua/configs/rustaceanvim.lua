local dap, dapui = require("dap"), require("dapui")

dapui.setup()
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"
local codelldb_bin = codelldb_path .. "/adapter/codelldb"

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_bin,
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		name = "Launch",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input({
				prompt = "Path to executable: ",
				default = vim.fn.getcwd() .. "/",
				completion = "file",
			})
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

vim.g.rustaceanvim = {
	-- LSP configuration
	server = {
		on_attach = function(client, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { buffer = bufnr })

			-- Code action groups
			vim.keymap.set("n", "<Leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end, { buffer = bufnr })
		end,
	},
	-- DAP configuration
	dap = {},
}
