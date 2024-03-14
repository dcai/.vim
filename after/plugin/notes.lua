vim.g.notes_home = '~/Library/CloudStorage/Dropbox/Documents/txt'
local fzflua_loaded, fzflua = pcall(require, 'fzf-lua')

local note_today = function()
  return os.date('%Y%m%d')
end

local note_now = function()
  return os.date('%Y-%m-%d %H:%M')
end

local note_insert_text = function(text)
  local str = [[ exec "normal Go%s\<cr>\<esc>G" ]]
  vim.cmd(string.format(str, text))
end

local note_run_cmd = function(cmd)
  local result = vim.fn.systemlist(cmd)[1]
  if vim.v.shell_error == 0 then
    return result
  end
  return nil
end

local note_get_git_root = function()
  return note_run_cmd('git rev-parse --show-toplevel | xargs basename')
end

local note_get_git_branch = function()
  return note_run_cmd('git symbolic-ref --short HEAD')
end

local note_create_or_edit = function(name)
  local filename = slugify(name, '-')
  local dir = vim.g.notes_home
  local path = vim.fn.expand(string.format('%s/%s.md', dir, filename))
  vim.cmd('edit ' .. path)
end

local create_note_for_project = function(with_branch)
  return function()
    local now = note_now()
    local git_root = slugify(note_get_git_root(), '-')
    local git_branch = 'index'
    if with_branch then
      git_branch = slugify(note_get_git_branch(), '-')
    end

    if git_root and git_branch then
      local dir = vim.g.notes_home
      local project_dir = vim.fn.expand(dir .. '/projects/' .. git_root)
      vim.fn.mkdir(project_dir, 'p')
      local filename = project_dir .. '/' .. git_branch .. '.md'
      vim.cmd('edit ' .. filename)
      note_insert_text(string.format('###### %s', now))
    end
  end
end

vim.api.nvim_create_user_command('NoteToday', function()
  local today = note_today()
  local now = note_now()
  local dir = vim.g.notes_home
  local filename = dir .. '/Journal/' .. today .. '.md'
  vim.cmd('edit ' .. filename)
  note_insert_text(string.format('###### %s', now))
end, {})

vim.api.nvim_create_user_command('NoteNew', function(opt)
  local note = opt.args
  if not note then
    note = vim.fn.input("What's note name? ")
  end
  note_create_or_edit(note)
end, { nargs = '?' })

vim.api.nvim_create_user_command(
  'NoteGitBranch',
  create_note_for_project(true),
  {}
)
vim.api.nvim_create_user_command('NoteGit', create_note_for_project(false), {})

-- global_keymap('n', '<leader>nc', ':NoteNew<cr>')
-- global_keymap('n', '<leader>nt', ':NoteToday<cr>')
-- global_keymap('n', '<leader>nb', ':NoteGitBranch<cr>')
-- global_keymap('n', '<leader>ng', ':NoteGit<cr>')
