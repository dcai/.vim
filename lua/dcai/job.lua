local M = {}

---@class dcai.JobOptions
---@field command string
---@field args? string[]
---@field cwd? string
---@field env? table<string, string|number> Overrides inherited environment variables.
---@field stdin? string|string[]
---@field timeout? integer Milliseconds before termination.
---@field text? boolean Normalize CRLF by default; false preserves raw output.
---@field on_exit? fun(result: dcai.JobResult) Called once on the main loop.

---@class dcai.JobResult
---@field ok boolean
---@field code integer Exit code, or -1 if the process could not start.
---@field signal integer
---@field stdout string
---@field stderr string
---@field cancelled boolean
---@field error? string Process-launch error; not a nonzero exit status.

---@class dcai.Job
---@field pid? integer
---@field result? dcai.JobResult Set before the completion callback runs.
---@field stop fun(self: dcai.Job) Request termination; safe to call repeatedly.

---Start a buffered text process without invoking a shell.
---@param opts dcai.JobOptions
---@return dcai.Job
function M.run(opts)
  vim.validate('command', opts.command, 'string')
  vim.validate('args', opts.args, 'table', true)
  vim.validate('on_exit', opts.on_exit, 'function', true)
  local task = {}
  local process
  local cancelled = false
  local complete = vim.schedule_wrap(function(result)
    if task.result then
      return
    end
    if opts.text ~= false then
      -- Normalize once after chunks are joined, not once per pipe read.
      result.stdout = (result.stdout or ''):gsub('\r\n', '\n')
      result.stderr = (result.stderr or ''):gsub('\r\n', '\n')
    else
      result.stdout = result.stdout or ''
      result.stderr = result.stderr or ''
    end
    result.cancelled = cancelled
    result.ok = not cancelled
      and result.error == nil
      and result.code == 0
      and result.signal == 0
    task.result = result
    if opts.on_exit then
      opts.on_exit(result)
    end
  end)

  function task:stop()
    if self.result or cancelled then
      return
    end
    cancelled = true
    if process and not process:is_closing() then
      process:kill('sigterm')
    end
  end

  local command = vim.list_extend({ opts.command }, opts.args or {})
  local ok, value = pcall(vim.system, command, {
    cwd = opts.cwd,
    env = opts.env,
    stdin = opts.stdin,
    timeout = opts.timeout,
  }, complete)
  if ok then
    process = value
    task.pid = process.pid
  else
    local message = tostring(value)
    complete({ code = -1, signal = 0, stderr = message, error = message })
  end
  return task
end

return M
