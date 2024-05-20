local M = {}

local function lazy_shell_cmd(command, opts, desc)
  return function()
    local plenary_loaded, Job = pcall(require, 'plenary.job')
    if not plenary_loaded then
      return
    end
    local disable_popup = opts.disable_popup and true or false
    opts = opts or {}
    -- local cwd = opts.cwd or vim.fn.expand('%:p:h')
    local cwd = opts.cwd or vim.fn.getcwd()
    desc = desc or string.format('%s %s', command, table.concat(opts.args, ' '))
    local channel = nil
    if not disable_popup then
      local popup_title = command
      local popup = G.new_popup({
        title = popup_title,
        number = false,
        height = opts.height or 10,
      })
      popup.open()
      channel = vim.api.nvim_open_term(popup.buffer, {})
      vim.api.nvim_chan_send(
        channel,
        string.format('[%s] start...' .. G.nl, desc)
      )
    end
    local args = opts.args or {}
    Job
      :new({
        command = command,
        args = args,
        cwd = cwd,
        on_exit = vim.schedule_wrap(function(job, ret)
          local stderr = table.concat(job:stderr_result(), G.nl)
          local stdout = table.concat(job:result(), G.nl)
          if ret == 0 then
            if not disable_popup then
              vim.api.nvim_chan_send(channel, stderr .. G.nl .. stdout)
            else
              vim.notify(string.format('[%s] done', desc))
            end
          else
            if not disable_popup then
              pcall(vim.api.nvim_chan_send, channel, stderr)
            else
              vim.notify(
                command
                  .. ''
                  .. table.concat(args, ',')
                  .. ' failed: '
                  .. stderr
              )
            end
          end
        end),
      })
      :start()
  end
end

M.lazy_shell_cmd = lazy_shell_cmd

local function shell_cmd(command)
  return function(opts, desc)
    return {
      lazy_shell_cmd(command, opts, desc),
      desc,
    }
  end
end
M.shell_cmd = shell_cmd

M.git_cmd = shell_cmd('git')

local function project_root()
  local dir = vim.fn.expand('%:p:h')
  local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_loaded then
    return dir
  end
  local root_pattern = nvim_lspconfig.util.root_pattern
  return root_pattern(
    'package.json',
    'readme.md',
    'README.md',
    'readme.txt',
    'LICENSE.txt',
    'LICENSE',
    '.git'
  )(dir)
end

M.project_root = project_root

M.live_grep = function()
  local fzf = require('fzf-lua')
  fzf.live_grep({ cwd = project_root() })
end

---@param cmd string vim command
M.vim_cmd = function(cmd, desc, notify_after)
  return {
    function()
      vim.cmd(cmd)
      if notify_after then
        vim.notify(notify_after)
      end
    end,
    desc or cmd,
  }
end
local function open_git_hosting_web()
  local mode = vim.fn.mode()
  if string.lower(mode) == 'v' then
    mode = 'v'
  else
    mode = 'n'
  end

  require('gitlinker').get_buf_range_url(mode)
end
M.open_git_hosting_web = open_git_hosting_web

return M
