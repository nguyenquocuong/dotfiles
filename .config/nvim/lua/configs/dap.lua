local dap = require("dap")
local dapui = require("dapui")
local utils = require("dap.utils")

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

dap.adapters = {
  ["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "js-debug-adapter",
      args = {
        "${port}",
      },
    },
  }
}

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      name = "Launch",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = "pwa-node",
      request = 'attach',
      cwd = "${workspaceFolder}"
    },
  }
end

vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue" })
vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into" })
vim.keymap.set("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "Step over" })
vim.keymap.set("n", "<leader>de", "<cmd>lua require('dap').terminate()<CR>", { desc = "Terminate" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", { desc = "Run last" })

vim.keymap.set("n", "<leader>dr", "<cmd>RustLsp runnables<CR>", { desc = "Runnables" })
vim.keymap.set("n", "<leader>dt", "<cmd>RustLsp testables<CR>", { desc = "Testables" })
