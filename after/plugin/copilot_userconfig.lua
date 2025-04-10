local ok, copilot = pcall(require, 'copilot')
if not ok then
  return
end

copilot.setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = '[[',
      jump_next = ']]',
      accept = '<CR>',
      refresh = 'gr',
      open = '<M-CR>',
    },
    layout = {
      position = 'bottom', -- | top | left | right | horizontal | vertical
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = '<c-f>',
      accept_word = false,
      accept_line = false,
      next = '<c-n>',
      -- next = '<M-]>',
      -- prev = '<M-[>',
      -- dismiss = '<C-]>',
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ['.'] = false,
  },
  logger = {
    file = vim.fn.stdpath('log') .. '/copilot-lua.log',
    file_log_level = vim.log.levels.OFF,
    print_log_level = vim.log.levels.WARN,
    trace_lsp = 'verbose', -- "off" | "messages" | "verbose"
    trace_lsp_progress = true,
    log_lsp_messages = true,
  },
  copilot_node_command = 'node', -- Node.js version must be > 20
  workspace_folders = {},
  copilot_model = 'gpt-4o-copilot', -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
  root_dir = function()
    return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
  end,
  should_attach = function(_, _)
    if not vim.bo.buflisted then
      return false
    end

    if vim.bo.buftype ~= '' then
      return false
    end

    return true
  end,
  server = {
    type = 'nodejs', -- "nodejs" | "binary"
    -- type = 'binary', -- "nodejs" | "binary"
    custom_server_filepath = nil,
  },
  server_opts_overrides = {},
})

local chat_loaded, copilotchat = pcall(require, 'CopilotChat')

local os = vim.uv.os_uname().sysname
if os == 'Darwin' then
  os = 'macOS'
end

require('CopilotChat.config.prompts').COPILOT_INSTRUCTIONS.system_prompt =
  string.format(
    [[
You are a code-focused AI programming assistant that specializes in practical software engineering solutions.

Follow the user's requirements carefully & to the letter.
Keep your answers short and impersonal.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The user is working on a %s machine. Please respond with system specific commands if applicable.
You will receive code snippets that include line number prefixes - use these to maintain correct position references but remove them when generating output.

When presenting code changes:

1. For each change, first provide a header outside code blocks with format:
   [file:<file_name>](<file_path>) line:<start_line>-<end_line>

2. Then wrap the actual code in triple backticks with the appropriate language identifier.

3. Keep changes minimal and focused to produce short diffs.

4. Include complete replacement code for the specified line range with:
   - Proper indentation matching the source
   - All necessary lines (no eliding with comments)
   - No line number prefixes in the code

5. Address any diagnostics issues when fixing code.

6. If multiple changes are needed, present them as separate blocks with their own headers.
]],
    os
  )

if chat_loaded then
  copilotchat.setup({

    -- Shared config starts here (can be passed to functions at runtime and configured via setup function)

    system_prompt = 'COPILOT_INSTRUCTIONS', -- System prompt to use (can be specified manually in prompt via /).

    model = 'gpt-4o', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
    agent = 'copilot', -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
    context = nil, -- Default context or array of contexts to use (can be specified manually in prompt via #).
    sticky = nil, -- Default sticky prompt or array of sticky prompts to use at start of every new chat.

    temperature = 0.1, -- GPT result temperature
    headless = false, -- Do not write to chat buffer and use history (useful for using custom processing)
    stream = nil, -- Function called when receiving stream updates (returned string is appended to the chat buffer)
    callback = nil, -- Function called when full response is received (retuned string is stored to history)
    remember_as_sticky = true, -- Remember model/agent/context as sticky prompts when asking questions

    -- default selection
    -- see select.lua for implementation
    -- selection = function(source)
    --   return select.visual(source) or select.buffer(source)
    -- end,

    -- default window options
    window = {
      layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
      width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
      height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
      -- Options below only apply to floating windows
      relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
      border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
      row = nil, -- row position of the window, default is centered
      col = nil, -- column position of the window, default is centered
      title = 'Copilot Chat', -- title of chat window
      footer = nil, -- footer of chat window
      zindex = 1, -- determines if window is on top or below other floating windows
    },

    show_help = true, -- Shows help message as virtual lines when waiting for user input
    highlight_selection = true, -- Highlight selection
    highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
    references_display = 'virtual', -- 'virtual', 'write', Display references in chat as virtual text or write to buffer
    auto_follow_cursor = true, -- Auto-follow cursor in chat
    auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
    insert_at_end = false, -- Move cursor to end of buffer when inserting text
    clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

    -- Static config starts here (can be configured only via setup function)

    debug = false, -- Enable debug logging (same as 'log_level = 'debug')
    log_level = 'info', -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
    proxy = nil, -- [protocol://]host[:port] Use this proxy
    allow_insecure = true, -- Allow insecure server connections

    chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)

    log_path = vim.fn.stdpath('state') .. '/copilotchat/log',
    history_path = vim.fn.stdpath('state') .. '/copilotchat/history',

    question_header = '# User ', -- Header to use for user questions
    answer_header = '# Copilot ', -- Header to use for AI answers
    error_header = '# Error ', -- Header to use for errors
    separator = '───', -- Separator to use in chat

    -- default providers
    -- see config/providers.lua for implementation
    providers = {
      copilot = {},
      github_models = {},
      copilot_embeddings = {},
    },

    -- default contexts
    -- see config/contexts.lua for implementation
    contexts = {
      buffer = {},
      buffers = {},
      file = {},
      files = {},
      git = {},
      url = {},
      register = {},
      quickfix = {},
      system = {},
    },

    -- default prompts
    -- see config/prompts.lua for implementation
    prompts = {
      Explain = {
        prompt = 'Write an explanation for the selected code as paragraphs of text.',
        system_prompt = 'COPILOT_EXPLAIN',
      },
      Review = {
        prompt = 'Review the selected code.',
        system_prompt = 'COPILOT_REVIEW',
      },
      Fix = {
        prompt = 'There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.',
      },
      Optimize = {
        prompt = 'Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.',
      },
      Docs = {
        prompt = 'Please add documentation comments to the selected code.',
      },
      Tests = {
        prompt = 'Please generate tests for my code.',
      },
      Commit = {
        prompt = 'Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.',
        context = 'git:staged',
      },
    },

    -- default mappings
    -- see config/mappings.lua for implementation
    mappings = {
      complete = {
        insert = '<Tab>',
      },
      close = {
        normal = 'q',
        insert = '<C-c>',
      },
      reset = {
        normal = '<C-l>',
        insert = '<C-l>',
      },
      submit_prompt = {
        normal = '<CR>',
        insert = '<C-s>',
      },
      toggle_sticky = {
        normal = 'grr',
      },
      clear_stickies = {
        normal = 'grx',
      },
      accept_diff = {
        normal = '<C-y>',
        insert = '<C-y>',
      },
      jump_to_diff = {
        normal = 'gj',
      },
      quickfix_answers = {
        normal = 'gqa',
      },
      quickfix_diffs = {
        normal = 'gqd',
      },
      yank_diff = {
        normal = 'gy',
        register = '"', -- Default register to use for yanking
      },
      show_diff = {
        normal = 'gd',
        full_diff = false, -- Show full diff instead of unified diff when showing diff window
      },
      show_info = {
        normal = 'gi',
      },
      show_context = {
        normal = 'gc',
      },
      show_help = {
        normal = 'gh',
      },
    },
  })
end
