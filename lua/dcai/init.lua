require('dcai.globals')

LOG = require('dcai.log').setup()
-- LOG.trace('Starting nvim')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = vim.g.find_executable({
  '~/.local/share/nvim/venv/bin/python3',
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})
LOG.trace('python3_host_prog', vim.g.python3_host_prog)

vim.g.node_host_prog = vim.g.find_executable({
  '~/.npm-packages/bin/neovim-node-host',
})

-- vim.opt.cmdheight = 0
local shadafile = os.getenv('NVIM_SHADA')
if shadafile then
  vim.opt.shadafile = shadafile
end

vim.g.source('loader.vim')
vim.g.setup_colorscheme()
require('dcai.plug').setup({})
require('dcai.keymaps')

local codestats = require('dcai.codestats')
if codestats then
  codestats.setup()
end

local statusline = require('dcai.statusline')
if statusline then
  statusline.setup()
end

-- Copy/Paste when using ssh on a remote server
-- Only works when neovim >= 0.10.0
local is_ssh = vim.env.SSH_CONNECTION and vim.env.SSH_TTY
local has_osc52 = vim.clipboard and vim.clipboard.osc52
if is_ssh and has_osc52 then
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('ssh_clipboard', { clear = true }),
    callback = function()
      vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
          ['+'] = require('vim.clipboard.osc52').copy,
          ['*'] = require('vim.clipboard.osc52').copy,
        },
        paste = {
          ['+'] = require('vim.clipboard.osc52').paste,
          ['*'] = require('vim.clipboard.osc52').paste,
        },
      }
    end,
  })
end

vim.api.nvim_create_user_command('Cc', function()
  local popup = vim.g.new_popup({ title = 'clang build and run', number = true })
  local PJob = require('plenary.job')
  local sourcefile = vim.fn.expand('%')
  local bin_name = vim.fn.fnamemodify(sourcefile, ':t:r')
  popup.open()
  local channel = vim.api.nvim_open_term(popup.buffer, {})
  local task = PJob:new({
    command = string.format('./%s', bin_name),
    skip_validation = true,
    on_exit = vim.schedule_wrap(function(job, status)
      if status ~= 0 then
        pcall(
          vim.api.nvim_chan_send,
          channel,
          table.concat(job:stderr_result(), vim.g.nl)
        )
      else
        pcall(vim.api.nvim_chan_send, channel, table.concat(job:result(), vim.g.nl))
      end
    end),
  })
  -- compile the source code
  PJob:new({
    command = 'cc',
    args = { '-o', bin_name, sourcefile },
    on_exit = function(_, code)
      if code ~= 0 then
        return
      end
      -- run the binary and display the output
      task:start()
    end,
  }):start()
  vim.keymap.set('n', '<C-q>', function()
    task:shutdown()
  end, { buffer = popup.buffer })
end, { desc = 'Compile and run C file.' })

-- playground, test something
vim.keymap.set('n', '<leader>tg', function()
  local input = { 'a', 1, 2, 22 }
  local function run(a, b, c, d)
    print(a)
    print(b)
    print(c)
    print(d)
    print('test? yes.')
  end
  run(unpack(input))
end)
