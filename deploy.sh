#!/bin/bash

# ==========================================
# 配置区域
# ==========================================
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$CONFIG_DIR"
mkdir -p "$BACKUP_DIR"

# ==========================================
# 核心函数: 兼容 Bash 3.2 (macOS) 和 Bash 5+ (Linux)
# ==========================================
link_file() {
    local SRC=$1
    local DEST=$2
    local FILENAME=$(basename "$SRC")

    # 1. 检查源文件是否存在
    if [ ! -e "$SRC" ]; then
        echo "⚠️  源缺失 (跳过): $FILENAME"
        return
    fi

    # 2. 检查是否已经是正确的软连接
    # 注意: readlink 在 Mac 和 Linux 上行为略有不同，这里用 -L 判断是否为链接
    if [ -L "$DEST" ]; then
        local CURRENT_LINK=$(readlink "$DEST")
        if [ "$CURRENT_LINK" == "$SRC" ]; then
            echo "✅ 已连接 (跳过): $FILENAME"
            return
        fi
    fi

    # 3. 如果目标存在（是文件、目录或错误的链接），则备份
    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
        echo "🔄 备份冲突: $DEST -> $BACKUP_DIR/$FILENAME"
        mv "$DEST" "$BACKUP_DIR/"
    fi

    # 4. 建立链接
    echo "🔗 建立连接: $FILENAME -> $DEST"
    ln -s "$SRC" "$DEST"
}

# ==========================================
# 执行逻辑
# ==========================================
echo "🚀 开始部署 Dotfiles (Universal Version)..."
echo "📂 源目录: $DOTFILES_DIR"
echo "---------------------------------------------"

# --- 根目录文件 ---
link_file "$DOTFILES_DIR/.zshrc"      "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zimrc"      "$HOME/.zimrc"
link_file "$DOTFILES_DIR/.tmux.conf"  "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"

# --- .config 目录下的文件夹 ---
link_file "$DOTFILES_DIR/nvim"        "$CONFIG_DIR/nvim"
link_file "$DOTFILES_DIR/lazygit"     "$CONFIG_DIR/lazygit"
link_file "$DOTFILES_DIR/yazi"        "$CONFIG_DIR/yazi"

# --- 其他 (如果您的仓库里有这些) ---
link_file "$DOTFILES_DIR/fish"        "$CONFIG_DIR/fish"
link_file "$DOTFILES_DIR/coc"         "$CONFIG_DIR/coc"
link_file "$DOTFILES_DIR/scripts"     "$HOME/scripts"

echo "---------------------------------------------"
echo "🎉 部署完成！"
