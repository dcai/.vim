```
       __           _          _
  ____/ /________ _(_)  _   __(_)___ ___  __________
 / __  / ___/ __ `/ /  | | / / / __ `__ \/ ___/ ___/
/ /_/ / /__/ /_/ / /   | |/ / / / / / / / /  / /__
\__,_/\___/\__,_/_/    |___/_/_/ /_/ /_/_/   \___/

```

[![Selene Lint](https://github.com/dcai/.vim/actions/workflows/selene.yml/badge.svg)](https://github.com/dcai/.vim/actions/workflows/selene.yml)
[![Neovim Tests](https://github.com/dcai/.vim/actions/workflows/neovim-tests.yml/badge.svg)](https://github.com/dcai/.vim/actions/workflows/neovim-tests.yml)

A personal Neovim configuration with 15+ years of evolution, migrated from Vim to Neovim in early 2023. It combines Lua-first modules with retained Vimscript customizations.

This is a personal setup, not a minimal starter config. Review local paths, environment settings, and external integrations before using it on another machine.

## Requirements

- Neovim 0.12 or newer.
- Git and curl for installing plugins and tools.
- Node.js LTS for Node-based tools. `mise.toml` tracks Node LTS.
- Additional command-line tools depend on the features you use, such as ripgrep, fd, fzf, bat, and tmux.

## Installation

Back up any existing configuration, then clone:

```sh
git clone https://github.com/dcai/.vim.git ~/.config/nvim
```

Open Neovim and install plugins:

```vim
:PlugInstall
```

Restart Neovim after installation. The first start may report missing-plugin errors until installation completes. vim-plug is included in `autoload/plug.vim`.

To install the configured language-server packages managed by Mason:

```vim
:LspInstallAll
```

Some language servers need separate language runtimes or platform tools. See `lua/dcai/lsp/` for their configuration.

Legacy Vim files are retained for reference. The current setup primarily targets Neovim.

## Configuration Structure

- `init.lua`: Neovim entry point.
- `lua/dcai/`: Core Lua modules.
- `lua/dcai/plug.lua`: Plugin declarations and setup hooks.
- `lua/dcai/lsp/`: Language-server configuration.
- `loader.vim`: Shared Vimscript and platform-specific setup.
- `core.vim`, `filetype.vim`, `gui.vim`: Retained Vimscript settings.
- `before/`: Early configuration.
- `after/ftplugin/`: Filetype-specific settings.
- `after/plugin/`: Plugin-specific configuration.
- `plugin/`: Runtime plugin scripts.
- `ftdetect/`, `syntax/`, `queries/`: Filetype detection, syntax definitions, and Tree-sitter queries.
- `colors/`: Color schemes.
- `os/`: Platform-specific settings.
- `tests/`: Headless Lua tests.
- `.github/workflows/`: Automated lint and test workflows.

## Plugins

Plugins are managed with vim-plug. See `lua/dcai/plug.lua` for the active list and `after/plugin/` for configuration. Some older declarations and configuration files are retained but disabled.

## Development

Run commands from the repository root. Install Selene and StyLua separately.

```sh
mise run lint
stylua --check init.lua lua after/plugin plugin colors tests
```

Headless tests live in `tests/`. See each test file's header and the test workflow for invocation and dependency setup. Run test files in separate Neovim processes to keep their state isolated.

CI uses separate workflows for linting and tests. The Neovim test workflow runs on pushes that change Lua files or the workflow itself, using latest stable Neovim and latest upstream test dependencies.

## History

- **2008**: Initial `vimrc` created.
- **Pre-2014**: Early history tracked in Git (commit `2f299642859b9efe0d5b1619ceeabcab16158a19`).
- **Early 2023**: Migration to Neovim with Lua configuration.

---

<sub>_The ASCII art header was generated using `figlet -f slant 'dcai vimrc'`._</sub>
