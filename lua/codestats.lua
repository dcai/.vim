-- local languages = require('codestats.languages')
local curl = require('plenary.curl')
local languages = {
  ['vim-plug'] = 'Vim-fu',
  ada = 'Ada',
  ansible = 'Ansible',
  ansible_hosts = 'Ansible',
  ansible_template = 'Ansible',
  c = 'C/C++',
  clojure = 'Clojure',
  cmake = 'CMake',
  coffee = 'CoffeeScript',
  cpp = 'C/C++',
  cs = 'C#',
  css = 'CSS',
  dart = 'Dart',
  diff = 'Diff',
  eelixir = 'HTML (EEx)',
  elixir = 'Elixir',
  elm = 'Elm',
  erlang = 'Erlang',
  fish = 'Shell Script (fish)',
  fsharp = 'F#',
  gitcommit = 'Git Commit Message',
  gitconfig = 'Git Config',
  gitrebase = 'Git Rebase Message',
  glsl = 'GLSL',
  go = 'Go',
  haskell = 'Haskell',
  html = 'HTML',
  htmldjango = 'HTML (Django)',
  jade = 'Pug (Jade)',
  java = 'Java',
  javascript = 'JavaScript',
  javascriptreact = 'JavaScript',
  json = 'JSON',
  jsp = 'JSP',
  jsx = 'JavaScript (JSX)',
  kotlin = 'Kotlin',
  lua = 'Lua',
  markdown = 'Markdown',
  netrw = 'Vim-fu',
  objc = 'Objective-C',
  objcpp = 'Objective-C++',
  ocaml = 'OCaml',
  pascal = 'Pascal',
  perl = 'Perl',
  perl6 = 'Perl 6',
  pgsql = 'SQL (PostgreSQL)',
  php = 'PHP',
  plain_text = 'Plain text',
  plsql = 'PL/SQL',
  pug = 'Pug (Jade)',
  puppet = 'Puppet',
  purescript = 'PureScript',
  python = 'Python',
  ruby = 'Ruby',
  rust = 'Rust',
  scala = 'Scala',
  scheme = 'Scheme',
  scss = 'SCSS',
  sh = 'Shell Script',
  snippets = 'ultisnips snippet',
  sql = 'SQL',
  sqloracle = 'SQL (Oracle)',
  tcl = 'Tcl',
  tcsh = 'Shell Script (tcsh)',
  tex = 'TeX',
  toml = 'TOML',
  typescript = 'TypeScript',
  typescriptreact = 'TypeScript',
  vb = 'Visual Basic',
  vbnet = 'Visual Basic .NET',
  vim = 'VimL',
  yaml = 'YAML',
  zsh = 'Shell Script (Zsh)',
}

local CODESTATS_API_URL = os.getenv('CODESTATS_API_URL')
  or 'https://codestats.net/api'
local CODESTATS_API_KEY = os.getenv('CODESTATS_API_KEY')

local xp_table = {}

local function gather_xp(filetype, xp_amount)
  log.info(string.format('gather_xp: %s: %d', filetype, xp_amount))
  if filetype:gsub('%s+', '') == '' then
    filetype = 'plain_text'
  end

  xp_table[filetype] = (xp_table[filetype] or 0) + xp_amount
end

local function pulse()
  log.info('pulse():', vim.inspect(xp_table))
  if next(xp_table) == nil then
    return
  end

  local time = os.date('%Y-%m-%dT%T%z')
  local xps_table = {}
  for filetype, xp in pairs(xp_table) do
    table.insert(
      xps_table,
      { language = languages[filetype] or filetype, xp = xp }
    )
  end
  local body = {
    coded_at = time,
    xps = xps_table,
  }
  log.info('Pulsing: body: ', vim.inspect(body))
  local response = curl.post({
    url = CODESTATS_API_URL .. '/my/pulses',
    body = vim.fn.json_encode(body),
    headers = {
      ['X-API-Token'] = CODESTATS_API_KEY,
      ['Content-Type'] = 'application/json',
    },
  })

  local status = response.status
  if status == 200 or status == 201 then
    log.info('Pulsed', response.body)
    xp_table = {}
  else
    log.info('Pulsed failed', vim.inspect(response))
  end
end

return {
  setup = function()
    vim.api.nvim_create_user_command('CodestatsInfo', function()
      log.info('codestats: xp_table: ', vim.inspect(xp_table))
    end, { nargs = 0, desc = 'log xp_table' })
    vim.api.nvim_create_user_command('CodestatsPulse', function()
      pulse()
    end, { nargs = 0 })
    if isempty(CODESTATS_API_KEY) then
      return
    end
    vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
      callback = function()
        pulse()
      end,
    })
    vim.api.nvim_create_autocmd(
      { 'TextChanged', 'InsertCharPre', 'InsertEnter' },
      {
        callback = function()
          gather_xp(vim.api.nvim_buf_get_option(0, 'filetype'), 1)
        end,
      }
    )
  end,
}
