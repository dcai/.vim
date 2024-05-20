local utils = require('keymaps.utils')

-- local subl = '/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl'
local zed = [[/Applications/Zed.app/Contents/MacOS/cli]]

local openthings_keymap = {
  name = 'open things',
  b = {
    '<Plug>(openbrowser-smart-search)',
    'search current word in browser',
  },
  d = {
    function()
      -- has to be wrapped because dir must be lazy evaluated
      utils.lazy_shell_cmd(
        'open',
        { disable_popup = true, args = { vim.fn.expand('%:p:h') } },
        'open folder'
      )()
    end,
    'open in folder',
  },
  f = {
    function()
      -- has to be wrapped because filename must be lazy evaluated
      utils.lazy_shell_cmd(
        zed,
        { disable_popup = true, args = { vim.fn.expand('%:p') } },
        'open file in zed'
      )()
    end,
    'open file in gui editor',
  },
  g = { utils.open_git_hosting_web, 'open file in git web' },
  t = {
    function()
      require('mini.files').open()
    end,
    'open file tree',
  },
}

return openthings_keymap
