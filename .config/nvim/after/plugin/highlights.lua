vim.diagnostic.config({
  virtual_text = true, -- show inline
  signs = true,        -- show signs in gutter
  underline = true,
  update_in_insert = false,
})

local groups = {
  "DiagnosticVirtualTextError",
  "DiagnosticVirtualTextWarn",
  "DiagnosticVirtualTextInfo",
  "DiagnosticVirtualTextHint",
}

for _, group in ipairs(groups) do
  local hl = vim.api.nvim_get_hl(0, { name = group })
  hl.bg = "NONE" -- remove background
  vim.api.nvim_set_hl(0, group, hl)
end
