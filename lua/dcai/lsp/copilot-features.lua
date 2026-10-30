local M = {}
local buffers = {}
local guarded_clients = setmetatable({}, { __mode = 'k' })

-- Filename checks are a safety net, not a replacement for server-side exclusions.
function M.allowed(bufnr)
  if vim.bo[bufnr].buftype ~= '' or not vim.bo[bufnr].buflisted then
    return false
  end
  if
    vim.tbl_contains(
      { 'help', 'codecompanion', 'copilot-chat', 'gitcommit' },
      vim.bo[bufnr].filetype
    )
  then
    return false
  end
  local path = vim.api.nvim_buf_get_name(bufnr):gsub('\\', '/'):lower()
  local name = vim.fs.basename(path)
  if path == '' or path:find('://', 1, true) then
    return false
  end
  if name == '.env' or name:match('^%.env%.') then
    return false
  end
  if
    vim.tbl_contains({
      '.envrc',
      'id_rsa',
      'id_dsa',
      'id_ecdsa',
      'id_ed25519',
      'id_ecdsa_sk',
      'id_ed25519_sk',
      '.netrc',
      '.npmrc',
      '.pypirc',
      'credentials',
      'credentials.json',
      'secrets.json',
      'secrets.yaml',
      'secrets.yml',
    }, name)
  then
    return false
  end
  if path:find('/.ssh/', 1, true) or path:find('/.gnupg/', 1, true) then
    return false
  end
  return not name:match('%.pem$')
    and not name:match('%.key$')
    and not name:match('%.p12$')
    and not name:match('%.pfx$')
    and not name:match('%.keystore$')
end

local function active(bufnr, state)
  return buffers[bufnr] == state
    and vim.api.nvim_buf_is_valid(bufnr)
    and state.client.attached_buffers[bufnr]
    and M.allowed(bufnr)
    and vim.b[bufnr].copilot_enabled ~= false
end

local function set_inline(bufnr, state, enabled)
  state.inline_generation = state.inline_generation + 1
  vim.lsp.inline_completion.enable(enabled, { bufnr = bufnr })
  vim.cmd.redrawstatus()
end

local function guard_inline_responses(client)
  if guarded_clients[client] then
    return
  end
  guarded_clients[client] = true
  local request = client.request
  -- Nvim 0.12.6's native handler dereferences deleted client state after disable.
  -- Cancellation alone cannot stop a response already queued on vim.schedule.
  client.request = function(self, method, params, handler, bufnr)
    if
      method == 'textDocument/inlineCompletion'
      and type(handler) == 'function'
    then
      local buf = bufnr and bufnr ~= 0 and bufnr
        or vim.api.nvim_get_current_buf()
      local state = buffers[buf]
      local generation = state and state.inline_generation
      local callback = handler
      handler = function(...)
        if
          state
          and active(buf, state)
          and state.inline_generation == generation
          and vim.api.nvim_get_current_buf() == buf
          and not state.menu_open
          and vim.lsp.inline_completion.is_enabled({ bufnr = buf })
        then
          callback(...)
        end
      end
    end
    return request(self, method, params, handler, bufnr)
  end
end

function M.status_handler(err, result, ctx)
  if err or not result then
    return
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end
  local previous = client.copilot_status
  client.copilot_status = result
  vim.cmd.redrawstatus()
  if
    (result.kind == 'Error' or result.kind == 'Warning')
    and result.message
    and result.message ~= ''
    and (
      not previous
      or previous.kind ~= result.kind
      or previous.message ~= result.message
    )
  then
    vim.notify('Copilot: ' .. result.message, vim.log.levels.WARN)
  end
end

function M.status(bufnr)
  local state = buffers[bufnr]
  if not state then
    vim.notify('Copilot is not attached to this buffer')
    return
  end
  local status = state.client.copilot_status or { kind = 'Starting' }
  vim.print({
    enabled = vim.b[bufnr].copilot_enabled ~= false,
    kind = status.kind,
    busy = status.busy,
    message = status.message,
  })
end

function M.focus(bufnr)
  local current = buffers[bufnr]
  for _, client in ipairs(vim.lsp.get_clients({ name = 'copilot' })) do
    local params = vim.empty_dict()
    if
      current
      and current.client.id == client.id
      and active(bufnr, current)
    then
      params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
    end
    client:notify('textDocument/didFocus', params)
  end
end

function M.dismiss(bufnr)
  local state = buffers[bufnr]
  if not state then
    return
  end
  set_inline(bufnr, state, false)
  if active(bufnr, state) and not state.menu_open then
    set_inline(bufnr, state, true)
  end
end

function M.toggle(bufnr)
  local state = buffers[bufnr]
  if not state then
    return
  end
  vim.b[bufnr].copilot_enabled = vim.b[bufnr].copilot_enabled == false
  M.dismiss(bufnr)
  M.focus(bufnr)
  vim.notify(
    'Copilot suggestions '
      .. (vim.b[bufnr].copilot_enabled and 'enabled' or 'disabled')
  )
end

function M.attach(client, bufnr)
  local state = { client = client, inline_generation = 0 }
  buffers[bufnr] = state
  guard_inline_responses(client)
  set_inline(bufnr, state, vim.b[bufnr].copilot_enabled ~= false)
  require('dcai.keymaps.copilot').attach(bufnr)
  require('dcai.completion').attach(bufnr)
  for name, callback in pairs({
    Status = M.status,
    Toggle = M.toggle,
    Dismiss = M.dismiss,
  }) do
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilot' .. name, function()
      callback(bufnr)
    end, {})
  end
  local group =
    vim.api.nvim_create_augroup('dcai.copilot.' .. bufnr, { clear = true })
  vim.api.nvim_create_autocmd('BufLeave', {
    group = group,
    buffer = bufnr,
    callback = function()
      client:notify('textDocument/didFocus', vim.empty_dict())
    end,
  })
  vim.api.nvim_create_autocmd({ 'LspDetach', 'BufWipeout' }, {
    group = group,
    buffer = bufnr,
    callback = function(args)
      if args.event == 'LspDetach' and args.data.client_id ~= client.id then
        return
      end
      buffers[bufnr] = nil
      set_inline(bufnr, state, false)
      require('dcai.keymaps.copilot').detach(bufnr)
      require('dcai.completion').detach(bufnr)
      for _, name in ipairs({
        'Status',
        'Toggle',
        'Dismiss',
        'SignIn',
        'SignOut',
      }) do
        pcall(vim.api.nvim_buf_del_user_command, bufnr, 'LspCopilot' .. name)
      end
      vim.api.nvim_del_augroup_by_id(group)
    end,
  })
  M.focus(vim.api.nvim_get_current_buf())
end

local group = vim.api.nvim_create_augroup('dcai.copilot', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePost', 'FileType' }, {
  group = group,
  callback = function(args)
    local state = buffers[args.buf]
    if state and not M.allowed(args.buf) then
      vim.lsp.buf_detach_client(args.buf, state.client.id)
    end
    M.focus(vim.api.nvim_get_current_buf())
  end,
})

-- The completion coordinator owns menu events; this engine owns buffer state.
function M.menu_changed(bufnr, open)
  local state = buffers[bufnr]
  if state then
    state.menu_open = open
    set_inline(bufnr, state, active(bufnr, state) and not open)
  end
end

return M
