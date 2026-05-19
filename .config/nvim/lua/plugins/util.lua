return {
  -- Tmux & split window navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- Autoclose parentheses, brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- High-performance color highlighter
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = "both",
      },
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({})
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function(_, opts)
      require("Comment").setup(opts)
      local api = require("Comment.api")
      vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, { desc = "Toggle line comment" })
      vim.keymap.set("i", "<C-/>", api.toggle.linewise.current, { desc = "Toggle line comment" })
      vim.keymap.set("v", "<C-/>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle line comment" })
      vim.keymap.set("n", "<C-S-/>", api.toggle.blockwise.current, { desc = "Toggle block comment" })
      vim.keymap.set("v", "<C-S-/>", "<ESC><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>", { desc = "Toggle block comment" })
    end,
  },

}

