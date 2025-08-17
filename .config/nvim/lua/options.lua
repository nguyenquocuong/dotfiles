local opt = vim.opt

-- UI
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true     -- Highlight current line
opt.termguicolors = true  -- True color support
opt.signcolumn = "yes"    -- Always show sign column
opt.wrap = true           -- No line wrap by default
opt.scrolloff = 8         -- Keep cursor away from screen edge
opt.sidescrolloff = 8     -- Same for horizontal scroll

-- Indentation
opt.expandtab = true   -- Tabs -> spaces
opt.tabstop = 2        -- Tab width
opt.shiftwidth = 2     -- Indent width
opt.softtabstop = 2    -- Backspace behaves as expected
opt.smartindent = true -- Smart autoindent

-- Search
opt.ignorecase = true -- Ignore case by default
opt.smartcase = true  -- Override ignorecase if search has capitals
opt.incsearch = true  -- Show matches while typing
opt.hlsearch = true   -- Highlight search matches

-- Clipboard & mouse
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a"               -- Enable mouse in all modes

-- Splits
opt.splitbelow = true -- Horizontal split below
opt.splitright = true -- Vertical split to the right

-- Performance
opt.updatetime = 250 -- Faster CursorHold events
opt.timeoutlen = 400 -- Shorter mapped sequence timeout

-- File handling
opt.swapfile = false -- Disable swapfiles
opt.backup = false   -- No backup file
opt.undofile = true  -- Persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Better fillchars for UI
opt.fillchars = { eob = " " }

-- Reduce command line messages
opt.shortmess:append("c")

-- Show whitespace
opt.list = true
opt.listchars:append({
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
})

-- Disable showing current mode (since it's in statusline)
opt.showmode = false
