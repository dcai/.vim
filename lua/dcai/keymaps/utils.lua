local M = {}

-- Base function for running async commands with plenary.job
-- @param command string: The command to run
-- @param args table: Command arguments
-- @param opts table: Options (cwd, on_success, on_error)
--   - cwd: working directory (default: getcwd())
--   - on_success: function(stdout, stderr) - called when ret == 0
--   - on_error: function(stdout, stderr, ret) - called when ret != 0
-- @return function: A function that executes the command when called
M.lazy_cmd = function(command, args, opts)
  return function()
    local plenary_loaded, Job = pcall(require, 'plenary.job')
    if not plenary_loaded then
      return
    end

    opts = opts or {}
    args = args or {}
    local cwd = opts.cwd or vim.fn.getcwd()

    Job
      :new({
        command = command,
        args = args,
        cwd = cwd,
        on_exit = vim.schedule_wrap(function(job, ret)
          local stderr = table.concat(job:stderr_result(), vim.g.nl)
          local stdout = table.concat(job:result(), vim.g.nl)

          if ret == 0 then
            if opts.on_success then
              opts.on_success(stdout, stderr)
            end
          else
            if opts.on_error then
              opts.on_error(stdout, stderr, ret)
            end
          end
        end),
      })
      :start()
  end
end

local function lazy_cmd_with_window(command, opts, desc)
  return function()
    opts = opts or {}
    local disable_popup = opts.disable_popup and true or false
    local args = opts.args or {}
    desc = desc or string.format('%s %s', command, table.concat(args, ' '))
    local done_msg = string.format('### all done:  %s', desc)

    local popupwin = nil
    if not disable_popup then
      popupwin =
        vim.g.new_win({ title = command, filetype = 'sh', w = 90, h = 50 })
      popupwin.append(string.format('> %s' .. vim.g.nl .. vim.g.nl, desc))
    end

    M.lazy_cmd(command, args, {
      cwd = opts.cwd,
      on_success = function(stdout, stderr)
        if (not disable_popup) and popupwin then
          popupwin.append(stderr .. vim.g.nl .. stdout .. vim.g.nl .. vim.g.nl)
          popupwin.append(done_msg)
        else
          vim.notify(done_msg)
        end
      end,
      on_error = function(stdout, stderr, ret)
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
      end,
    })()
  end
end
M.lazy_cmd_with_window = lazy_cmd_with_window

M.lazy_cmd_with_fidget = function(command, args, opts)
  return function()
    opts = opts or {}
    local command_full = string.format('%s %s', command, table.concat(args, ' '))

    -- Create fidget progress handle
    local fidget_progress = require('fidget.progress')
    local handle = fidget_progress.handle.create({
      title = opts.title or command,
      message = 'Running...',
      lsp_client = { name = command_full },
    })

    M.lazy_cmd(command, args, {
      cwd = opts.cwd,
      on_success = function(stdout, stderr)
        handle.message = 'Completed'
        if stdout ~= '' then
          vim.notify(stdout, vim.log.levels.INFO)
        end
        handle:finish()
      end,
      on_error = function(stdout, stderr, ret)
        handle.message = 'Error'
        if stderr ~= '' then
          vim.notify(stderr, vim.log.levels.ERROR)
        end
        handle:finish()
      end,
    })()
  end
end

M.live_grep = function()
  -- local telescope = require('telescope.builtin')
  -- telescope.live_grep({ cwd = G.git_root() })
  local fzf = require('fzf-lua')
  fzf.live_grep({ cwd = vim.g.git_root() })
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
