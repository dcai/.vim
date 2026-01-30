local utils = require('dcai.keymaps.utils')

local subl = [[/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl]]
-- local zed = [[/Applications/Zed.app/Contents/MacOS/cli]]

local openthings_keymap = {
  { '<leader>o', group = 'open things' },
  {
    '<leader>ob',
    '<Plug>(openbrowser-smart-search)',
    desc = 'search current word in browser',
    mode = { 'v', 'n' },
  },
  {
    '<leader>ob',
    '<Plug>(openbrowser-smart-search)',
    desc = 'search selected',
    mode = 'v',
  },
  {
    '<leader>od',
    function()
      -- has to be wrapped because dir must be lazy evaluated
      utils.lazy_cmd_with_window(
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
      utils.lazy_cmd_with_window(
        subl,
        { disable_popup = true, args = { vim.fn.expand('%:p') } },
        'open file in external editor'
      )()
    end,
    desc = 'open file in gui editor',
  },
  {
    '<leader>og',
    utils.open_git_hosting_web,
    desc = 'open file in git web',
    mode = { 'v', 'n' },
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
