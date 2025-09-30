return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          json = { "jq" },
          lua = { "stylua" },
          sql = { "sleek" },
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
        },
        formatters = {
          prettier = {
            condition = function(self, ctx)
              local root = require("conform.util").root_file({
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.js",
                ".prettierrc.cjs",
                "prettier.config.js",
                "prettier.config.cjs",
              })(self, ctx)

              return root ~= nil
            end
          }
        }
      })
    end
  },
}
