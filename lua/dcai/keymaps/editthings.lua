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
local vimrc_to_edit = '~/.config/nvim/lua/dcai/keymaps/init.lua'

local editthings_keymap = {
  { '<leader>e', group = 'edit things' },
  {
    '<leader>ea',
    function()
      local marlin = require('marlin')
      local f = vim.fn.expand('#')
      marlin.add()
      marlin.save()
      vim.notify(f .. ' added to marlin')
    end,
    desc = 'marlin: add to collection',
  },
  {
    '<leader>eD',
    function()
      local marlin = require('marlin')
      local f = vim.fn.expand('#')
      marlin.remove()
      marlin.save()
      vim.notify(f .. ' removed from marlin')
    end,
    desc = 'marlin: remove from collection',
  },
  {
    '<leader>ee',
    function()
      local f = vim.fn.expand('#')
      if f == '' then
        -- vim.notify('No file to alternate', vim.log.levels.WARN)
        -- vim.cmd('e ' .. vimrc_to_edit)
        require('fzf-lua').files({ cwd = '~/.config/nvim' })
      else
        vim.cmd('e! #')
      end
    end,
    desc = 'toggle last used file',
  },
  {
    '<leader>el',
    marlin_marks,
    desc = 'marlin: list collection',
  },
  {
    '<leader>es',
    function()
      -- vim.cmd('UltiSnipsEdit')
    end,
    desc = 'edit snippet for current buffer',
  },
  {
    '<leader>ev',
    function()
      -- require('fzf-lua').git_files({ cwd = '~/.config/nvim' })
      require('fzf-lua').files({ cwd = '~/.config/nvim' })
      -- v = utils.vim_cmd('e ' .. vimrc_to_edit, 'edit vimrc')
    end,
    desc = 'toggle last used file',
  },
  {
    '<leader>eX',
    function()
      local marlin = require('marlin')

      marlin.remove_all()
    end,
    desc = 'marlin: remove all collection items',
  },
}
return editthings_keymap
