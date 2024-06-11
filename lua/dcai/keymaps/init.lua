local loaded, which_key = pcall(require, 'which-key')
if not loaded then
  LOG.error('which-key not loaded!')
  return
end
LOG.trace('which-key loaded, setting up...')

local fzf = require('fzf-lua')
local utils = require('dcai.keymaps.utils')
local lsp_keymap = require('dcai.keymaps.lsp')
local notes_keymap = require('dcai.keymaps.notes')
local git_keymap = require('dcai.keymaps.git')
local chatgpt_keymap_n, chatgpt_keymap_v = require('dcai.keymaps.gpt')
local openthings_keymap = require('dcai.keymaps.openthings')
local testthings_keymap = require('dcai.keymaps.testthings')
local editthings_keymap = require('dcai.keymaps.editthings')
local fzf_keymap = require('dcai.keymaps.fzfthings')
local yank_keymap = require('dcai.keymaps.yankthings')
local vim_keymap = require('dcai.keymaps.vim')

local n_keymap = {
  [','] = {
    function()
      local ft = vim.bo.filetype
      if ft == 'elixir' or ft == 'heex' then
        vim.lsp.buf.format({ async = true })
      else
        vim.cmd('ALEFix')
      end
    end,
    'code format',
  },
  ['/'] = { utils.live_grep, 'fzf grep repo' },
  ['.'] = {
    function()
      fzf.grep_cword({ cwd = G.root() })
    end,
    'fzf grep <cword>',
  },
  c = chatgpt_keymap_n,
  e = editthings_keymap,
  f = fzf_keymap,
  g = git_keymap,
  l = lsp_keymap,
  n = notes_keymap,
  o = openthings_keymap,
  v = vim_keymap,
  t = testthings_keymap,
  y = yank_keymap,
}

---generate opts for the plugin based on mode
---@param mode string
---@return table
local function make_mapping_opts(mode)
  return {
    mode = mode,
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false,
  }
end

which_key.register(n_keymap, make_mapping_opts('n'))

local v_keymap = {
  ['.'] = {
    function()
      fzf.grep_visual({ cwd = G.root() })
    end,
    'fzf selected',
  },
  c = chatgpt_keymap_v,
  f = fzf_keymap,
  g = git_keymap,
  l = lsp_keymap,
  o = openthings_keymap,
  y = yank_keymap,
}

which_key.register(v_keymap, make_mapping_opts('v'))

which_key.setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      -- adds help for operators like d, y, ... and registers them for motion / text object completion
      operators = true,
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- -- For example:
    -- ['<space>'] = 'SPC',
    -- ['<cr>'] = 'RET',
    -- ['<tab>'] = 'TAB',
  },
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = 'rounded', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 3, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = 'auto', -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
})
