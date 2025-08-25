local jsonfixer = { os.getenv('JSONFIXER') or 'prettier' }
local jsfixer = { os.getenv('JSFIXER') or 'prettier' }
local cssfixer = { os.getenv('CSSFIXER') or 'prettier' }

vim.g.ale_fixers = {
  ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
  c = { 'clang-format' },
  cpp = { 'clang-format' },
  cs = { 'clang-format' },
  css = cssfixer,
  caddyfile = { 'caddy' },
  dokuwiki = { 'plaintext' },
  elixir = { 'mix_format' },
  heex = { 'mix_format' },
  fish = { 'fish_indent' },
  go = { 'goimports', 'gofmt' },
  graphql = { 'prettier' },
  html = { 'prettier' },
  hurl = { 'hurlfmt' },
  gotmpl = { 'prettier' },
  templ = { 'templ' },
  java = { 'clang-format' },
  javascript = jsfixer,
  javascriptreact = jsfixer,
  json = jsonfixer,
  json5 = jsonfixer,
  jsonc = jsonfixer,
  less = { 'prettier' },
  lua = { 'stylua' },
  markdown = { 'prettier' },
  php = { 'php_cs_fixer' },
  python = { 'ruff', 'ruff_format' },
  rust = { 'rustfmt' },
  ruby = { 'rubyfmt' },
  sh = { 'shfmt' },
  svelte = { 'prettier' },
  sql = { 'pgformatter' },
  swift = { 'appleswiftformat' },
  terraform = { 'terraform' },
  typescript = jsfixer,
  typescriptreact = jsfixer,
  vue = { 'prettier' },
  xml = { 'xmllint' },
  yaml = { 'prettier' },
}

vim.g.ale_completion_enabled = 0
vim.g.ale_disable_lsp = 'auto'
vim.g.ale_hover_cursor = 0
vim.g.ale_virtualtext_cursor = 'disabled'
vim.g.ale_set_highlights = 1
vim.g.ale_sign_column_always = 1
vim.g.ale_lint_on_save = 1
vim.g.ale_lint_on_text_changed = 1
vim.g.ale_lint_on_enter = 0
vim.g.ale_set_loclist = 0
vim.g.ale_set_quickfix = 0
vim.g.ale_open_list = 0
vim.g.ale_php_cs_fixer_use_global = 1
vim.g.ale_php_cs_fixer_options = ''

vim.g.ale_lua_stylua_options = '--search-parent-directories'

vim.g.ale_sign_error = 'E'
vim.g.ale_sign_warning = 'W'
vim.g.ale_plaintext_pandoc_use_gfm = 1
vim.g.ale_plaintext_pandoc_options = '--columns=120'
vim.g.ale_xml_xmllint_indentsize = 4
vim.g.ale_cspell_use_global = 1
vim.g.ale_cspell_executable = 'cspell-cli'

vim.g.ale_javascript_eslint_suppress_missing_config = 1
vim.g.ale_javascript_eslint_use_global = 0
vim.g.ale_javascript_prettier_use_global = 0

vim.g.ale_python_ruff_use_global = 1
vim.g.ale_python_ruff_format_use_global = 1

vim.g.ale_biome_use_global = 1
vim.g.ale_biome_executable = 'biome'

local jslinter = { os.getenv('JSLINTER') or 'biome' }
vim.g.ale_linters = {
  c = { 'clangd', 'ccls' },
  cs = { 'csc' },
  go = { 'gopls' },
  graphql = {},
  javascript = jslinter,
  javascriptreact = jslinter,
  json = {},
  lua = {},
  markdown = {},
  php = {},
  python = { 'ruff' },
  rust = { 'analyzer', 'cargo' },
  sh = { 'shellcheck' },
  typescript = jslinter,
  typescriptreact = jslinter,
  vim = { 'vimls' },
  swift = {},
}
