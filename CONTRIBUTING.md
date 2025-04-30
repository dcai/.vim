# Contributing to Neovim Config Repository

This repository houses a Neovim configuration in Lua and partially some vimscripts.

## Repository Overview

- **`plenary.nvim`**: Provides utility functions, and unit tests runner.
- **`gp.nvim`**: Provides ability to integration with LLM AI providers, for example openai, gemini and copilot.
- **Plugin Management**: Employs [vim-plug](https://github.com/junegunn/vim-plug) for managing plugins, enhanced by a lightweight Lua wrapper in `lua/dcai/plug.lua`.
- **Legacy Vimscript**: Some Vimscript files are retained for historical reference, though they are no longer actively used.
- **Folder Structure**:
  - `lua/dcai`: Holds Lua-based configuration and utility scripts.
  - `lua/dcai/keymaps`: Configures the [which-key](https://github.com/folke/which-key.nvim) plugin.
  - `mini-rc.vim`: A minimal independent Vimrc configuration file.
- **Git Integration**: Leverages custom Git aliases defined in the Git configuration.
- **Vim + Tmux Workflow**: Seamless integration between Vim and Tmux is central to the workflow.

## Guidelines for Contributions

When contributing, please adhere to the following:

- Ensure compatibility with the existing structure, prefer using Lua where appropriate and the vim-plug wrapper for plugin management.
- Preserve historical Vimscript files as references unless a explicit decision is made to remove them.
