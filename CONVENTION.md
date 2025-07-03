# Contributing to Neovim Config Repository

This repository houses a Neovim configuration in Lua and partially some vimscripts.

## Repository Overview

- **Plugin Management**: Uses [vim-plug](https://github.com/junegunn/vim-plug) for plugin management, with a Lua wrapper in `lua/dcai/plug.lua` for declarative plugin setup and post-install hooks. Plugins are organized and configured in Lua for performance and maintainability.
- **Key Plugins**: Includes `plenary.nvim` (utility functions), `fzf-lua` (fuzzy finder), `mini.nvim` (editing utilities), `gp.nvim` (LLM/AI integration), and others for LSP, Git, UI, and AI coding assistants.
- **AI/LLM Integration**: Modern config integrates AI tools (Copilot, Codeium, CodeCompanion, gp.nvim) with custom prompts and keymaps. AI provider/model selection is abstracted in Lua (`globals.lua`).
- **LSP & Treesitter**: Language server support is modularized in `lua/dcai/lspconfig/`, with Treesitter and textobjects for advanced syntax and navigation.
- **Keymaps**: Key mappings are organized by topic in `lua/dcai/keymaps/`, using which-key for discoverability. Leader key is `<space>`, with ergonomic mappings for common actions.
- **Legacy Vimscript**: Vimscript files are preserved for reference and backward compatibility, but new config is Lua-first.
- **Folder Structure**:
  - `lua/dcai/`: Core Lua modules (plugin management, LSP, keymaps, AI, UI, utilities)
  - `lua/dcai/keymaps/`: Keymap modules by topic
  - `lua/dcai/lspconfig/`: LSP server configs
  - `lua/dcai/llm/`: AI/LLM integration and prompt libraries
  - `after/plugin/`: Plugin-specific configs (Lua or Vimscript)
  - `after/ftplugin/`: Filetype-specific settings
  - `before/`: Early Vimscript loaded before plugins
  - `vim8/after/`: Vim8-specific plugin configs
  - `colors/`: Custom colorschemes
  - `queries/`: Treesitter queries

## Coding & Contribution Guidelines

- **Lua First**: Prefer Lua for new config and plugin setup. Use the Lua wrapper for vim-plug in `plug.lua`.
- **Plugin Config**: Place plugin-specific config in `after/plugin/` (Lua preferred). Use `setup` functions for post-install configuration.
- **Keymaps**: Add new keymaps in the appropriate `lua/dcai/keymaps/` module. Use which-key for discoverability.
- **LSP**: Add or update LSP configs in `lua/dcai/lspconfig/`. Use modular functions and utility helpers.
- **AI/LLM**: Integrate new AI tools in `lua/dcai/llm/` and update prompt libraries as needed.
- **Preserve History**: Do not remove legacy Vimscript unless explicitly decided. Keep historical files for reference.
- **Style**: Follow idiomatic Lua style. Use descriptive names, minimal global state, and modular functions. Prefer table-based config and explicit setup calls.
- **Git**: Use conventional commit messages (see below). Leverage custom Git aliases and maintain atomic, descriptive commits.
- **Testing**: Use integrated test runners and ensure config works across supported platforms (macOS, Linux, Windows).

## For AI Agents

- **Understand the modular structure**: Most config logic is in `lua/dcai/` and subfolders. Plugin management is declarative in `plug.lua`.
- **AI/LLM features**: Look for AI provider/model selection in `globals.lua`, prompt libraries in `llm/`, and keymaps for chat/coding assistants.
- **Key conventions**: Use Lua for new features, keep plugin config modular, and follow commit/message conventions.
- **Preserve legacy**: Do not remove Vimscript files unless directed. Use them as reference for porting to Lua.
- **Testing**: Ensure changes do not break cross-platform support or core workflows (editing, LSP, AI, Git, FZF).

---

For more details, see `readme.md` and `HISTORY.md` for project history and philosophy.
