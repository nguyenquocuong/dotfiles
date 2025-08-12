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

map("n", "<leader>x", ":bd<CR>", { desc = "Delete buffer" })
