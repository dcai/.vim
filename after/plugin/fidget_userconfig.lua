local ok, fidget = pcall(require, 'fidget')
if not ok then
  return
end
fidget.setup({})

local fidget_progress = require('fidget.progress')

---@class table<string, fidget_progress.handle>
_G._notifications_map = {}

---@param id string
---@param msg string
---@param title string
---@param finish? boolean
vim.g.update_notification = function(id, msg, title, finish)
  local handle = _G._notifications_map[id]
  if type(msg) ~= 'string' then
    msg = vim.inspect(msg)
  end
  if handle then
    handle.message = msg
  else
    local new_handle = fidget_progress.handle.create({
      title = title or 'Neovim',
      message = msg,
      -- done = finish or nil,
      lsp_client = { name = 'Neovim' },
    })
    _G._notifications_map[id] = new_handle
  end
  if finish then
    _G._notifications_map[id] = nil
    vim.defer_fn(function()
      handle:finish()
    end, 1000)
  end
end
