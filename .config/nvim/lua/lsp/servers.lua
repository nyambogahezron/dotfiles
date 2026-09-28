local M = {}

local runtime = require("lsp.runtime")

local TS_LS = {
  pkg = "typescript-language-server",
  entry = "node_modules/typescript-language-server/lib/cli.mjs",
  args = { "--stdio" },
  bin = "typescript-language-server",
}

local TAILWINDCSS = {
  pkg = "@tailwindcss/language-server",
  entry = "node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server",
  args = { "--stdio" },
  bin = "tailwindcss-language-server",
}

---`cmd` functions in Neovim 0.11 receive the resolved config, so the argv can
---be derived from the project root of the buffer that triggered the start.
local function js_server(spec)
  return function(dispatchers, config)
    local root_dir = config and config.root_dir
    local argv = assert(runtime.js_argv(root_dir, spec), "no runtime available for " .. spec.pkg)
    return vim.lsp.rpc.start(argv, dispatchers, { cwd = root_dir })
  end
end

M.ensure_installed = {
  "lua_ls",
  "pyright",
  "gopls",
  "bashls",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "dockerls",
  "docker_compose_language_service",
  "biome",
  "markdown_oxide",
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
  ts_ls = {
    probe = function(root_dir)
      return runtime.js_argv(root_dir, TS_LS)
    end,
    cmd = js_server(TS_LS),
    root_dir = function(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json" }))
    end,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      workspace = { inlayHints = { refreshOnEdit = true } },
    },
  },
  biome = {
    probe = function(root_dir)
      return runtime.biome_argv(root_dir)
    end,
    cmd = function(dispatchers, config)
      local root_dir = config and config.root_dir
      local argv = assert(runtime.biome_argv(root_dir), "no runtime available for biome")
      return vim.lsp.rpc.start(argv, dispatchers, { cwd = root_dir })
    end,
    root_dir = function(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }))
    end,
  },
  markdown_oxide = {},
  eslint = {},
  tailwindcss = {
    probe = function(root_dir)
      return runtime.js_argv(root_dir, TAILWINDCSS)
    end,
    cmd = js_server(TAILWINDCSS),
    root_dir = function(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, {
        "postcss.config.js",
        "postcss.config.mjs",
        "postcss.config.cjs",
        "postcss.config.ts",
        "tailwind.config.js",
        "tailwind.config.mjs",
        "tailwind.config.cjs",
        "tailwind.config.ts",
      }))
    end,
  },
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
  lemminx = {},
  angularls = {},
  golangci_lint_ls = {},
  glsl_analyzer = {},
}

return M
