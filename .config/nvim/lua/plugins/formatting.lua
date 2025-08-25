return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          sql = { "sleek" },
          python = { "isort", "black" },
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
