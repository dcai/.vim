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
    equal(#vim.api.nvim_get_autocmds({
      group = 'dcai_lsp_progress',
      event = 'LspProgress',
    }), 1)

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

T['shrinks visible message floats and ignores unrelated progress'] = function()
  child.lua_func(function()
    local equal = require('mini.test').expect.equality
    dofile('after/plugin/lsp-progress-native.lua')
    dofile('after/plugin/lsp-progress-native.lua')
    equal(#vim.api.nvim_get_autocmds({
      group = 'dcai_lsp_progress',
      event = 'Progress',
    }), 1)

    local function float(filetype, hide)
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = filetype
      local win = vim.api.nvim_open_win(buf, false, {
        relative = 'editor',
        row = 1,
        col = 0,
        width = 60,
        height = 2,
        hide = hide,
      })
      return buf, win
    end
    local buf, win = float('msg', false)
    local _, unrelated = float('other', false)
    local _, hidden = float('msg', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      'lsp: 100% Done',
      '界界界界界界界界',
    })
    local function progress(id)
      vim.api.nvim_exec_autocmds('Progress', { data = { id = id } })
      -- Drain scheduled work without relying on a fixed sleep.
      local done = false
      vim.schedule(function()
        done = true
      end)
      assert(vim.wait(1000, function()
        return done
      end))
    end

    progress('another-feature')
    equal(vim.api.nvim_win_get_width(win), 60)
    progress('dcai.lsp.progress:1')
    equal(vim.api.nvim_win_get_width(win), 16)
    equal(vim.api.nvim_win_get_width(unrelated), 60)
    equal(vim.api.nvim_win_get_width(hidden), 60)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Done' })
    progress('dcai.lsp.progress:1')
    equal(vim.api.nvim_win_get_width(win), 4)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      string.rep('x', vim.o.columns + 10),
    })
    progress('dcai.lsp.progress:1')
    equal(vim.api.nvim_win_get_width(win), vim.o.columns)

    -- Closing a float before the scheduled resize must be safe.
    vim.api.nvim_exec_autocmds('Progress', {
      data = { id = 'dcai.lsp.progress:1' },
    })
    vim.api.nvim_win_close(win, true)
    progress('dcai.lsp.progress:1')
  end)
end

return T
