local utils = require('dcai.keymaps.utils')

-- local subl = '/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl'
local zed = [[/Applications/Zed.app/Contents/MacOS/cli]]

local shell = nil
local openthings_keymap = {
  { '<leader>o', group = 'open things' },
  {
    '<leader>ob',
    '<Plug>(openbrowser-smart-search)',
    desc = 'search current word in browser',
    mode = 'n',
  },
  {
    '<leader>ob',
    '<Plug>(openbrowser-smart-search)',
    desc = 'search selected',
    mode = 'v',
  },
  {
    '<leader>oo',
    function()
      local Term = require('toggleterm.terminal').Terminal

      if not shell then
        shell = Term:new({
          cmd = 'fish',
          dir = 'git_dir',
          -- direction = 'float',
        })
      end
      shell:toggle()
    end,
    desc = 'terminal',
  },
  {
    '<leader>od',
    function()
      -- has to be wrapped because dir must be lazy evaluated
      utils.lazy_shell_cmd(
        'open',
        { disable_popup = true, args = { vim.fn.expand('%:p:h') } },
        'open folder'
      )()
    end,
    desc = 'open in folder',
  },
  {
    '<leader>of',
    function()
      -- has to be wrapped because filename must be lazy evaluated
      utils.lazy_shell_cmd(
        zed,
        { disable_popup = true, args = { vim.fn.expand('%:p') } },
        'open file in zed'
      )()
    end,
    desc = 'open file in gui editor',
  },
  {
    '<leader>og',
    utils.open_git_hosting_web,
    desc = 'open file in git web',
  },
  {
    '<leader>ot',
    function()
      require('mini.files').open()
    end,
    desc = 'open file tree',
  },
}

return openthings_keymap
