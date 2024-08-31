local neocodeium_loaded, neocodeium = pcall(require, 'neocodeium')
if neocodeium_loaded then
  neocodeium.setup({
    -- Enable NeoCodeium on startup
    enabled = true,
    -- Local file path to a custom Codeium server binary
    bin = nil,
    -- When set to `true`, autosuggestions are disabled.
    -- Use `require'neodecodeium'.cycle_or_complete()` to show suggestions manually
    manual = false,
    -- Information about the API server to use
    server = {
      -- API URL to use (for Enterprise mode)
      api_url = nil,
      -- Portal URL to use (for registering a user and downloading the binary)
      portal_url = nil,
    },
    -- Set to `false` to disable showing the number of suggestions label
    -- at the line column
    show_label = true,
    -- Set to `true` to enable suggestions debounce
    debounce = false,
    -- Maximum number of lines parsed from loaded buffers (current buffer always fully parsed)
    -- Set to `0` to disable parsing non-current buffers (may lower suggestion quality)
    -- Set it to `-1` to parse all lines
    max_lines = 10000,
    -- Set to `true` to disable some non-important messages, like "NeoCodeium: server started..."
    silent = true,
    -- Set to `false` to disable suggestions in buffers with specific filetypes
    filetypes = {
      ['.'] = false,
      gitcommit = false,
      gitrebase = false,
      help = false,
      markdown = false,
      text = false,
    },
  })
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

-- https://sourcegraph.com/cody
-- local cody_loaded, cody = pcall(require, 'sg')
-- if cody_loaded then
--   -- Sourcegraph configuration. All keys are optional
--   cody.setup({
--     enable_cody = true,
--     accept_tos = true,
--     download_binaries = true,
--     -- Pass your own custom attach function
--     --    If you do not pass your own attach function, then the following maps are provide:
--     --        - gd -> goto definition
--     --        - gr -> goto references
--     on_attach = function()
--       -- do nothing
--     end,
--   })
-- end
-- vim.cmd([[
--   let g:copilot_no_tab_map = v:true
--   imap <silent><script><expr> <c-f> copilot#Accept("\<CR>")
-- ]])

-- https://github.com/zbirenbaum/copilot.lua
-- local copilot_loaded, copilot = pcall(require, 'copilot')
-- if copilot_loaded then
--   copilot.setup({
--     panel = {
--       enabled = true,
--       auto_refresh = true,
--       keymap = {
--         jump_prev = '[[',
--         jump_next = ']]',
--         accept = '<CR>',
--         refresh = 'gr',
--         open = '<M-CR>',
--       },
--       layout = {
--         position = 'bottom', -- | top | left | right
--         ratio = 0.4,
--       },
--     },
--     suggestion = {
--       enabled = true,
--       auto_trigger = true,
--       debounce = 75,
--       keymap = {
--         accept = '<c-f>',
--         accept_word = false,
--         accept_line = false,
--         next = '<M-]>',
--         prev = '<M-[>',
--         dismiss = '<C-]>',
--       },
--     },
--     filetypes = {
--       yaml = false,
--       markdown = false,
--       help = false,
--       gitcommit = false,
--       gitrebase = false,
--       hgcommit = false,
--       svn = false,
--       cvs = false,
--       ['*'] = true,
--       ['.'] = false,
--     },
--     copilot_node_command = 'node', -- Node.js version must be > 18.x
--     server_opts_overrides = {},
--   })
-- end
