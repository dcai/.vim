local loaded, harpoon = pcall(require, 'harpoon')
if not loaded then
  return
end

-- REQUIRED
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    key = function()
      -- return vim.fn.systemlist('git rev-parse --show-toplevel')[1]
      return vim.loop.cwd()
    end,
  },
})
-- REQUIRED

vim.keymap.set('n', '<leader>fa', function()
  harpoon:list():append()
end)
vim.keymap.set('n', '<leader>fl', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
-- vim.keymap.set('n', '<C-h>', function()
--   harpoon:list():select(1)
-- end)
-- vim.keymap.set('n', '<C-t>', function()
--   harpoon:list():select(2)
-- end)
-- vim.keymap.set('n', '<C-n>', function()
--   harpoon:list():select(3)
-- end)
-- vim.keymap.set('n', '<C-s>', function()
--   harpoon:list():select(4)
-- end)
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set('n', '<C-S-P>', function()
--   harpoon:list():prev()
-- end)
-- vim.keymap.set('n', '<C-S-N>', function()
--   harpoon:list():next()
-- end)
