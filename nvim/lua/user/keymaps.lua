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


-- Coc.nvim format --
vim.keymap.set(
  "n",
  "<leader>f",
  ":CocCommand editor.action.formatDocument<CR>",
  { silent = true, noremap = true, desc = "Format document with Coc" }
)
keymap("n", "cr", "<Plug>(coc-rename)", { silent = true })
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

-- ① d / D —— 正常删除（写入默认寄存器 "）
keymap({ "n", "x" }, "d", "d", opts)
keymap({ "n", "x" }, "D", "D", opts)

-- ② x / X —— 删一个字符，不污染寄存器（写入黑洞寄存器 "_）
keymap("n", "x", '"_x', opts)
keymap("n", "X", '"_X', opts)

-- ③ c / C —— 修改也不写入寄存器（防止干扰 y）
keymap("n", "c", '"_c', opts)
keymap("n", "C", '"_C', opts)
keymap("x", "c", '"_c', opts)
keymap("x", "C", '"_C', opts) 


-------------------------------------------------
-- DeepSeek CLI 集成（Neovim 内置 terminal 版本）
-------------------------------------------------

-- 你的 ds 所在目录 + 可执行文件名
local DS_CMD_ROOT = "/home/bob/Projects/deepseek-cli"
local DS_CMD = "./ds"   -- deepseek-cli 目录里的可执行脚本

-- 在右侧新建一个终端窗口，流式运行命令
local function open_ds_term(cmd)
  -- 在右侧竖分屏中新建一个空窗口
  vim.cmd("botright vnew")

  -- 获取当前窗口，用来设置宽度
  local win = vim.api.nvim_get_current_win()

  -- 在这个新窗口 / buffer 里打开终端
  vim.fn.termopen({ "bash", "-lc", "cd " .. DS_CMD_ROOT .. " && " .. cmd })

  -- 右侧窗口宽度，可按需要调整
  vim.api.nvim_win_set_width(win, 50)

  -- 进入插入模式方便看输出
  vim.cmd("startinsert")
end

-- 获取可视模式选区文本
local function get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos("'<"))
  local _, le, ce = unpack(vim.fn.getpos("'>"))
  if ls > le or (ls == le and cs > ce) then
    ls, le = le, ls
    cs, ce = ce, cs
  end
  local lines = vim.fn.getline(ls, le)
  if #lines == 0 then
    return ""
  end
  lines[#lines] = string.sub(lines[#lines], 1, ce)
  lines[1] = string.sub(lines[1], cs)
  return table.concat(lines, "\n")
end

-------------------------------------------------
-- 1) 在 Neovim 里向 DeepSeek 提问（普通问答）
--    普通模式按：<leader>dq   （空格 d q）
-------------------------------------------------
local function ds_ask_in_term()
  local q = vim.fn.input("DeepSeek> ")
  if q == nil or q == "" then
    return
  end
  -- shellescape 防止引号等字符把命令搞坏
  local esc = vim.fn.shellescape(q)
  local cmd = DS_CMD .. " " .. esc
  open_ds_term(cmd)
end

vim.keymap.set(
  "n",
  "<leader>dq",
  ds_ask_in_term,
  { silent = true, noremap = true, desc = "DeepSeek: ask question (terminal)" }
)

-------------------------------------------------
-- 2) 选中一段代码让 DeepSeek 查错 + 给修改建议
--    可视模式按：<leader>dr   （空格 d r）
-------------------------------------------------
local function ds_review_visual_in_term()
  local code = get_visual_selection()
  if code == nil or code == "" then
    vim.notify("No visual selection", vim.log.levels.WARN, { title = "DeepSeek Review" })
    return
  end

  local ft = vim.bo.filetype
  local lang = (ft ~= "" and ft or "代码")

  -- 简单中文 prompt：先找问题，再给改进版
  local prompt = table.concat({
    "请帮我检查下面这段 " .. lang .. " 的错误或不优雅之处，",
    "用中文列出问题：",
    "",
    "```" .. (ft ~= "" and ft or "text"),
    code,
    "```",
  }, "\n")

  local esc = vim.fn.shellescape(prompt)
  local cmd = DS_CMD .. " " .. esc
  open_ds_term(cmd)
end

vim.keymap.set(
  "v",
  "<leader>dr",
  ds_review_visual_in_term,
  { silent = true, noremap = true, desc = "DeepSeek: review selected code (terminal)" }
)
