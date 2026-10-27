local M = {}

local function quote(value)
  return '"'
    .. value
      :gsub('\\', '\\\\')
      :gsub('"', '\\"')
      :gsub('\r', '\\r')
      :gsub('\n', '\\n')
      :gsub('\t', '\\t')
    .. '"'
end

---@class dcai.HttpOptions
---@field method? string Defaults to GET.
---@field headers? table<string, string>
---@field body? string Text payload; NUL bytes are not supported.
---@field timeout? integer Milliseconds; defaults to 30000.
---@field retry? integer Defaults to zero; only GET/HEAD can be retried.
---@field verbose? boolean Curl diagnostics; avoid with credentials.
---@field outpath? string Write successful response bytes to this file.
---@field outbuf? integer Write a successful response to this loaded buffer.

---@class dcai.HttpResponse
---@field body string Raw response bytes, including final newlines.
---@field status? integer HTTP status, absent on launch/transport failures.

---Curl HTTP client with vim.net.request's calling convention.
---Callbacks run once on the main loop. HTTP errors retain their response body.
---Unlike vim.net.request, retries default to zero and redirects are not followed.
---@param url string
---@param opts? dcai.HttpOptions
---@param on_response? fun(err: string?, response: dcai.HttpResponse?)
---@return table handle With close() to cancel the request.
function M.request(url, opts, on_response)
  opts = opts or {}
  vim.validate('url', url, 'string')
  vim.validate('opts', opts, 'table')
  vim.validate('on_response', on_response, 'function', true)
  vim.validate('body', opts.body, 'string', true)
  vim.validate('headers', opts.headers, 'table', true)
  assert(
    url:match('^https?://') and not url:find('[%c]'),
    'Expected an HTTP(S) URL'
  )
  local method = (opts.method or 'GET'):upper()
  local timeout = opts.timeout or 30000
  local retry = opts.retry or 0
  assert(method:match('^[A-Z]+$'), 'Invalid HTTP method')
  assert(
    type(timeout) == 'number' and timeout > 0,
    'Expected a positive timeout'
  )
  assert(
    type(retry) == 'number' and retry >= 0 and retry % 1 == 0,
    'Invalid retry count'
  )
  assert(
    retry == 0 or method == 'GET' or method == 'HEAD',
    'Only GET/HEAD requests can retry'
  )
  assert(
    not opts.body or not opts.body:find('\0', 1, true),
    'NUL bytes are not supported in request bodies'
  )
  local config = { 'url = ' .. quote(url), 'request = ' .. quote(method) }
  for name, value in pairs(opts.headers or {}) do
    assert(
      type(name) == 'string' and name:match("^[!#$%%&'*+.^_`|~%w-]+$"),
      'Invalid header name'
    )
    assert(
      type(value) == 'string' and not value:find('[%c]'),
      'Invalid header value'
    )
    config[#config + 1] = 'header = ' .. quote(name .. ': ' .. value)
  end
  if opts.body ~= nil then
    config[#config + 1] = 'data-raw = ' .. quote(opts.body)
  end
  local args = {
    '--disable', -- Ignore curlrc options that change body/status semantics.
    '--silent',
    '--show-error',
    '--config',
    '-',
    '--write-out',
    '\n%{http_code}',
    '--max-time',
    tostring(timeout / 1000),
    '--retry',
    tostring(retry),
  }
  if method == 'HEAD' then
    args[#args + 1] = '--head'
  end
  if opts.verbose then
    args[#args + 1] = '--verbose'
  end
  local outbuf = opts.outbuf == 0 and vim.api.nvim_get_current_buf()
    or opts.outbuf
  local settled = false
  local function complete(err, response)
    if settled then
      return
    end
    settled = true
    if not err and response then
      local ok = pcall(function()
        if opts.outpath then
          local file = assert(io.open(opts.outpath, 'wb'))
          local written = file:write(response.body)
          local closed = file:close()
          assert(written and closed, 'Could not save response file')
        end
        if outbuf and vim.api.nvim_buf_is_loaded(outbuf) then
          vim.api.nvim_buf_set_lines(
            outbuf,
            0,
            -1,
            false,
            vim.split(response.body, '\n', { plain = true })
          )
        end
      end)
      if not ok then
        err = 'Could not write HTTP response'
      end
    end
    if on_response then
      on_response(err, response)
    end
  end
  -- Headers and payloads go through stdin, not process arguments.
  local job = require('dcai.job').run({
    command = 'curl',
    args = args,
    stdin = table.concat(config, '\n') .. '\n',
    timeout = timeout,
    text = false,
    on_exit = function(result)
      if not result.ok then
        complete(
          result.cancelled and 'Request cancelled' or 'HTTP transport failed',
          nil
        )
        return
      end
      local body, status = result.stdout:match('^(.*)\n(%d%d%d)$')
      status = tonumber(status)
      if not status or status == 0 then
        complete('curl returned no HTTP status', nil)
        return
      end
      local err = (status < 200 or status >= 300) and ('HTTP ' .. status) or nil
      complete(err, { status = status, body = method == 'HEAD' and '' or body })
    end,
  })
  return {
    close = function()
      if settled then
        return
      end
      job:stop()
      vim.schedule(function()
        complete('Request cancelled', nil)
      end)
    end,
  }
end

return M
