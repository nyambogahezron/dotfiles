-- ~/.config/nvim/lua/plugins/ai.lua

return {
  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = function()
      return vim.fn.executable("node") == 1
    end,
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  -- Copilot completion source
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    cond = function()
      return vim.fn.executable("node") == 1
    end,
    opts = {},
    config = function(_, opts)
      require("copilot_cmp").setup(opts)
    end,
  },

  -- Gemini (chat + inline)
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = { api_key = "GEMINI_API_KEY" },
          })
        end,
      },
    },
  },
}
