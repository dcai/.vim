local SPC = ' '
local SEP = '%='
local COLOR_RESET = '%0*'
local COLOR_USER_1 = '%1*'
local COLOR_USER_3 = '%3*'
local COLOR_STL_ACCENT = '%#StatusLineAccent#'
local COLOR_STL_HL = '%#StatusLineHighlight#'

local M = {}
local function linter_status()
  if not vim.fn.exists(':ALEInfo') then
    return
  end
  local counts = vim.fn['ale#statusline#Count'](vim.fn.bufnr(''))
  local all_errors = counts.error + counts.style_error
  local all_non_errors = counts.total - all_errors

  return counts.total == 0 and 'OK'
    or string.format('%dW %dE', all_non_errors, all_errors)
end

local function pad(s)
  return s and ' ' .. s .. ' ' or SPC
end

local function lpad(s)
  return s and ' ' .. s or SPC
end

local function rpad(s)
  return s and s .. ' ' or SPC
end

local function color_accent(s)
  return COLOR_STL_ACCENT .. s .. COLOR_RESET
end
local function color_highlight(s)
  return COLOR_STL_HL .. s .. COLOR_RESET
end

local function git_branch()
  local cmd =
    'git rev-parse --abbrev-ref HEAD 2>/dev/null | fold -w30 | head -n1'
  local branch = vim.fn.trim(vim.fn.system(cmd))
  local ret = branch and branch or 'NOT IN GIT'
  return lpad(color_highlight(ret))
end

local function extract_after(path, substrings)
  for _, substring in ipairs(substrings) do
    local result = path:gsub('.*' .. substring .. '/', '')
    if result ~= path then
      return '@/' .. result
    end
  end
  return path
end

local function current_buffer()
  local fullpath = vim.fn.expand('%:~')
  local markers = { 'iris', 'packages', 'services' }
  local filemodified = ' %m'
  local readonly = '%r'
  return extract_after(fullpath, markers) .. filemodified .. readonly
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
}

local function currentmode()
  return rpad(color_accent(modes[vim.fn.mode()]))
end

local function lineinfo()
  return color_accent('[%l] / %L | Col: %c')
end

local function fileinfo()
  local filetype = '%y'
  local helpfile = '%h'
  return lpad(filetype .. helpfile)
end

local function filencoding()
  return table.concat({
    '[',
    '%{strlen(&fileencoding)?&fileencoding:"none"}|',
    '%{&fileformat}',
    '%{&bomb?"\\|BOM":""}',
    ']',
  })
end

function BuildStatusline()
  local wide_enough = vim.fn.winwidth(0) > 100
  local sections = {}
  local function push(item)
    table.insert(sections, item)
  end

  if wide_enough then
    push(currentmode())
  end

  push(current_buffer())
  push(SEP)

  if wide_enough then
    push(lineinfo())
    push(fileinfo())
    push(filencoding())
    push(git_branch())
  end
  -- vim.wo.statusline = table.concat(sections)
  return table.concat(sections)
end

M.setup = function()
  vim.cmd([[
      augroup Statusline
        au!
        autocmd BufEnter,BufLeave,WinResized,WinNew,WinEnter,WinClosed * setlocal statusline=%!v:lua.BuildStatusline()
      augroup END
    ]])
end

return M
