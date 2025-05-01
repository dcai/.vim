# Contributing to Neovim Config Repository

This repository houses a Neovim configuration in Lua and partially some vimscripts.

## Repository Overview

- **`plenary.nvim`**: Provides utility functions: async job, curl wrapper, config reloading and unit tests runner.
- **`fzf-lua`**: Essential to the workflow, a fuzzy finder for everything in Neovim.
- **`mini.nvim`**: toggling comments, manage chars pairs, text object, file tree navigation etc.
- **`gp.nvim`**: Provides ability to integration with LLM AI providers, for example openai, gemini and copilot.
- **Plugin Management**: Employs [vim-plug](https://github.com/junegunn/vim-plug) for managing plugins, enhanced by a lightweight Lua wrapper in `lua/dcai/plug.lua`.
- **Legacy Vimscript**: Some Vimscript files are retained for historical reference, though they are no longer actively used.
- **Folder Structure**:
  - `lua/dcai`: Holds Lua-based configuration and utility scripts.
  - `lua/dcai/keymaps`: Configures the [which-key](https://github.com/folke/which-key.nvim) plugin.
  - `lua/dcai/lspconfig`: LSP configuration for various LSP servers.
  - `after/plugin/`: plugin configs.
- **Git Integration**: Leverages custom Git aliases defined in the Git configuration.
- **Vim + Tmux Workflow**: Seamless integration between Vim and Tmux is central to the workflow.

## Guidelines for Contributions

When contributing, please adhere to the following:

- Ensure compatibility with the existing structure, prefer using Lua where appropriate and the vim-plug wrapper for plugin management.
- Preserve historical Vimscript files as references unless a explicit decision is made to remove them.
