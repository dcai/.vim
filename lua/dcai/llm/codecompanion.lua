local ok = pcall(require, 'codecompanion')
local prompt_library = require('dcai.llm.prompt_library')
local use_llm = 'local_copilot'
-- local use_llm = 'grok'

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

  local instance = require('codecompanion')
  instance.setup({
    strategies = {
      inline = {
        adapter = use_llm,
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
      chat = {
        adapter = use_llm,
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
              -- n = { 'q', '<C-c>' },
              n = { 'Q' },
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
    },
    adapters = {
      local_copilot = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          env = {
            url = 'http://localhost:7890',
            api_key = 'neovim-codecompanion',
            chat_url = '/v1/chat/completions',
            models_endpoint = '/v1/models',
          },
          schema = {
            model = {
              default = 'gpt-4.1',
              -- default = 'claude-3.7-sonnet',
            },
            temperature = {
              order = 2,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 1,
              desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
              validate = function(n)
                return n >= 0 and n <= 2, 'Must be between 0 and 2'
              end,
            },
          },
        })
      end,
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
      grok = function()
        return require('codecompanion.adapters').extend('xai', {
          schema = {
            model = {
              default = 'grok-4',
            },
          },
        })
      end,
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          schema = {
            model = {
              default = 'gpt-4.1-mini',
            },
          },
        })
      end,
    },
    prompt_library = {
      ['Neovim Expert'] = {
        strategy = 'chat',
        description = 'neovim help',
        opts = {
          index = 11,
          is_slash_cmd = false,
          auto_submit = false,
          short_name = 'neovim',
        },
        -- references = {
        --   {
        --     type = 'file',
        --     path = {
        --       'doc/.vitepress/config.mjs',
        --       'lua/codecompanion/config.lua',
        --       'README.md',
        --     },
        --   },
        -- },
        prompts = {
          {
            role = 'system',
            content = 'Act as neovim power user, use lua api when possible.',
          },
          {
            role = 'user',
            content = '',
          },
        },
      },
      ['Unit Tests'] = {
        strategy = 'chat',
        description = 'Generate unit tests for the selected code',
        opts = {
          index = 7,
          is_default = true,
          is_slash_cmd = false,
          modes = { 'v' },
          short_name = 'tests',
          -- auto_submit = true,
          auto_submit = false,
          user_prompt = false,
          placement = 'new',
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = 'system',
            -- content = [[When generating unit tests, follow these steps:
            --
            -- 1. Identify the programming language.
            -- 2. Identify the purpose of the function or module to be tested.
            -- 3. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
            -- 4. Generate unit tests using an appropriate testing framework for the identified programming language.
            -- 5. Ensure the tests cover:
            --       - Normal cases
            --       - Edge cases
            --       - Error handling (if applicable)
            -- 6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.]],

            content = prompt_library.JAVASCRIPT_UNIT_TESTS,
            opts = {
              visible = false,
            },
          },
          {
            role = 'user',
            content = function(context)
              vim.g.logger.info(vim.inspect(context))
              local code = require('codecompanion.helpers.actions').get_code(
                context.start_line,
                context.end_line
              )

              return string.format(
                [[<user_prompt>
Please generate unit tests for this code from buffer %d:

```%s
%s
```
</user_prompt>
]],
                context.bufnr,
                context.filetype,
                code
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ['Custom Prompt'] = {
        strategy = 'inline',
        description = 'Prompt the LLM from Neovim',
        opts = {
          index = 3,
          is_default = true,
          is_slash_cmd = false,
          user_prompt = true,
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return string.format(
                [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                context.filetype
              )
            end,
            opts = {
              visible = false,
              tag = 'system_tag',
            },
          },
        },
      },
    },
    display = {
      action_palette = {
        provider = 'default',
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
        },
      },
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = 'vertical', -- vertical|horizontal split for default provider
        opts = {
          'internal',
          'filler',
          'closeoff',
          'algorithm:patience',
          'followwrap',
          'linematch:120',
        },
        provider = 'default', -- default|mini_diff
      },
      inline = {
        layout = 'vertical', -- vertical|horizontal|buffer
      },
      chat = {
        intro_message = 'Welcome to CodeCompanion ✨! Press ? for options',
        auto_scroll = false,
        show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
        separator = '─', -- The separator between the different messages in the chat buffer
        show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
        show_settings = true, -- Show LLM settings at the top of the chat buffer?
        show_token_count = true, -- Show the token count for each response?
        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        -- Change the default icons
        icons = {
          pinned_buffer = ' ',
          watched_buffer = '👀 ',
        },

        -- Alter the sizing of the debug window
        debug_window = {
          ---@return number|fun(): number
          width = vim.o.columns - 5,
          ---@return number|fun(): number
          height = vim.o.lines - 2,
        },

        -- Options to customize the UI of the chat buffer
        window = {
          layout = 'vertical', -- float|vertical|horizontal|buffer
          position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
          border = 'single',
          height = 0.8,
          width = 0.45,
          relative = 'editor',
          full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
          opts = {
            breakindent = true,
            cursorcolumn = false,
            cursorline = false,
            foldcolumn = '0',
            linebreak = true,
            list = false,
            numberwidth = 1,
            signcolumn = 'no',
            spell = false,
            wrap = true,
          },
        },

        ---Customize how tokens are displayed
        ---@param tokens number
        ---@param adapter CodeCompanion.Adapter
        ---@return string
        token_count = function(tokens, adapter)
          return ' (' .. tokens .. ' tokens)'
        end,
      },
    },
    opts = {
      log_level = 'INFO', -- TRACE|DEBUG|ERROR|INFO
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
