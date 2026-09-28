local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Neovim is not started from a login shell, so nvm's node is missing from $PATH.
-- Language servers are launched through Bun, but node based plugins (copilot,
-- cspell, eslint, prettierd, ...) still expect a node binary.
if vim.fn.executable("node") == 0 then
  local root = vim.fs.joinpath(vim.env.HOME, ".nvm", "versions", "node")
  local latest, latest_major
  for _, version in ipairs(vim.fn.glob(vim.fs.joinpath(root, "*"), false, true)) do
    local major = tonumber(version:match("v(%d+)"))
    if major and (not latest_major or major > latest_major) then
      latest, latest_major = version, major
    end
  end
  if latest then
    vim.env.PATH = vim.fs.joinpath(latest, "bin") .. ":" .. vim.env.PATH
  end
end

-- Load options, keymaps, and autocmds
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup lazy.nvim with plugin directory
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
