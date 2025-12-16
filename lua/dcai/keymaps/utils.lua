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
    local popupwin = nil
    if not disable_popup then
      popupwin =
        vim.g.new_win({ title = command, filetype = 'sh', w = 90, h = 50 })
      popupwin.append(string.format('> %s' .. vim.g.nl .. vim.g.nl, desc))
    end
    local args = opts.args or {}
    local done_msg = string.format('### all done:  %s', desc)
    Job
      :new({
        command = command,
        args = args,
        cwd = cwd,
        on_exit = vim.schedule_wrap(function(job, ret)
          local stderr = table.concat(job:stderr_result(), vim.g.nl)
          local stdout = table.concat(job:result(), vim.g.nl)
          if ret == 0 then
            if (not disable_popup) and popupwin then
              popupwin.append(
                stderr .. vim.g.nl .. stdout .. vim.g.nl .. vim.g.nl
              )
              popupwin.append(done_msg)
            else
              vim.notify(done_msg)
            end
          else
            if (not disable_popup) and popupwin then
              popupwin.append(stderr)
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

M.git_cmd = function(opts, desc)
  return lazy_shell_cmd('git', opts, desc)
end

M.cmd_with_fidget = function(command, args, opts)
  return function()
    local plenary_loaded, Job = pcall(require, 'plenary.job')
    if not plenary_loaded then
      vim.notify(
        'plenary.nvim is required for cmd_with_fidget',
        vim.log.levels.ERROR
      )
      return
    end

    local fidget_loaded, fidget_progress = pcall(require, 'fidget.progress')
    if not fidget_loaded then
      vim.notify(
        'fidget.nvim is required for cmd_with_fidget',
        vim.log.levels.ERROR
      )
      return
    end

    opts = opts or {}
    local cwd = opts.cwd or vim.fn.getcwd()
    local title = opts.title
      or string.format('%s %s', command, table.concat(args, ' '))

    -- Create fidget progress handle
    local handle = fidget_progress.handle.create({
      title = title,
      message = 'Running...',
      lsp_client = { name = command },
    })

    Job:new({
      command = command,
      args = args,
      cwd = cwd,
      on_exit = vim.schedule_wrap(function(job, ret)
        local stderr = table.concat(job:stderr_result(), '\n')
        local stdout = table.concat(job:result(), '\n')

        if ret == 0 then
          handle.message = 'Completed'
          if stdout ~= '' then
            vim.notify(stdout, vim.log.levels.INFO)
          end
        else
          handle.message = 'Error'
          if stderr ~= '' then
            vim.notify(stderr, vim.log.levels.ERROR)
          end
        end

        handle:finish()
      end),
    }):start()
  end
end

M.live_grep = function()
  -- local telescope = require('telescope.builtin')
  -- telescope.live_grep({ cwd = G.git_root() })
  local fzf = require('fzf-lua')
  fzf.live_grep({ cwd = vim.g.git_root() })
end

---@param cmd string vim command
M.vim_cmd = function(key, cmd, desc, notify_after)
  return {
    key,
    function()
      vim.cmd(cmd)
      if notify_after then
        vim.notify(notify_after)
      end
    end,
    desc = desc or cmd,
  }
end
local function open_git_hosting_web()
  -- local mode = vim.fn.mode()
  -- if string.lower(mode) == 'v' then
  --   mode = 'v'
  -- else
  --   mode = 'n'
  -- end
  -- require('gitlinker').get_buf_range_url(mode)
  Snacks.gitbrowse.open()
end
M.open_git_hosting_web = open_git_hosting_web

return M
