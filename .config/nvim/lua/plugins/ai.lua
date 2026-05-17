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
      filetypes = {
        markdown = true,
        help = true,
      },
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
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
          if event.data == "nvim-cmp" then
            require("cmp").setup.filetype({ "markdown", "help" }, {
              sources = {
                { name = "copilot" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
              },
            })
          end
        end,
      })
    end,
  },
}
