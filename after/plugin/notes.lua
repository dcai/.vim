vim.g.notes_home = '~/Library/CloudStorage/Dropbox/Documents/txt'
local fzflua_loaded, fzflua = pcall(require, 'fzf-lua')

function note_today()
  return os.date('%Y%m%d')
end

function note_now()
  return os.date('%Y-%m-%d %H:%M')
end

function note_insert_text(text)
  local str = [[ exec "normal Go%s\<cr>\<esc>G" ]]
  vim.cmd(string.format(str, text))
end

function note_run_cmd(cmd)
  local result = vim.fn.systemlist(cmd)[1]
  if vim.v.shell_error == 0 then
    return result
  end
  return nil
end

function note_get_git_root()
  return note_run_cmd('git rev-parse --show-toplevel | xargs basename')
end

function note_get_git_branch()
  return note_run_cmd('git symbolic-ref --short HEAD')
end

function note_create_or_edit(name)
  local filename = slugify(name, '-')
  local dir = vim.g.notes_home
  local path = vim.fn.expand(string.format('%s/%s.md', dir, filename))
  vim.cmd(f('edit {path}'))
end

function create_note_for_project(with_branch)
  return function()
    local now = note_now()
    local git_root = slugify(note_get_git_root(), '-')
    local git_branch = 'index'
    if with_branch then
      git_branch = slugify(note_get_git_branch(), '-')
    end

    if git_root and git_branch then
      local dir = vim.g.notes_home
      local project_dir = vim.fn.expand(f('{dir}/projects/{git_root}'))
      vim.fn.mkdir(project_dir, 'p')
      local filename = f('{project_dir}/{git_branch}.md')
      vim.cmd(f('edit {filename}'))
      note_insert_text(string.format('###### %s', now))
    end
  end
end

vim.api.nvim_create_user_command('NoteToday', function()
  local today = note_today()
  local now = note_now()
  local dir = vim.g.notes_home
  local filename = f('{dir}/Journal/{today}.md')
  vim.cmd(f('edit {filename}'))
  note_insert_text(string.format('###### %s', now))
end, {})

vim.api.nvim_create_user_command('NoteNew', function(opt)
  local note = opt.args
  if note then
  else
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

vim.keymap.set('n', '<leader>nl', function()
  if fzflua_loaded then
    fzflua.files({
      cwd = vim.g.notes_home,
      file_ignore_patterns = {
        'node_modules',
        '.png',
        '.pdf',
        '.jpg',
        '.docx',
        '.pptx',
      },
    })
  end
end, {
  noremap = true,
  expr = true,
})

vim.keymap.set('n', '<leader>ns', function()
  if fzflua_loaded then
    fzflua.live_grep({
      cwd = vim.g.notes_home,
      multiprocess = true,
    })
  end
end, {
  noremap = true,
  expr = true,
})

global_keymap('n', '<leader>nc', ':NoteNew<cr>')
global_keymap('n', '<leader>nt', ':NoteToday<cr>')
global_keymap('n', '<leader>ngb', ':NoteGitBranch<cr>')
global_keymap('n', '<leader>ngg', ':NoteGit<cr>')
