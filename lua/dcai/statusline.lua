---@diagnostic disable: unused-function, unused-local
local SPC = ' '
local SEP = '%='
-- Restore normal highlight with %* or %0*.
local COLOR_RESET = '%0*'
local COLOR_USER_1 = '%1*'
local COLOR_USER_3 = '%3*'
local COLOR_STL_ACCENT = '%#StatusLineAccent#'
local COLOR_STL_PRJ_ACCENT = '%#StatusLineProjectAccent#'
local COLOR_STL_HL = '%#StatusLineHighlight#'

local M = {}

local function pad(s)
  return s and SPC .. s .. SPC or SPC
end

local function lpad(s)
  return s and SPC .. s or SPC
end

local function rpad(s)
  return s and s .. SPC or SPC
end

local function color_accent(s)
  return s and COLOR_STL_ACCENT .. s .. COLOR_RESET or ''
end

local function color_project_accent(s)
  return s and COLOR_STL_PRJ_ACCENT .. s .. COLOR_RESET or ''
end

local function color_highlight(s)
  return s and COLOR_STL_HL .. s .. COLOR_RESET or ''
end

local function git_branch()
  local cmd =
    'git rev-parse --abbrev-ref HEAD 2>/dev/null | fold -w30 | head -n1'
  local branch = vim.fn.trim(vim.fn.system(cmd))
  local ret = branch and branch or 'NOT IN GIT'
  return lpad(color_highlight(ret))
end

local function current_buffer_name()
  return '%t'
  -- local fullpath = vim.fn.expand('%:p')
  -- local filemodified = ' %m'
  -- local readonly = '%r'
  -- local project_root = vim.g.git_root()
  -- local project_name = project_root and project_root:match('([^/]+)$') or 'N/A'
  -- local project_root_trimed = vim.g.replace(fullpath, vim.g.smart_root(), '')
  -- return color_project_accent('(' .. project_name .. ')')
  --   .. project_root_trimed
  --   .. filemodified
  --   .. readonly
end

local modes = {
  n = 'NORMAL',
  v = 'VISUAL',
  V = 'V·Line',
  ['\22'] = 'V·Block',
  i = 'INSERT',
  R = 'R',
  Rv = 'V·Replace',
  c = 'Command',
  t = 'Term',
  s = 'Select',
  S = 'Select',
}

local function current_mode()
  return color_accent(modes[vim.fn.mode()])
end

local function lineinfo()
  return color_accent('%l/%L')
end

local function percentage()
  return color_highlight('%3p%%')
end

local function column()
  return color_accent('%3v')
end

local function fileinfo()
  local filetype = '%y'
  local helpfile = '%h'
  return lpad(filetype .. helpfile)
end

local function filencoding()
  return table.concat({
    '[',
    vim.bo.fileformat,
    vim.g.isempty(vim.bo.fileencoding) and '' or '|' .. vim.bo.fileencoding,
    vim.bo.bomb and '|BOM' or '',
    ']',
  })
end

function StatuslineActive()
  local wide_enough = vim.fn.winwidth(0) > 100
  local sections = {}
  local function push(item)
    table.insert(sections, item)
  end

  if wide_enough then
    push(current_mode())
  end

  push(current_buffer_name())

  if wide_enough then
    push(SEP)
    push(lineinfo())
    push(percentage())
    push(column())
    push(fileinfo())
    push(filencoding())
    push(git_branch())
  end
  return table.concat(sections)
end

function StatuslineInactive(evt)
  return '%t'
end

M.setup = function()
  vim.cmd([[
      augroup Statusline
        au!
        autocmd BufEnter,BufLeave,WinResized,WinNew,WinEnter,WinClosed * setlocal statusline=%!v:lua.StatuslineActive()
        autocmd BufLeave,WinLeave * setlocal statusline=%!v:lua.StatuslineInactive()
      augroup END
    ]])

  -- XXX: autocommand below doesnt update mode correctly, try to fix this later
  -- vim.api.nvim_create_autocmd(
  --   { 'BufEnter', 'BufLeave', 'WinResized', 'WinNew', 'WinEnter', 'WinClosed' },
  --   {
  --     group = vim.api.nvim_create_augroup('Statusline', { clear = true }),
  --     pattern = '*',
  --     callback = function()
  --       vim.wo.statusline = BuildStatusline()
  --     end,
  --   }
  -- )
end

return M
