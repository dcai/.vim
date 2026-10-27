local M = {}
local nes = require('copilot-lsp.nes')
-- Use the plugin's renderer, but keep requests scoped and reject stale edits.
-- Its default global hooks bypass our buffer policy and lifecycle checks.
local nes_ui = require('copilot-lsp.nes.ui')
local namespace = vim.api.nvim_create_namespace('copilotlsp.nes')
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

local function nes_status(state, status, message, manual)
  state.nes_status = { status = status, message = message }
  vim.cmd.redrawstatus()
  if manual then
    vim.notify('Copilot NES: ' .. message)
  end
end

local function cancel(state)
  state.generation = state.generation + 1
  if state.request_id then
    state.client:cancel_request(state.request_id)
    state.request_id = nil
    if state.nes_status and state.nes_status.status == 'requesting' then
      nes_status(state, 'cancelled', 'Request cancelled by a newer action')
    end
  end
end

local function clear(bufnr, state)
  vim.b[bufnr].nes_jump = false
  nes.clear_suggestion(bufnr)
  state.tick = nil
  if state.nes_status and state.nes_status.status == 'ready' then
    nes_status(state, 'cleared', 'Next-edit preview cleared')
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

local nes_labels = {
  idle = 'idle',
  requesting = 'requesting...',
  ready = 'ready',
  empty = 'none',
  error = 'error',
  blocked = 'paused',
  cancelled = 'idle',
  stale = 'stale',
  cleared = 'idle',
  accepted = 'accepted',
}

function M.statusline(bufnr)
  local state = buffers[bufnr]
  if
    not state
    or not vim.api.nvim_buf_is_valid(bufnr)
    or not state.client.attached_buffers[bufnr]
    or not M.allowed(bufnr)
  then
    return ''
  end
  if vim.b[bufnr].copilot_enabled == false then
    return 'NES: off'
  end
  if
    state.client.copilot_status
    and state.client.copilot_status.kind == 'Error'
  then
    return 'NES: error'
  end
  local status = state.nes_status and state.nes_status.status or 'idle'
  -- The plugin can clear a preview on cursor movement without calling clear().
  if status == 'ready' and not vim.b[bufnr].nes_state then
    status = 'cleared'
  end
  return 'NES: ' .. (nes_labels[status] or 'idle')
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
    nes = state.nes_status or { status = 'idle' },
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

function M.request(bufnr, manual)
  local state = buffers[bufnr]
  if not state then
    if manual then
      vim.notify('Copilot NES: not attached to this buffer')
    end
    return
  end
  if not active(bufnr, state) then
    nes_status(
      state,
      'blocked',
      'Suggestions are disabled or this buffer is excluded',
      manual
    )
    return
  end
  if state.menu_open then
    nes_status(
      state,
      'blocked',
      'Close the completion menu before requesting NES',
      manual
    )
    return
  end
  if vim.api.nvim_get_current_buf() ~= bufnr then
    return
  end
  cancel(state)
  clear(bufnr, state)
  nes_status(state, 'requesting', 'Requesting next edit...', manual)
  local generation = state.generation
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local params = vim.lsp.util.make_position_params(0, 'utf-16')
  params.textDocument.version = vim.lsp.util.buf_versions[bufnr]
  local ok, request_id = state.client:request(
    'textDocument/copilotInlineEdit',
    params,
    function(err, result)
      if not active(bufnr, state) or generation ~= state.generation then
        return
      end
      state.request_id = nil
      if err then
        nes_status(state, 'error', err.message)
        if
          manual
          or (err.code ~= -32800 and err.code ~= -32801 and err.code ~= -32802)
        then
          vim.notify('Copilot NES: ' .. err.message, vim.log.levels.WARN)
        end
        return
      end
      if
        vim.api.nvim_get_current_buf() ~= bufnr
        or vim.api.nvim_buf_get_changedtick(bufnr) ~= tick
      then
        nes_status(
          state,
          'stale',
          'Buffer changed; request another next edit',
          manual
        )
        return
      end
      local edit = result and result.edits and result.edits[1]
      if not edit then
        nes_status(
          state,
          'empty',
          'No next edit returned. Try making another related edit, then request again.',
          manual
        )
        return
      end
      if
        edit.textDocument.uri ~= params.textDocument.uri
        or edit.textDocument.version ~= params.textDocument.version
      then
        nes_status(
          state,
          'stale',
          'Discarded an edit for a different document or version',
          manual
        )
        return
      end
      edit.newText = edit.text
      if nes_ui._display_next_suggestion(bufnr, namespace, { edit }) then
        state.tick = tick
        state.client:notify('textDocument/didShowInlineEdit', { item = edit })
        nes_status(
          state,
          'ready',
          'Next edit ready. Press Shift-Tab to jump or accept.',
          manual
        )
      else
        nes_status(state, 'empty', 'No displayable next edit returned', manual)
      end
    end,
    bufnr
  )
  state.request_id = request_id
  if not ok then
    nes_status(state, 'error', 'Could not send the next-edit request', manual)
  end
