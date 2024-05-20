local curl = require('plenary.curl')

local logger = require('log').setup({
  plugin = 'codestats',
})

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
  json5 = 'JSON',
  jsp = 'JSP',
  jsx = 'JavaScript',
  kotlin = 'Kotlin',
  lua = 'Lua',
  markdown = 'Markdown',
  netrw = 'Vim-fu',
  fugitive = 'Vim-fu',
  fugitiveblame = 'Vim-fu',
  ['ale-info'] = 'Vim-fu',
  startuptime = 'Vim-fu',
  dbout = 'Vim-fu',
  checkhealth = 'Vim-fu',
  ['dbui'] = 'Vim-fu',
  objc = 'Objective-C',
  objcpp = 'Objective-C++',
  ocaml = 'OCaml',
  pascal = 'Pascal',
  perl = 'Perl',
  perl6 = 'Perl 6',
  pgsql = 'SQL (PostgreSQL)',
  php = 'PHP',
  text = 'Plain text',
  help = 'Plain text',
  plsql = 'PL/SQL',
  pug = 'Pug (Jade)',
  puppet = 'Puppet',
  purescript = 'PureScript',
  python = 'Python',
  ruby = 'Ruby',
  rust = 'Rust',
  nu = 'Nushell',
  scala = 'Scala',
  scheme = 'Scheme',
  scss = 'SCSS',
  sh = 'Shell Script',
  snippets = 'ultisnips snippet',
  sql = 'SQL',
  sqloracle = 'SQL (Oracle)',
  tcl = 'Tcl',
  templ = 'Templ', -- https://templ.guide/
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

local function isempty(s)
  return s == nil or s == ''
end

local CODESTATS_API_URL = 'https://codestats.net/api'
if not isempty(os.getenv('CODESTATS_API_URL')) then
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
  print('codestats: profile: ', vim.inspect(json))
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
  local response = curl.post({
    url = CODESTATS_API_URL .. '/my/pulses',
    body = vim.fn.json_encode(body),
    headers = {
      ['X-API-Token'] = CODESTATS_API_KEY,
      ['Content-Type'] = 'application/json',
    },
    callback = vim.schedule_wrap(function(response)
      local status = response.status
      if status == 200 or status == 201 then
        xp_table = {}
        logger.info('Pulsed: body sent:', body)
        logger.info('Pulsed: response body', response.body)
      else
        logger.error('Pulsed failed', response)
      end
    end),
  })
end

local M = {}
local timer = vim.uv.new_timer()

function M.setup()
  vim.api.nvim_create_user_command('CSProfile', function(opts)
    local username = opts.fargs[1]
    if isempty(username) then
      logger.warn('provide codestats public username')
      return
    end
    myprofile(username)
  end, { nargs = '*' })
  vim.api.nvim_create_user_command('CSInfo', function()
    print('codestats: xp_table: ', vim.inspect(xp_table))
  end, { nargs = 0, desc = 'log xp_table' })
  vim.api.nvim_create_user_command('CSPulse', function()
    pulse()
  end, { nargs = 0 })
  if isempty(CODESTATS_API_KEY) then
    return
  end

  local timer_waitfor = 1000 -- wait for 1 sec
  local interval = 30000 -- every 30 sec
  timer:start(
    timer_waitfor,
    interval,
    vim.schedule_wrap(function()
      pulse()
    end)
  )

  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    callback = function()
      pulse()
    end,
  })
  vim.api.nvim_create_autocmd(
    { 'CursorMoved', 'TextChanged', 'InsertCharPre', 'InsertEnter' },
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
