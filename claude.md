# Claude Code Assistant Context

## Critical Workflow for Dotfiles Management

**IMPORTANT**: This repository uses symlinks to manage dotfiles. When working with config files, ALWAYS follow this workflow:

### The Correct Process

1. **Config files live in the dotfiles repo** (`~/dotfiles/`)
2. **They are symlinked to their actual locations** (e.g., `~/.config/atuin/config.toml` -> `~/dotfiles/.config/atuin/config.toml`)
3. **When adding/modifying configs:**
   - Add the file to the appropriate location in `~/dotfiles/`
   - Update `install.sh` to include the symlink
   - Update `install.sh` to create any necessary directories
   - Update `install.sh` to install any required packages via Homebrew

### Directory Structure

```
~/dotfiles/
├── .config/
│   ├── nvim/          # Neovim config (entire directory symlinked)
│   ├── wezterm/       # Terminal config
│   ├── zsh/           # Shell aliases and functions
│   ├── git/           # Git ignore patterns
│   ├── atuin/         # Shell history manager
│   └── starship.toml  # Shell prompt
├── .zshrc             # Main shell config
├── .zshenv            # Shell environment
├── .gitconfig         # Git configuration
├── .aerospace.toml    # Window manager
└── install.sh         # Installation script
```

### When Modifying Configs

**DON'T**: Edit files directly in `~/.config/` or `~/`
**DO**:
1. Copy the file to the dotfiles repo structure
2. Update `install.sh` with the symlink
3. Test by running `install.sh`

### Example: Adding a New Config

```bash
# 1. Add file to repo
mkdir -p ~/dotfiles/.config/tool-name
cp ~/.config/tool-name/config.file ~/dotfiles/.config/tool-name/

# 2. Update install.sh:
#    - Add directory to mkdir -p line
#    - Add symlink command
#    - Add tool to Homebrew TOOLS array if needed

# 3. Test
cd ~/dotfiles && ./install.sh
```

## Repository Philosophy

- **Version controlled**: All configs tracked in git
- **Portable**: Run install.sh on any new machine
- **Secrets safe**: Use ~/.zshrc.local for API keys (not tracked)
- **Backup first**: install.sh backs up existing files before symlinking
