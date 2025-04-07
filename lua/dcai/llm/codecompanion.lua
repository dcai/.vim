local ok = pcall(require, 'codecompanion')

local M = {
  setup = function() end,
}

if not ok then
  return M
end

local progress = require('fidget.progress')

local sys_prompt = [[
You are an AI programming assistant named "CodeCompanion". You are currently plugged into the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
- Minimize additional prose unless clarification is needed.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of each Markdown code block.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.
- Avoid using H1 and H2 headers in your responses.
- Use actual line breaks in your responses; only use "\n" when you want a literal backslash followed by 'n'.
- All non-code text responses must be written in the %s language indicated.

When given a task:
1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.
2. Output the final code in a single code block, ensuring that only relevant code is included.
3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.
4. Provide exactly one complete reply per conversation turn.]]

M.handles = {}

function M:store_progress_handle(id, handle)
  M.handles[id] = handle
end

function M:pop_progress_handle(id)
  local handle = M.handles[id]
  M.handles[id] = nil
  return handle
end

function M:create_progress_handle(request)
  local strategy = request.data.strategy or ''
  return progress.handle.create({
    title = ' Requesting assistance (' .. strategy .. ')',
    message = 'In progress...',
    lsp_client = {
      name = M:llm_role_title(request.data.adapter),
    },
  })
end

function M:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name or '')
  if adapter.model and adapter.model ~= '' then
    table.insert(parts, '(' .. adapter.model .. ')')
  end
  return table.concat(parts, ' ')
end

function M:report_exit_status(handle, request)
  if request.data.status == 'success' then
    handle.message = 'Completed'
  elseif request.data.status == 'error' then
    handle.message = ' Error'
  else
    handle.message = '󰜺 Cancelled'
  end
end

function M:init_fidget()
  local group = vim.api.nvim_create_augroup('CodeCompanionFidgetHooks', {})

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestStarted',
    group = group,
    callback = function(request)
      local handle = M:create_progress_handle(request)
      M:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestFinished',
    group = group,
    callback = function(request)
      local handle = M:pop_progress_handle(request.data.id)
      if handle then
        M:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })
end

M.setup = function()
  vim.env['CODECOMPANION_TOKEN_PATH'] = vim.fn.expand(vim.env.XDG_CONFIG_HOME)

  local instance = require('codecompanion')
  instance.setup({
    display = {
      action_palette = {
        provider = 'default',
      },
    },
    adapters = {
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          name = 'deepseek',
          schema = {
            model = {
              default = 'deepseek-chat',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        -- adapter = 'anthropic',
        -- adapter = 'gemini',
        adapter = 'deepseek',
        slash_commands = {
          ['help'] = {
            opts = {
              provider = 'fzf_lua', -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
            },
          },
        },
        tools = {
          ['cmd_runner'] = {
            opts = {
              requires_approval = false,
            },
          },
        },
        keymaps = {
          send = {
            modes = {
              -- n = '<C-s>',
              n = { '<cr>' },
              i = '<C-s>',
            },
          },
          close = {
            modes = {
              -- n = '<C-c>',
              n = { 'q', '<C-c>' },
              i = '<C-c>',
            },
          },
          clear = {
            modes = {
              n = { 'gx', '<C-l>' },
            },
          },
          stop = {
            modes = {
              n = 'c-s',
            },
          },
        },
      },
      inline = {
        -- adapter = 'anthropic',
        -- adapter = 'gemini',
        keymaps = {
          accept_change = {
            modes = { n = 'ga' },
            description = 'Accept the suggested change',
          },
          reject_change = {
            modes = { n = 'gr' },
            description = 'Reject the suggested change',
          },
        },
      },
    },
    opts = {
      log_level = 'ERROR', -- TRACE|DEBUG|ERROR|INFO
      language = 'English',
      system_prompt = function(opts)
        local language = opts.language or 'English'
        return string.format(sys_prompt, language)
      end,
    },
  })
  M:init_fidget()
  return instance
end

return M
