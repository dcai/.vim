local ok, aider = pcall(require, 'aider')
local group = 'Aider'
if not ok then
  return {
    { '<leader>a', group = group },
  }
end

aider.setup({
  -- Auto trigger diffview after Aider's file changes
  after_update_hook = function()
    -- Show git diff in the terminal
    vim.cmd('!Git diff HEAD^')
    -- Alternative: open in diffview plugin (currently commented out)
    -- require('diffview').open({ 'HEAD^' })
  end,
})

local aider_keymap = {
  { '<leader>a', group = group },
  {
    '<leader>aa',
    function()
      -- Toggle Aider's chat interface
      vim.cmd('AiderToggle')
    end,
    desc = 'AiderToggle',
  },
  {
    '<leader>aC',
    function()
      -- Spawn a new Aider instance
      vim.cmd('AiderSpawn')
    end,
    desc = 'AiderSpawn',
  },
  {
    '<leader>al',
    function()
      -- Add current file to Aider's context
      vim.cmd('AiderAdd')
    end,
    desc = 'AiderAdd',
  },
}

return aider_keymap
