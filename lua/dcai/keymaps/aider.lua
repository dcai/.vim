local ok, aider = pcall(require, 'aider')
if not ok then
  return
end

aider.setup({
  -- Auto trigger diffview after Aider's file changes
  after_update_hook = function()
    vim.cmd('!Git diff HEAD^')
    -- require('diffview').open({ 'HEAD^' })
  end,
})

local aider_keymap = {
  { '<leader>a', group = 'aider' },
  {
    '<leader>aa',
    function()
      vim.cmd('AiderToggle')
    end,
    desc = 'AiderToggle',
  },
  {
    '<leader>aC',
    function()
      vim.cmd('AiderSpawn')
    end,
    desc = 'AiderSpawn',
  },
  {
    '<leader>al',
    function()
      vim.cmd('AiderAdd')
    end,
    desc = 'AiderAdd',
  },
}

return aider_keymap
