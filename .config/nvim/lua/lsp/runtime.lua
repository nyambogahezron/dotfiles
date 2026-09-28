-- Runtime resolution for language servers that ship as JavaScript/Node packages.
-- Everything is executed through Bun when it is available so a Node install is
-- not required inside Neovim's (non-interactive) environment.
local M = {}

local function is_executable(path)
  return path ~= "" and vim.fn.executable(path) == 1
end

local function is_file(path)
  return path ~= "" and vim.fn.filereadable(path) == 1
end

---Walk up from `from` looking for a relative path that satisfies `predicate`.
---@param from string|nil
---@param rel string
---@param predicate fun(path: string): boolean
---@return string|nil
function M.find_up(from, rel, predicate)
  local dir = from
  while dir and dir ~= vim.fs.dirname(dir) do
    local hit = vim.fs.joinpath(dir, rel)
    if predicate(hit) then
      return hit
    end
    dir = vim.fs.dirname(dir)
  end
end

---Walk up from `from` looking for an executable matching a (globbed) `rel`.
---@param from string|nil
---@param rel string
---@return string|nil
function M.find_up_executable(from, rel)
  local dir = from
  while dir and dir ~= vim.fs.dirname(dir) do
    for _, hit in ipairs(vim.fn.glob(vim.fs.joinpath(dir, rel), false, true)) do
      if is_executable(hit) then
        return hit
      end
    end
    dir = vim.fs.dirname(dir)
  end
end

---@return string|nil
function M.js_runtime()
  local bun = vim.fn.exepath("bun")
  if bun ~= "" then
    return bun
  end
  local fallback = vim.fs.joinpath(vim.uv.os_homedir(), ".bun", "bin", "bun")
  if is_executable(fallback) then
    return fallback
  end
end

---Build the argv for a JavaScript language server.
---Resolution order: Bun + the project-pinned entry point, the binary on $PATH,
--- then `bun x <pkg>`. Returns nil when no runtime can run the server.
---@param root_dir string|nil
---@param spec { pkg: string, entry: string, args: string[], bin: string }
---@return string[]|nil
function M.js_argv(root_dir, spec)
  local runtime = M.js_runtime()
  local entry = M.find_up(root_dir, spec.entry, is_file)
  if runtime and entry then
    return vim.list_extend({ runtime, entry }, spec.args)
  end
  if is_executable(spec.bin) then
    return vim.list_extend({ spec.bin }, spec.args)
  end
  if runtime then
    return vim.list_extend({ runtime, "x", spec.pkg }, spec.args)
  end
end

---Biome ships platform specific native binaries that speak LSP over
---`lsp-proxy`, so prefer those over the JavaScript entry point.
---@param root_dir string|nil
---@return string[]|nil
function M.biome_argv(root_dir)
  local native = M.find_up_executable(root_dir, "node_modules/@biomejs/cli-*/biome")
  if native then
    return { native, "lsp-proxy" }
  end
  local runtime = M.js_runtime()
  local shim = M.find_up(root_dir, "node_modules/.bin/biome", is_file)
  if runtime and shim then
    return { runtime, shim, "lsp-proxy" }
  end
  if is_executable("biome") then
    return { "biome", "lsp-proxy" }
  end
end

---True when the buffer belongs to a project that uses Biome, in which case
---formatting is delegated to the Biome LSP instead of Prettier.
---@param bufnr number|nil
---@return boolean
function M.uses_biome(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then
    return false
  end
  return vim.fs.root(name, { "biome.json", "biome.jsonc" }) ~= nil
end

return M
