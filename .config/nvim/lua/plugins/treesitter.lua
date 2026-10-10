return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      local function start(buf, lang)
        if vim.api.nvim_buf_is_valid(buf) and vim.treesitter.language.add(lang) then
          vim.treesitter.start(buf, lang)
        end
      end

      -- The main branch does not install parsers or start highlighting on its own.
      -- Install a parser the first time its filetype is opened, then highlight.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end
          if vim.treesitter.language.add(lang) then
            start(args.buf, lang)
          elseif available[lang] then
            ts.install(lang):await(function()
              vim.schedule(function()
                start(args.buf, lang)
              end)
            end)
          end
        end,
      })
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
}
