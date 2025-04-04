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
      vim.g.logger.debug("not attaching, buffer is not 'buflisted'")
      return false
    end

    if vim.bo.buftype ~= '' then
      vim.g.logger.debug(
        "not attaching, buffer 'buftype' is " .. vim.bo.buftype
      )
      return false
    end
    -- vim.g.logger.debug('should attach')

    return true
  end,
  server = {
    -- type = 'nodejs', -- "nodejs" | "binary"
    type = 'binary', -- "nodejs" | "binary"
    custom_server_filepath = nil,
  },
  server_opts_overrides = {},
})
