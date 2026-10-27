local MiniTest = require('mini.test')
local eq = MiniTest.expect.equality
local Job = require('dcai.job')
local tasks = {}
local directory = vim.fn.tempname() .. ' with spaces'
local T = MiniTest.new_set({
  hooks = {
    pre_once = function()
      vim.fn.mkdir(directory, 'p')
    end,
    post_case = function()
      for _, task in ipairs(tasks) do
        task:stop()
      end
      tasks = {}
    end,
    post_once = function()
      vim.fn.delete(directory, 'rf')
    end,
  },
})

-- Use Neovim itself as a portable executable, not a shell or external service.
local function command(lua, opts)
  return vim.tbl_extend('force', {
    command = vim.v.progpath,
    args = { '--headless', '--clean', '-i', 'NONE', '-n', '-c', 'lua ' .. lua },
    timeout = 10000,
  }, opts or {})
end

local function start(opts)
  local result, fast
  local calls = 0
  opts.on_exit = function(value)
    calls = calls + 1
    fast = vim.in_fast_event()
    result = value
  end
  local task = Job.run(opts)
  tasks[#tasks + 1] = task
  return task,
    function()
      eq(
        vim.wait(5000, function()
          return result ~= nil
        end),
        true
      )
      eq(fast, false)
      eq(calls, 1)
      return result
    end
end

T['captures text without trimming final newlines'] = function()
  local task, finish = start(command([[
    io.stdout:write('one\r\ntwo\nkeep\r\r\n')
    io.stderr:write('warning\n')
    vim.cmd('qa!')
  ]]))
  local result = finish()
  eq(
    { result.ok, result.code, result.signal, result.cancelled },
    { true, 0, 0, false }
  )
  eq(result.stdout, 'one\ntwo\nkeep\r\n')
  eq(result.stderr, 'warning\n')
  task:stop()
  eq(result.cancelled, false)
end

T['reports nonzero exit status'] = function()
  local _, finish =
    start(command([[io.stderr:write('failure'); vim.cmd('cquit 7')]]))
  local result = finish()
  eq({ result.ok, result.code, result.stderr }, { false, 7, 'failure' })
  eq(result.error, nil)
end

T['reports launch errors through the scheduled callback'] = function()
  local _, finish = start({ command = directory .. '/missing-executable' })
  local result = finish()
  eq({ result.ok, result.code, result.stdout }, { false, -1, '' })
  eq(type(result.error), 'string')
  eq(result.stderr, result.error)
end

T['forwards cwd, environment overrides and stdin'] = function()
  local _, finish = start(
    command(
      [[
    io.stdout:write(vim.uv.fs_realpath(vim.fn.getcwd()) .. '|' .. vim.env.JOB_TEST_VAR .. '|' .. io.read('*a'))
    vim.cmd('qa!')
  ]],
      { cwd = directory, env = { JOB_TEST_VAR = 'value' }, stdin = 'body\n' }
    )
  )
  local result = finish()
  eq(result.ok, true)
  eq(result.stdout, vim.uv.fs_realpath(directory) .. '|value|body\n')
end

T['stop terminates the process and is idempotent'] = function()
  local task, finish =
    start(command([[vim.defer_fn(function() vim.cmd('qa!') end, 10000)]]))
  task:stop()
  task:stop()
  local result = finish()
  eq({ result.ok, result.cancelled }, { false, true })
  task:stop()
end

T['timeout is a failure, not a user cancellation'] = function()
  local _, finish = start(
    command(
      [[vim.defer_fn(function() vim.cmd('qa!') end, 10000)]],
      { timeout = 50 }
    )
  )
  local result = finish()
  eq({ result.ok, result.code, result.cancelled }, { false, 124, false })
end

T['lazy_cmd preserves its deferred callback and display contract'] = function()
  local opts = command(
    [[io.stdout:write('line\n\n'); io.stderr:write('warning\n'); vim.cmd('qa!')]]
  )
  local output
  local run = require('dcai.keymaps.utils').lazy_cmd(opts.command, opts.args, {
    on_success = function(stdout, stderr)
      output = { stdout, stderr }
    end,
  })
  eq(output, nil)
  tasks[#tasks + 1] = run()
  eq(
    vim.wait(5000, function()
      return output ~= nil
    end),
    true
  )
  eq(output, { 'line\n', 'warning' })
end

return T
