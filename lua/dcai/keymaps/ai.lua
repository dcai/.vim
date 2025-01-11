local group = 'chat'
local loaded, gpplugin = pcall(require, 'gp')
if not loaded then
  return {
    { '<leader>c', group = group },
  }
end

local cmd_prefix = 'Ai'

local openai_gpt4o_mini = 'gpt-4o-mini'
-- find claude models: https://docs.anthropic.com/en/docs/about-claude/models
local claude_code_model = 'claude-3-5-sonnet-20241022'
-- find gemini models: https://ai.google.dev/gemini-api/docs/models/gemini
local gemini2_model = 'gemini-2.0-flash-exp'
local chat_topic_gen_model = openai_gpt4o_mini
local translator_model = openai_gpt4o_mini

local prompt_chat_default = [[
You are a versatile AI assistant. When responding, please adhere to the following guidelines:

- **Accuracy**: If unsure about a topic, state that you don’t know rather than guessing.
- **Clarification**: Ask clarifying questions to ensure you fully understand the user's request before answering.
- **Analytical Approach**: Break down your thought process step-by-step, starting with a broader perspective (zooming out) before delving into specifics (zooming in).
- **Socratic Method**: Utilize the Socratic method to stimulate deeper thinking and enhance coding skills.
- **Complete Responses**: Include all relevant code in your responses when coding is necessary; do not omit any details.
- **Conciseness**: Keep answers succinct, elaborating only when requested or necessary.
- **Encouragement**: Approach each question with confidence and a positive mindset.

With these guidelines, respond creatively and accurately to user queries while fostering a supportive environment for learning.
]]

