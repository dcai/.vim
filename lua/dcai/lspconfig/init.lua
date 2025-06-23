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
    lspconfig.biome.setup({
      cmd = { 'biome', 'lsp-proxy' },
    })
  end

  local mason = require('mason')
  -- local mason_lspconfig = require('mason-lspconfig')

  mason.setup({
    install_root_dir = vim.fs.joinpath(vim.g.data_dir, 'mason'),
  })

  -- mason_lspconfig.setup({
  --   ensure_installed = {
  --     'biome',
  --     'bashls',
  --     'lua_ls',
  --     'pyright',
  --     'ts_ls',
  --     'vimls',
  --   },
  --   automatic_installation = false,
  -- })

  require('lspconfig.ui.windows').default_options.border = 'single'

  local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
  -- local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
    'force', -- force: use value from the rightmost map
    lspconfig.util.default_config.capabilities,
    cmp_capabilities
  )

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  local root_pattern = lspconfig.util.root_pattern

  lspconfig.csharp_ls.setup({
    on_attach = mylsputils.common_on_attach,
  })

  lspconfig.phpactor.setup({
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

  lspconfig.sourcekit.setup({
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

  lspconfig.nushell.setup({})
  lspconfig.tailwindcss.setup({})
  lspconfig.vimls.setup({
    on_attach = mylsputils.common_on_attach,
  })
  if vim.fn.executable('go') == 1 then
    lspconfig.gopls.setup({
      on_attach = mylsputils.common_on_attach,
    })
  end
  lspconfig.bashls.setup({
    on_attach = mylsputils.common_on_attach,
  })
  require('dcai.lspconfig.lua_ls')
  require('dcai.lspconfig.ts_ls')
  require('dcai.lspconfig.pyright')
  require('dcai.lspconfig.dgnostics')
end

return M
