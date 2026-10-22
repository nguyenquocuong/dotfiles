local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.winborder = "rounded"

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.splitbelow = true
opt.splitright = true

opt.updatetime = 250
opt.timeoutlen = 400

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

opt.completeopt = { "menu", "menuone", "noselect" }

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.fillchars = { eob = " " }

opt.shortmess:append("c")

opt.list = true
opt.listchars:append({
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
})

-- lualine already shows the mode
opt.showmode = false
