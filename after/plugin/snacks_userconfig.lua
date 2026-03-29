local ok, snacks = pcall(require, 'snacks')

if not ok then
  return
end

snacks.setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  -- disabled
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  notifier = { enabled = false },
  picker = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})
