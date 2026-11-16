local utils = require('dcai.keymaps.utils')

local subl = [[/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl]]
local zed = [[/Applications/Zed.app/Contents/MacOS/cli]]
local editor = zed

local function open_browser()
  local mode = vim.fn.mode()
  local visual = mode == 'v' or mode == 'V' or mode == '\22'
  local text
  if visual then
    text = table.concat(
      vim.fn.getregion(
        vim.fn.getpos('v'),
        vim.fn.getpos('.'),
        { type = mode, exclusive = vim.o.selection == 'exclusive' }
      ),
      '\n'
    )
  else
    text = vim.fn.expand('<cfile>')
  end
  text = vim.trim(text)
  if text:match('^[%w_-]+/[%w_.-]+$') then
    local url = 'https://github.com/' .. text
    local command = '<Cmd>call openbrowser#open('
      .. vim.fn.string(url)
      .. ')<CR>'
    return (visual and '<Esc>' or '') .. command
  end
  return '<Plug>(openbrowser-smart-search)'
end

local openthings_keymap = {
  { '<leader>o', group = 'open things' },
  {
    '<leader>ob',
    open_browser,
    expr = true,
    desc = 'search word or selection in browser',
    mode = { 'v', 'n' },
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
        editor,
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
