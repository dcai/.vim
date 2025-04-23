local M = {}

---@alias ClaudeModel 'claude-3-5-sonnet-latest'|'claude-3-7-sonnet-latest'
---@alias DeepseekModel "deepseek-reasoner"|"deepseek-chat"
---@alias CopilotModel "gpt-4o"|"gpt-4.1"|"o3-mini"|"o4-mini"|"claude-3.5-sonnet"|"claude-3.7-sonnet-thought"
M.prefix = 'Gp'

M.agents = {
  coder_chat = 'CoderChat',
  code_editor = 'CodeEditor',
  copilot = 'Copilot',
}

local cmd_prefix = M.prefix

M.wrapGpCmd = function(str)
  return ":<c-u>'<,'>" .. cmd_prefix .. str .. '<cr>'
end

local function dropbox_chat_dir()
  return vim.g.dropbox_home and vim.g.dropbox_home .. '/Documents/chatgpt_logs'
    or nil
end

local function std_chat_dir()
  ---@diagnostic disable-next-line: param-type-mismatch
  return vim.g.data_dir .. '/gp/chats'
end

local function join(tbl, sep)
  return table.concat(vim.tbl_map(vim.trim, tbl), sep or ' ')
end

M.chatlogs_home = vim.fn.expand(dropbox_chat_dir() or std_chat_dir())

local code_system_prompt = 'You are an AI working as a code editor.\n\n'
  .. 'Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n'
  .. 'START AND END YOUR ANSWER WITH:\n\n```'

