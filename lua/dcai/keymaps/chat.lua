local group = 'chat'

local loaded, gpplugin = pcall(require, 'gp')
if not loaded then
  return {
    { '<leader>c', group = group },
  }
end

local gpconfig = require('dcai.llm.gpconfig')
local gpinstance = gpconfig.setup()
local gp_cmd_prefix = gpconfig.prefix
local default_chat_agent = gpconfig.default_llm

local keymap = {
  { '<leader>c', group = group },
  {
    '<leader>ca',
    function()
      local enabled = {}
      for key, _ in pairs(gpplugin.agents) do
        table.insert(enabled, key)
      end
      require('fzf-lua').fzf_exec(enabled, {
        actions = {
          default = function(selected, _)
            local selected_agent = selected[1]
            vim.cmd(gp_cmd_prefix .. 'Agent ' .. selected_agent)
          end,
        },
      })
    end,
    desc = 'select an agent',
  },
  {
    '<leader>cc',
    function()
      local completion_engine = os.getenv('NVIM_COMPLETION_ENGINE')
      if completion_engine == 'copilot' then
        vim.cmd('CopilotChatToggle')
      else
        vim.cmd(gp_cmd_prefix .. 'ChatToggle vsplit')
      end
    end,
    desc = 'chat toggle',
  },
  {
    '<leader>cd',
    function()
      vim.notify('AI working', vim.log.levels.INFO)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<esc>V', true, false, true),
        'n',
        true
      )
      vim.cmd('AiDev')
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<esc>', true, false, true),
        'n',
        true
      )
    end,
    desc = 'AiDev',
  },
  {
    '<leader>cn',
    function()
      local agent = gpplugin.get_chat_agent(default_chat_agent)
      gpinstance.new_chat(
        {},
        false,
        'You are a helpful assistant. Provide clear, brief, and precise responses.',
        agent
      )
    end,
    desc = 'new chat',
  },
  {
    '<leader>cD',
    function()
      vim.cmd(gp_cmd_prefix .. 'ChatDelete')
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
        cwd = gpconfig.chatlogs_home,
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
  -- s = utils.vim_cmd('GpWhisper', 'speech to text'),
  ----------------------------------------------------------------------------
  --- Visual mode below
  ----------------------------------------------------------------------------
  { '<leader>c', group = group, mode = 'v' },
  {
    '<leader>cn',
    gpconfig.wrapGpCmd('ChatNew'),
    desc = 'visual new chat',
    mode = 'v',
  },
  {
    '<leader>cr',
    gpconfig.wrapGpCmd('Rewrite'),
    desc = 'prompt to rewrite',
    mode = 'v',
  },
  {
    '<leader>cd',
    gpconfig.wrapGpCmd('Dev'),
    desc = 'select to dev',
    mode = 'v',
  },
  {
    '<leader>cu',
    gpconfig.wrapGpCmd('UnitTests'),
    desc = 'create unit tests',
    mode = 'v',
  },
  {
    '<leader>ce',
    gpconfig.wrapGpCmd('Explain'),
    desc = 'explain selected',
    mode = 'v',
  },
}

return keymap