end

-- Readiness query keeps completion policy out of the renderer's buffer state.
function M.has_edit(bufnr)
  local state = buffers[bufnr]
  return state ~= nil
    and active(bufnr, state)
    and vim.b[bufnr].nes_state ~= nil
    and state.tick == vim.api.nvim_buf_get_changedtick(bufnr)
end

function M.accept_edit(bufnr)
  local state = buffers[bufnr]
  if not state or not active(bufnr, state) or not vim.b[bufnr].nes_state then
    return false
  end
  if state.tick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
    clear(bufnr, state)
    return false
  end
  if nes.walk_cursor_start_edit(bufnr) then
    return true
  end
  local edit = vim.b[bufnr].nes_state
  -- Apply synchronously so feedback is sent only after a successful edit.
  require('copilot-lsp.util').apply_inline_edit(edit)
  clear(bufnr, state)
  nes_status(state, 'accepted', 'Next edit accepted')
  if edit.command then
    state.client:exec_cmd(edit.command, { bufnr = bufnr })
  end
  return true
end

function M.dismiss(bufnr)
  local state = buffers[bufnr]
  if not state then
    return
  end
  cancel(state)
  local edit = vim.b[bufnr].nes_state
  if edit and edit.command then
    state.client:exec_cmd({
      command = 'github.copilot.didRejectNextEditSuggestionItem',
      arguments = edit.command.arguments,
    }, { bufnr = bufnr })
  end
  clear(bufnr, state)
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
  local state = { client = client, generation = 0, inline_generation = 0 }
  buffers[bufnr] = state
  guard_inline_responses(client)
  set_inline(bufnr, state, vim.b[bufnr].copilot_enabled ~= false)
  require('dcai.keymaps.copilot').attach(bufnr)
  require('dcai.completion').attach(bufnr)
  for name, callback in pairs({
    Status = M.status,
    Toggle = M.toggle,
    NextEdit = function(buffer)
      M.request(buffer, true)
    end,
    Dismiss = M.dismiss,
  }) do
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilot' .. name, function()
      callback(bufnr)
    end, {})
  end
  local group =
    vim.api.nvim_create_augroup('dcai.copilot.' .. bufnr, { clear = true })
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = group,
    buffer = bufnr,
    callback = function()
      cancel(state)
      clear(bufnr, state)
      local generation = state.generation
      vim.defer_fn(function()
        if active(bufnr, state) and generation == state.generation then
          M.request(bufnr)
        end
      end, 500)
    end,
  })
  vim.api.nvim_create_autocmd('BufLeave', {
    group = group,
    buffer = bufnr,
    callback = function()
      cancel(state)
      clear(bufnr, state)
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
      cancel(state)
      clear(bufnr, state)
      buffers[bufnr] = nil
      set_inline(bufnr, state, false)
      require('dcai.keymaps.copilot').detach(bufnr)
      require('dcai.completion').detach(bufnr)
      for _, name in ipairs({
        'Status',
        'Toggle',
        'NextEdit',
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
    if open then
      cancel(state)
      clear(bufnr, state)
    end
    set_inline(bufnr, state, active(bufnr, state) and not open)
  end
end

return M
