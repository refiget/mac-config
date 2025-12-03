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

" LSP / Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/coc-pyright'

" Modern Markdown renderer
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-tree/nvim-web-devicons'
		
" === Appearance ===
Plug 'theniceboy/nvim-deus'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'petertriho/nvim-scrollbar'
Plug 'HiPhish/rainbow-delimiters.nvim'
Plug 'theniceboy/eleline.vim'
Plug 'RRethy/vim-illuminate'
Plug 'NvChad/nvim-colorizer.lua'
Plug 'kevinhwang91/nvim-hlslens'

" === Telescope  ===
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'


" === Editing Helpers ===
Plug 'windwp/nvim-autopairs'
Plug 'echasnovski/mini.surround'
Plug 'junegunn/vim-after-object'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'dkarter/bullets.vim'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'mzlogin/vim-markdown-toc'
Plug 'dhruvasagar/vim-table-mode'

" === Jupyter / Markdown ===
Plug 'goerz/jupytext.vim'
Plug 'dccsillag/magma-nvim'
Plug 'iamcco/markdown-preview.nvim'

" === LuaSnip ===
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

call plug#end()
]])

-- ===================== Telescope =====================
pcall(function()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      -- 轻量一点的按键，不和你现有习惯冲突
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
        n = {
          ["j"] = "move_selection_next",
          ["k"] = "move_selection_previous",
        },
      },
    },
  })
end)
-- ===================== UI / Appearance =====================

vim.opt.termguicolors = true
vim.cmd("silent! colorscheme deus")

vim.api.nvim_set_hl(0, "NonText", { fg = "grey10" })
vim.g.rainbow_active = 1
vim.g.Illuminate_delay = 750
vim.api.nvim_set_hl(0, "illuminatedWord", { undercurl = true })

vim.g.lightline = {
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'modified' },
    },
  },
}

-- ===================== Plugin Configurations =====================

pcall(function()
  require("scrollbar").setup()
  require("scrollbar.handlers.search").setup()
end)

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

vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit' }
vim.g.bullets_auto_indent_after_enter = 1

vim.g.vmt_cycle_list_item_markers = 1
vim.g.vmt_fence_text = 'TOC'
vim.g.vmt_fence_closing_text = '/TOC'

vim.g.instant_markdown_slow = 0
vim.g.instant_markdown_autostart = 0
vim.g.instant_markdown_autoscroll = 1

vim.keymap.set("n", "<leader>tm", ":TableModeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gy", ":Goyo<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", ":Tabularize /", { noremap = true })

-- ===================== Final tweaks =====================
vim.opt.re = 0
vim.cmd("nohlsearch")
vim.g.eleline_colorscheme = 'deus'
vim.g.eleline_powerline_fonts = 1


-- =============================
-- Safe rainbow delimiter colors
-- =============================
local soft = "#88c0a0"   -- 散光友好颜色

vim.g.rainbow_conf = {
  guifgs = {
    "#ff5555",  -- red
    "#f1fa8c",  -- yellow
    soft,       -- blue → 柔和青绿
    "#bd93f9",  -- purple
    "#50fa7b",  -- green
  },
  ctermfgs = { "Red", "Yellow", "Green", "Cyan", "Magenta" },
}

-- render-markdown.nvim config
pcall(function()
  require("render-markdown").setup({
    -- 默认配置就很好看，你可以以后再改主题
  })
end)

pcall(function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "lua","vim","markdown","markdown_inline","python","json","bash","javascript","c"
    },
    highlight = { enable = true },
    indent = { enable = true },
  })
end)

