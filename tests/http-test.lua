local MiniTest = require('mini.test')
local eq = MiniTest.expect.equality
local T, child = require('tests.helpers').new_set()

-- Capture the process boundary without launching curl or making HTTP requests.
local function capture(url, opts)
  return child.lua_func(function(request_url, request_opts)
    local captured
    package.loaded['dcai.job'] = {
      run = function(job_opts)
        captured = job_opts
        return { stop = function() end }
      end,
    }
    require('dcai.http').request(request_url, request_opts)
    captured.on_exit = nil
    return captured
  end, url, opts)
end

T['GET uses safe defaults and sends its URL through stdin'] = function()
  eq(capture('https://example.test/path?x=1&y=2'), {
    command = 'curl',
    args = {
      '--disable',
      '--silent',
      '--show-error',
      '--config',
      '-',
      '--write-out',
      '\n%{http_code}',
      '--max-time',
      '30',
      '--retry',
      '0',
    },
    stdin = 'url = "https://example.test/path?x=1&y=2"\nrequest = "GET"\n',
    timeout = 30000,
    text = false,
  })
end

T['POST keeps credentials and escaped payloads out of arguments'] = function()
  local result = capture('https://example.test', {
    method = 'post',
    headers = { Authorization = 'Bearer test-token' },
    body = '"quoted"\\path\r\n\tend',
  })
  eq(
    result.stdin,
    'url = "https://example.test"\n'
      .. 'request = "POST"\n'
      .. 'header = "Authorization: Bearer test-token"\n'
      .. 'data-raw = "\\"quoted\\"\\\\path\\r\\n\\tend"\n'
  )
  eq(table.concat(result.args, ' '):find('test-token', 1, true), nil)
  eq(table.concat(result.args, ' '):find('quoted', 1, true), nil)
  eq(vim.tbl_contains(result.args, '--location'), false)
  eq(vim.tbl_contains(result.args, '--verbose'), false)
end

T['HEAD forwards timeout and retries with the head flag'] = function()
  local result = capture('https://example.test', {
    method = 'head',
    timeout = 1250,
    retry = 2,
    verbose = true,
  })
  eq(result.args, {
    '--disable',
    '--silent',
    '--show-error',
    '--config',
    '-',
    '--write-out',
    '\n%{http_code}',
    '--max-time',
    '1.25',
    '--retry',
    '2',
    '--head',
    '--verbose',
  })
  eq(result.timeout, 1250)
  eq(result.stdin, 'url = "https://example.test"\nrequest = "HEAD"\n')
end

T['GET permits explicit retries without enabling redirects'] = function()
  local result = capture('https://example.test', { retry = 3 })
  eq(result.args[#result.args], '3')
  eq(vim.tbl_contains(result.args, '--head'), false)
  eq(vim.tbl_contains(result.args, '--location'), false)
end

T['an empty payload is sent rather than omitted'] = function()
  local result = capture('https://example.test', { method = 'PUT', body = '' })
  eq(
    result.stdin,
    'url = "https://example.test"\nrequest = "PUT"\ndata-raw = ""\n'
  )
end

T['invalid requests fail before launching a job'] = function()
  local result = child.lua_func(function()
    local launches = 0
    package.loaded['dcai.job'] = {
      run = function()
        launches = launches + 1
        error('Unexpected job launch')
      end,
    }
    local request = require('dcai.http').request
    local cases = {
      { 'file:///tmp/example', {}, 'Expected an HTTP(S) URL' },
      { 'https://example.test\n', {}, 'Expected an HTTP(S) URL' },
      { 'https://example.test', { method = 'GET\n' }, 'Invalid HTTP method' },
      {
        'https://example.test',
        { timeout = 0 },
        'Expected a positive timeout',
      },
      { 'https://example.test', { retry = -1 }, 'Invalid retry count' },
      { 'https://example.test', { retry = 0.5 }, 'Invalid retry count' },
      {
        'https://example.test',
        { method = 'POST', retry = 1 },
        'Only GET/HEAD requests can retry',
      },
      {
        'https://example.test',
        { body = 'a\0b' },
        'NUL bytes are not supported in request bodies',
      },
      {
        'https://example.test',
        { headers = { ['Bad:Name'] = 'value' } },
        'Invalid header name',
      },
      {
        'https://example.test',
        { headers = { Accept = 'text/plain\r\nInjected: yes' } },
        'Invalid header value',
      },
    }
    local results = {}
    for _, case in ipairs(cases) do
      local ok, err = pcall(request, case[1], case[2])
      results[#results + 1] = not ok
        and tostring(err):find(case[3], 1, true) ~= nil
    end
    return { results = results, launches = launches }
  end)
  eq(result, {
    results = { true, true, true, true, true, true, true, true, true, true },
    launches = 0,
  })
end

return T
