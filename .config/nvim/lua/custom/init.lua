-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "c,cpp",
	callback = function()
		vim.opt.shiftwidth = 4
		vim.opt.tabstop = 4
	end,
})
