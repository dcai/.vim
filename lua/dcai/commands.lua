local M = {}

local function most_used_filetypes()
  local counts = {}

  for _, file in ipairs(vim.v.oldfiles) do
    if vim.fn.filereadable(file) == 1 then
      local ft = vim.filetype.match({ filename = file })
      if ft and ft ~= '' then
        counts[ft] = (counts[ft] or 0) + 1
      end
    end
  end

  local items = {}
  for ft, count in pairs(counts) do
    table.insert(items, { ft = ft, count = count })
  end

  table.sort(items, function(a, b)
    return a.count > b.count
  end)

  return items
end

function M.setup()
  vim.api.nvim_create_user_command('OldfileTypes', function(opts)
    local limit = tonumber(opts.args) or 10
    local items = most_used_filetypes()
    local lines = {}

    for index = 1, math.min(limit, #items) do
      local item = items[index]
      table.insert(lines, item.ft .. ': ' .. item.count)
    end

    vim.notify(table.concat(lines, '\n'))
  end, { nargs = '?' , desc = 'Show most used filetypes from oldfiles' })
end

return M
