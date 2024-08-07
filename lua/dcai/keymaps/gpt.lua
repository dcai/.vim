local group = 'chat'
local loaded, gpplugin = pcall(require, 'gp')
if not loaded then
  return {
    { '<leader>c', group = group },
  }
end

local claude_code_model = 'claude-3-5-sonnet-20240620'
local chat_topic_gen_model = 'gpt-4o-mini'
local new_chat_params = {}

local function join(tbl, sep)
  return table.concat(vim.tbl_map(vim.trim, tbl), sep or ' ')
end

local function wrapGpCmd(str)
  return ":<c-u>'<,'>" .. str .. '<cr>'
end

local function dropbox_chat_dir()
  return vim.g.dropbox_home and vim.g.dropbox_home .. '/Documents/chatgpt_logs'
    or nil
end
local function std_chat_dir()
  ---@diagnostic disable-next-line: param-type-mismatch
  return vim.fn.stdpath('data'):gsub('/$', '') .. '/gp/chats'
end

local chatlogs_home = vim.fn.expand(dropbox_chat_dir() or std_chat_dir())

local translator_prompt = [[
  Translate any provided text directly to Chinese or English,
  based on the input language,
  without adding any interpretation or additional commentary.
]]

local code_template = [[
  Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.
  START AND END YOUR ANSWER WITH: ```
]]

local default_code_system_prompt = 'You are an AI working as a code editor.'
  .. code_template

local default_chat_prompt = [[
  You are a general AI assistant.
  The user provided the additional info about how they would like you to respond:
  - If you're unsure don't guess and say you don't know instead.
  - Ask question if you need clarification to provide better answer.
  - Think deeply and carefully from first principles step by step.
  - Zoom out first to see the big picture and then zoom in to details.
  - Use Socratic method to improve your thinking and coding skills.
  - Don't elide any code from your output if the answer requires coding.
  - Take a deep breath; You've got this!
]]

-- https://github.com/Robitx/gp.nvim/blob/main/lua/gp/config.lua
local config = {
  providers = {
    openai = {
      endpoint = 'https://api.openai.com/v1/chat/completions',
      secret = os.getenv('OPENAI_API_KEY'),
    },
    googleai = {
      endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}',
      secret = os.getenv('GOOGLEAI_API_KEY'),
    },
    anthropic = {
      endpoint = 'https://api.anthropic.com/v1/messages',
      secret = os.getenv('ANTHROPIC_API_KEY'),
    },
  },
  agents = {
    {
      name = 'CodeClaudeSonnet',
      provider = 'anthropic',
      chat = false,
      command = true,
      model = {
        model = claude_code_model,
        temperature = 0.8,
        top_p = 1,
      },
      system_prompt = default_code_system_prompt,
    },
    {
      name = 'ClaudeSonnet',
      provider = 'anthropic',
      chat = true,
      command = false,
      model = {
        model = claude_code_model,
        temperature = 0.8,
        top_p = 1,
      },
      system_prompt = default_chat_prompt,
    },
    {
      name = 'ChatGPT4o',
      chat = true,
      command = false,
      model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
      system_prompt = default_chat_prompt,
    },
    {
      name = 'CodeGPT4o',
      disable = true,
      chat = false,
      command = true,
      model = { model = 'gpt-4o', temperature = 0.8, top_p = 1 },
      system_prompt = default_code_system_prompt,
    },
    {
      name = 'CodeGPT3-5',
      chat = true,
      command = false,
      disable = true,
    },
    {
      name = 'ChatGPT3-5',
      chat = true,
      command = false,
      disable = true,
    },
    {
      name = 'ChatGemini',
      disable = true,
    },
    {
      name = 'CodeGPT4o-mini',
      disable = true,
    },
    {
      name = 'CodeGemini',
      disable = true,
    },
    {
      name = 'ChatClaude-3-Haiku',
      disable = true,
    },
    {
      name = 'CodeClaude-3-Haiku',
      disable = true,
    },
    {
      name = 'ChatClaude-3-5-Sonnet',
      disable = true,
    },
    {
      name = 'CodeClaude-3-5-Sonnet',
      disable = true,
    },
  },
  chat_dir = chatlogs_home,
  -- chat user prompt prefix in chat buffer
  chat_user_prefix = '👇',
  -- prompt in command `:GpNew`
  command_prompt_prefix_template = '👉 ye? [{{agent}}] ~ ',
  -- chat assistant prompt prefix (static string or a table {static, template})
  -- first string has to be static, second string can contain template {{agent}}
  -- just a static string is legacy and the [{{agent}}] element is added automatically
  -- if you really want just a static string, make it a table with one element { "🤖:" }
  chat_assistant_prefix = { '😒 Bot: ', '[{{agent}}]' },
  chat_shortcut_respond = {
    modes = { 'n', 'i', 'v', 'x' },
    shortcut = '<c-x><c-x>',
  },
  chat_shortcut_delete = {
    modes = { 'n', 'i', 'v', 'x' },
    shortcut = '<c-x>D',
  },
  chat_shortcut_stop = {
    modes = { 'n', 'i', 'v', 'x' },
    shortcut = '<Plug>vs',
  },
  chat_shortcut_new = {
    modes = { 'n', 'i', 'v', 'x' },
    shortcut = '<Plug>vn',
  },
  -- prefix for all commands
  cmd_prefix = 'Gp',
  curl_params = {},
  -- chat topic generation prompt
  chat_topic_gen_prompt = [[
    Summarize the topic of our conversation above in 3 or 4 words.
    Respond only with those words.
  ]],
  -- chat topic model (string with model name or table with model name and parameters)
  chat_topic_gen_model = chat_topic_gen_model,
  -- explicitly confirm deletion of a chat file
  chat_confirm_delete = true,
  -- conceal model parameters in chat
  chat_conceal_model_params = false,
  -- default search term when using :GpChatFinder
  chat_finder_pattern = 'topic ',
  -- if true, finished ChatResponder won't move the cursor to the end of the buffer
  chat_free_cursor = false,

  -- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
  toggle_target = '',
  -- auto select command response (easier chaining of commands)
  -- if false it also frees up the buffer cursor for further editing elsewhere
  command_auto_select_response = true,

  -- templates
  template_selection = 'I have the following from {{filename}}:'
    .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}',
  template_rewrite = 'I have the following from {{filename}}:'
    .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
    .. '\n\nRespond exclusively with the snippet that should replace the selection above.',
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
      local key = copy.config.openai_api_key
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

    -- GpImplement rewrites the provided selection/range based on comments in it
    Implement = function(gp, params)
      local template = join({
        'Having following from {{filename}}: ',
        '```{{filetype}} \n {{selection}} \n ```',
        'Please rewrite this according to the contained instructions.',
        'Respond exclusively with the snippet that should replace the selection above.',
      })

      local agent = gp.get_command_agent()
      gp.info('Implementing selection with agent: ' .. agent.name)

      gp.Prompt(
        params,
        gp.Target.rewrite,
        nil, -- command will run directly without any prompting for user input
        agent.model,
        template,
        agent.system_prompt
      )
    end,

    BufferChatNew = function(gp, _)
      -- call GpChatNew command in range mode on whole buffer
      vim.api.nvim_command('%' .. gp.config.cmd_prefix .. 'ChatNew')
    end,

    Translator = function(gp, params)
      gp.cmd.ChatNew(params, nil, translator_prompt)
    end,

    UnitTests = function(gp, params)
      local template = join({
        'I have the following code from {{filename}}: ',
        '```{{filetype}}\n{{selection}}\n``` ',
        'Please respond by writing table driven unit tests for the code above.',
      })
      local agent = gp.get_command_agent()
      gp.Prompt(
        params,
        gp.Target.enew,
        nil,
        agent.model,
        template,
        agent.system_prompt
      )
    end,

    Explain = function(gp, params)
      local template = join({
        'I have the following code from {{filename}}:',
        '```{{filetype}} \n {{selection}} \n```',
        'Please respond by explaining the code above and keep the response concise and straightforward.',
      })
      local agent = gp.get_chat_agent()
      gp.Prompt(
        params,
        gp.Target.popup,
        nil,
        agent.model,
        template,
        agent.system_prompt
      )
    end,
  },
}
gpplugin.setup(config)

local keymap = {
  { '<leader>c', group = group },
  {
    '<leader>cc',
    function()
      vim.cmd('GpChatToggle')
    end,
    desc = 'toggle chat',
  },
  {
    '<leader>cn',
    function()
      vim.cmd('GpChatNew')
    end,
    desc = 'new chat buffer',
  },
  {
    '<leader>cD',
    function()
      vim.cmd('GpChatDelete')
    end,
    desc = 'delete chat',
  },
  -- utils.vim_cmd('<leader>cc', 'GpNew', 'Enter a prompt'),
  {
    '<leader>cF',
    function()
      local fzf = require('fzf-lua')
      fzf.live_grep({
        winopts = {
          preview = {
            hidden = 'nohidden',
          },
        },
        multiprocess = true,
        cwd = chatlogs_home,
        query = '# topic',
        file_ignore_patterns = {
          'node_modules',
          '.png',
          '.pdf',
          '.jpg',
          '.docx',
          '.pptx',
        },
      })
    end,
    desc = 'chat finder',
  },
  {
    '<leader>ca',
    function()
      local agents = {}
      for key, _ in pairs(gpplugin.agents) do
        table.insert(agents, key)
      end
      require('fzf-lua').fzf_exec(agents, {
        actions = {
          default = function(selected, _)
            local selected_agent = selected[1]
            vim.cmd('GpAgent ' .. selected_agent)
          end,
        },
      })
    end,
    desc = 'select an agent',
  },
  {
    '<leader>cN',
    function()
      vim.cmd('GpNextAgent')
    end,
    desc = 'next agent',
  },
  -- s = utils.vim_cmd('GpWhisper', 'speech to text'),
  ---javascript react and nodejs
  {
    '<leader>cJ',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for a project using javascript, react and nodejs.',
          code_template,
        })
      )
    end,
    desc = '#topic: javascript',
  },
  ---python
  {
    '<leader>cY',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for python project.',
          code_template,
        })
      )
    end,
    desc = '#topic: python',
  },
  ---php and laravel
  {
    '<leader>cP',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for a fullstack project using php, laravel with inertiajs for react.',
          'Add tailwind class to style the components.',
          code_template,
        })
      )
    end,
    desc = '#topic: laravel',
  },
  ---tailwind
  {
    '<leader>cS',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for frontend development with tailwind, no need to setup tailwind, just response with the code.',
          code_template,
        })
      )
    end,
    desc = '#topic: tailwind',
  },
  -- Translator
  {
    '<leader>cT',
    function()
      gpplugin.new_chat(new_chat_params, false, translator_prompt)
    end,
    desc = '#topic: translate',
  },
  -- etymologist
  {
    '<leader>cE',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'I want you to act as a etymologist. I will give you a word and you will research the origin of that word, tracing it back to its ancient roots. You should also provide information on how the meaning of the word has changed over time, if applicable',
        })
      )
    end,
    desc = '#topic: etymologist',
  },
  {
    '<leader>cH',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'I want you to act as a historian and an archaeologist',
        })
      )
    end,
    desc = '#topic: history',
  },
  ---neovim and lua
  {
    '<leader>cL',
    function()
      gpplugin.new_chat(
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for neovim, use lua instead of vimscript when possible.',
          code_template,
        })
      )
    end,
    desc = '#topic: neovim',
  },
  ----------------------------------------------------------------------------
  --- Visual mode below
  ----------------------------------------------------------------------------
  { '<leader>c', group = group, mode = 'v' },
  {
    '<leader>cn',
    wrapGpCmd('GpChatNew'),
    desc = 'visual new chat',
    mode = 'v',
  },
  {
    '<leader>ce',
    wrapGpCmd('GpExplain'),
    desc = 'explain selcted code',
    mode = 'v',
  },
}

return keymap
