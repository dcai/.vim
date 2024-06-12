local neocodeium_loaded, neocodeium = pcall(require, 'neocodeium')
if neocodeium_loaded then
  neocodeium.setup()
  vim.keymap.set('i', '<c-f>', neocodeium.accept)
  vim.keymap.set('i', '<c-n>', neocodeium.cycle_or_complete)
end

-- for Exafunction/codeium.nvim
local codeium_loaded, codeium = pcall(require, 'codeium')
if codeium_loaded then
  local cachedir = vim.fn.stdpath('cache')
  codeium.setup({
    manager_path = cachedir .. '/codeium/manager_path',
    bin_path = cachedir .. '/codeium/bin',
    config_path = cachedir .. '/codeium/config.json',
    language_server_download_url = 'https://github.com',
    -- api = {
    --   host = 'server.codeium.com',
    --   port = '443',
    --   path = '/',
    --   portal_url = 'codeium.com',
    -- },
    -- enterprise_mode = nil,
    -- detect_proxy = nil,
    -- tools = {},
    -- wrapper = nil,
    enable_chat = false,
    enable_local_search = false,
    enable_index_service = false,
    search_max_workspace_file_count = 5000,
  })
end

local cody_loaded, cody = pcall(require, 'sg')
if cody_loaded then
  -- Sourcegraph configuration. All keys are optional
  cody.setup({
    enable_cody = true,
    accept_tos = true,
    download_binaries = true,
    -- Pass your own custom attach function
    --    If you do not pass your own attach function, then the following maps are provide:
    --        - gd -> goto definition
    --        - gr -> goto references
    on_attach = function()
      -- do nothing
    end,
  })
end
-- vim.cmd([[
--   let g:copilot_no_tab_map = v:true
--   imap <silent><script><expr> <c-f> copilot#Accept("\<CR>")
-- ]])

-- https://github.com/zbirenbaum/copilot.lua
local copilot_loaded, copilot = pcall(require, 'copilot')
if copilot_loaded then
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
        position = 'bottom', -- | top | left | right
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = '<c-f>',
        accept_word = false,
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
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
      ['*'] = true,
      ['.'] = false,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
  })
end
