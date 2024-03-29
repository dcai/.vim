local loaded, autosave = pcall(require, 'auto-save')
if not loaded then
  print('pocco81/auto-save.nvim not loaded!')
  return
end
-- https://github.com/pocco81/auto-save.nvim
autosave.setup({
  enabled = true,
  -- saves the file at most every `debounce_delay` milliseconds
  debounce_delay = 2000,
  execution_message = {
    message = function()
      return ('auto-save: saved at ' .. vim.fn.strftime('%H:%M:%S'))
    end,
    dim = 0.18, -- dim the color of `message`
    cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
  },
  trigger_events = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger auto-save. See :h events
  condition = function(buf)
    local fn = vim.fn
    local modifiable = fn.getbufvar(buf, '&modifiable') == 1
    local ft = fn.getbufvar(buf, '&filetype')
    local blacklist = { 'sagafinder', 'harpoon' }
    if modifiable and not vim.tbl_contains(blacklist, ft) then
      return true
    end
    return false
  end,
  write_all_buffers = false, -- write all buffers when the current one meets `condition`
  callbacks = { -- functions to be executed at different intervals
    enabling = nil, -- ran when enabling auto-save
    disabling = nil, -- ran when disabling auto-save
    before_asserting_save = nil, -- ran before checking `condition`
    before_saving = nil, -- ran before doing the actual save
    after_saving = nil, -- ran after doing the actual save
  },
})
