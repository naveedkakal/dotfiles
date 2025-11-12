# Dotfiles

A clean, modern shell environment setup.

## Features

- **WezTerm**: Modern, GPU-accelerated terminal emulator with Tokyo Night theme
- **Tmux**: Terminal multiplexer with Tokyo Night theme and TPM plugin manager
- **Starship**: Fast, customizable prompt
- **Neovim**: Modern text editor based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- **Modern CLI tools**: eza (ls), bat (cat), delta (git diffs), zoxide (cd), atuin (history)
- **Atuin**: Magical shell history with sync and search
- **btop**: Beautiful system monitor
- **VS Code**: Editor settings and keybindings
- **Minimal Zsh**: No bloat, just what you need
- **Proper secret management**: Keep credentials out of version control

## What's Included

- Clean zsh configuration with useful aliases
- Git configuration and aliases
- WezTerm configuration with Tokyo Night theme
- Tmux configuration with Tokyo Night theme and TPM
- Starship prompt theme
- Neovim configuration based on kickstart.nvim (LSP, Telescope, Treesitter, and more)
- Atuin shell history manager with Tokyo Night theme
- btop system monitor
- VS Code settings and keybindings
- Modern CLI replacements: eza (ls), bat (cat), delta (git), zoxide (cd), atuin (history)
- Integration with: fzf, nvm, rbenv, asdf

## Installation

```bash
cd ~/dotfiles
./install.sh
```

The installer will:
- Install Homebrew packages (including modern bash for tmux theme support)
- Set up zsh plugins (autosuggestions, syntax highlighting)
- Create symlinks to all config files
- Install TPM (Tmux Plugin Manager)
- Create a template for local secrets

**After installation:**
1. Restart your terminal or run `source ~/.zshrc`
2. Open tmux and press `Ctrl+a` then `Shift+I` to install tmux plugins
3. Enjoy your new setup!

## Structure

Mirrors your home directory structure for easy browsing:

```
dotfiles/
├── .config/
│   ├── zsh/
│   │   └── aliases.zsh      # All your aliases
│   ├── git/
│   │   └── .gitignore_global # Global gitignore
│   ├── wezterm/
│   │   └── wezterm.lua      # WezTerm config
│   ├── tmux/
│   │   └── tmux.conf        # Tmux config with Tokyo Night theme
│   ├── atuin/
│   │   ├── config.toml      # Atuin config
│   │   └── themes/          # Tokyo Night theme
│   ├── btop/
│   │   └── btop.conf        # btop config
│   ├── vscode/
│   │   ├── settings.json    # VS Code settings
│   │   └── keybindings.json # VS Code keybindings
│   ├── nvim/                # Neovim config (kickstart.nvim)
│   │   ├── init.lua         # Main config file
│   │   ├── lua/             # Additional plugins
│   │   └── ...
│   └── starship.toml        # Starship prompt config
├── .zshrc                   # Main zsh config
├── .zshenv                  # Environment variables
├── .gitconfig               # Git configuration
├── .aerospace.toml          # AeroSpace window manager config
├── install.sh               # Symlink installer
└── README.md
```

Files in the root → symlink to `~/`
Files in `.config/` → symlink to `~/.config/`

## Secret Management

**IMPORTANT**: Never commit secrets to your dotfiles!

Create `~/.zshrc.local` for machine-specific secrets:

```bash
# ~/.zshrc.local (never commit this!)
export OPENAI_API_KEY="your-key-here"
export GITHUB_TOKEN="your-token-here"
```

This file is sourced by .zshrc but excluded from git.
