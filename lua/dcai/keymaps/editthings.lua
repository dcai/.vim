local utils = require('dcai.keymaps.utils')

local function marlin_marks()
  local marlin = require('marlin')
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
      local marlin = require('marlin')
      local f = vim.fn.expand('#')
      marlin.add()
      marlin.save()
      vim.notify(f .. ' added to marlin')
    end,
    'marlin: add to collection',
  },
  D = {
    function()
      local marlin = require('marlin')
      local f = vim.fn.expand('#')
      marlin.remove()
      marlin.save()
      vim.notify(f .. ' removed from marlin')
    end,
    'marlin: remove from collection',
  },
  e = {
    function()
      local f = vim.fn.expand('#')
      if f == '' then
        -- vim.notify('No file to alternate', vim.log.levels.WARN)
        -- vim.cmd('e ' .. vimrc_to_edit)
        require('fzf-lua').git_files({ cwd = '~/.config/nvim' })
      else
        vim.cmd('e! #')
      end
    end,
    'toggle last used file',
  },
  l = {
    marlin_marks,
    'marlin: list collection',
  },
  s = utils.vim_cmd('UltiSnipsEdit', 'edit snippet for current buffer'),
  v = {
    function()
      -- require('fzf-lua').git_files({ cwd = '~/.config/nvim' })
      require('fzf-lua').files({ cwd = '~/.config/nvim' })
      -- v = utils.vim_cmd('e ' .. vimrc_to_edit, 'edit vimrc')
    end,
    'toggle last used file',
  },
  X = {
    function()
      local marlin = require('marlin')

      marlin.remove_all()
    end,
    'marlin: remove all collection items',
  },
}
return editthings_keymap
