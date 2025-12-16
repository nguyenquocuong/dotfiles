return {
  {
    "mfussenegger/nvim-dap",
    config = function()
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

      vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into" })
      vim.keymap.set("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "Step over" })
      vim.keymap.set("n", "<leader>de", "<cmd>lua require('dap').terminate()<CR>", { desc = "Terminate" })
      vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", { desc = "Run last" })

      vim.keymap.set("n", "<leader>dr", "<cmd>RustLsp runnables<CR>", { desc = "Runnables" })
      vim.keymap.set("n", "<leader>dt", "<cmd>RustLsp testables<CR>", { desc = "Testables" })
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#FF0000", bg = "" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "", bg = "#31353f" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
      )
    end
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)
    end
  }
}
