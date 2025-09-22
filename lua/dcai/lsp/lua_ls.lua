local common_on_attach = require('dcai.lsp.utils').common_on_attach

local capabilities = require('blink.cmp').get_lsp_capabilities()
local function plugin_path(plugin_name)
  local path = string.format('%s/plug/%s/lua', vim.g.data_dir, plugin_name)
  return path
end

local lua_workspace_libs = {
  checkThirdParty = false,

  ---- loads all runtime lua files
  -- library = vim.api.nvim_get_runtime_file('', true),

  --- so only load selected libs
  library = {
    vim.g.config_dir .. '/lua',
    -- vim.env.VIMRUNTIME .. '/lua',
    -- plugin_path('fzf-lua'),
  },
}

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
    },
  },
  on_init = function(client, _)
    -- client.server_capabilities.document_formatting = false
    -- client.server_capabilities.document_range_formatting = false
    local nvim_settings = {
      -- https://github.com/LuaLS/vscode-lua/blob/master/setting/schema.json
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      completion = {
        enable = true,
        callSnippet = 'Both', -- 'Disable' | 'Both' | 'Replace'
      },
      hint = {
        enable = false,
      },
      codeLens = {
        enable = false,
      },
      format = {
        enable = false,
      },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim', 'hs' },
        enable = true,
      },
      workspace = lua_workspace_libs,
    }
    client.config.settings.Lua =
      vim.tbl_deep_extend('force', client.config.settings.Lua, nvim_settings)
  end,
  on_attach = common_on_attach,
})

vim.lsp.enable('lua_ls')
