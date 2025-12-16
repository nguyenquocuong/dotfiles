vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

      vim.api.nvim_buf_set_keymap(bufnr, 'n', 's', '<cmd>lua require("tree_climber_rust").init_selection()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'x', 's', '<cmd>lua require("tree_climber_rust").select_incremental()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'x', 'S', '<cmd>lua require("tree_climber_rust").select_previous()<CR>', opts)

      -- Code actions
      vim.keymap.set('n', '<leader>ca', function()
        vim.cmd.RustLsp({ 'codeAction' })
      end)
      vim.keymap.set('n', 'K', function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
      end)
    end,
  },
}
