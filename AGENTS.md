This repository houses a Neovim configuration in Lua and partially some vimscripts.

## Repository Overview

- **Plugin Management**: Uses [vim-plug](https://github.com/junegunn/vim-plug) for plugin management, with a Lua wrapper in `lua/dcai/plug.lua` for declarative plugin setup and post-install hooks. Plugins are organized and configured in Lua for performance and maintainability.
- **Key Plugins**: Includes `plenary.nvim` (utility functions), `fzf-lua` (fuzzy finder), `mini.nvim` (editing utilities) and others for LSP, Git, UI, and AI coding assistants.
- **AI/LLM Integration**: Modern config integrates AI tools (Copilot, CodeCompanion, gp.nvim) with custom prompts and keymaps.
- **LSP & Treesitter**: Language server support is modularized in `lua/dcai/lspconfig/`, with Treesitter and textobjects for advanced syntax and navigation.
- **Keymaps**: Key mappings are organized by topic in `lua/dcai/keymaps/`, using which-key for discoverability. Leader key is `<space>`, with ergonomic mappings for common actions.
- **Legacy Vimscript**: Vimscript files are preserved for reference and backward compatibility, but new config is Lua-first.
- **Folder Structure**:
  - `lua/dcai/`: Core Lua modules (plugin management, LSP, keymaps, AI, UI, utilities)
    - `globals.lua`: Globally shared Lua functions for use across the setup.
  - `lua/dcai/keymaps/`: Keymap modules by topic
  - `lua/dcai/llm/`: AI/LLM integration and prompt libraries
  - `after/plugin/`: Plugin-specific configs (Lua or Vimscript)
  - `after/ftplugin/`: Filetype-specific settings
  - `before/`: Early Vimscript loaded before plugins
  - `vim8/after/`: Vim8-specific plugin configs
  - `colors/`: Custom colorschemes
  - `queries/`: Treesitter queries
  - `~/.local/share/nvim/plug/`: Installed plugins (vim-plug directory). Plugin source code can be found here (e.g., `~/.local/share/nvim/plug/fzf-lua/lua/fzf-lua/` for fzf-lua internals)

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

## 🌍 Environment Variables

The configuration respects several environment variables to customize behavior:

### Development Tools

- **`JSONFIXER`**: JSON formatter tool (default: `prettier`) - used in ale.lua:1
- **`JSFIXER`**: JavaScript formatter tool (default: `prettier`) - used in ale.lua:2
- **`CSSFIXER`**: CSS formatter tool (default: `prettier`) - used in ale.lua:3
- **`JSLINTER`**: JavaScript linter tool (default: `biome`) - used in ale.lua:82
- **`VIM_FZF_ENABLE_FILE_ICONS`**: Enable file icons in FZF (set to `'true'`) - commented out in fzflua_userconfig.lua:17

### System Behavior

- **`NVIM_SHADA`**: Custom path for Neovim's ShaDa file - used in init.lua:39
- **`VIRTUAL_ENV`**: Python virtual environment path (automatically used by pyright LSP) - used in pyright.lua:7-8
- **`SSH_CONNECTION`** & **`SSH_TTY`**: Detected automatically to enable OSC52 clipboard for SSH sessions - used in init.lua:65
- **`MYVIMRC`**: Path to vimrc file for reloading - used in vim.lua keymap
- **`VIMRUNTIME`**: Vim runtime path (automatically set by Neovim) - used in lua_ls.lua:55
- **`NODE_TLS_REJECT_UNAUTHORIZED`**: Set to `"0"` to disable TLS verification for development - set in init.lua

### Code Statistics

- **`CODESTATS_API_KEY`**: API key for Code::Stats tracking service - used in codestats.lua:108
- **`CODESTATS_API_URL`**: Custom Code::Stats API URL (default: `https://codestats.net/api`) - commented in codestats.lua:104-106

### Color Scheme

The pine color scheme supports several environment variables for customization:

- **`VIM_PINE_COLORSCHEME_STL_FG`**: Sets the foreground color for statusline (default: moss color) - used in colors/pine.lua:557
- **`VIM_PINE_COLORSCHEME_STL_BG`**: Sets the background color for statusline (default: kombu_green) - used in colors/pine.lua:558
- **`VIM_PINE_COLORSCHEME_STL_BG_NC`**: Sets the background color for inactive window statusline (default: axolotl color) - used in colors/pine.lua:559
- **`VIM_DISABLE_MODE_CHANGE`**: Set to `'true'` or `'1'` to disable automatic statusline color changes based on Vim mode - used in colors/pine.lua:646

## For AI Agents

- **Understand the modular structure**: Most config logic is in `lua/dcai/` and subfolders. Plugin management is declarative in `plug.lua`.
- **AI/LLM features**: prompt libraries in `llm/`, and keymaps for chat/coding assistants.
- **Key conventions**: Use Lua for new features, keep plugin config modular, and follow commit/message conventions.
- **Preserve legacy**: Do not remove Vimscript files unless directed. Use them as reference for porting to Lua.
- **Testing**: Ensure changes do not break cross-platform support or core workflows (editing, LSP, AI, Git, FZF).
