local ok = pcall(require, 'codecompanion')

local M = {
  setup = function() end,
}

if not ok then
  return M
end

local fidget_progress = require('fidget.progress')

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
  return fidget_progress.handle.create({
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
      -- vim.g.logger.info(vim.inspect(request))
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

  local provider, model = vim.g.get_ai_model()

  local instance = require('codecompanion')
  instance.setup({
    display = {
      action_palette = {
        provider = 'default',
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
        },
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
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          schema = {
            model = {
              default = 'gpt-4o-mini',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        -- adapter = 'anthropic',
        -- adapter = 'gemini',
        adapter = provider,
        show_settings = true, -- Show LLM settings at the top of the chat buffer?

        roles = {
          ---The header name for the LLM's messages
          ---@type string|fun(adapter: CodeCompanion.Adapter): string
          llm = function(adapter)
            ---@diagnostic disable-next-line
            return adapter.formatted_name
            -- return 'CodeCompanion (' .. adapter.formatted_name .. ')'
          end,

          ---The header name for your messages
          ---@type string
          user = 'Me',
          intro_message = 'Welcome to CodeCompanion ✨! Press ? for options',
          show_header_separator = true,
          separator = '─',
          auto_scroll = false,
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = true, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        },
        slash_commands = {
          ['help'] = {
            opts = {
              provider = 'fzf_lua', -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
            },
          },
          ['buffer'] = {
            opts = {
              provider = 'fzf_lua',
            },
          },
          ['symbols'] = {
            opts = {
              provider = 'fzf_lua',
            },
          },
          ['file'] = {
            opts = {
              provider = 'fzf_lua',
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
              -- i = '<C-c>',
              i = nil,
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
        adapter = provider,
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
      system_prompt = function(_opts)
        return require('dcai.llm.prompt_library').BASE_PROMPT_CODING
      end,
    },
  })
  M:init_fidget()
  return instance
end

return M
