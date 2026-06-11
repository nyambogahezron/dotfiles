local M = {}

M.ensure_installed = {
  "lua_ls",
  "pyright",
  "gopls",
  "bashls",
  "tsserver",
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "dockerls",
  "docker_compose_language_service",
  "biome",
  "codeqlls",
  "markdown_oxide",
  "cssvariables",
  "eslint",
  "tailwindcss",
  "emmet_language_server",
  "marksman",
  "ruff",
  "rust_analyzer",
  "clangd",
  "jdtls",
  "solargraph",
  "intelephense",
  "zls",
  "terraformls",
  "graphql",
  "prismals",
  "taplo",
  "sqlls",
  "texlab",
  "elixirls",
  "hls",
  "svelte",
  "volar",
  "kotlin_language_server",
  "dartls",
  "cmake",
  "nil",
  "lemminx",
  "angularls",
  "golangci_lint_ls",
  "glsl_analyzer",
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
  biome = {},
  codeqlls = {},
  markdown_oxide = {},
  cssvariables = {},
  eslint = {},
  tailwindcss = {},
  emmet_language_server = {},
  marksman = {},
  ruff = {},
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
    on_new_config = function(new_config)
      new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
    end,
    settings = {
      yaml = {
        schemaStore = { enable = false, url = "" },
        keyOrdering = false,
      },
    },
  },
  dockerls = {},
  docker_compose_language_service = {},
  clangd = {},
  jdtls = {},
  solargraph = {},
  intelephense = {},
  zls = {},
  terraformls = {},
  graphql = {},
  prismals = {},
  taplo = {},
  sqlls = {},
  texlab = {},
  elixirls = {},
  hls = {},
  svelte = {},
  volar = {},
  kotlin_language_server = {},
  dartls = {},
  cmake = {},
  ["nil"] = {},
  lemminx = {},
  angularls = {},
  golangci_lint_ls = {},
  glsl_analyzer = {},
}

return M
