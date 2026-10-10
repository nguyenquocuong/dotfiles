vim.g.rustaceanvim = {
  server = {
    on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set("n", "s", function() require("tree_climber_rust").init_selection() end, opts)
      vim.keymap.set("x", "s", function() require("tree_climber_rust").select_incremental() end, opts)
      vim.keymap.set("x", "S", function() require("tree_climber_rust").select_previous() end, opts)

      -- Code actions
      vim.keymap.set('n', '<leader>ca', function()
        vim.cmd.RustLsp({ 'codeAction' })
      end, opts)
      vim.keymap.set('n', 'K', function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
      end, opts)
    end,
  },
}
