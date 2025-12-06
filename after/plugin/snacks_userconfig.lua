local ok, snacks = pcall(require, 'snacks')

if not ok then
  return
end

snacks.setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  input = { enabled = true },

  -- disabled
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  picker = { enabled = false },
  notifier = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})
