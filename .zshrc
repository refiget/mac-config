# ============================================================
# Basic Environment
# ============================================================

# 1. 开启变量动态刷新 (关键：让 Vim 和 Venv 能够实时变化)
setopt PROMPT_SUBST

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

setopt CORRECT
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

# ============================================================
# 🌍 OS Detection & Path (跨平台核心)
# ============================================================
os_name=$(uname -s)

# 处理 PATH (兼容 Mac Homebrew 和 Linux)
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "/usr/local/bin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  $path
)

# 如果是 Mac 且有 Brew，加入 Brew 路径
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# TexLive path (Mac)
if [[ "$os_name" == "Darwin" ]]; then
  export PATH="/usr/local/texlive/2025/bin/universal-darwin:$PATH"
fi


export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

autoload -U colors && colors

# ============================================================
# 🖱 Custom Indicators & Cursor Shape
# ============================================================

# 辅助函数：发送转义码改变光标形状
# 2 = Block █ (普通模式), 6 = Beam | (插入模式)
function _set_cursor() {
  echo -ne "\e[$1 q"
}

# --- Vim 模式监听 ---
VIM_MODE_INDICATOR="%F{green}I%f"

function zle-keymap-select {
  case ${KEYMAP} in
    vicmd)
      VIM_MODE_INDICATOR="%F{red}N%f"
      _set_cursor 2  # 切换到普通模式 -> 方块光标
      ;;
    main|viins)
      VIM_MODE_INDICATOR="%F{green}I%f"
      _set_cursor 6  # 切换到插入模式 -> 竖线光标
      ;;
    *)
      VIM_MODE_INDICATOR="%F{green}I%f"
      _set_cursor 6
      ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
  VIM_MODE_INDICATOR="%F{green}I%f"
  _set_cursor 6      # 每次新行默认 -> 竖线光标
  zle reset-prompt
}
zle -N zle-line-init

# --- 虚拟环境获取函数 ---
function get_venv_prompt() {
  local venv_name="base"
  if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    venv_name="$CONDA_DEFAULT_ENV"
  elif [[ -n "$VIRTUAL_ENV" ]]; then
    venv_name="$(basename "$VIRTUAL_ENV")"
  fi
  echo "(%F{cyan}${venv_name}%f)"
}

# ============================================================
# Zim Framework
# ============================================================
export ZIM_HOME=${ZIM_HOME:-${ZDOTDIR:-${HOME}}/.zim}

prompt-pwd() { print -P "%~" }

[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

# ============================================================
# Prompt Injection (Left Side)
# ============================================================
if [[ "$PROMPT" != *"\${VIM_MODE_INDICATOR}"* ]]; then
  PROMPT='${VIM_MODE_INDICATOR} $(get_venv_prompt) '"$PROMPT"
fi

# ============================================================
# 🛠 Aliases (跨平台适配)
# ============================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'
alias ...='cd ../..'

# --- ls 颜色适配 ---
if [[ "$os_name" == "Darwin" ]]; then
  alias ls='ls -G'
  alias o='open'
  alias flushdns='sudo killall -HUP mDNSResponder'
else
  alias ls='ls --color=auto'
  alias o='xdg-open'
  alias update='sudo apt update && sudo apt upgrade -y'
fi

alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -CF'

alias reload='source ~/.zshrc && echo "✅ Reloaded!"'
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias vim='nvim'
alias vi='nvim'
alias lg='lazygit'
alias jl='jupyter lab'


# ============================================================
# External Tools (Yazi, Zoxide, FZF, NVM)
# ============================================================

# Yazi
y() {
  local tmp="$(mktemp)"
  yazi --cwd-file="$tmp" "$@"
  [[ -f "$tmp" ]] && cd "$(cat "$tmp")" && rm -f "$tmp"
}

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias za='zoxide add $(pwd)'
  alias zl='zoxide query -l'
  alias zf='zoxide query'
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# Lazy NVM
export NVM_DIR="$HOME/.nvm"
lazy_nvm() {
  unset -f node npm nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}
node() { lazy_nvm; node "$@"; }
npm() { lazy_nvm; npm "$@"; }
nvm() { lazy_nvm; nvm "$@"; }

# ============================================================
# Keybindings
# ============================================================
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# ============================================================
# Init Checks
# ============================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc 2>/dev/null
fi

if [[ -o interactive ]]; then
  command -v fastfetch >/dev/null && fastfetch
fi

# ============================================================
# 🚀 Auto-Start Tmux (Linux Server Only)
# ============================================================
# 只在 Linux 服务器上自动进入 Tmux，Mac 本地不进
if [[ -z "$TMUX" && "$(uname)" == "Linux" ]]; then
  # 连接 main 会话，没有则新建。退出 Tmux 后自动断开 SSH
  exec tmux new-session -A -s main
fi
