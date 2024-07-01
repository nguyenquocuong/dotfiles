require("nvchad.mappings")

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

map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "terminal toggleable vertical term" })

-- easymotion
vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_noremap = 1

map("n", "<Space><Space>", "<Plug>(easymotion-overwin-f2)")

-- dap
map("n", "<F8>", "<cmd>DapStepInto<CR>", { desc = "Step into" })
map("n", "<F9>", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
map("n", "<F5>", "<cmd>DapContinue<CR>", { desc = "Continue" })
map("n", "<leader>dd", "<cmd>DapTerminate<CR>", { desc = "Terminate" })
