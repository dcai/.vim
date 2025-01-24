local loaded, wk = pcall(require, 'which-key')
if not loaded then
  vim.g.logger.error('which-key not loaded!')
  return
end

local chat_keymap = require('dcai.keymaps.chat')
local editthings_keymap = require('dcai.keymaps.editthings')
local fzf = require('fzf-lua')
local fzf_keymap = require('dcai.keymaps.fzfthings')
local git_keymap = require('dcai.keymaps.git')
local lsp_keymap = require('dcai.keymaps.lsp')
local notes_keymap = require('dcai.keymaps.notes')
local openthings_keymap = require('dcai.keymaps.openthings')
local testthings_keymap = require('dcai.keymaps.testthings')
local utils = require('dcai.keymaps.utils')
local vim_keymap = require('dcai.keymaps.vim')
local yank_keymap = require('dcai.keymaps.yankthings')

wk.add(fzf_keymap)
wk.add(chat_keymap)
wk.add(editthings_keymap)
wk.add(git_keymap)
wk.add(lsp_keymap)
wk.add(openthings_keymap)
wk.add(testthings_keymap)
wk.add(yank_keymap)
wk.add(vim_keymap)
wk.add(notes_keymap)

wk.add({
  {
    '<leader>pp',
    '<cmd>set paste<CR>:r !pbpaste<CR>:set nopaste<CR>',
    desc = 'paste',
  },
  {
    '<leader>/',
    utils.live_grep,
    desc = 'fzf grep repo',
    mode = 'n',
  },
  {
    '<leader>,',
    function()
      local ft = vim.bo.filetype
      if vim.list_contains({ 'elixir', 'heex', 'swift' }, ft) then
        vim.lsp.buf.format({ async = true })
      else
        vim.cmd('ALEFix')
      end
    end,
    desc = 'code format',
    mode = 'n',
  },

  {
    '<leader>.',
    function()
      fzf.grep_cword({ cwd = vim.g.git_root() })
    end,
    desc = 'fzf grep <cword>',
    mode = 'n',
  },
  {
    '<leader>.',
    function()
      fzf.grep_visual({ cwd = vim.g.git_root() })
    end,
    desc = 'fzf selected text',
    mode = 'v',
  },
})

local user_config = {
  preset = 'modern',
  -- show a warning when issues were detected with your mappings
  notify = true,
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
  layout = {
    height = { min = 3, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- align columns left, center or right
  },
  keys = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  ---@type (string|wk.Sorter)[]
  --- Mappings are sorted using configured sorters and natural sort of the keys
  --- Available sorters:
  --- * local: buffer-local mappings first
  --- * order: order of the items (Used by plugins like marks / registers)
  --- * group: groups last
  --- * alphanum: alpha-numerical first
  --- * mod: special modifier keys last
  --- * manual: the order the mappings were added
  --- * case: lower-case first
  -- sort = { 'local', 'order', 'group', 'alphanum', 'mod', 'manual' },
  sort = { 'manual' },
  ---@type number|fun(node: wk.Node):boolean?
  expand = 1, -- expand groups when <= n mappings
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
    ellipsis = '…',
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons
    ---@type wk.IconRule[]|false
    -- rules = {},
    rules = false,
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = true,
    -- used by key format
    keys = {
      Up = ' ',
      Down = ' ',
      Left = ' ',
      Right = ' ',
      C = '󰘴 ',
      M = '󰘵 ',
      S = '󰘶 ',
      CR = '󰌑 ',
      -- Esc = '󱊷 ',
      Esc = 'Esc',
      ScrollWheelDown = '󱕐 ',
      ScrollWheelUp = '󱕑 ',
      NL = '󰌑 ',
      BS = '⌫',
      Space = '󱁐 ',
      Tab = '󰌒 ',
    },
  },
  show_help = true, -- show help message on the command line when the popup is visible
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  triggers = {
    { '<auto>', mode = 'nxsot' },
  },
  -- disable = {
  --   -- disable WhichKey for certain buf types and file types.
  --   ft = {},
  --   bt = {},
  --   -- disable a trigger for a certain context by returning true
  --   ---@type fun(ctx: { keys: string, mode: string, plugin?: string }):boolean?
  --   trigger = function(ctx)
  --     return false
  --   end,
  -- },
  debug = false, -- enable wk.log in the current directory
  ---@type wk.Win
  win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    border = 'rounded',
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = 'center',
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
}
wk.setup(user_config)
