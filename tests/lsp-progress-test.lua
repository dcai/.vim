local T, child = dofile('tests/helpers.lua').new_set()

T['uses one native message per client across tasks and reloads'] = function()
  child.lua_func(function()
    local equal = require('mini.test').expect.equality
    local messages, percentages = {}, {}
    vim.g.set_terminal_progress = function(percent)
      percentages[#percentages + 1] = percent
    end
    vim.api.nvim_create_autocmd('Progress', {
      callback = function(event)
        messages[#messages + 1] = event.data
      end,
    })
    local original_handler = vim.lsp.handlers['$/progress']
    dofile('after/plugin/lsp-progress-native.lua')
    dofile('after/plugin/lsp-progress-native.lua')
    equal(vim.lsp.handlers['$/progress'], original_handler)
    equal(#vim.api.nvim_get_autocmds({ group = 'dcai_lsp_progress' }), 1)

    local function emit(client_id, token, value)
      vim.api.nvim_exec_autocmds('LspProgress', {
        data = {
          client_id = client_id,
          params = { token = token, value = value },
        },
      })
    end
    emit(1, 'workspace', {
      kind = 'begin',
      title = 'Loading workspace',
      percentage = 10,
    })
    emit(1, 'diagnostics', {
      kind = 'begin',
      title = 'Diagnostics',
      percentage = 20,
    })
    emit(1, 'workspace', { kind = 'end' })
    equal(#messages, 3)
    equal(messages[3].status, 'running')
    equal(messages[3].percent, 20)
    equal(messages[3].title, 'lsp - Diagnostics')
    emit(1, 'diagnostics', { kind = 'report', message = 'Checking files' })
    equal(messages[4].text[1], 'Checking files')
    equal(messages[4].percent, 20)
    emit(1, 'diagnostics', { kind = 'end' })
    equal(messages[5].status, 'success')
    equal(messages[5].text[1], 'Done')
    equal(messages[5].percent, 100)
    for _, message in ipairs(messages) do
      equal(message.id, 'dcai.lsp.progress:1')
    end
    equal(percentages, { 10, 20, 20, 20, 100 })

    -- A later task replaces the completed message instead of adding a new line.
    emit(1, 1, { kind = 'begin', title = 'Reloading' })
    equal(messages[6].id, messages[5].id)
    equal(messages[6].status, 'running')
    emit(2, 1, { kind = 'begin', title = 'Other client' })
    equal(messages[7].id, 'dcai.lsp.progress:2')

    -- Unknown completions and non-work-done payloads must not add messages.
    emit(1, 'unknown', { kind = 'end' })
    emit(1, 'custom', 'custom payload')
    emit(1, 'custom', { unrelated = true })
    equal(#messages, 7)
  end)
end

return T