local prompt_code_block_only = [[
Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.
START AND END YOUR ANSWER WITH: ```
]]

local prompt_coding_rules = [[

Other Rules need to follow:

- Follow the user's requirements carefully & to the Letter.
- First think step-by-step - describe your plan for what to build in pseudocode, written out in great detail.
- Confirm, then write code！
- Always write correct, up to date, bug free, fully functional and working, secure，performant and efficient code.
- Focus on readability over being performant.
- Fully implement all requested functionality.
- Leave No todo's, placeholders or missing pieces.
- Be sure to reference file names.
- Be concise, minimize any other prose.
- If you think there might not be a correct answer, you say so. If you do not know the answer, say so instead of guessing.

Don't be lazy, write all the code to implement the features I ask for.
]]

local prompt_coding = [[
You are an expert Al programming assistant that primarily focuses on producing clear，readable code.
Use javascript unless asked otherwise.
]] .. prompt_code_block_only .. prompt_coding_rules

local prompt_python = [[
You are an AI working as a code editor for python project.
]] .. prompt_code_block_only .. prompt_coding_rules

local prompt_laravel = [[
You are an expert AI working as a code editor for a fullstack project primarily focuses on producing clear, readable php in the backend with laravel and inertiajs for react in frontend.

You always use the Latest stable version of Laravel, Javascript, React, TailwindCSS and you are familiar with the Latest features and best practices.

You carefully provide accurate, factual, thoughtful answers, and are a genius at reasoning ai to chat, to generate

Code Style and Structure

- Write concise, technical code with accurate examples.

UI and Styling

- Add tailwind class to style the components
- Implement responsive design with Tailwind CSS; use a mobile-first approach.

]] .. prompt_code_block_only .. prompt_coding_rules

local prompt_javascript = [[
You are an expert Al programming assistant that primarily focuses on producing clear，readable React and JavaScript code.

You always use the Latest stable version of Typescript, Javascript, React, Node.js, Next.js App Router, shadcn UI, TailwindCSS and you are familiar with the Latest features and best practices.

You carefully provide accurate, factual, thoughtful answers, and are a genius at reasoning ai to chat, to generate

Code Style and Structure

- Write concise, technical Javascript code with accurate examples.
    • Use functional and declarative programming patterns; avoid classes.
    • Prefer iteration and modularization over code duplication.
- Use descriptive variable names with auxiliary verbs （e.g.， isLoading, hasError）.
- Structure files: exported component, helpers, static content，types.

Naming Conventions

- Use Lowercase with dashes for directories （e.g.. components/auth-wizard）.
- Favor named exports for components.

UI and Styling

- Use shadcn UI, and Tailwind for components and styling.
- Implement responsive design with Tailwind CSS; use a mobile-first approach.
]] .. prompt_code_block_only .. prompt_coding_rules

local translator_prompt = [[
Translate any provided text directly to Chinese or English,
based on the input language,
without adding any interpretation or additional commentary.
]]

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

local short_chat_template = [[
# topic: ?

- file: {{filename}}

---

{{user_prefix}}
]]

---@param params table  # vim command parameters such as range, args, etc.
---@param toggle boolean # whether chat is toggled
---@param system_prompt string | nil # system prompt to use
---@param agent table | nil # obtained from get_command_agent or get_chat_agent
---@return number # buffer number
local function new_chat(M, params, toggle, system_prompt, agent)
  M._toggle_close(M._toggle_kind.popup)

  local filename = M.config.chat_dir .. '/' .. M.logger.now() .. '.md'

  -- encode as json if model is a table
  local model = ''
  local provider = ''
  if agent and agent.model and agent.provider then
    model = agent.model
    provider = agent.provider
    if type(model) == 'table' then
      model = '- model: ' .. vim.json.encode(model) .. '\n'
    else
      model = '- model: ' .. model .. '\n'
    end

    provider = '- provider: ' .. provider:gsub('\n', '\\n') .. '\n'
  end

  -- display system prompt as single line with escaped newlines
  if system_prompt then
    system_prompt = '- role: ' .. system_prompt:gsub('\n', '\\n') .. '\n'
  else
    system_prompt = ''
  end

  local template = M.render.template(
    M.config.chat_template or require('gp.defaults').chat_template,
    {
      ['{{filename}}'] = string.match(filename, '([^/]+)$'),
      ['{{optional_headers}}'] = model .. provider .. system_prompt,
      ['{{user_prefix}}'] = M.config.chat_user_prefix,
      ['{{respond_shortcut}}'] = M.config.chat_shortcut_respond.shortcut,
      ['{{cmd_prefix}}'] = M.config.cmd_prefix,
      ['{{stop_shortcut}}'] = M.config.chat_shortcut_stop.shortcut,
      ['{{delete_shortcut}}'] = M.config.chat_shortcut_delete.shortcut,
      ['{{new_shortcut}}'] = M.config.chat_shortcut_new.shortcut,
    }
  )

  -- escape underscores (for markdown)
  template = template:gsub('_', '\\_')

  local cbuf = vim.api.nvim_get_current_buf()

  -- strip leading and trailing newlines
  template = template:gsub('^%s*(.-)%s*$', '%1') .. '\n'

  -- create chat file
  vim.fn.writefile(vim.split(template, '\n'), filename)
  local target = M.resolve_buf_target(params)
  local buf = M.open_buf(filename, target, M._toggle_kind.chat, toggle)

  if params.range == 2 then
    M.render.append_selection(params, cbuf, buf, M.config.template_selection)
  end
  M.helpers.feedkeys('G', 'xn')
  return buf
end

local new_chat_params = {
  -- params = {},      -- table  # vim command parameters such as range, args, etc.
  -- toggle = false,   -- boolean # whether chat is toggled
  -- system_prompt = nil,  -- string | nil # system prompt to use
  -- agent = nil,  -- table | nil # obtained from get_command_agent or get_chat_agent
}

local function join(tbl, sep)
  return table.concat(vim.tbl_map(vim.trim, tbl), sep or ' ')
end

local function wrapGpCmd(str)
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

local chatlogs_home = vim.fn.expand(dropbox_chat_dir() or std_chat_dir())

-- https://github.com/Robitx/gp.nvim/blob/main/lua/gp/config.lua
local config = {
  -- prefix for all commands
  cmd_prefix = cmd_prefix,
  chat_dir = chatlogs_home,
  state_dir = vim.g.state_dir .. '/gp/persisted',
  log_file = vim.g.log_dir .. '/gp.nvim.log',
  log_sensitive = false,
  providers = {
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
  agents = {
    {
      name = 'CmdClaudeSonnet',
      provider = 'anthropic',
      chat = false,
      command = true,
      model = {
        model = claude_code_model,
        temperature = 0.8,
        top_p = 1,
      },
      system_prompt = prompt_coding,
    },
    {
      name = 'ChatClaudeSonnet',
      provider = 'anthropic',
      chat = true,
      command = false,
      model = {
        model = claude_code_model,
        temperature = 0.8,
        top_p = 1,
      },
      system_prompt = prompt_chat_default,
    },
    {
      name = 'ChatGPT4o-mini',
      chat = true,
      command = false,
      model = { model = openai_gpt4o_mini, temperature = 1.1, top_p = 1 },
      system_prompt = prompt_chat_default,
    },
    {
      name = 'ChatGPT4o',
      chat = true,
      command = false,
      model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
      system_prompt = prompt_chat_default,
    },
    {
      name = 'TranslateAgent',
      chat = false,
      command = true,
      model = { model = translator_model, temperature = 0.8, top_p = 1 },
      system_prompt = [[
        you are dictionary/translator,
        response detailed translation in chinese in the format same as oxford dictionary,
        then response essential usage examples in english.
      ]],
    },
    {
      name = 'CodeGPT4o',
      disable = true,
      chat = false,
      command = true,
      model = { model = 'gpt-4o', temperature = 0.8, top_p = 1 },
      system_prompt = prompt_coding,
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
      name = 'CodeGPT4o-mini',
      disable = true,
    },
    {
      provider = 'googleai',
      name = 'ChatGemini2',
      disable = false,
      chat = true,
      command = false,
      model = {
        model = gemini2_model,
        temperature = 1.1,
        top_p = 0.95,
        top_k = 40,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = prompt_chat_default,
    },
    {
      provider = 'googleai',
      name = 'ChatGemini',
      disable = false,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = 'gemini-pro', temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = prompt_chat_default,
    },
    {
      provider = 'googleai',
      name = 'CodeGemini',
      disable = false,
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = 'gemini-pro', temperature = 0.8, top_p = 1 },
      system_prompt = prompt_coding,
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

    -- AiDev rewrites the provided selection/range based on comments in it
    Dev = function(gp, params)
      local template = join({
        'Having following from {{filename}}: ',
        '```{{filetype}} \n {{selection}} \n ```',
        'Please rewrite this according to the contained instructions.',
        'Respond exclusively with the snippet that should replace the selection above.',
      })

      local agent = gp.get_command_agent()

      --- params table  # vim command parameters such as range, args, etc.
      --- target number | function | table  # where to put the response
      --- agent table  # obtained from get_command_agent or get_chat_agent
      --- template string  # template with model instructions
      --- prompt string | nil  # nil for non interactive commads
      --- whisper string | nil  # predefined input (e.g. obtained from Whisper)
      --- callback function | nil  # callback after completing the prompt
      gp.Prompt(
        params,
        gp.Target.rewrite,
        agent,
        template,
        nil, -- command will run directly without any prompting for user input
        nil -- no predefined instructions (e.g. speech-to-text from Whisper)
      )
    end,

    BufferChatNew = function(gp, _)
      -- call GpChatNew command in range mode on whole buffer
      vim.api.nvim_command('%' .. gp.config.cmd_prefix .. 'ChatNew')
    end,

    Translator = function(gp, params)
      local agent = gp.get_chat_agent('ChatGPT4o-mini')
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

    UnitTests = function(gp, params)
      local template = join({
        'I have the following code from {{filename}}: ',
        '```{{filetype}}\n{{selection}}\n``` ',
        'Please respond by writing table driven unit tests for the code above.',
      })
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.enew, agent, template)
    end,

    Explain = function(gp, params)
      local template = join({
        'I have the following code from {{filename}}:',
        '```{{filetype}} \n {{selection}} \n```',
        'Please respond by explaining the code above and keep the response concise and straightforward.',
      })
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.popup, agent, template)
    end,
  },
}
gpplugin.setup(config)

local keymap = {
  { '<leader>c', group = group },
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
            vim.cmd(cmd_prefix .. 'Agent ' .. selected_agent)
          end,
        },
      })
    end,
    desc = 'select an agent',
  },
  {
    '<leader>cc',
    function()
      vim.cmd(cmd_prefix .. 'ChatToggle')
    end,
    desc = 'toggle chat',
  },
  {
    '<leader>cn',
    function()
      -- local agent = gpplugin.get_chat_agent('ChatGemini')
      local agent = gpplugin.get_chat_agent('ChatGemini2')
      -- local agent = gpplugin.get_chat_agent('ChatGPT4o-mini')
      new_chat(gpplugin, new_chat_params, false, prompt_chat_default, agent)
    end,
    desc = 'new chat',
  },
  {
    '<leader>cD',
    function()
      vim.cmd(cmd_prefix .. 'ChatDelete')
    end,
    desc = 'delete chat',
  },
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
    '<leader>cN',
    function()
      vim.cmd(cmd_prefix .. 'NextAgent')
    end,
    desc = 'next agent',
  },
  -- s = utils.vim_cmd('GpWhisper', 'speech to text'),
  ---javascript react and nodejs
  {
    '<leader>cJ',
    function()
      local agent = gpplugin.get_chat_agent('ChatClaudeSonnet')
      new_chat(gpplugin, new_chat_params, false, prompt_javascript, agent)
    end,
    desc = '#topic: JS/TS',
  },
  ---python
  {
    '<leader>cY',
    function()
      local agent = gpplugin.get_chat_agent('ChatClaudeSonnet')
      new_chat(gpplugin, new_chat_params, false, prompt_python, agent)
    end,
    desc = '#topic: python',
  },
  ---php and laravel
  {
    '<leader>cP',
    function()
      local agent = gpplugin.get_chat_agent('ChatClaudeSonnet')
      new_chat(gpplugin, new_chat_params, false, prompt_laravel, agent)
    end,
    desc = '#topic: laravel',
  },
  ---tailwind
  {
    '<leader>cS',
    function()
      local agent = gpplugin.get_chat_agent('ChatClaudeSonnet')
      new_chat(
        gpplugin,
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for frontend development with tailwind, no need to setup tailwind, just response with the code.',
          prompt_code_block_only,
        }),
        agent
      )
    end,
    desc = '#topic: tailwind',
  },
  ---neovim and lua
  {
    '<leader>cL',
    function()
      local agent = gpplugin.get_chat_agent('ChatClaudeSonnet')
      new_chat(
        gpplugin,
        new_chat_params,
        false,
        join({
          'You are an AI working as a code editor for neovim, use lua instead of vimscript when possible.',
          prompt_code_block_only,
        }),
        agent
      )
    end,
    desc = '#topic: neovim',
  },
  -- Translator
  {
    '<leader>cT',
    function()
      local agent = gpplugin.get_chat_agent('TranslateAgent')
      new_chat(gpplugin, new_chat_params, false, translator_prompt, agent)
    end,
    desc = '#topic: translate',
  },
  -- etymologist
  {
    '<leader>cE',
    function()
      local agent = gpplugin.get_chat_agent('ChatGPT4o')
      new_chat(
        gpplugin,
        new_chat_params,
        false,
        [[
          I want you to act as a etymologist. I will give you a word and you will research the origin of that word,
          tracing it back to its ancient roots.
          You should also provide information on how the meaning of the word has changed over time, if applicable
        ]],
        agent
      )
    end,
    desc = '#topic: etymologist',
  },
  {
    '<leader>cH',
    function()
      local agent = gpplugin.get_chat_agent('ChatGPT4o')
      new_chat(
        gpplugin,
        new_chat_params,
        false,
        join({
          'I want you to act as a historian and an archaeologist',
        }),
        agent
      )
    end,
    desc = '#topic: history',
  },
  ----------------------------------------------------------------------------
  --- Visual mode below
  ----------------------------------------------------------------------------
  { '<leader>c', group = group, mode = 'v' },
  {
    '<leader>cn',
    wrapGpCmd('ChatNew'),
    desc = 'visual new chat',
    mode = 'v',
  },
  {
    '<leader>cr',
    wrapGpCmd('Rewrite'),
    desc = 'prompt to rewrite',
    mode = 'v',
  },
  {
    '<leader>cd',
    wrapGpCmd('Dev'),
    desc = 'select to dev',
    mode = 'v',
  },
  {
    '<leader>ce',
    wrapGpCmd('Explain'),
    desc = 'explain selected',
    mode = 'v',
  },
}

return keymap
