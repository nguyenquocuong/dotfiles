local vim = vim

vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_noremap = 1

vim.api.nvim_set_keymap("n", "<Space><Space>", "<Plug>(easymotion-overwin-f2)", {})
