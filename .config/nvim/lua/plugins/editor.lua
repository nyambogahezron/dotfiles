return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      { "nvim-lua/plenary.nvim", commit = "74b06c6" },
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>fe", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree (Root Dir)" },
      { "<leader>e",  "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<C-b>", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    },
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },

  -- Search / Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = { { "nvim-lua/plenary.nvim", commit = "74b06c6" } },
    keys = {
      { "<leader>,",  "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>/",  "<cmd>Telescope live_grep<cr>",                    desc = "Grep (root dir)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                      desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                   desc = "Find Files (root dir)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                     desc = "Recent" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",                  desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",                   desc = "status" },
      { "<C-p>",      "<cmd>Telescope find_files<cr>",                   desc = "Quick Open" },
      { "<C-S-f>",    "<cmd>Telescope live_grep<cr>",                    desc = "Search Files" },
      { "<C-S-p>",    "<cmd>Telescope commands<cr>",                     desc = "Command Palette" },
      { "<C-S-o>",    "<cmd>Telescope lsp_document_symbols<cr>",         desc = "Go to Symbol" },
      { "<C-t>",      "<cmd>Telescope lsp_workspace_symbols<cr>",        desc = "Go to Workspace Symbol" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<C-t>"] = function(...) return require("trouble.providers.telescope").open_with_trouble(...) end,
            ["<C-i>"] = function()
              local action_state = require("telescope.actions.state")
              local line = action_state.get_current_line()
              require("telescope.builtin").find_files({ no_ignore = true, default_text = line })
            end,
            ["<C-h>"] = function()
              local action_state = require("telescope.actions.state")
              local line = action_state.get_current_line()
              require("telescope.builtin").find_files({ hidden = true, default_text = line })
            end,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
        },
      },
    },
  },

  -- Keybindings help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader><tab>", group = "tabs" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
      }, { mode = { "n", "v" } })
    end,
  },

  -- Flash (better jumping)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    },
  },

  -- Better diagnostics list
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<C-S-m>", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Problems Panel" },
    },
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },

  -- Persistence
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