M.setup = function()
  local gpplugin = require('gp')
  local prompt_library = require('dcai.llm.prompt_library')

  -- vim.keymap.set({ 'i', 'n' }, '<c-i>', function()
  --   local bufnr = vim.api.nvim_get_current_buf()
  --   local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  --   local content = table.concat(lines, '\n')
  --   vim.ui.input(
  --     { prompt = 'what do you want me to do? ', default = '' },
  --     function(input)
  --       if not input then
  --         return
  --       end
  --       local line_number = vim.api.nvim_win_get_cursor(0)[1]
  --       local template = join({
  --         'Having following from {{filename}}: ',
  --         '```{{filetype}} \n ',
  --         content,
  --         ' \n ```',
  --         string.format('Cursor is at line number: %s\n', line_number),
  --         input,
  --         '\nResponse in code and valid code only. \n',
  --       })
  --
  --       local agent = gpplugin.get_command_agent(M.agents.code_editor)
  --       gpplugin.Prompt(
  --         {
  --           line1 = line_number,
  --           line2 = line_number,
  --         },
  --         gpplugin.Target.vnew,
  --         agent,
  --         template,
  --         nil, -- command will run directly without any prompting for user input
  --         nil -- no predefined instructions (e.g. speech-to-text from Whisper)
  --       )
  --     end
  --   )
  -- end)

  vim.g.handle_autocmd('User', 'GpQueryStarted', function(ev)
    -- vim.g.logger.debug('Handle GpQueryStarted: ' .. vim.inspect(ev))
    if not ev.data then
      return
    end
    local qid = ev.data.qid
    local model_name = 'AI'
    if ev.data.payload and ev.data.payload.model then
      model_name = ev.data.payload.model
    end
    local title = ' Request from ' .. model_name
    local msg = 'In progress... '
    vim.g.update_notification(qid, msg, title, false)
  end, 'handle gp started')

  vim.g.handle_autocmd('User', 'GpDone', function(ev)
    if not ev.data then
      return
    end
    local qid = ev.data.qid
    local reason = ev.data.reason or 'Unknown'
    vim.g.logger.debug('Handle GpDone: ' .. vim.inspect({ reason = reason }))
    vim.g.update_notification(qid, 'Done', '', true)
  end, 'handle gp query end')

  local translator_prompt = prompt_library.TRANSLATE
  local prompt_code_block_only = prompt_library.ONLYCODE
  local prompt_chat_default = prompt_library.BASE_PROMPT_GENERAL

  local chat_template = [[
# topic: ?

- file: {{filename}}
{{optional_headers}}
Write your queries after {{user_prefix}}. Use `{{respond_shortcut}}` or :{{cmd_prefix}}ChatRespond to generate a response.
Response generation can be terminated by using `{{stop_shortcut}}` or :{{cmd_prefix}}ChatStop command.
Chats are saved automatically. To delete this chat, use `{{delete_shortcut}}` or :{{cmd_prefix}}ChatDelete.
Be cautious of very long chats. Start a fresh chat by using `{{new_shortcut}}` or :{{cmd_prefix}}ChatNew.

---

{{user_prefix}}
]]

  -- https://github.com/Robitx/gp.nvim/blob/main/lua/gp/config.lua
  --
  local disabled_agents = vim.tbl_map(function(agent)
    return {
      name = agent,
      disable = true,
    }
  end, {
    'ChatClaude-3-5-Haiku',
    'ChatClaude-3-5-Sonnet',
    'ChatClaude-3-7-Sonnet',
    'ChatClaude-3-Haiku',
    'ChatCopilot',
    'ChatGPT-o3-mini',
    'ChatGPT4o',
    'ChatGPT4o-mini',
    'ChatGemini',
    'CodeClaude-3-5-Haiku',
    'CodeClaude-3-5-Sonnet',
    'CodeClaude-3-7-Sonnet',
    'CodeClaude-3-Haiku',
    'CodeCopilot',
    'CodeGPT-o3-mini',
    'CodeGPT4o',
    'CodeGPT4o-mini',
    'CodeGemini',
  })

  local enabled_agents = {
    {
      name = M.agents.copilot,
      provider = 'copilot',
      ---@type CopilotModel
      model = 'gpt-4.1',
      -- model = 'o4-mini',
      chat = true,
      command = true,
      system_prompt = code_system_prompt,
    },
    {
      name = M.agents.code_editor,
      provider = 'copilot',
      ---@type CopilotModel
      model = 'o4-mini',
      chat = false,
      command = true,
      system_prompt = code_system_prompt,
    },
    {
      -- Grok is not great at **editing** code
      -- so this is chat only
      name = M.agents.coder_chat,
      provider = 'xai',
      model = 'grok-3-mini-beta',
      chat = true,
      -- command runs without user instructions
      command = false,
      system_prompt = code_system_prompt,
    },
    {
      name = 'Gemini',
      provider = 'googleai',
      model = {
        -- find gemini models: https://ai.google.dev/gemini-api/docs/models/gemini
        model = 'gemini-2.0-flash',
        temperature = 1.1,
        top_p = 0.95,
        top_k = 40,
      },
      disable = false,
      chat = true,
      command = false,
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = prompt_chat_default,
    },
    {
      name = 'ChatDeepSeek',
      provider = 'deepseek',
      ---@type DeepseekModel
      model = 'deepseek-chat',
      chat = true,
      command = true,
      system_prompt = prompt_chat_default,
    },
    {
      name = 'CodeClaudeSonnet',
      provider = 'anthropic',
      chat = true,
      command = true,
      ---@type ClaudeModel
      model = 'claude-3-5-sonnet-latest',
      system_prompt = code_system_prompt,
    },
    {
      name = 'TranslateAgent',
      privider = 'openai',
      model = 'gpt-4o-mini',
      chat = false,
      command = true,
      system_prompt = [[
        you are dictionary/translator,
        response detailed translation in chinese in the format same as oxford dictionary,
        then response essential usage examples in english.
      ]],
    },
  }

  local agents = vim.list_extend(disabled_agents, enabled_agents)

  local opts = {
    agents = agents,
    -- prefix for all commands
    cmd_prefix = cmd_prefix,
    chat_dir = M.chatlogs_home,
    state_dir = vim.g.state_dir .. '/gp/persisted',
    log_file = vim.g.log_dir .. '/gp.nvim.log',
    log_sensitive = false,
    log_level = vim.log.levels.INFO,
    providers = {
      xai = {
        endpoint = 'https://api.x.ai/v1/chat/completions',
        secret = os.getenv('XAI_API_KEY'),
      },
      copilot = {
        disable = false,
        endpoint = 'https://api.githubcopilot.com/chat/completions',
        secret = {
          'bash',
          '-c',
          "jq -r '.[ ].oauth_token' ~/.config/github-copilot/apps.json",
        },
      },
      deepseek = {
        endpoint = 'https://api.deepseek.com/chat/completions',
        secret = os.getenv('DEEPSEEK_API_KEY'),
      },
      openai = {
        endpoint = 'https://api.openai.com/v1/chat/completions',
        secret = os.getenv('OPENAI_API_KEY'),
      },
      googleai = {
        endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}',
        secret = os.getenv('GEMINI_API_KEY'),
      },
      anthropic = {
        endpoint = 'https://api.anthropic.com/v1/messages',
        secret = os.getenv('ANTHROPIC_API_KEY'),
      },
    },
    -- chat user prompt prefix in chat buffer
    chat_user_prefix = 'Write question below 👇',
    command_prompt_prefix_template = '👉 [CMD_PROMPT({{agent}})] > ',
    -- chat assistant prompt prefix (static string or a table {static, template})
    -- first string has to be static, second string can contain template {{agent}}
    -- just a static string is legacy and the [{{agent}}] element is added automatically
    -- if you really want just a static string, make it a table with one element { "🤖:" }
    chat_assistant_prefix = { '😒 Bot: ', '[{{agent}}]' },
    chat_template = chat_template,
    -- chat_template = short_chat_template,
    chat_shortcut_respond = {
      -- modes = { 'n', 'i', 'v', 'x' },
      modes = { 'n', 'x' },
      -- shortcut = '<c-x><c-x>',
      shortcut = '<cr>',
    },
    chat_shortcut_delete = {
      modes = { 'n', 'i', 'v', 'x' },
      shortcut = '<c-x>D',
    },
    chat_shortcut_stop = {
      modes = { 'n', 'v', 'x' },
      shortcut = '<bs>',
    },
    chat_shortcut_new = {
      modes = { 'n', 'i', 'v', 'x' },
      shortcut = '<Plug>vn',
    },
    curl_params = {},
    -- chat topic generation prompt
    chat_topic_gen_prompt = prompt_library.TOPIC_GEN,
    chat_topic_gen_provider = 'openai',
    -- chat topic model (string with model name or table with model name and parameters)
    chat_topic_gen_model = 'gpt-4.1-nano',
    -- explicitly confirm deletion of a chat file
    chat_confirm_delete = true,
    -- conceal model parameters in chat
    chat_conceal_model_params = false,
    -- default search term when using :GpChatFinder
    chat_finder_pattern = 'topic ',
    -- if true, finished ChatResponder won't move the cursor to the end of the buffer
    chat_free_cursor = false,

    -- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
    toggle_target = 'vsplit',
    -- auto select command response (easier chaining of commands)
    -- if false it also frees up the buffer cursor for further editing elsewhere
    command_auto_select_response = true,

    -- templates
    template_selection = 'I have the following from {{filename}}:'
      .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}',

    template_rewrite = 'I have the following from {{filename}}:'
      .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
      .. '\n\nRespond exclusively with the snippet that should replace the selection above.'
      .. prompt_code_block_only,

    template_append = 'I have the following from {{filename}}:'
      .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
      .. '\n\nRespond exclusively with the snippet that should be appended after the selection above.',

    template_prepend = 'I have the following from {{filename}}:'
      .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
      .. '\n\nRespond exclusively with the snippet that should be prepended before the selection above.',

    template_command = '{{command}}',

    hooks = {
      InspectPlugin = function(plugin, params)
        local bufnr = vim.api.nvim_create_buf(false, true)
        local copy = vim.deepcopy(plugin)
        local key = copy.config.openai_api_key or ''
        copy.config.openai_api_key = key:sub(1, 3)
          .. string.rep('*', #key - 6)
          .. key:sub(-3)
        local plugin_info =
          string.format('Plugin structure:\n%s', vim.inspect(copy))
        local params_info =
          string.format('Command params:\n%s', vim.inspect(params))
        local lines = vim.split(plugin_info .. '\n' .. params_info, '\n')
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.api.nvim_win_set_buf(0, bufnr)
      end,

      BufferChatNew = function(gp, _)
        -- call GpChatNew command in range mode on whole buffer
        vim.api.nvim_command('%' .. gp.config.cmd_prefix .. 'ChatNew')
      end,

      Translator = function(gp, params)
        local agent = gp.get_chat_agent('TranslateAgent')
        gp.cmd.ChatNew(params, translator_prompt, agent)
      end,

      Dict = function(gp, params)
        local input = params.args
        if input then
          gp.Prompt(
            params,
            gp.Target.popup,
            gp.get_chat_agent('TranslateAgent'),
            join({
              'translate this: ```',
              input,
              '```',
            })
          )
        else
          gp.cmd.ChatNew(params, translator_prompt)
        end
      end,

      ---rewrites the provided selection/range based on comments in it
      ---@param _gp table -- its the instance of gpplugin
      ---@param params table
      Implement = function(_gp, params)
        local template = join({
          'Having following from {{filename}}: ',
          '```{{filetype}} \n {{selection}} \n ```',
          'Please rewrite this according to the contained instructions.',
          'Respond exclusively with the snippet that should replace the selection above.',
        })

        local agent = gpplugin.get_command_agent(M.agents.code_editor)
        --- params table  # vim command parameters such as range, args, etc.
        --- target number | function | table  # where to put the response
        --- agent table  # obtained from get_command_agent or get_chat_agent
        --- template string  # template with model instructions
        --- prompt string | nil  # nil for non interactive commads
        --- whisper string | nil  # predefined input (e.g. obtained from Whisper)
        --- callback function | nil  # callback after completing the prompt
        gpplugin.Prompt(
          params,
          gpplugin.Target.vnew,
          agent,
          template,
          nil, -- command will run directly without any prompting for user input
          nil -- no predefined instructions (e.g. speech-to-text from Whisper)
        )
      end,

      UnitTests = function(gp, params)
        local template = join({
          'I have the following code from {{filename}}: ',
          '```{{filetype}} \n {{selection}} \n``` ',
          'Please respond by writing unit tests for the code above.',
          -- 'Please respond by writing table driven unit tests for the code above.',
        })
        local agent = gp.get_command_agent(M.agents.code_editor)
        gp.Prompt(params, gp.Target.vnew, agent, template)
      end,

      Explain = function(gp, params)
        local template = join({
          'I have the following code from {{filename}}:',
          '```{{filetype}} \n {{selection}} \n```',
          'Please respond by explaining the code above and keep the response concise and straightforward.',
        })
        local agent = gp.get_command_agent(M.agents.code_editor)
        gp.Prompt(params, gp.Target.popup, agent, template)
      end,
    },
  }
  gpplugin.setup(opts)
  return gpplugin
end

return M
