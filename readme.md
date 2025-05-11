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
- **LSP Integration**: Pre-configured language server protocol support for multiple languages
- **Fuzzy Finding**: Advanced file and text search with FZF integration
- **Git Integration**: Seamless git workflow with Fugitive and other tools
- **AI Coding Assistants**: Integrated LLM support with CopilotChat and CodeCompanion
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
- `lua/dcai/`: Core configuration modules
  - `plug.lua`: Plugin management
  - `keymaps/`: Keyboard mappings organized by functionality
  - `lspconfig/`: Language server configurations
  - `llm/`: AI assistant integrations

## 🔌 Key Plugins

This configuration uses numerous plugins managed through vim-plug. See [plug.lua](./lua/dcai/plug.lua) for the complete list.

## 🔧 Customization

You can customize this configuration by:

- Setting environment variables (e.g., `NVIM_COMPLETION_ENGINE` to choose between completion providers)
- Modifying keymap files to adjust key bindings
- Adding your plugins to the `plug.lua` file

## 📜 History

- **2008**: Initial `vimrc` created
- **Pre-2014**: Early history tracked in Git (commit `2f299642859b9efe0d5b1619ceeabcab16158a19`)
- **Early 2023**: Migration to Neovim with Lua configuration

---

<sub>_The ASCII art header was generated using `figlet -f slant 'dcai vimrc'`_</sub>
