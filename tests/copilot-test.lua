local MiniTest = require('mini.test')
local T, child = dofile('tests/helpers.lua').new_set()

-- No upvalues: Mini serializes this function into the isolated child.
local function scenario(scope)
  vim.cmd.packadd({ 'copilot-lsp', bang = true })
  package.loaded['which-key'] = { add = function() end }

  local enabled = {}
  vim.lsp.inline_completion.enable = function(value, filter)
    enabled[filter.bufnr] = value
  end
  local notifications, requests, commands, cancelled = {}, {}, {}, {}
  local client = { id = 42, attached_buffers = {} }
  function client:stop() end
  function client:notify(method, params)
    notifications[#notifications + 1] = { method = method, params = params }
  end
  function client:request(method, params, callback, bufnr)
    requests[#requests + 1] =
      { method = method, params = params, callback = callback, bufnr = bufnr }
    return true, #requests
  end
  function client:cancel_request(id)
    cancelled[#cancelled + 1] = id
  end
  function client:exec_cmd(command)
    commands[#commands + 1] = command
  end
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

  require('dcai.statusline')
  local redraws = 0
  local redrawstatus = vim.cmd.redrawstatus
  vim.cmd.redrawstatus = function(...)
    redraws = redraws + 1
    return redrawstatus(...)
  end
  local function statusline()
    local before = #requests
    local result =
      vim.api.nvim_eval_statusline('%{v:lua.StatuslineCopilotNes()}', {}).str
    check(#requests == before, 'statusline evaluation sent an LSP request')
    return vim.trim(result)
  end
  local loaded_copilot = package.loaded['dcai.lsp.copilot-features']
  package.loaded['dcai.lsp.copilot-features'] = nil
  check(statusline() == '', 'statusline visible without Copilot loaded')
  check(
    package.loaded['dcai.lsp.copilot-features'] == nil,
    'statusline loaded Copilot'
  )
  package.loaded['dcai.lsp.copilot-features'] = loaded_copilot
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
  check(statusline() == 'NES: idle', 'attached buffer has no idle statusline')
  for _, mode in ipairs({ 'i', 's' }) do
    check(
      vim.fn.maparg('<S-Tab>', mode, false, true).callback == snippet_backward,
      'NES shadows snippet Shift-Tab in ' .. mode .. ' mode'
    )
  end
  check(
    vim.fn.maparg('<Tab>', 'n', false, true).callback == jump,
    'Copilot shadows MiniJump2d Tab'
  )
  check(
    vim.fn.maparg('<S-Tab>', 'n', false, true).buffer == 1,
    'NES accept mapping missing'
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

  local function response(request)
    return {
      edits = {
        {
          text = 'local total = 2',
          textDocument = vim.deepcopy(request.params.textDocument),
          range = {
            start = { line = 0, character = 0 },
            ['end'] = { line = 0, character = 15 },
          },
          command = {
            command = 'github.copilot.didAcceptNextEditSuggestionItem',
            arguments = { 'test-edit' },
          },
        },
      },
    }
  end
  local function suggest()
    features.request(buf)
    local request = requests[#requests]
    request.callback(nil, response(request))
    return request
  end

  local request = suggest()
  check(request.method == 'textDocument/copilotInlineEdit', 'wrong NES method')
  check(request.params.textDocument.version == 1, 'document version missing')
  check(vim.b[buf].nes_state ~= nil, 'NES preview missing')
  check(statusline() == 'NES: ready', 'preview missing from statusline')
  check(
    notifications[#notifications].method == 'textDocument/didShowInlineEdit',
    'display feedback missing'
  )
  check(
    vim.fn.maparg('<Tab>', 'n', false, true).callback == jump,
    'NES preview shadows MiniJump2d Tab'
  )
  vim.fn.maparg('<S-Tab>', 'n', false, true).callback()
  check(vim.b[buf].nes_state == nil, 'NES accept mapping did not accept edit')
  check(
    vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == 'local total = 2',
    'edit not applied'
  )
  check(
    commands[#commands].command
      == 'github.copilot.didAcceptNextEditSuggestionItem',
    'acceptance feedback missing'
  )
  check(vim.b[buf].nes_state == nil, 'accepted preview not cleared')
  check(statusline() == 'NES: accepted', 'acceptance missing from statusline')

  suggest()
  features.dismiss(buf)
  check(vim.b[buf].nes_state == nil, 'dismissed preview not cleared')
  check(
    commands[#commands].command
      == 'github.copilot.didRejectNextEditSuggestionItem',
    'rejection feedback missing'
  )
  check(enabled[buf], 'dismiss disabled future completions')

  features.request(buf)
  local stale = requests[#requests]
  vim.api.nvim_buf_set_lines(buf, 1, 2, false, { 'print(total + 1)' })
  stale.callback(nil, response(stale))
  check(vim.b[buf].nes_state == nil, 'stale response displayed')
  check(statusline() == 'NES: stale', 'stale result missing from statusline')

  suggest()
  vim.api.nvim_buf_set_lines(buf, 1, 2, false, { 'print(total + 2)' })
  check(not features.accept_edit(buf), 'stale edit accepted')
  check(vim.b[buf].nes_state == nil, 'stale edit not cleared')

  features.request(buf)
  local old = requests[#requests]
  features.request(buf)
  old.callback(nil, response(old))
  check(vim.b[buf].nes_state == nil, 'superseded request displayed')
  check(#cancelled > 0, 'pending request not cancelled')
  local wrong_document = requests[#requests]
  local wrong_response = response(wrong_document)
  wrong_response.edits[1].textDocument.uri = 'file:///tmp/other.lua'
  wrong_document.callback(nil, wrong_response)
  check(vim.b[buf].nes_state == nil, 'cross-document edit displayed')

  features.toggle(buf)
  check(not enabled[buf], 'toggle did not disable native completion')
  check(statusline() == 'NES: off', 'disabled state missing from statusline')
  local before = #requests
  features.request(buf)
  check(#requests == before, 'NES requested while disabled')
  check(
    vim.tbl_isempty(notifications[#notifications].params),
    'disabled buffer still focused'
  )
  features.toggle(buf)
  check(enabled[buf], 'toggle did not reenable native completion')

  vim.api.nvim_exec_autocmds('User', { pattern = 'BlinkCmpMenuOpen' })
  check(not enabled[buf], 'inline completion overlaps Blink menu')
  local menu_requests = #requests
  features.request(buf)
  check(#requests == menu_requests, 'NES requested over Blink menu')
  features.dismiss(buf)
  check(not enabled[buf], 'dismiss reenabled inline completion over Blink menu')
  vim.api.nvim_exec_autocmds('User', { pattern = 'BlinkCmpMenuClose' })
  check(enabled[buf], 'inline completion not restored after Blink menu closed')

  for _ = 1, 3 do
    vim.api.nvim_exec_autocmds('TextChangedI', { buffer = buf })
  end
  local debounced_requests = #requests
  vim.wait(650, function()
    return #requests > debounced_requests
  end)
  check(#requests == debounced_requests + 1, 'NES changes were not debounced')

  local pending_before_switch = requests[#requests]
  buffer('.env.focus-test')
  check(
    vim.tbl_isempty(notifications[#notifications].params),
    'excluded document URI sent as focus'
  )
  check(statusline() == '', 'NES statusline visible in excluded buffer')
  pending_before_switch.callback(nil, response(pending_before_switch))
  check(
    vim.b[buf].nes_state == nil,
    'response displayed after switching buffers'
  )
  vim.api.nvim_set_current_buf(buf)
  check(
    notifications[#notifications].params.textDocument.uri
      == vim.uri_from_bufnr(buf),
    'focus not restored'
  )

  suggest()
  vim.b[buf].nes_jump = true
  features.dismiss(buf)
  check(vim.b[buf].nes_state == nil, 'jump flag prevented explicit dismissal')

  local function nes_status()
    local saved_print = vim.print
    local result
    vim.print = function(status)
      result = status.nes
    end
    features.status(buf)
    vim.print = saved_print
    return result.status
  end

  local redraws_before_request = redraws
  vim.cmd('LspCopilotNextEdit')
  check(
    statusline() == 'NES: requesting...',
    'requesting state missing from statusline'
  )
  check(
    redraws > redraws_before_request,
    'request start did not redraw the statusline'
  )
  local requesting_redraws = redraws
  check(
    messages[#messages]:find('Requesting next edit', 1, true),
    'manual request has no progress message'
  )
  requests[#requests].callback(nil, { edits = {} })
  check(
    messages[#messages]:find('No next edit returned', 1, true),
    'empty manual result is silent'
  )
  check(nes_status() == 'empty', 'empty result missing from status')
  check(
    redraws > requesting_redraws,
    'request completion did not redraw the statusline'
  )
  check(statusline() == 'NES: none', 'empty result missing from statusline')

  local auto_messages = #messages
  features.request(buf)
  requests[#requests].callback(nil, { edits = {} })
  check(#messages == auto_messages, 'automatic requests spam notifications')

  vim.cmd('LspCopilotNextEdit')
  local manual_request = requests[#requests]
  manual_request.callback(nil, response(manual_request))
  check(
    messages[#messages]:find('Next edit ready', 1, true),
    'manual preview has no ready message'
  )
  check(nes_status() == 'ready', 'ready result missing from status')
  check(statusline() == 'NES: ready', 'manual preview missing from statusline')
  require('copilot-lsp.nes').clear_suggestion(buf)
  check(
    statusline() == 'NES: idle',
    'statusline reports a preview cleared by the plugin'
  )
  features.dismiss(buf)

  vim.cmd('LspCopilotNextEdit')
  requests[#requests].callback({
    code = -32603,
    message = 'Test server failure',
  })
  check(
    messages[#messages]:find('Test server failure', 1, true),
    'manual server error is silent'
  )
  check(nes_status() == 'error', 'error missing from status')
  check(statusline() == 'NES: error', 'error missing from statusline')

  vim.api.nvim_exec_autocmds('User', { pattern = 'BlinkCmpMenuOpen' })
  local blocked_requests = #requests
  vim.cmd('LspCopilotNextEdit')
  check(#requests == blocked_requests, 'manual request ignored completion menu')
  check(
    messages[#messages]:find('Close the completion menu', 1, true),
    'blocked manual request is silent'
  )
  check(nes_status() == 'blocked', 'blocked request missing from status')
  check(statusline() == 'NES: paused', 'blocked state missing from statusline')
  vim.api.nvim_exec_autocmds('User', { pattern = 'BlinkCmpMenuClose' })

  local saved_request = client.request
  client.request = function()
    return false
  end
  features.request(buf, true)
  check(
    messages[#messages]:find('Could not send', 1, true),
    'send failure is silent'
  )
  check(nes_status() == 'error', 'send failure missing from status')
  client.request = saved_request

  local warning =
    { kind = 'Warning', message = 'Temporary failure', busy = false }
  local previous_messages = #messages
  features.status_handler(nil, warning, { client_id = client.id })
  features.status_handler(nil, warning, { client_id = client.id })
  check(#messages == previous_messages + 1, 'duplicate status warnings')
  check(client.copilot_status == warning, 'status not saved')

  features.request(buf)
  local detached = requests[#requests]
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
  detached.callback(nil, response(detached))
  check(vim.b[buf].nes_state == nil, 'response displayed after detach')
  check(statusline() == '', 'NES statusline visible after detach')
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
  check(
    vim.fn.maparg('<S-Tab>', 'n') == '',
    'NES accept mapping not removed after detach'
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

T['handles NES feedback, stale replies, mappings, status and detach'] = function()
  MiniTest.add_note(
    child.lua_func(scenario, 'lifecycle') .. ' lifecycle checks'
  )
end

return T
