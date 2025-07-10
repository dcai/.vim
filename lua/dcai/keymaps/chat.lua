local group = 'chat'

local loaded_gpplugin, gpplugin = pcall(require, 'gp')
local loaded_cc = pcall(require, 'codecompanion')
if (not loaded_gpplugin) and not loaded_cc then
  return {
    { '<leader>c', group = group },
  }
end

require('dcai.llm.codecompanion').setup()

local prompt_library = require('dcai.llm.prompt_library')

local gpconfig = require('dcai.llm.gpconfig')
local gpinstance = gpconfig.setup()
local gp_cmd_prefix = gpconfig.prefix
local completion_engine = os.getenv('NVIM_COMPLETION_ENGINE')
local use_copilot = false
if completion_engine == 'copilot' then
  use_copilot = true
end

local function wrapVisualModeCmd(cmd)
  return ":<c-u>'<,'>" .. cmd .. '<cr>'
end

local keymap = {
  { '<leader>c', group = group },
  -- {
  --   '<leader>ca',
  --   function()
  --     local enabled = {}
  --     for key, _ in pairs(gpplugin.agents) do
  --       table.insert(enabled, key)
  --     end
  --     require('fzf-lua').fzf_exec(enabled, {
  --       actions = {
  --         default = function(selected, _)
  --           local selected_agent = selected[1]
  --           vim.cmd(gp_cmd_prefix .. 'Agent ' .. selected_agent)
  --         end,
  --       },
  --     })
  --   end,
  --   desc = 'select an agent',
  -- },
  {
    '<leader>cg',
    function()
      -- if use_copilot then
      --   vim.cmd('CopilotChatToggle')
      -- else
      --   -- vim.cmd(gp_cmd_prefix .. 'ChatToggle vsplit')
      --   -- vim.cmd('CodeCompanionActions')
      -- end
      local agent = gpplugin.get_chat_agent(
        -- gpconfig.agents.copilot
        -- use_copilot and gpconfig.agents.copilot or gpconfig.agents.coder_chat
        gpconfig.agents.grok_v4
      )
      gpinstance.new_chat({
        args = 'vsplit',
      }, false, prompt_library.BASE_PROMPT_GENERAL, agent)
    end,
    desc = 'gp.nvim',
  },
  {
    '<leader>cc',
    function()
      vim.cmd('CodeCompanionActions')
    end,
    desc = 'CodeCompanion',
  },
  {
    '<leader>cv',
    function()
      -- -- local agent = gpplugin.get_chat_agent('grok-3-latest')
      -- -- local agent = gpplugin.get_chat_agent('grok-3-mini-beta')
      -- local agent = gpplugin.get_chat_agent(gpconfig.agents.coder_chat)
      -- gpinstance.new_chat({
      --   args = 'vsplit',
      -- }, false, prompt_library.NEOVIM_PROMPT, agent)
      require('codecompanion').prompt('neovim')
    end,
    desc = 'ask neovim topic',
  },
  -- {
  --   '<leader>cn',
  --   function()
  --     vim.cmd('CodeCompanionActions')
  --     -- local agent = gpplugin.get_chat_agent(default_chat_agent)
  --     -- gpinstance.new_chat(
  --     --   {},
  --     --   false,
  --     --   'You are a helpful assistant. Provide clear, brief, and precise responses.',
  --     --   agent
  --     -- )
  --   end,
  --   desc = 'new chat',
  -- },
  -- {
  --   '<leader>cD',
  --   function()
  --     vim.cmd(gp_cmd_prefix .. 'ChatDelete')
  --   end,
  --   desc = 'delete chat',
  -- },
  {
    '<leader>cF',
    function()
      local fzf = require('fzf-lua')
      fzf.grep({
        winopts = {
          preview = {
            hidden = 'nohidden',
          },
        },
        multiprocess = true,
        cwd = gpconfig.chatlogs_home,
        -- query = '# topic',
        search = '# topic',
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
  -- s = utils.vim_cmd('GpWhisper', 'speech to text'),
  ----------------------------------------------------------------------------
  --- Visual mode below
  ----------------------------------------------------------------------------
  { '<leader>c', group = group, mode = 'v' },
  {
    '<leader>cc',
    ":<c-u>'<,'>CodeCompanionActions<cr>",
    desc = 'Code Companion Actions',
    mode = 'v',
  },
  {
    '<leader>cd',
    wrapVisualModeCmd('GpDo'),
    desc = 'GpDo',
    mode = 'v',
  },
  {
    '<leader>cn',
    wrapVisualModeCmd('GpChatNew'),
    desc = 'visual new chat',
    mode = 'v',
  },
  {
    '<leader>cr',
    wrapVisualModeCmd('GpRewrite'),
    desc = 'prompt to rewrite',
    mode = 'v',
  },
  {
    '<leader>cu',
    wrapVisualModeCmd('GpUnitTests'),
    desc = 'create unit tests',
    mode = 'v',
  },
  {
    '<leader>ce',
    wrapVisualModeCmd('GpExplain'),
    desc = 'explain selected',
    mode = 'v',
  },
}

return keymap
