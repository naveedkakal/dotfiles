# Dotfiles

A clean, modern shell environment setup.

## Features

- **WezTerm**: Modern, GPU-accelerated terminal emulator
- **Starship**: Fast, customizable prompt
- **Neovim**: Modern text editor based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- **Minimal Zsh**: No bloat, just what you need
- **Proper secret management**: Keep credentials out of version control

## What's Included

- Clean zsh configuration with useful aliases
- Git configuration and aliases
- WezTerm configuration
- Starship prompt theme
- Neovim configuration based on kickstart.nvim (LSP, Telescope, Treesitter, and more)
- Integration with: fzf, autojump, nvm, rbenv, asdf

## Installation

```bash
cd ~/dotfiles
./install.sh
```

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
│   ├── nvim/                # Neovim config (kickstart.nvim)
│   │   ├── init.lua         # Main config file
│   │   ├── lua/             # Additional plugins
│   │   └── ...
│   └── starship.toml        # Starship prompt config
├── .zshrc                   # Main zsh config
├── .zshenv                  # Environment variables
├── .gitconfig               # Git configuration
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
