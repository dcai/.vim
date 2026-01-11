local ok, claudecode = pcall(require, 'claude-code')
if not ok then
  return
end
claudecode.setup({
  command = 'claude-via-copilot-proxy.bash claude-opus-4.5',
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = '--continue', -- Resume the most recent conversation
    resume = '--resume', -- Display an interactive conversation picker

    -- Output options
    verbose = '--verbose', -- Enable verbose logging with full turn-by-turn output
  },
  window = {
    split_ratio = 0.5, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = 'float', -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true, -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true, -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window

    -- Floating window configuration (only applies when position = "float")
    float = {
      width = '90%', -- Width: number of columns or percentage string
      height = '90%', -- Height: number of rows or percentage string
      row = 'center', -- Row position: number, "center", or percentage string
      col = 'center', -- Column position: number, "center", or percentage string
      relative = 'editor', -- Relative to: "editor" or "cursor"
      border = 'single', -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = '<c-q>', -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = '<c-q>', -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = nil, -- Normal mode keymap for Claude Code with continue flag
        verbose = '<leader>cV', -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = false, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
  },
})
