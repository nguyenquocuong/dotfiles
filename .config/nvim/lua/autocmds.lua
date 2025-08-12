-- Reload file when changed externally
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })
