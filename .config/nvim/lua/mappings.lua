require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable default mappings
nomap("n", "<C-n>")
--

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")

map("n", "j", "jzz")
map("n", "k", "kzz")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- nvimtree
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "terminal toggleable vertical term" })

-- lsp
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- easymotion
vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_noremap = 1

map("n", "<Space><Space>", "<Plug>(easymotion-overwin-f2)")

-- dap
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue" })
map("n", "<leader>dd", "<cmd>DapTerminate<CR>", { desc = "Terminate" })
map("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into" })
map("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "Step over" })
map("n", "<leader>do", "<cmd>DapStepOut<CR>", { desc = "Step out" })
