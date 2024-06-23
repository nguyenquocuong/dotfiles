require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable default mappings
nomap("n", "<C-n>")
--

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "j", "jzz")
map("n", "k", "kzz")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>")
