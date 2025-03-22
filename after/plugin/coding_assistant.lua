local neocodeium_loaded, neocodeium = pcall(require, 'neocodeium')

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.snippet.active({ direction = 1 }) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  else
    return '<Tab>'
  end
end, { expr = true })

-- vim.keymap.set('i', '<c-f>', neocodeium.accept)
vim.keymap.set({ 'i', 's' }, '<Tab>', function(...)
  local args = { ... }
  local active = vim.snippet.active({ direction = 1 })
  vim.g.logger.info('insert mode tab ' .. vim.inspect({ active = active }))
  if active then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  end
  if neocodeium_loaded then
    neocodeium.accept()
  end
end, { expr = true })

vim.keymap.set('i', '<c-n>', neocodeium.cycle_or_complete)

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
end

-- for Exafunction/codeium.nvim
local codeium_loaded, codeium = pcall(require, 'codeium')
if codeium_loaded then
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
    enable_chat = false,
    enable_local_search = false,
    enable_index_service = false,
    search_max_workspace_file_count = 5000,
  })
end
