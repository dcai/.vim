# Contributing to Neovim Config Repository

This repository contains a Neovim configuration that originally started as Vimscript-based but has partially transitioned to Lua.

## Repository Overview

- **Plugin Management**: Utilizes [vim-plug](https://github.com/junegunn/vim-plug) for plugin management, wrapped with a lightweight Lua layer located in `lua/dcai/plug.lua`.
- **Legacy Vimscript**: Some Vimscript files are no longer in use but are retained in the repository for historical reference.
- **Folder Structure**:
  - `lua/dcai`: Contains Lua-based configuration and utility scripts.
  - `lua/dcai/keymaps`: Configuration for the [which-key](https://github.com/folke/which-key.nvim) plugin.
  - `mini-rc.vim`: A minimal Vimrc configuration file.
- **Git Integration**: Relies on custom Git aliases defined in the Git configuration.
- **Vim + Tmux Workflow**: Integration between Vim and Tmux is a core part of the workflow.

## Guidelines for Contributions

When contributing, please ensure compatibility with the existing structure, including the use of Lua where applicable and the vim-plug wrapper for plugin management. Retain historical Vimscript files as references unless explicitly decided otherwise.
