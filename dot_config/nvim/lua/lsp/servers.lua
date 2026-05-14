-- ~/.config/nvim/lua/lsp/servers.lua

local M = {}

M.ensure_installed = {
  "lua_ls",
  "pyright",
  "bashls",
  "tsserver",
  "jsonls",
  "html",
  "cssls",
  "tailwindcss",
  "rust_analyzer",
  "gopls",
  "yamlls",
  "dockerls",
}

M.servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  pyright = {},
  bashls = {},
  tsserver = {},
  jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = { enable = true },
        validate = { enable = true },
      },
    },
  },
  html = {},
  cssls = {},
  tailwindcss = {
    filetypes_exclude = { "markdown" },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        procMacro = { enable = true },
        cargo = { allFeatures = true },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          parameterTypes = true,
        },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
      },
    },
  },
  dockerls = {},
}

return M
