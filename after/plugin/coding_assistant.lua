-- "  for Exafunction/codeium.vim
vim.g.codeium_enabled = true
vim.g.codeium_disable_bindings = 1
vim.g.codeium_no_map_tab = true
-- vim.g.codeium_log_file = stdpath('log') . '/codeium.vim.log'
-- imap <script><silent><nowait><expr> <C-f> codeium#Accept()
-- " imap <C-j> <Cmd>call codeium#CycleCompletions(1)<CR>
-- " imap <C-k> <Cmd>call codeium#CycleCompletions(-1)<CR>
-- " imap <C-x> <Cmd>call codeium#Clear()<CR>

local loaded, neocodeium = pcall(require, 'neocodeium')
if loaded then
  neocodeium.setup()
  vim.keymap.set('i', '<c-f>', neocodeium.accept)
  vim.keymap.set('i', '<c-f>', '<Cmd>call codeium#Clear()<CR>')
end

local codeium_loaded, codeium = pcall(require, 'codeium')
if codeium_loaded then
  local cachedir = vim.fn.stdpath('cache')
  -- for Exafunction/codeium.nvim
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
