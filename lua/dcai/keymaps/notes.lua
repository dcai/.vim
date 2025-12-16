local utils = require('dcai.keymaps.utils')

local notes_keymap = {
  { '<leader>n', group = 'notes' },
  {
    '<leader>nn',
    function()
      local todofile = vim.g.notes_home .. '/todo.md'
      vim.cmd('edit ' .. todofile)
    end,
    desc = 'todo',
  },
  {
    '<leader>nb',
    function()
      vim.cmd('NoteGitBranch')
    end,
    desc = 'create new note for current git branch',
  },
  {
    '<leader>nc',
    function()
      vim.cmd('NoteNew')
    end,
    desc = 'create new note',
  },
  {
    '<leader>ng',
    function()
      vim.cmd('NoteGit')
    end,
    desc = 'create new note for current git repo',
  },
  {
    '<leader>nt',
    function()
      vim.cmd('NoteToday')
    end,
    desc = 'create new note for today',
  },
  {
    '<leader>np',
    function()
      local ft = vim.bo.filetype
      if not vim.tbl_contains({ 'markdown' }, ft) then
        vim.g.logger.warn('must be markdown file')
        return
      end
      utils.lazy_shell_cmd(
        'doku-publish.py',
        -- args should be evaluated when the function is called
        { disable_popup = false, args = { vim.fn.expand('%:p') } }
      )()
    end,

    desc = 'publish to dokuwiki',
  },
  {
    '<leader>nl',
    function()
      local fzf = require('fzf-lua')
      fzf.files({
        cwd = vim.g.notes_home,
      })
    end,
    desc = 'list all notes',
  },
  {
    '<leader>n/',
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
    desc = 'full text search in notes',
  },
}
return notes_keymap
