vim.g.mapleader = " "

vim.keymap.set("i", "jk", "<ESC>")

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })

vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

vim.keymap.set({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })
