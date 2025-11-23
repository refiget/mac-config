-- ===================== keymaps.lua =====================
vim.g.mapleader = " "
local keymap = vim.keymap.set
local opts = { silent = true }

-- Basic
keymap("n", ";", ":", { desc = "Command mode" })
keymap("n", "Q", ":q<CR>", opts)
keymap("v", "Y", '"+y', opts)
keymap("n", "<leader><CR>", ":nohlsearch<CR>", opts)
keymap("n", "<leader>rc", ":e $HOME/.config/nvim/init.lua<CR>", opts)

-- Advanced
keymap("n", "<leader>e", "G$a", opts)
keymap("n", "J", "5j", opts)
keymap("n", "K", "5k", opts)

-- Splits
keymap("n", "s", "<nop>")
keymap("n", "sl", ":set splitright<CR>:vsplit<CR>", opts)
keymap("n", "sh", ":set nosplitright<CR>:vsplit<CR>", opts)
keymap("n", "sk", ":set nosplitbelow<CR>:split<CR>", opts)
keymap("n", "si", ":set splitbelow<CR>:split<CR>", opts)

keymap("n", "<leader>l", "<C-w>l", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>h", "<C-w>h", opts)

keymap("n", "<Up>", ":res -5<CR>", opts)
keymap("n", "<Down>", ":res +5<CR>", opts)
keymap("n", "<Left>", ":vertical resize -5<CR>", opts)
keymap("n", "<Right>", ":vertical resize +5<CR>", opts)

-- Tabs
keymap("n", "tu", ":tabe<CR>", opts)
keymap("n", "tn", ":+tabnext<CR>", opts)
keymap("n", "ti", ":+tabnext<CR>", opts)
keymap("n", "sv", "<C-w>t<C-w>H", opts)
keymap("n", "sh", "<C-w>t<C-w>K", opts)

-- Markdown + Wrap toggle
keymap("n", "<leader>sw", ":set wrap!<CR>", { desc = "Toggle wrap" })
keymap("i", "<C-y>", "<ESC>A {}<ESC>i<CR><ESC>ko", opts)

-- Compile/Run
local function compile_run()
  vim.cmd("w")
  local ft = vim.bo.filetype
  if ft == "markdown" then
    vim.cmd("InstantMarkdownPreview")
  elseif ft == "sh" then
    vim.cmd("term bash %")
  elseif ft == "python" then
    vim.opt.splitbelow = true
    vim.cmd("sp | term python3 %")
  else
    print("Run not defined for filetype: " .. ft)
  end
end
keymap("n", "r", compile_run, { silent = true, desc = "Compile/Run file" })

-- Terminal
keymap("t", "<C-N>", "<C-\\><C-N>", opts)
keymap("t", "<C-O>", "<C-\\><C-N><C-O>", opts)

-- ===================== Delete behavior enhancements =====================

-- x / X 删除到黑洞寄存器（不污染寄存器）
keymap({"n", "x"}, "x", '"_x', opts)
keymap({"n", "x"}, "X", '"_X', opts)

-- c / C 删除并进入插入模式，但不写入寄存器
keymap("n", "c", '"_c', opts)
keymap("n", "C", '"_C', opts)
keymap("x", "c", '"_c', opts)
keymap("x", "C", '"_C', opts)

-- d / D 删除进入系统剪贴板
keymap({"n", "x"}, "d", '"+d', opts)
keymap({"n", "x"}, "D", '"+D', opts)
