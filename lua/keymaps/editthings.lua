local utils = require('keymaps.utils')
local marlin = require('marlin')
local function marlin_marks()
  marlin.load_project_files()
  local results = marlin.get_indexes()
  local files = {}
  for _, item in ipairs(results) do
    table.insert(
      files,
      string.format('%s:%d:%d', item.filename, item.row, item.col)
    )
  end
  local fzf = require('fzf-lua')
  fzf.fzf_exec(files, { actions = fzf.defaults.actions.files })
end
local vimrc_to_edit = '~/.config/nvim/after/plugin/whichkey_userconfig.lua'

local editthings_keymap = {
  name = 'edit things',
  a = {
    function()
      local f = vim.fn.expand('#')
      marlin.add()
      marlin.save()
      vim.notify(f .. ' added to marlin')
    end,
    'add file to marlin collection',
  },
  D = {
    function()
      local f = vim.fn.expand('#')
      marlin.remove()
      marlin.save()
      vim.notify(f .. ' removed from marlin')
    end,
    'remove file from marlin collection',
  },
  e = {
    function()
      local f = vim.fn.expand('#')
      if f == '' then
        -- vim.notify('No file to alternate', vim.log.levels.WARN)
        vim.cmd('e ' .. vimrc_to_edit)
      else
        vim.cmd('e! #')
      end
    end,
    'toggle last used file',
  },
  l = {
    marlin_marks,
    'list marlin collection',
  },
  s = utils.vim_cmd('UltiSnipsEdit', 'edit snippet for current buffer'),
  v = utils.vim_cmd('e ' .. vimrc_to_edit, 'edit vimrc'),
  X = {
    marlin.remove_all,
    '',
  },
}
return editthings_keymap
