-- vim.cmd([[
--   let g:copilot_no_tab_map = v:true
--   imap <silent><script><expr> <c-f> copilot#Accept("\<CR>")
-- ]])

-- https://github.com/zbirenbaum/copilot.lua
local loaded, copilot = pcall(require, 'copilot')
if not loaded then
  return
end

copilot.setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = '[[',
      jump_next = ']]',
      accept = '<CR>',
      refresh = 'gr',
      open = '<M-CR>',
    },
    layout = {
      position = 'bottom', -- | top | left | right
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = '<c-f>',
      accept_word = false,
      accept_line = false,
      next = '<M-]>',
      prev = '<M-[>',
      dismiss = '<C-]>',
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ['*'] = true,
    ['.'] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})
