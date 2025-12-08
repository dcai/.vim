local M = {}
M.setup = function()
  vim.lsp.set_log_level(vim.log.levels.ERROR)
  local mylsputils = require('dcai.lsp.utils')
  local root_pattern = vim.g.root_pattern

  local mason = require('mason')

  mason.setup({
    install_root_dir = vim.fs.joinpath(vim.g.data_dir, 'mason'),
  })

  vim.lsp.config('biome', {
    cmd = function(dispatchers, config)
      local cmd = 'biome'
      local local_cmd = (config or {}).root_dir
        and config.root_dir .. '/node_modules/.bin/biome'
      if local_cmd and vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
      return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
    end,
    workspace_required = true,
    root_markers = {
      'package.json',
      'tsconfig.json',
      'jsconfig.json',
      '.git',
    },
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
  vim.lsp.enable('biome')

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_loaded, blinkcmp = pcall(require, 'blink.cmp')
  if cmp_loaded then
    capabilities = blinkcmp.get_lsp_capabilities()
  end
  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- -- php
  -- vim.lsp.config('phpactor', {
  --   capabilities = capabilities,
  --   on_attach = mylsputils.common_on_attach,
  --   init_options = {
  --     ['language_server_phpstan.enabled'] = false,
  --     ['language_server_psalm.enabled'] = false,
  --   },
  --   root_dir = function(startpath)
  --     local root = root_pattern({
  --       'composer.lock',
  --       '.editorconfig',
  --       '.phpactor.json',
  --       '.phpactor.yml',
  --     })(startpath)
  --     return root
  --   end,
  -- })

  -- -- swift
  -- vim.lsp.config('sourcekit', {
  --   cmd = {
  --     '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp',
  --     '-Xswiftc',
  --     '-sdk',
  --     '-Xswiftc',
  --     -- get this form `xcrun --sdk iphonesimulator --show-sdk-path`
  --     '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk',
  --     '-Xswiftc',
  --     '-target',
  --     '-Xswiftc',
  --     -- use `generate-triple.sh` script to generate
  --     'arm64-apple-ios18.5-simulator',
  --   },
  --   on_attach = mylsputils.common_on_attach,
  --   capabilities = {
  --     workspace = {
  --       didChangeWatchedFiles = {
  --         dynamicRegistration = true,
  --       },
  --     },
  --     textDocument = {
  --       diagnostic = {
  --         dynamicRegistration = true,
  --         relatedDocumentSupport = true,
  --       },
  --     },
  --   },
  -- })
  -- vim.lsp.enable('sourcekit')

  vim.lsp.config('vimls', {
    cmd = { 'vim-language-server', '--stdio' },
    capabilities = capabilities,
    on_attach = mylsputils.common_on_attach,
    filetypes = { 'vim' },
    root_markers = { 'vimrc', '.git' },
    init_options = {
      isNeovim = true,
      iskeyword = '@,48-57,_,192-255,-#',
      vimruntime = '',
      runtimepath = '',
      diagnostic = { enable = true },
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 3,
        projectRootPatterns = {
          'runtime',
          'nvim',
          '.git',
          'autoload',
          'plugin',
        },
      },
      suggest = { fromVimruntime = true, fromRuntimepath = true },
    },
  })
  vim.lsp.enable('vimls')
  if vim.fn.executable('go') == 1 then
    -- vim.lsp.config.gopls =
    --   vim.tbl_deep_extend('force', vim.lsp.config.gopls or {}, {
    --     capabilities = capabilities,
    --     on_attach = mylsputils.common_on_attach,
    --   })
    -- vim.lsp.enable('gopls')
  end
  vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    on_attach = mylsputils.common_on_attach,
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' },
  })
  vim.lsp.enable('bashls')
  require('dcai.lsp.lua_ls')
  require('dcai.lsp.ts_ls')
  require('dcai.lsp.pyright')
  require('dcai.lsp.tailwindcss')
  require('dcai.lsp.dgnostics')
end

return M
