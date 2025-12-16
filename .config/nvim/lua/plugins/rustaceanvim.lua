return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false,   -- This plugin is already lazy
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "adaszko/tree_climber_rust.nvim"
    },
    config = function()
      require("configs.rustaceanvim")
    end
  },

  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      require('crates').setup()
    end,
  }
}
