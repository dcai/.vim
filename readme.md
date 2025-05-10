```
       __           _          _
  ____/ /________ _(_)  _   __(_)___ ___  __________
 / __  / ___/ __ `/ /  | | / / / __ `__ \/ ___/ ___/
/ /_/ / /__/ /_/ / /   | |/ / / / / / / / /  / /__
\__,_/\___/\__,_/_/    |___/_/_/ /_/ /_/_/   \___/

```

[^1]
[![Selene Lint](https://github.com/dcai/.vim/actions/workflows/selene.yml/badge.svg)](https://github.com/dcai/.vim/actions/workflows/selene.yml)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/dcai/.vim)

A personalized Neovim setup evolved from a vimrc first crafted in 2008, now migrated and optimized for Neovim as of early 2023.

### Installation

Clone this repository into your Neovim configuration directory and create a symlink for compatibility with traditional Vim setups:

```sh
git clone https://github.com/dcai/.vim.git ~/.config/nvim
ln -s ~/.config/nvim .vim
# fish shell
ln -s (which nvim) ~/.local/bin/vim
```

### Notes

- Extended `vimrc` since 2008[^2].
- Migrated to [Neovim](https://github.com/neovim/neovim) early 2023.
- Plugins used: [plug.lua](./lua/dcai/plug.lua)

[^1]: `figlet -f slant 'dcai vimrc'`

[^2]: Pre-2014 history was tracked in git: `2f299642859b9efe0d5b1619ceeabcab16158a19`
