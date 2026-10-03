return {
  -- Lazydocker integration for managing containers directly from Neovim
  {
    "crnvl96/lazydocker.nvim",
    event = "VeryLazy",
    opts = {},  -- automatically calls setup
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>gd", "<cmd>LazyDocker<cr>", desc = "LazyDocker" },
    },
  },
}
