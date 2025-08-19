return {
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    },
    config = function()
      vim.keymap.set("n", "<leader>rs", "<cmd>Rest env select<CR>", { desc = "Rest select env" })
      vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<CR>", { desc = "Run rest command" })
      vim.keymap.set("n", "<leader>rl", "<cmd>Rest run last<CR>", { desc = "Run last rest command" })
    end,
  },
}
