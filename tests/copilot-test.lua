local MiniTest = require('mini.test')
local T, child = dofile('tests/helpers.lua').new_set()

-- No upvalues: Mini serializes this function into the isolated child.
local function scenario(scope)
  package.loaded['which-key'] = { add = function() end }

  local enabled = {}
  vim.lsp.inline_completion.enable = function(value, filter)
    enabled[filter.bufnr] = value
  end
  local notifications = {}
  local client = { id = 42, attached_buffers = {} }
  function client:stop() end
  function client:notify(method, params)
    notifications[#notifications + 1] = { method = method, params = params }
  end
  function client:request() end
  vim.lsp.get_clients = function()
    return { client }
  end
  vim.lsp.get_client_by_id = function(id)
    return id == client.id and client or nil
  end
  local messages = {}
  vim.notify = function(message)
    messages[#messages + 1] = message
  end

  local features = require('dcai.lsp.copilot-features')
  local count = 0
  local function check(value, message)
    assert(value, message)
    count = count + 1
  end

  local function buffer(name)
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, '/tmp/copilot-tests/' .. name)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_lines(
      buf,
      0,
      -1,
      false,
      { 'local total = 1', 'print(total)' }
    )
    vim.lsp.util.buf_versions[buf] = 1
    return buf
  end

  if scope == 'exclusions' then
    for _, name in ipairs({
      'example.lua',
      'notes.md',
      'standalone.py',
      'id_helpers.lua',
    }) do
      check(features.allowed(buffer(name)), 'normal file blocked: ' .. name)
    end
    for _, name in ipairs({
      '.env',
      '.env.production',
      '.envrc',
      'id_ecdsa_sk',
      'id_ed25519_sk',
      'id_rsa',
      'id_ed25519',
      'cert.pem',
      'private.key',
      'cert.p12',
      'cert.pfx',
      'app.keystore',
      '.netrc',
      '.npmrc',
      '.pypirc',
      'credentials',
      'credentials.json',
      'secrets.yaml',
      'secrets.yml',
      'secrets.json',
      '.ssh/config',
      '.gnupg/key',
    }) do
      check(not features.allowed(buffer(name)), 'secret file allowed: ' .. name)
    end
    local special = buffer('special')
    for _, buftype in ipairs({ 'help', 'nofile', 'prompt' }) do
      vim.bo[special].buftype = buftype
      check(
        not features.allowed(special),
        'special buffer allowed: ' .. buftype
      )
    end
    vim.bo[special].buftype = ''
    for _, filetype in ipairs({
      'help',
      'codecompanion',
      'copilot-chat',
      'gitcommit',
    }) do
      vim.bo[special].filetype = filetype
      check(
        not features.allowed(special),
        'special filetype allowed: ' .. filetype
      )
    end
    return count
  end

  local buf = buffer('attached.lua')
  local jump = function() end
  vim.keymap.set('n', '<Tab>', jump, { desc = 'MiniJump2d test mapping' })
  local snippet_backward = function() end
  vim.keymap.set({ 'i', 's' }, '<S-Tab>', snippet_backward)
  client.attached_buffers[buf] = true
  features.attach(client, buf)
  check(enabled[buf], 'native completion not enabled')
  for _, mode in ipairs({ 'i', 's' }) do
    check(
      vim.fn.maparg('<S-Tab>', mode, false, true).callback == snippet_backward,
      'Copilot shadows snippet Shift-Tab in ' .. mode .. ' mode'
    )
  end
  check(
    vim.fn.maparg('<Tab>', 'n', false, true).callback == jump,
    'Copilot shadows MiniJump2d Tab'
  )
  check(
    vim.fn.maparg('<C-f>', 'i', false, true).buffer == 1,
    'inline accept mapping missing'
  )
  check(
    vim.api.nvim_buf_get_commands(buf, {}).LspCopilotStatus ~= nil,
    'status command missing'
  )
  check(
    notifications[#notifications].params.textDocument.uri
      == vim.uri_from_bufnr(buf),
    'initial focus missing'
  )

  features.dismiss(buf)
  check(enabled[buf], 'dismiss disabled future completions')

  features.toggle(buf)
  check(not enabled[buf], 'toggle did not disable native completion')
  check(
    vim.tbl_isempty(notifications[#notifications].params),
    'disabled buffer still focused'
  )
  features.toggle(buf)
  check(enabled[buf], 'toggle did not reenable native completion')

  vim.api.nvim_exec_autocmds('User', { pattern = 'BlinkCmpMenuOpen' })
  check(not enabled[buf], 'inline completion overlaps Blink menu')
  features.dismiss(buf)
  check(not enabled[buf], 'dismiss reenabled inline completion over Blink menu')
  vim.api.nvim_exec_autocmds('User', { pattern = 'BlinkCmpMenuClose' })
  check(enabled[buf], 'inline completion not restored after Blink menu closed')

  buffer('.env.focus-test')
  check(
    vim.tbl_isempty(notifications[#notifications].params),
    'excluded document URI sent as focus'
  )
  vim.api.nvim_set_current_buf(buf)
  check(
    notifications[#notifications].params.textDocument.uri
      == vim.uri_from_bufnr(buf),
    'focus not restored'
  )

  local warning =
    { kind = 'Warning', message = 'Temporary failure', busy = false }
  local previous_messages = #messages
  features.status_handler(nil, warning, { client_id = client.id })
  features.status_handler(nil, warning, { client_id = client.id })
  check(#messages == previous_messages + 1, 'duplicate status warnings')
  check(client.copilot_status == warning, 'status not saved')

  vim.api.nvim_exec_autocmds(
    'LspDetach',
    { buffer = buf, data = { client_id = 99 } }
  )
  check(
    vim.api.nvim_buf_get_commands(buf, {}).LspCopilotStatus ~= nil,
    'other client detach removed Copilot'
  )
  vim.api.nvim_exec_autocmds(
    'LspDetach',
    { buffer = buf, data = { client_id = client.id } }
  )
  client.attached_buffers[buf] = nil
  check(not enabled[buf], 'native completion not disabled after detach')
  check(
    vim.api.nvim_buf_get_commands(buf, {}).LspCopilotStatus == nil,
    'commands not removed after detach'
  )
  check(vim.fn.maparg('<C-f>', 'i') == '', 'mapping not removed after detach')
  check(
    vim.fn.maparg('<Tab>', 'n', false, true).callback == jump,
    'detach removed MiniJump2d Tab'
  )
  for _, mode in ipairs({ 'i', 's' }) do
    check(
      vim.fn.maparg('<S-Tab>', mode, false, true).callback == snippet_backward,
      'detach removed snippet Shift-Tab in ' .. mode .. ' mode'
    )
  end
  return count
end

T['allows normal files and excludes secrets and special buffers'] = function()
  MiniTest.add_note(
    child.lua_func(scenario, 'exclusions') .. ' exclusion checks'
  )
end

T['handles inline completion, menus and detach'] = function()
  MiniTest.add_note(
    child.lua_func(scenario, 'lifecycle') .. ' lifecycle checks'
  )
end

return T
