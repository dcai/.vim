local ok = pcall(require, 'codecompanion')
local prompt_library = require('dcai.llm.prompt_library')
local llm_provider = 'local_copilot'
-- local llm_provider = {
--   name = 'copilot_cli',
--   model = 'gpt-5.4',
-- }
-- local llm_provider = 'claude_code'
-- local llm_provider = 'grok'
-- local llm_provider = 'opencode'

local M = {
  setup = function() end,
}

if not ok then
  return M
end

M.handles = {}

function M:store_progress_handle(id, handle)
  M.handles[id] = handle
end

function M:pop_progress_handle(id)
  local handle = M.handles[id]
  M.handles[id] = nil
  return handle
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

function M:init_progress_hooks()
  -- local fidget_loaded, fidget_progress = pcall(require, 'fidget.progress')
  -- if not fidget_loaded then
  --   return
  -- end
  local group = vim.api.nvim_create_augroup('CodeCompanionProgressHooks', {})

  -- local function create_progress_handle(request)
  --   local strategy = request.data.strategy or ''
  --   return fidget_progress.handle.create({
  --     title = ' Requesting assistance (' .. strategy .. ')',
  --     message = 'In progress...',
  --     lsp_client = {
  --       name = M:llm_role_title(request.data.adapter),
  --     },
  --   })
  -- end

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestStarted',
    group = group,
    callback = function(request)
      vim.g.set_terminal_progress_loading()
      -- vim.g.logger.info(vim.inspect(request))
      -- local handle = create_progress_handle(request)
      -- M:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestFinished',
    group = group,
    callback = function(request)
      vim.g.clear_terminal_progress()
      -- local handle = M:pop_progress_handle(request.data.id)
      -- if handle then
      --   M:report_exit_status(handle, request)
      --   handle:finish()
      -- end
    end,
  })
end

