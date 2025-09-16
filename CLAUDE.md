# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language Settings

**Communicate in Japanese**: All interactions should be conducted in Japanese. This is the owner's preferred language for development discussions and explanations.

## Repository Structure

This is a personal dotfiles repository with the following key components:

- **nvim/**: Neovim configuration using Lazy.nvim plugin manager
- **wezterm/**: WezTerm terminal emulator configuration
- **karabiner/**: Karabiner Elements keyboard customization files
- **zsh/**: Zsh shell configuration files
- **scripts/**: Setup and management scripts for dotfiles installation
- **raycast/**: Raycast launcher configuration

## Setup and Installation

Initial setup is handled by `init.sh` which orchestrates:
1. **Homebrew installation**: Via `scripts/homebrew.sh` 
2. **Package installation**: From `scripts/Brewfile` using `brew bundle`
3. **Symlink creation**: Via `scripts/symlink.sh` to link configs to appropriate locations

### Key Commands

```bash
# Full dotfiles setup
./init.sh

# Install/update packages from Brewfile
brew bundle --file=scripts/Brewfile

# Create symlinks (run from dotfiles directory)
./scripts/symlink.sh
```

## Architecture Overview

### Neovim Configuration
- **Plugin Manager**: Lazy.nvim with lazy loading based on events
- **Structure**: Modular Lua configuration in `nvim/lua/user/`
- **Leader Key**: Space (`<Space>`)
- **Key Features**: LSP support, Go development, Copilot integration, tree-sitter syntax highlighting
- **Language Servers**: Configured for Go, Lua, TypeScript, Python, Terraform, and more

The Neovim config uses a plugin specification system (`LAZY_PLUGIN_SPEC`) and loads plugins from individual files in `nvim/lua/user/`.

### Terminal & Shell Setup  
- **Terminal**: WezTerm with Tokyo Night color scheme and 90% opacity
- **Shell**: Zsh with multiple enhancement plugins (autosuggestions, syntax highlighting, etc.)
- **Tool Version Management**: Uses `mise` (configured via `mise.toml`)

### Key Symlink Mappings
- `nvim/` → `~/.config/nvim`
- `wezterm/` → `~/.config/wezterm` 
- `karabiner/` → `~/.config/karabiner`
- `zsh/zshenv.home` → `~/.zshenv`
- `zsh/zshrc` → `~/.config/zsh/.zshrc`

## Development Notes

- The repository uses Japanese comments in some configuration files
- All shell scripts include safety checks for existing symlinks and files
- Node.js version 20 is specified via mise configuration
- Go development is heavily supported with dedicated Neovim plugins and LSP setup

## Testing and Validation

```bash
# Test Neovim config with specific APPNAME
NVIM_APPNAME=isseii10/dotfiles/nvim nvim

# Verify symlinks are correctly created
ls -la ~/.config/nvim ~/.config/wezterm ~/.config/karabiner
```

## Language Server Support

This configuration includes LSP setup for:
- **Go**: gopls with go.nvim plugin for enhanced Go development
- **Lua**: lua_ls for Neovim configuration development
- **Web Technologies**: TypeScript, HTML, CSS, TailwindCSS
- **Infrastructure**: Terraform, YAML, JSON
- **Other**: Python (pyright), Bash, Markdown