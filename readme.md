# dcai's Neovim Configuration

```
       __           _          _
  ____/ /________ _(_)  _   __(_)___ ___  __________
 / __  / ___/ __ `/ /  | | / / / __ `__ \/ ___/ ___/
/ /_/ / /__/ /_/ / /   | |/ / / / / / / / /  / /__
\__,_/\___/\__,_/_/    |___/_/_/ /_/ /_/_/   \___/

```

[![Selene Lint](https://github.com/dcai/.vim/actions/workflows/selene.yml/badge.svg)](https://github.com/dcai/.vim/actions/workflows/selene.yml)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/dcai/.vim)

A personal Neovim configuration with 15+ years of evolution, migrated from Vim to Neovim in early 2023. This setup combines modern Neovim features with time-tested customizations.

## ✨ Features

- **Modular Organization**: Configuration split into logical modules for easy maintenance
- **Modern Completion**: Advanced completion with blink.cmp v1.5.1 for fast, intelligent autocomplete
- **LSP Integration**: Pre-configured language server protocol support for multiple languages
- **Fuzzy Finding**: Advanced file and text search with FZF integration
- **Git Integration**: Seamless git workflow with Fugitive and other tools
- **AI Coding Assistants**: Integrated LLM support with CodeCompanion, Copilot, and gp.nvim
- **Code Manipulation**: Tree-sitter powered code splitting/joining with treesj
- **Terminal Integration**: Toggleable terminal management with toggleterm.nvim
- **Test Runner**: Integrated testing workflow
- **Extensive Keymaps**: Organized key mappings via which-key for better discoverability

## 🚀 Installation

```sh
# Clone the repository
git clone https://github.com/dcai/.vim.git ~/.config/nvim

# Optional: Create symlink for Vim compatibility
ln -s ~/.config/nvim ~/.vim

# For fish shell users: Create nvim symlink as vim
ln -s (which nvim) ~/.local/bin/vim
```

## ⚙️ Configuration Structure

- `init.lua`: Main entry point
- `core.vim`: Core Vim settings and functionality
- `filetype.vim`: Filetype-specific settings
- `gui.vim`: GUI-related configurations
- `loader.vim`: Script loader and environment detection
- `lua/dcai/`: Core Lua configuration modules
  - `plug.lua`: Plugin management
  - `keymaps/`: Keyboard mappings organized by functionality
  - `lspconfig/`: Language server configurations
  - `llm/`: AI assistant integrations
- `before/`: Configurations loaded before plugins
  - `captureoutput.vim`: Utility for capturing command output
  - `keymap.vim`: Early keymaps loaded before plugins
  - `netrw.vim`: File browser configurations
- `after/`: Configurations loaded after plugins
  - `ftplugin/`: Filetype-specific settings
  - `plugin/`: Plugin-specific configurations
- `os/`: OS-specific configurations
  - `macos.vim`: macOS-specific settings
  - `linux.vim`: Linux-specific settings
  - `windows.vim`: Windows-specific settings
  - `wsl.vim`: Windows Subsystem for Linux settings

## 🔌 Key Plugins

This configuration uses numerous plugins managed through vim-plug. See [plug.lua](./lua/dcai/plug.lua) for the complete list.

## 📜 History

- **2008**: Initial `vimrc` created
- **Pre-2014**: Early history tracked in Git (commit `2f299642859b9efe0d5b1619ceeabcab16158a19`)
- **Early 2023**: Migration to Neovim with Lua configuration

---

<sub>_The ASCII art header was generated using `figlet -f slant 'dcai vimrc'`_</sub>
