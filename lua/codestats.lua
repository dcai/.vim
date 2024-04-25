local curl = require('plenary.curl')

local languages = {
  ada = 'Ada',
  ansible = 'Ansible',
  ansible_hosts = 'Ansible',
  ansible_template = 'Ansible',
  c = 'C',
  clojure = 'Clojure',
  cmake = 'CMake',
  coffee = 'CoffeeScript',
  cpp = 'C++',
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
  jsx = 'JavaScript',
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
  text = 'text',
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
  templ= 'Templ', -- https://templ.guide/
  tcsh = 'Shell Script (tcsh)',
  tex = 'TeX',
  toml = 'TOML',
  typescript = 'TypeScript',
  typescriptreact = 'TypeScript',
  tsx = 'TypeScript',
  vb = 'Visual Basic',
  vbnet = 'Visual Basic .NET',
  vim = 'VimL',
  yaml = 'YAML',
  zsh = 'Shell Script (Zsh)',
}

local CODESTATS_API_URL = 'https://codestats.net/api'
if os.getenv('CODESTATS_API_URL') then
  CODESTATS_API_URL = os.getenv('CODESTATS_API_URL')
end
local CODESTATS_API_KEY = os.getenv('CODESTATS_API_KEY')

local xp_table = {}

local function gather_xp(filetype, xp_amount)
  if filetype:gsub('%s+', '') == '' then
    filetype = 'text'
  end
  xp_table[filetype] = (xp_table[filetype] or 0) + xp_amount
end

local function myprofile(username)
  local response = curl.get({
    url = string.format('%s/users/%s', CODESTATS_API_URL, username),
    headers = {
      ['Content-Type'] = 'application/json',
    },
  })
  local json = vim.json.decode(response.body)
  log.info('codestats: profile: ', vim.inspect(json))
end

local function pulse()
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
  log.info('Pulsing: request body: ', vim.inspect(body))
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
    log.error('Pulsed failed', vim.inspect(response))
  end
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command('CSProfile', function(opts)
    local username = opts.fargs[1]
    if isempty(username) then
      log.warn('provide codestats public username')
      return
    end
    myprofile(username)
  end, { nargs = '*' })
  vim.api.nvim_create_user_command('CSInfo', function()
    log.info('codestats: xp_table: ', vim.inspect(xp_table))
  end, { nargs = 0, desc = 'log xp_table' })
  vim.api.nvim_create_user_command('CSPulse', function()
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
    { 'CursorMoved', 'BufEnter', 'TextChanged', 'InsertCharPre', 'InsertEnter' },
    {
      callback = function()
        -- local currentbuf = 0
        -- local ft = vim.api.nvim_buf_get_option(currentbuf, 'filetype')
        local ft = vim.bo.filetype
        gather_xp(ft, 1)
      end,
    }
  )
end

return M