M.setup = function()
  vim.env['CODECOMPANION_TOKEN_PATH'] = vim.fn.expand(vim.env.XDG_CONFIG_HOME)

  local instance = require('codecompanion')
  instance.setup({
    interactions = {
      cmd = {
        adapter = llm_provider,
      },
      inline = {
        adapter = llm_provider,
      },
      shared = {
        keymaps = {
          -- Reserve ga/gr for whole-change review, not the new inline hunk actions.
          accept_hunk = false,
          reject_hunk = false,
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
        opts = {

          ---This is the default prompt which is sent with every request in the chat
          ---strategy. It is primarily based on the GitHub Copilot Chat's prompt
          ---but with some modifications. You can choose to remove this via
          ---your own config but note that LLM results may not be as good
          ---@param ctx CodeCompanion.SystemPrompt.Context
          ---@return string
          system_prompt = function(ctx)
            -- vim.g.logger.info('Generating system prompt with context: ' .. vim.inspect(ctx))
            return ctx.default_system_prompt
              .. string.format(
                [[Additional context:
All non-code text responses must be written in the %s language.
The current date is %s.
The user's Neovim version is %s.
The user is working on a %s machine. Please respond with system specific commands if applicable.


Only use tools that are available in the current chat.
]],
                ctx.language,
                ctx.date,
                ctx.nvim_version,
                ctx.os
              )
          end,
        },
        adapter = llm_provider,
        sessions = {
          enabled = true,
          autosave = true,
          continuous_save = true,
        },
        roles = {
          ---The header name for the LLM's messages
          ---@type string|fun(adapter: CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter): string
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
          ['run_command'] = {
            opts = {
              require_approval_before = false,
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
              i = '<C-d>',
              -- i = nil,
            },
          },
          clear = {
            modes = {
              n = { 'gx', '<C-l>' },
            },
          },
          stop = {
            modes = {
              n = '<C-s>',
            },
          },
        },
      },
    },
    adapters = {
      acp = {
        copilot_cli = function()
          return require('codecompanion.adapters').extend('copilot_acp', {
            defaults = {
              mcpServers = {},
              timeout = 20000,
              session_config_options = {
                thought_level = 'Xhigh',
              },
            },
          })
        end,
        opencode = function()
          return require('codecompanion.adapters').extend('opencode', {})
        end,
        claude_code = function()
          return require('codecompanion.adapters').extend('claude_code', {
            env = {
              ANTHROPIC_API_KEY = 'neovim-codecompanion-acp-fake-token',
              ANTHROPIC_BASE_URL = 'http://localhost:4141',
              ANTHROPIC_MODEL = 'gpt-5.4',
              ANTHROPIC_SMALL_FAST_MODEL = 'gpt-4.1',
            },
          })
        end,
        gemini_cli = function()
          return require('codecompanion.adapters').extend('gemini_cli', {
            defaults = {
              auth_method = 'gemini-api-key',
              mcpServers = {},
              timeout = 20000, -- 20 seconds
            },
            env = {
              GEMINI_API_KEY = 'GEMINI_API_KEY',
            },
          })
        end,
      },
      http = {
        local_copilot = function()
          return require('codecompanion.adapters').extend('openai_responses', {
            url = 'http://localhost:7890/v1/responses',
            env = {
              api_key = 'neovim-codecompanion',
            },
            schema = {
              model = {
                default = 'gpt-6-luna',
                choices = function()
                  return {
                    ['gpt-6-luna'] = {
                      formatted_name = 'GPT-6 Luna',
                      meta = { context_window = 1000000 },
                      opts = {
                        can_reason = true,
                        can_use_tools = true,
                        has_vision = true,
                        can_form_structured_outputs = true,
                      },
                    },
                  }
                end,
              },
              ['reasoning.effort'] = {
                choices = { 'none', 'low', 'medium', 'high', 'xhigh', 'max' },
              },
              temperature = {
                enabled = function()
                  return false
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
                default = 'deepseek-flash',
              },
            },
          })
        end,
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            schema = {
              model = {
                default = 'gpt-6-luna',
              },
            },
          })
        end,
      },
    },
    rules = {
      root = {
        description = 'Shared root agent instructions',
        files = { vim.fn.expand('~/.dotfiles/agents/AGENTS-ROOT.md') },
      },
      opts = {
        chat = {
          enabled = true,
          autoload = { 'root', 'default' },
          autoload_groups_in_prompt_library = true,
        },
      },
    },
    prompt_library = {
      ['Neovim Expert'] = {
        interaction = 'chat',
        description = 'neovim help',
        opts = {
          index = 11,
          is_slash_cmd = false,
          auto_submit = false,
          alias = 'neovim',
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
        interaction = 'chat',
        description = 'Generate unit tests for the selected code',
        opts = {
          index = 7,
          is_slash_cmd = false,
          modes = { 'v' },
          alias = 'unit_tests',
          -- auto_submit = true,
          auto_submit = false,
          user_prompt = false,
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
              local code = table.concat(
                vim.api.nvim_buf_get_lines(
                  context.bufnr,
                  context.start_line - 1,
                  context.end_line,
                  false
                ),
                '\n'
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
        interaction = 'inline',
        description = 'Prompt the LLM from Neovim',
        opts = {
          index = 3,
          is_slash_cmd = false,
          user_prompt = true,
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return string.format(
                [[Act as a senior %s developer. Make the requested edits directly. Keep explanations brief.]],
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
        -- provider = 'default',
        provider = 'fzf_lua',
        opts = {
          show_preset_actions = true,
          show_preset_prompts = true,
        },
      },
      diff = {
        enabled = true,
      },
      chat = {
        intro_message = 'Welcome to CodeCompanion ✨! Press ? for options',
        auto_scroll = false,
        show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
        separator = '─', -- The separator between the different messages in the chat buffer
        show_context = true, -- Show context shared with the LLM in the chat buffer
        show_settings = true, -- Show LLM settings at the top of the chat buffer?
        show_token_count = true, -- Show the token count for each response?
        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        -- Change the default icons
        icons = {
          sync_all = ' ',
          sync_diff = '👀 ',
        },

        -- Size floating windows when opened, so they follow editor resizing.
        floating_window = {
          width = function()
            return vim.o.columns - 5
          end,
          height = function()
            return vim.o.lines - 2
          end,
        },

        -- Options to customize the UI of the chat buffer
        window = {
          layout = 'vertical', -- float|vertical|horizontal|buffer
          position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
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
        ---@param adapter CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter
        ---@return string
        token_count = function(tokens, adapter)
          return ' (' .. tokens .. ' tokens)'
        end,
      },
    },
  })
  M:init_progress_hooks()
  return instance
end

return M
