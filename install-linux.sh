#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script (Ubuntu / Debian)
# ============================================================================
#
# Linux counterpart to install.sh. Installs CLI tooling via apt + official
# installers, then symlinks the portable configs. GUI bits assume a desktop
# (wezterm, vscode). The macOS-only aerospace.toml is intentionally skipped.
#
# Requires sudo for package installation.
# ============================================================================

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

echo "🚀 Installing dotfiles (Linux)..."
echo ""

# Detect architecture for binary downloads (amd64 / arm64)
DEB_ARCH="$(dpkg --print-architecture)"
case "$(uname -m)" in
  x86_64)  NVIM_ARCH="x86_64" ;;
  aarch64) NVIM_ARCH="arm64"  ;;
  *) echo "❌ Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

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

# ============================================================================
# Create necessary directories
# ============================================================================

echo ""
echo "📁 Creating directories..."
mkdir -p "$CONFIG_DIR"/{zsh,git,wezterm,atuin,btop,tmux}
mkdir -p "$HOME/.local/share" "$LOCAL_BIN"
mkdir -p "$CONFIG_DIR/Code/User"

# ============================================================================
# Install apt packages
# ============================================================================

echo ""
echo "📦 Installing apt packages..."
sudo apt update
sudo apt install -y \
  zsh git curl wget unzip build-essential \
  tmux btop bat ripgrep fd-find

# Ubuntu ships bat as `batcat`; alias in aliases.zsh expects `bat`.
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
  ln -sf "$(command -v batcat)" "$LOCAL_BIN/bat"
fi
# fd ships as `fdfind`; provide the conventional `fd` name too.
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
  ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
fi

# ============================================================================
# Install eza (modern ls) from the official apt repo
# ============================================================================

echo ""
echo "📦 Installing eza..."
if ! command -v eza &> /dev/null; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
  sudo apt update
  sudo apt install -y eza
else
  echo "  ✓ eza already installed"
fi

# ============================================================================
# Install git-delta (.deb from GitHub releases)
# ============================================================================

echo ""
echo "📦 Installing git-delta..."
if ! command -v delta &> /dev/null; then
  DELTA_VERSION="0.18.2"
  DELTA_DEB="git-delta_${DELTA_VERSION}_${DEB_ARCH}.deb"
  wget -qO "/tmp/$DELTA_DEB" \
    "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DELTA_DEB}"
  sudo dpkg -i "/tmp/$DELTA_DEB"
  rm -f "/tmp/$DELTA_DEB"
else
  echo "  ✓ git-delta already installed"
fi

# ============================================================================
# Install Neovim (official tarball -> /opt, symlinked onto PATH)
# ============================================================================

echo ""
echo "📦 Installing Neovim..."
if ! command -v nvim &> /dev/null; then
  NVIM_TAR="nvim-linux-${NVIM_ARCH}.tar.gz"
  wget -qO "/tmp/$NVIM_TAR" \
    "https://github.com/neovim/neovim/releases/latest/download/${NVIM_TAR}"
  sudo rm -rf "/opt/nvim-linux-${NVIM_ARCH}"
  sudo tar -C /opt -xzf "/tmp/$NVIM_TAR"
  sudo ln -sf "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim
  rm -f "/tmp/$NVIM_TAR"
else
  echo "  ✓ Neovim already installed"
fi

# ============================================================================
# Install starship, zoxide, atuin (official installers -> ~/.local/bin)
# ============================================================================

echo ""
echo "📦 Installing starship, zoxide, atuin..."

if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "  ✓ starship already installed"
fi

if ! command -v zoxide &> /dev/null; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "  ✓ zoxide already installed"
fi

if ! command -v atuin &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  echo "  ✓ atuin already installed"
fi

# ============================================================================
# Install fzf (git method -> generates ~/.fzf.zsh, matching .zshrc)
# ============================================================================

echo ""
echo "🔍 Installing fzf..."
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf "$HOME/.fzf"
fi
if [ ! -f "$HOME/.fzf.zsh" ]; then
  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
fi

# ============================================================================
# Install nvm (Node version manager)
# ============================================================================

echo ""
echo "📦 Installing nvm..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  echo "  ✓ nvm already installed"
fi

# ============================================================================
# Install a Nerd Font (for wezterm / prompt glyphs on the desktop)
# ============================================================================

