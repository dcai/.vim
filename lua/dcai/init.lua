require('dcai.globals')

if not vim.g.file_exists(vim.g.run_dir) then
  vim.fn.mkdir(vim.g.run_dir, 'p')
end

vim.g.logger = require('dcai.log').setup()
_G.logger = vim.g.logger

-- require('vim._core.ui2').enable({
--   enable = true, -- Whether to enable or disable the UI.
--   msg = { -- Options related to the message module.
--     ---@type 'cmd'|'msg' Default message target, either in the
--     ---cmdline or in a separate ephemeral message window.
--     ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
--     ---or table mapping |ui-messages| kinds and triggers to a target.
--     targets = 'cmd',
--     cmd = { -- Options related to messages in the cmdline window.
--       height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
--     },
--     dialog = { -- Options related to dialog window.
--       height = 0.5, -- Maximum height.
--     },
--     msg = { -- Options related to msg window.
--       height = 0.5, -- Maximum height.
--       timeout = 4000, -- Time a message is visible in the message window.
--     },
--     pager = { -- Options related to message window.
--       height = 1, -- Maximum height.
--     },
--   },
-- })

local original_notify = vim.notify
---@diagnostic disable-next-line
vim.notify = function(msg, level, opts)
  local log = vim.g.logger[level]
  if log then
    log(msg)
  else
    vim.g.logger.info(msg)
  end
  original_notify(msg, level, opts)
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = vim.g.find_executable({
  '~/.local/share/nvim/venv/bin/python3',
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})
-- vim.g.logger.trace('python3_host_prog', vim.g.python3_host_prog)

vim.g.node_host_prog = vim.g.find_executable({
  '~/.npm-packages/bin/neovim-node-host',
})

-- Select the provider before plugins can initialize the clipboard.
if vim.env.SSH_CONNECTION and vim.env.SSH_CONNECTION ~= '' then
  vim.g.clipboard = 'osc52'
end

-- Neovim doesn't support legacy terminal options like t_SI/t_EI.
-- Use guicursor instead so cursor shape changes work in terminals and tmux.
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'

-- vim.opt.cmdheight = 0
local shadafile = os.getenv('NVIM_SHADA')
if shadafile then
  vim.opt.shadafile = shadafile
end

vim.g.source('loader.vim')
vim.g.setup_colorscheme()
require('dcai.pack').setup()
require('dcai.lsp').setup()
require('dcai.ui.input').setup()
require('dcai.keymaps')

require('dcai.mycmp').setup()
require('dcai.commands').setup()

local codestats = require('dcai.codestats')
if codestats then
  codestats.setup()
end

local statusline = require('dcai.statusline')
if statusline then
  statusline.setup()
end

local is_macos = vim.fn.has('mac') == 1
local im_select_bin = vim.g.find_executable({
  'im-select',
})
if is_macos and im_select_bin then
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = vim.api.nvim_create_augroup('macos_input_method', { clear = true }),
    callback = function()
      vim.fn.system({
        im_select_bin,
        'com.apple.keylayout.Australian',
      })
    end,
    desc = 'Switch macOS input source to Australian English on InsertLeave',
  })
end

vim.api.nvim_create_user_command('Cc', function()
  local Job = require('dcai.job')
  local sourcefile = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local binary = vim.fs.joinpath(cwd, vim.fn.fnamemodify(sourcefile, ':t:r'))
  local popup =
    vim.g.new_popup({ title = 'clang build and run', number = true })
  local win = popup.open()
  local channel = vim.api.nvim_open_term(popup.buffer, {})
  local task
  local cancelled = false

  local function active()
    return not cancelled
      and vim.api.nvim_buf_is_valid(popup.buffer)
      and vim.api.nvim_win_is_valid(win)
  end
  local function send(text)
    if active() and text ~= '' then
      pcall(vim.api.nvim_chan_send, channel, (text:gsub('\n', '\r\n')))
    end
  end
  local function show(result, stage)
    send(result.stdout)
    send(result.stderr)
    if not result.ok then
      send(string.format('\n%s failed (exit %d)\n', stage, result.code))
    end
  end
  local function stop()
    cancelled = true
    if task then
      task:stop()
    end
  end
  vim.api.nvim_create_autocmd('WinClosed', {
    group = vim.api.nvim_create_augroup('dcai_cc', { clear = false }),
    pattern = tostring(win),
    once = true,
    callback = stop,
    desc = 'Stop C compilation or execution when its popup closes',
  })
  vim.keymap.set('n', '<C-q>', function()
    if task and not task.result then
      send('\nCancelled\n')
    end
    stop()
  end, { buffer = popup.buffer, desc = 'Stop C compilation or execution' })

  task = Job.run({
    command = 'cc',
    args = { '-o', binary, sourcefile },
    cwd = cwd,
    on_exit = function(result)
      if not active() then
        return
      end
      show(result, 'Compilation')
      if result.ok then
        task = Job.run({
          command = binary,
          cwd = cwd,
          on_exit = function(output)
            if active() then
              show(output, 'Program')
            end
          end,
        })
      end
    end,
  })
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

vim.keymap.set('n', 'XX', function()
  vim.cmd(':cclose')
  vim.cmd(':lclose')
  vim.cmd(':pclose')
  vim.cmd(':helpclose')
  vim.g.close_all_popups()
end)

vim.keymap.set(
  'n',
  '<c-_>',
  '<cmd>!tmux popup -E -h "80\\%" -w "80\\%" -d "'
    .. vim.fn.getcwd()
    .. '" -- fish<CR><CR>',
  { desc = 'Shell' }
) -- opens terminal in a new tmux window

vim.api.nvim_create_user_command('EslintFix', function()
  local filetype = vim.bo.filetype
  local dir = vim.fn.expand('%:p:h')
  local fname = vim.fn.expand('%:t')

  local lsp_utils = require('dcai.lsp.utils')
  if not vim.list_contains(lsp_utils.ts_ls_supported_filetypes, filetype) then
    vim.notify('Eslint: Not a JavaScript/TypeScript file', vim.log.levels.WARN)
    return
  end
  vim.cmd('!cd ' .. dir .. ' && npx eslint --fix ' .. fname)
  vim.cmd('edit')
end, {})
