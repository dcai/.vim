-- for Exafunction/codeium.nvim
local codeium_loaded, codeium = pcall(require, 'codeium')

if not codeium_loaded then
  return
end

-- local virtualtext = require('codeium.virtual_text')
-- vim.keymap.set({ 'i', 's' }, '<c-n>', virtualtext.cycle_or_complete)

local cachedir = vim.g.cache_dir
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
  enable_cmp_source = false,
  enable_chat = true,
  enable_local_search = false,
  enable_index_service = false,
  search_max_workspace_file_count = 5000,
  virtual_text = {
    enabled = true,
    -- These are the defaults
    -- Set to true if you never want completions to be shown automatically.
    manual = false,
    -- A mapping of filetype to true or false, to enable virtual text.
    filetypes = {},
    -- Whether to enable virtual text of not for filetypes not specifically listed above.
    default_filetype_enabled = true,
    -- How long to wait (in ms) before requesting completions after typing stops.
    idle_delay = 75,
    -- Priority of the virtual text. This usually ensures that the completions appear on top of
    -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
    -- desired.
    virtual_text_priority = 65535,
    -- Set to false to disable all key bindings for managing completions.
    map_keys = true,
    -- The key to press when hitting the accept keybinding but no completion is showing.
    -- Defaults to \t normally or <c-n> when a popup is showing.
    accept_fallback = nil,
    -- Key bindings for managing completions in virtual text mode.
    key_bindings = {
      -- Accept the current completion.
      accept = '<c-f>',
      -- Accept the next word.
      accept_word = false,
      -- Accept the next line.
      accept_line = false,
      -- Clear the virtual text.
      clear = false,
      -- Cycle to the next completion.
      -- next = '<M-]>',
      next = '<c-n>',
      -- Cycle to the previous completion.
      -- prev = '<M-[>',
      prev = false,
    },
  },
})
