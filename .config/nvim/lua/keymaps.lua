local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

map("i", "jk", "<ESC>")

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })

map("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

map("n", "<leader>x", function()
  local api = vim.api
  local buf = api.nvim_get_current_buf()

  -- Check if buffer is modified
  if vim.bo.modified then
    vim.notify("Buffer has unsaved changes!", vim.log.levels.WARN)
    return
  end

  -- Try switching to the alternate buffer first
  local alt = vim.fn.bufnr("#")
  if alt > 0 and api.nvim_buf_is_loaded(alt) and alt ~= buf then
    vim.cmd("buffer #")
  else
    -- Otherwise, try the last buffer in this window's buffer list
    local buflist = vim.fn.getbufinfo({ buflisted = 1 })
    local last_buf = nil
    for _, b in ipairs(buflist) do
      if b.bufnr ~= buf then
        last_buf = b.bufnr
      end
    end

    if last_buf then
      vim.cmd("buffer " .. last_buf)
    else
      -- If no other buffer exists, create a new empty one
      vim.cmd("enew")
    end
  end

  -- Finally, delete the old buffer
  if api.nvim_buf_is_loaded(buf) then
    vim.cmd("bdelete! " .. buf)
  end
end, { desc = "Delete buffer" })
