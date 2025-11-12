#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script
# ============================================================================

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🚀 Installing dotfiles..."
echo ""

# ============================================================================
# Backup existing files
# ============================================================================

echo "📦 Backing up existing dotfiles..."

backup_file() {
  if [ -f "$1" ] || [ -L "$1" ]; then
    echo "  Backing up $(basename $1)..."
    mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
  fi
}

backup_file "$HOME/.zshrc"
backup_file "$HOME/.zshenv"
backup_file "$HOME/.gitconfig"
backup_file "$HOME/.aerospace.toml"

# ============================================================================
# Create necessary directories
# ============================================================================

echo ""
echo "📁 Creating directories..."
mkdir -p "$CONFIG_DIR"/{zsh,git,wezterm,atuin}
mkdir -p "$HOME/.local/share"

# ============================================================================
# Install Homebrew packages
# ============================================================================

echo ""
echo "🍺 Checking for required tools..."

if ! command -v brew &> /dev/null; then
  echo "❌ Homebrew not found. Please install it first:"
  echo "   https://brew.sh"
  exit 1
fi

# Install required tools
TOOLS=(
  "wezterm"
  "starship"
  "fzf"
  "neovim"
  "eza"
  "bat"
  "git-delta"
  "zoxide"
  "atuin"
)

for tool in "${TOOLS[@]}"; do
  if ! brew list "$tool" &> /dev/null; then
    echo "  Installing $tool..."
    brew install "$tool"
  else
    echo "  ✓ $tool already installed"
  fi
done

# ============================================================================
# Install zsh plugins
# ============================================================================

echo ""
echo "🔌 Installing zsh plugins..."

ZSH_CUSTOM="$HOME/.config/zsh/plugins"
mkdir -p "$ZSH_CUSTOM"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/zsh-autosuggestions" ]; then
  echo "  Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"
else
  echo "  ✓ zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/zsh-syntax-highlighting" ]; then
  echo "  Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/zsh-syntax-highlighting"
else
  echo "  ✓ zsh-syntax-highlighting already installed"
fi

# ============================================================================
# Create symlinks
# ============================================================================

echo ""
echo "🔗 Creating symlinks..."

# Home directory dotfiles
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"

# .config directory files
ln -sf "$DOTFILES_DIR/.config/zsh/aliases.zsh" "$CONFIG_DIR/zsh/aliases.zsh"
ln -sf "$DOTFILES_DIR/.config/git/.gitignore_global" "$CONFIG_DIR/git/.gitignore_global"
ln -sf "$DOTFILES_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/.config/wezterm/wezterm.lua" "$CONFIG_DIR/wezterm/wezterm.lua"
ln -sf "$DOTFILES_DIR/.config/atuin/config.toml" "$CONFIG_DIR/atuin/config.toml"

# Neovim - symlink entire directory
if [ -d "$CONFIG_DIR/nvim" ] && [ ! -L "$CONFIG_DIR/nvim" ]; then
  echo "  Backing up existing nvim config..."
  mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sfn "$DOTFILES_DIR/.config/nvim" "$CONFIG_DIR/nvim"

# ============================================================================
# Setup fzf key bindings
# ============================================================================

echo ""
echo "🔍 Setting up fzf..."
if [ ! -f "$HOME/.fzf.zsh" ]; then
  $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# ============================================================================
# Create local secrets file template
# ============================================================================

echo ""
echo "🔐 Creating secrets template..."

if [ ! -f "$HOME/.zshrc.local" ]; then
  cat > "$HOME/.zshrc.local" << 'EOF'
# ============================================================================
# Local Configuration (NOT tracked in git!)
# Add your API keys, tokens, and machine-specific settings here
# ============================================================================

# Example:
# export OPENAI_API_KEY="your-key-here"
# export GITHUB_TOKEN="your-token-here"
# export SOME_PROJECT_VAR="value"

EOF
  echo "  ✓ Created ~/.zshrc.local template"
  echo "  📝 Edit this file to add your secrets and local config"
else
  echo "  ✓ ~/.zshrc.local already exists"
fi

# ============================================================================
# Git initialization
# ============================================================================

echo ""
echo "📚 Initializing dotfiles git repo..."
cd "$DOTFILES_DIR"
if [ ! -d ".git" ]; then
  git init
  cat > .gitignore << 'EOF'
# Never commit local secrets!
*.local
*.backup.*
EOF
  git add .
  echo "  ✓ Git repo initialized"
  echo "  💡 Run 'git commit -m \"Initial dotfiles\"' to commit"
else
  echo "  ✓ Git repo already exists"
fi

# ============================================================================
# Done!
# ============================================================================

echo ""
echo "✨ Done! Your dotfiles are installed."
echo ""
echo "Next steps:"
echo "  1. Review and edit ~/.zshrc.local with your secrets"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. If using WezTerm, open it to see your new config"
echo "  4. (Optional) Commit your dotfiles: cd ~/dotfiles && git commit -m \"Initial dotfiles\""
echo ""
echo "⚠️  Important: Remove API keys from your old .zshrc.backup file!"
echo ""
