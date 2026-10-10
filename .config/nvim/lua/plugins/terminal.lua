return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- Size of terminal
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<A-i>]], -- Keymap to toggle
        hide_numbers = true,      -- Hide line numbers in terminal buffer
        shade_terminals = true,
        shading_factor = 2,       -- Terminal shading amount
        start_in_insert = true,
        insert_mappings = true,   -- Allow toggling in insert mode
        persist_size = true,
        direction = "float",      -- "horizontal" | "vertical" | "tab" | "float"
        close_on_exit = true,
        shell = vim.o.shell,      -- Shell to use
        float_opts = {
          border = vim.o.winborder,
          width = math.floor(vim.o.columns * 0.5),
          height = math.floor(vim.o.lines * 0.4),
        },
      })

      -- Optional: Quick floating terminal with lazygit
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = vim.o.winborder,
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
        },
      })

      vim.keymap.set("n", "<leader>gg", function()
        lazygit:toggle()
      end, { noremap = true, silent = true, desc = "Toggle lazygit" })
    end
  }
}
