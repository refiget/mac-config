-- =====================================================
-- File: lua/user/plugins.lua
-- Purpose: Plugin management and configuration
-- Author: ChatGPT (converted from your Vimscript setup)
-- =====================================================

local fn = vim.fn

-- ===================== Install vim-plug automatically =====================
local plug_path = fn.stdpath("config") .. "/autoload/plug.vim"
if fn.empty(fn.glob(plug_path)) == 1 then
  fn.system({
    "curl", "-fLo", plug_path, "--create-dirs",
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  })
  vim.api.nvim_create_autocmd("VimEnter", {
    command = "PlugInstall --sync | source $MYVIMRC",
  })
end

-- ===================== Plugin Section =====================
vim.cmd([[
call plug#begin('$HOME/.config/nvim/plugged')

" === Appearance ===
Plug 'theniceboy/nvim-deus'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'luochen1990/rainbow'
Plug 'petertriho/nvim-scrollbar'
Plug 'theniceboy/eleline.vim'
Plug 'RRethy/vim-illuminate'
Plug 'NvChad/nvim-colorizer.lua'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'itchyny/lightline.vim'

" === Editing Helpers ===
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-after-object'
Plug 'godlygeek/tabular'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'
Plug 'dkarter/bullets.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'dhruvasagar/vim-table-mode'
" NOTE: you can manually call :TableModeToggle when needed

" === Jupyter / Markdown ===
Plug 'goerz/jupytext.vim'
Plug 'dccsillag/magma-nvim'
Plug 'suan/vim-instant-markdown'

" === LuaSnip ===
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

call plug#end()
]])

-- ===================== UI / Appearance =====================

vim.opt.termguicolors = true
vim.cmd("silent! colorscheme deus")

-- Modern Lua highlight API
vim.api.nvim_set_hl(0, "NonText", { fg = "grey10" })
vim.g.rainbow_active = 1
vim.g.Illuminate_delay = 750
vim.api.nvim_set_hl(0, "illuminatedWord", { undercurl = true })

-- Lightline setup
vim.g.lightline = {
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'modified' },
    },
  },
}

-- ===================== Plugin Configurations =====================

-- Scrollbar
pcall(function()
  require("scrollbar").setup()
  require("scrollbar.handlers.search").setup()
end)

-- Colorizer
pcall(function()
  require("colorizer").setup({
    filetypes = { "*" },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      AARRGGBB = true,
      mode = "virtualtext",
      virtualtext = "■",
    },
  })
end)

-- Bullets
vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit' }
vim.g.bullets_auto_indent_after_enter = 1

-- Markdown TOC
vim.g.vmt_cycle_list_item_markers = 1
vim.g.vmt_fence_text = 'TOC'
vim.g.vmt_fence_closing_text = '/TOC'

-- Instant Markdown
vim.g.instant_markdown_slow = 0
vim.g.instant_markdown_autostart = 0
vim.g.instant_markdown_autoscroll = 1
-- Uncomment if you need MathJax:
-- vim.g.instant_markdown_mathjax = 1

-- Table Mode toggle key
vim.keymap.set("n", "<leader>tm", ":TableModeToggle<CR>", { noremap = true, silent = true })

-- Goyo mode
vim.keymap.set("n", "<leader>gy", ":Goyo<CR>", { noremap = true, silent = true })

-- Tabular alignment
vim.keymap.set("v", "ga", ":Tabularize /", { noremap = true })

-- ===================== Final tweaks =====================
vim.opt.re = 0
vim.cmd("nohlsearch")

print(" Plugins loaded successfully!")
