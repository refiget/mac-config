-- ===================== core.lua =====================
local fn = vim.fn
local opt = vim.opt
local g = vim.g

-- -------------------- Environment --------------------
vim.env.PYTHONWARNINGS = "ignore::SyntaxWarning"
if fn.isdirectory(fn.getcwd()) == 0 then vim.cmd("cd ~") end

-- -------------------- Python Provider --------------------
if fn.executable("~/.venvs/nvim/bin/python3") == 1 then
  g.python3_host_prog = fn.expand("~/.venvs/nvim/bin/python3")
else
  g.python3_host_prog = "/usr/bin/python3"
end

-- -------------------- Editor Behavior --------------------
opt.laststatus = 2
opt.exrc = true
opt.secure = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.expandtab = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.list = true
opt.listchars = { tab = "| ", trail = "▫" }
opt.scrolloff = 4
opt.ttimeoutlen = 0
opt.timeout = false
opt.viewoptions = { "cursor", "folds", "slash", "unix" }
opt.wrap = true
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.completeopt = { "menuone", "noselect" }
opt.updatetime = 100
opt.virtualedit = "block"
opt.inccommand = "split"
opt.showmode = false
opt.lazyredraw = true
opt.visualbell = true
opt.colorcolumn = "100"

opt.backupdir = fn.expand("$HOME/.config/nvim/tmp/backup,.")
opt.directory = fn.expand("$HOME/.config/nvim/tmp/backup,.")
opt.undodir = fn.expand("$HOME/.config/nvim/tmp/undo,.")

if fn.has("persistent_undo") == 1 then opt.undofile = true end

-- -------------------- Autocommands --------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  command = "startinsert",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  command = "setlocal spell",
})
