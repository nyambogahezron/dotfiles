local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Cursor Movement
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-1>", "1<C-w>w", { desc = "Focus window 1" })
map("n", "<C-2>", "2<C-w>w", { desc = "Focus window 2" })
map("n", "<C-3>", "3<C-w>w", { desc = "Focus window 3" })

-- Splits
map("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "Split window right" })
map("n", "<C-k><C-\\>", "<cmd>split<cr>", { desc = "Split window below" })

-- Resize window
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Leader window helpers
map("n", "<leader>ww", "<C-W>p",         { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c",         { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s",         { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v",         { desc = "Split window right" })

-- File Operations
map({ "x", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })
map({ "i", "n" }, "<C-S-s>", "<cmd>wa<cr><esc>", { desc = "Save all files" })
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<C-S-n>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<C-S-w>", "<cmd>bufdo bd<cr>", { desc = "Close all buffers" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<C-h>", ":%s/\\v//<Left><Left>", { desc = "Find & Replace", silent = false })
map("n", "<C-g>", ":", { desc = "Go to line", silent = false })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Navigation
map("n", "<C-Tab>",    "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<C-S-Tab>",  "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<C-PageUp>",   "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<C-PageDown>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "[b",    "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b",    "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>",  { desc = "Switch to Other Buffer" })
map("n", "<leader>`",  "<cmd>e #<cr>",  { desc = "Switch to Other Buffer" })
map("n", "<A-Left>",  "<C-o>", { desc = "Go back" })
map("n", "<A-Right>", "<C-i>", { desc = "Go forward" })
map({ "n", "v" }, "<C-Home>", "gg", { desc = "Go to top" })
map({ "n", "v" }, "<C-End>",  "G",  { desc = "Go to bottom" })

-- Editing
map("n", "<A-j>",   "<cmd>m .+1<cr>==",      { desc = "Move line down" })
map("n", "<A-k>",   "<cmd>m .-2<cr>==",      { desc = "Move line up" })
map("i", "<A-j>",   "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>",   "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>",   ":m '>+1<cr>gv=gv",     { desc = "Move line down" })
map("v", "<A-k>",   ":m '<-2<cr>gv=gv",     { desc = "Move line up" })
map("v", "J",       ":m '>+1<CR>gv=gv",     { desc = "Move selection down" })
map("v", "K",       ":m '<-2<CR>gv=gv",     { desc = "Move selection up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==",      { desc = "Move line down" })
map("n", "<A-Up>",   "<cmd>m .-2<cr>==",      { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv",     { desc = "Move line down" })
map("v", "<A-Up>",   ":m '<-2<cr>gv=gv",     { desc = "Move line up" })
map("n", "<S-A-Down>", "<cmd>t.<cr>",  { desc = "Duplicate line down" })
map("n", "<S-A-Up>",   "<cmd>t.-1<cr>", { desc = "Duplicate line up" })
map("v", "<S-A-Down>", ":t'><cr>gv",  { desc = "Duplicate selection down" })
map("v", "<S-A-Up>",   ":t'<-1<cr>gv", { desc = "Duplicate selection up" })
map("n", "<C-S-k>", "dd", { desc = "Delete line" })
map("i", "<C-S-k>", "<esc>ddi", { desc = "Delete line" })
map("n", "<C-CR>",   "o<esc>",  { desc = "Insert line below" })
map("i", "<C-CR>",   "<esc>o",  { desc = "Insert line below" })
map("n", "<C-S-CR>", "O<esc>",  { desc = "Insert line above" })
map("i", "<C-S-CR>", "<esc>O",  { desc = "Insert line above" })
map("n", "<C-z>", "u",     { desc = "Undo" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>",     { desc = "Redo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Indenting
map("v", "<Tab>",   ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent" })
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Terminal
map("n", "<C-`>", "<cmd>terminal<CR>", { desc = "Open terminal" })
map("t", "<C-`>", "<C-\\><C-n>",          { desc = "Exit terminal mode" })
map("t", "<Esc>", "<C-\\><C-n>",          { desc = "Exit terminal mode" })

-- Explorer
map("n", "<C-b>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Folding
map("n", "<C-'>", "zM", { desc = "Fold all" })
map("n", "<C-;>", "zR", { desc = "Unfold all" })

-- View Toggles
map("n", "<leader>uf", function() vim.g.autoformat = not vim.g.autoformat end,    { desc = "Toggle Autoformat" })
map("n", "<leader>us", function() vim.opt_local.spell = not vim.opt_local.spell:get() end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() vim.opt_local.wrap = not vim.opt_local.wrap:get() end,   { desc = "Toggle Word Wrap" })
map("n", "<leader>ud", function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, { desc = "Toggle Diagnostics" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- LSP / Code Actions
map("n", "<F12>",   vim.lsp.buf.definition,  { desc = "Go to definition" })
map("n", "<A-F12>", vim.lsp.buf.hover,       { desc = "Peek definition (hover)" })
map("n", "<S-F12>", vim.lsp.buf.references,  { desc = "Find all references" })
map("n", "<F2>",    vim.lsp.buf.rename,      { desc = "Rename symbol" })
map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code action" })
map({ "n", "v" }, "<S-A-f>", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format document" })

-- Vim-native LSP fallbacks
map("n", "gd",  vim.lsp.buf.definition,     { desc = "Go to definition" })
map("n", "gD",  vim.lsp.buf.declaration,    { desc = "Go to declaration" })
map("n", "gr",  vim.lsp.buf.references,     { desc = "References" })
map("n", "gI",  vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "K",   vim.lsp.buf.hover,          { desc = "Hover docs" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename,      { desc = "Rename" })
map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format" })

-- Diagnostics
local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end

map("n", "<F8>",   diagnostic_goto(true),           { desc = "Next diagnostic" })
map("n", "<S-F8>", diagnostic_goto(false),          { desc = "Prev diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float,   { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true),               { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false),              { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true,  "ERROR"),     { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"),     { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true,  "WARN"),      { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"),      { desc = "Prev Warning" })

-- Tabs
map("n", "<leader><tab>l",   "<cmd>tablast<cr>",    { desc = "Last Tab" })
map("n", "<leader><tab>f",   "<cmd>tabfirst<cr>",   { desc = "First Tab" })
map("n", "<leader><tab><tab>","<cmd>tabnew<cr>",    { desc = "New Tab" })
map("n", "<leader><tab>]",   "<cmd>tabnext<cr>",    { desc = "Next Tab" })
map("n", "<leader><tab>d",   "<cmd>tabclose<cr>",   { desc = "Close Tab" })
map("n", "<leader><tab>[",   "<cmd>tabprevious<cr>",{ desc = "Previous Tab" })

-- Misc
-- Lazy plugin manager
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
