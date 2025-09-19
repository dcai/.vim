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

## 🌍 Environment Variables

The configuration respects several environment variables to customize behavior:

### AI/LLM Integration

- **`XAI_API_KEY`**: API key for X.AI (Grok) LLM services - used in gpconfig.lua:259
- **`OPENAI_API_KEY`**: API key for OpenAI services - used in gpconfig.lua:280
- **`DEEPSEEK_API_KEY`**: API key for DeepSeek AI services - used in gpconfig.lua:276
- **`GEMINI_API_KEY`**: API key for Google Gemini AI services - used in gpconfig.lua:284
- **`ANTHROPIC_API_KEY`**: API key for Anthropic Claude services - used in gpconfig.lua:288
- **`CODECOMPANION_TOKEN_PATH`**: Set automatically to `$XDG_CONFIG_HOME` for CodeCompanion token storage - set in codecompanion.lua:85
- **`XDG_CONFIG_HOME`**: Used by CodeCompanion for token path configuration - referenced in codecompanion.lua:85

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

## 📜 History

- **2008**: Initial `vimrc` created
- **Pre-2014**: Early history tracked in Git (commit `2f299642859b9efe0d5b1619ceeabcab16158a19`)
- **Early 2023**: Migration to Neovim with Lua configuration

---

<sub>_The ASCII art header was generated using `figlet -f slant 'dcai vimrc'`_</sub>
