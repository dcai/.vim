local MiniTest = require('mini.test')
local T, child = dofile('tests/helpers.lua').new_set()

local function setup(with_codecompanion)
  vim.cmd.packadd({ 'blink.cmp', bang = true })
  if with_codecompanion then
    vim.cmd.packadd({ 'plenary.nvim', bang = true })
    vim.cmd.packadd({ 'codecompanion.nvim', bang = true })
  else
    package.preload['codecompanion'] = function()
      error('CodeCompanion is not installed')
    end
  end
  require('dcai.completion').setup()
end

T['CodeCompanion provider exists before entering insert mode'] = function()
  child.lua_func(setup, true)
  MiniTest.expect.equality(
    child.lua_get([[
    require('blink.cmp.config').sources.providers.codecompanion.module
  ]]),
    'codecompanion.providers.completion.blink'
  )

  -- Use the real provider lookup and InsertEnter callbacks on a scratch buffer.
  child.lua([[
    vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(false, true))
    local sources = require('blink.cmp.sources.lib')
    sources.get_enabled_providers()
    vim.v.errmsg = ''
  ]])
  child.type_keys('o')
  child.lua('vim.wait(100)')
  MiniTest.expect.equality(child.lua_get('vim.v.errmsg'), '')
end

T['completion works without CodeCompanion installed'] = function()
  child.lua_func(setup, false)
  MiniTest.expect.equality(
    child.lua_get([[
    require('blink.cmp.config').sources.default
  ]]),
    { 'lsp', 'path', 'snippets', 'buffer' }
  )
  MiniTest.expect.equality(
    child.lua_get([[
    require('blink.cmp.config').sources.providers.codecompanion == nil
  ]]),
    true
  )
  child.lua("require('blink.cmp.sources.lib').get_enabled_providers()")
end

return T