echo ""
echo "🔤 Installing JetBrainsMono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
  mkdir -p "$FONT_DIR"
  wget -qO /tmp/JetBrainsMono.zip \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  unzip -oq /tmp/JetBrainsMono.zip -d "$FONT_DIR"
  rm -f /tmp/JetBrainsMono.zip
  fc-cache -f "$FONT_DIR" > /dev/null 2>&1 || true
else
  echo "  ✓ JetBrainsMono Nerd Font already installed"
fi

# ============================================================================
# Install WezTerm (desktop terminal, official apt repo)
# ============================================================================

echo ""
echo "📦 Installing WezTerm..."
if ! command -v wezterm &> /dev/null; then
  curl -fsSL https://apt.fury.io/wez/gpg.key \
    | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
    | sudo tee /etc/apt/sources.list.d/wezterm.list > /dev/null
  sudo apt update
  sudo apt install -y wezterm
else
  echo "  ✓ WezTerm already installed"
fi

# ============================================================================
# Install zsh plugins
# ============================================================================

echo ""
echo "🔌 Installing zsh plugins..."

ZSH_CUSTOM="$HOME/.config/zsh/plugins"
mkdir -p "$ZSH_CUSTOM"

if [ ! -d "$ZSH_CUSTOM/zsh-autosuggestions" ]; then
  echo "  Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"
else
  echo "  ✓ zsh-autosuggestions already installed"
fi

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

# Home directory dotfiles (.aerospace.toml is macOS-only -> skipped)
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# .config directory files
ln -sf "$DOTFILES_DIR/.config/zsh/aliases.zsh" "$CONFIG_DIR/zsh/aliases.zsh"
ln -sf "$DOTFILES_DIR/.config/git/.gitignore_global" "$CONFIG_DIR/git/.gitignore_global"
ln -sf "$DOTFILES_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/.config/starship-linux.toml" "$CONFIG_DIR/starship-linux.toml"  # green prompt (Linux)
ln -sf "$DOTFILES_DIR/.config/wezterm/wezterm.lua" "$CONFIG_DIR/wezterm/wezterm.lua"
ln -sf "$DOTFILES_DIR/.config/atuin/config.toml" "$CONFIG_DIR/atuin/config.toml"
ln -sfn "$DOTFILES_DIR/.config/atuin/themes" "$CONFIG_DIR/atuin/themes"
ln -sf "$DOTFILES_DIR/.config/btop/btop.conf" "$CONFIG_DIR/btop/btop.conf"
ln -sf "$DOTFILES_DIR/.config/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"

# Neovim - symlink entire directory
if [ -d "$CONFIG_DIR/nvim" ] && [ ! -L "$CONFIG_DIR/nvim" ]; then
  echo "  Backing up existing nvim config..."
  mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sfn "$DOTFILES_DIR/.config/nvim" "$CONFIG_DIR/nvim"

# VS Code (Linux user config dir)
VSCODE_USER="$CONFIG_DIR/Code/User"
for f in settings.json keybindings.json; do
  if [ -f "$VSCODE_USER/$f" ] && [ ! -L "$VSCODE_USER/$f" ]; then
    echo "  Backing up existing VS Code $f..."
    mv "$VSCODE_USER/$f" "$VSCODE_USER/$f.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  ln -sf "$DOTFILES_DIR/.config/vscode/$f" "$VSCODE_USER/$f"
done

# ============================================================================
# Setup tmux plugin manager (TPM)
# ============================================================================

echo ""
echo "🔌 Setting up tmux plugin manager..."
if [ ! -d "$CONFIG_DIR/tmux/plugins/tpm" ]; then
  echo "  Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$CONFIG_DIR/tmux/plugins/tpm"
  echo "  💡 After starting tmux, press Ctrl+a then Shift+I to install plugins"
else
  echo "  ✓ TPM already installed"
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

EOF
  echo "  ✓ Created ~/.zshrc.local template"
else
  echo "  ✓ ~/.zshrc.local already exists"
fi

# ============================================================================
# Set zsh as the default shell
# ============================================================================

echo ""
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "🐚 Setting zsh as default shell..."
  chsh -s "$(command -v zsh)" || echo "  ⚠ chsh failed; run 'chsh -s $(command -v zsh)' manually"
else
  echo "🐚 zsh is already the default shell"
fi

echo ""
echo "✅ Done! Restart your shell (or run 'exec zsh') to apply."
