local M = {}
M.setup = function()
  vim.lsp.set_log_level(vim.log.levels.ERROR)
  local mylsputils = require('dcai.lspconfig.utils')
  local lspconfig = require('lspconfig')

  local lsputils = require('lspconfig/util')
  if mylsputils.support_native_lsp_config() then
    vim.lsp.enable('biome')
    vim.lsp.config('biome', {
      cmd = { 'biome', 'lsp-proxy' },
      filetypes = {
        'astro',
        'css',
        'graphql',
        'javascript',
        'javascriptreact',
        -- 'json',
        -- 'jsonc',
        'svelte',
        'typescript',
        'typescript.tsx',
        'typescriptreact',
        'vue',
      },
    })
  else
    vim.lsp.config('biome', {
      cmd = { 'biome', 'lsp-proxy' },
    })
  end

  local mason = require('mason')

  mason.setup({
    install_root_dir = vim.fs.joinpath(vim.g.data_dir, 'mason'),
  })

  local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
  local default_capabilities = vim.tbl_deep_extend(
    'force', -- force: use value from the rightmost map
    vim.lsp.protocol.make_client_capabilities(),
    cmp_capabilities
  )

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  local root_pattern = lspconfig.util.root_pattern

  vim.lsp.config('csharp_ls', {
    capabilities = default_capabilities,
    on_attach = mylsputils.common_on_attach,
  })

  vim.lsp.config('phpactor', {
    capabilities = default_capabilities,
    on_attach = mylsputils.common_on_attach,
    init_options = {
      ['language_server_phpstan.enabled'] = false,
      ['language_server_psalm.enabled'] = false,
    },
    root_dir = function(startpath)
      ---@diagnostic disable-next-line: undefined-field
      local cwd = vim.uv.cwd()
      -- local root = root_pattern('composer.json')(startpath)
      local root = root_pattern(
        'composer.lock',
        '.editorconfig',
        '.phpactor.json',
        '.phpactor.yml'
      )(startpath)
      -- prefer cwd if root is a descendant
      local result = lsputils.path.is_descendant(cwd, root) and cwd or root
      return result
    end,
  })

  -- cfg.templ.setup({
  --   on_attach = utils.common_on_attach,
  -- })
  --
  -- cfg.rust_analyzer.setup({
  --   on_attach = utils.common_on_attach,
  -- })
  --
  -- cfg.intelephense.setup({
  --   root_dir = function(startpath)
  --     local cwd = vim.uv.cwd()
  --     -- local root = root_pattern('composer.json')(startpath)
  --     local root = root_pattern('.editorconfig')(startpath)
  --     -- prefer cwd if root is a descendant
  --     local result = util.path.is_descendant(cwd, root) and cwd or root
  --     return result
  --   end,
  -- })
  --
  -- cfg.elixirls.setup({
  --   on_attach = utils.common_on_attach,
  -- })

  vim.lsp.config('sourcekit', {
    cmd = {
      '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp',
      '-Xswiftc',
      '-sdk',
      '-Xswiftc',
      -- get this form `xcrun --sdk iphonesimulator --show-sdk-path`
      '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk',
      '-Xswiftc',
      '-target',
      '-Xswiftc',
      -- use `generate-triple.sh` script to generate
      'arm64-apple-ios18.5-simulator',
    },
    on_attach = mylsputils.common_on_attach,
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
      textDocument = {
        diagnostic = {
          dynamicRegistration = true,
          relatedDocumentSupport = true,
        },
      },
    },
  })

  vim.lsp.config('nushell', {})
  vim.lsp.config('tailwindcss', {})
  vim.lsp.config('vimls', {
    capabilities = default_capabilities,
    on_attach = mylsputils.common_on_attach,
  })
  if vim.fn.executable('go') == 1 then
    vim.lsp.config('gopls', {
      capabilities = default_capabilities,
      on_attach = mylsputils.common_on_attach,
    })
  end
  vim.lsp.config('bashls', {
    on_attach = mylsputils.common_on_attach,
  })
  require('dcai.lspconfig.lua_ls')
  require('dcai.lspconfig.ts_ls')
  require('dcai.lspconfig.pyright')
  require('dcai.lspconfig.dgnostics')
end

return M
