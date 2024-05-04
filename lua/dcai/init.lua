require('dcai.globals')

LOG = require('log')
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = G.find_executable({
  '~/.local/share/nvim/venv/bin/python3',
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})
vim.g.node_host_prog = G.find_executable({
  '~/.npm-packages/bin/neovim-node-host',
})

-- vim.opt.cmdheight = 0
local shadafile = os.getenv('NVIM_SHADA')
if shadafile then
  vim.opt.shadafile = shadafile
end

G.source('loader.vim')
G.setup_colorscheme()

local codestats = require('codestats')
codestats.setup()

vim.api.nvim_create_user_command('Cc', function()
  local popup = G.new_popup({ title = 'clang build and run', number = true })
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
          table.concat(job:stderr_result(), G.nl)
        )
      else
        pcall(vim.api.nvim_chan_send, channel, table.concat(job:result(), G.nl))
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
  print('test? yes.')
end)
