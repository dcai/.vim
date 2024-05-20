local utils = require('keymaps.utils')

local notes_keymap = {
  name = 'notes',
  b = utils.vim_cmd('NoteGitBranch', 'create new note for current git branch'),
  c = utils.vim_cmd('NoteNew', 'create new note'),
  g = utils.vim_cmd('NoteGit', 'create new note for current git repo'),
  t = utils.vim_cmd('NoteToday', 'create new note for today'),
  p = {
    function()
      local ft = vim.bo.filetype
      if not vim.tbl_contains({ 'markdown' }, ft) then
        LOG.warn('must be markdown file')
        return
      end
      utils.lazy_shell_cmd(
        'doku-publish.py',
        -- args should be evaluated when the function is called
        { disable_popup = false, args = { vim.fn.expand('%:p') } }
      )()
    end,

    'publish to dokuwiki',
  },
  l = {
    function()
      local fzf = require('fzf-lua')
      fzf.files({
        cwd = vim.g.notes_home,
      })
    end,
    'list all notes',
  },
  ['/'] = {
    function()
      local fzf = require('fzf-lua')
      fzf.live_grep({
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
    end,
    'full text search in notes',
  },
}
return notes_keymap
