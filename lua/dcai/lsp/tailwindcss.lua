vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = {
        'class',
        'className',
        'class:list',
        'classList',
        'ngClass',
      },
      includeLanguages = {
        eelixir = 'html-eex',
        elixir = 'phoenix-heex',
        eruby = 'erb',
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
    },
  },
  before_init = function(_, config)
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.editor then
      config.settings.editor = {}
    end
    if not config.settings.editor.tabSize then
      config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  workspace_required = true,
  root_markers = {
    -- Generic
    'tailwind.config.js',
    'tailwind.config.cjs',
    'tailwind.config.mjs',
    'tailwind.config.ts',
    'postcss.config.js',
    'postcss.config.cjs',
    'postcss.config.mjs',
    'postcss.config.ts',
    -- Django
    'theme/static_src/tailwind.config.js',
    'theme/static_src/tailwind.config.cjs',
    'theme/static_src/tailwind.config.mjs',
    'theme/static_src/tailwind.config.ts',
    'theme/static_src/postcss.config.js',
    -- Fallback for tailwind v4, where tailwind.config.* is not required anymore
    '.git',
  },
  -- filetypes copied and adjusted from tailwindcss-intellisense
  filetypes = {
    -- html
    'astro',
    'clojure',
    'htmldjango',
    'elixir',
    'eruby', -- vim ft
    'haml',
    'handlebars',
    'html',
    'htmlangular',
    'heex',
    'liquid',
    'markdown',
    'php',
    'twig',
    -- css
    'css',
    'less',
    'sass',
    'scss',
    'stylus',
    -- js
    'javascript',
    'javascriptreact',
    'rescript',
    'typescript',
    'typescriptreact',
    -- mixed
    'vue',
    'svelte',
  },
})
vim.lsp.enable('tailwindcss')
