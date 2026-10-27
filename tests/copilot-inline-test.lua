local MiniTest = require('mini.test')
local T, child = dofile('tests/helpers.lua').new_set()

T['rejects late native responses across menu, toggle, detach and wipe'] = function()
  local checks = child.lua_func(function()
    -- Exercise Nvim's actual inline-completion handler, not a mocked enable().
    vim.cmd.packadd({ 'copilot-lsp', bang = true })
    package.loaded['which-key'] = { add = function() end }

    local pending = {}
    local client = {
      id = 88,
      name = 'copilot',
      attached_buffers = {},
      _enabled_capabilities = {},
      offset_encoding = 'utf-16',
      requests = {},
      rpc = {
        is_closing = function()
          return true
        end,
      },
    }
    function client:stop() end
    function client:supports_method(method)
      return method == 'textDocument/inlineCompletion'
    end
    function client:notify() end
    function client:cancel_request() end
    function client:request(method, params, callback, bufnr)
      pending[#pending + 1] =
        { method = method, callback = callback, bufnr = bufnr }
      return true, #pending
    end
    local unguarded_request = client.request
    vim.lsp.get_clients = function()
      return { client }
    end
    vim.lsp.get_client_by_id = function(id)
      return id == client.id and client or nil
    end
    vim.notify = function() end
    -- Enter the native handler's insert-mode branch without interactive input.
    local get_mode = vim.api.nvim_get_mode
    vim.api.nvim_get_mode = function()
      return { mode = 'i', blocking = false }
    end

    local features = require('dcai.lsp.copilot-features')
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, '/tmp/copilot-inline-race.js')
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = 'javascript'
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'const answer = ' })
    client.attached_buffers[buf] = true
    features.attach(client, buf)
    local count = 0
    local function check(value, message)
      assert(value, message)
      count = count + 1
    end
    local function request()
      local previous = #pending
      vim.api.nvim_exec_autocmds('CursorMovedI', { buffer = buf })
      assert(
        vim.wait(1000, function()
          return #pending > previous
        end),
        'native request not sent'
      )
      local result = pending[#pending]
      check(
        result.method == 'textDocument/inlineCompletion',
        'wrong native request'
      )
      return result
    end
    local function respond(item)
      local done, ok, err = false, nil, nil
      vim.schedule(function()
        ok, err = pcall(item.callback, nil, {
          items = {
            {
              insertText = '42',
              range = {
                start = { line = 0, character = 15 },
                ['end'] = { line = 0, character = 15 },
              },
            },
          },
        }, { client_id = client.id, bufnr = item.bufnr })
        done = true
      end)
      assert(
        vim.wait(1000, function()
          return done
        end),
        'response not dispatched'
      )
      check(ok, 'late native response crashed: ' .. tostring(err))
    end
    local function marks()
      local ns = vim.api.nvim_get_namespaces()['nvim.lsp.inline_completion']
      return ns and #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {}) or 0
    end
    local function menu(open)
      vim.api.nvim_exec_autocmds('User', {
        pattern = open and 'BlinkCmpMenuOpen' or 'BlinkCmpMenuClose',
      })
    end

    -- Optional negative control: bypass the guard to reproduce the reported crash.
    if vim.env.COPILOT_TEST_UNGUARDED == '1' then
      client.request = unguarded_request
    end

    respond(request())
    check(marks() > 0, 'valid native completion was not rendered')

    local before_menu = request()
    menu(true)
    check(
      not vim.lsp.inline_completion.is_enabled({ bufnr = buf }),
      'menu did not disable inline completion'
    )
    respond(before_menu)
    check(marks() == 0, 'disabled completion rendered')
    menu(false)
    respond(before_menu)
    check(marks() == 0, 'old response rendered after reenable')
    respond(request())
    check(marks() > 0, 'fresh response not rendered after menu closed')

    local before_dismiss = request()
    features.dismiss(buf)
    respond(before_dismiss)
    check(marks() == 0, 'dismissed response reappeared')

    local before_toggle = request()
    features.toggle(buf)
    respond(before_toggle)
    check(marks() == 0, 'response rendered while toggled off')
    features.toggle(buf)
    respond(before_toggle)
    check(marks() == 0, 'old response rendered after toggled on')
    respond(request())
    check(marks() > 0, 'fresh response not rendered after toggle')

    local before_detach = request()
    vim.api.nvim_exec_autocmds(
      'LspDetach',
      { buffer = buf, data = { client_id = client.id } }
    )
    respond(before_detach)
    check(marks() == 0, 'detached completion rendered')
    features.attach(client, buf)
    respond(before_detach)
    check(marks() == 0, 'old response rendered after reattach')
    respond(request())
    check(marks() > 0, 'fresh response not rendered after reattach')

    local before_wipe = request()
    vim.api.nvim_buf_delete(buf, { force = true })
    respond(before_wipe)
    check(not vim.api.nvim_buf_is_valid(buf), 'test buffer was not wiped')

    vim.api.nvim_get_mode = get_mode
    return count
  end)
  MiniTest.add_note(checks .. ' native inline checks')
end

return T
