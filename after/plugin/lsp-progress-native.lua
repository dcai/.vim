-- Keep one visible status per client, even when it reports concurrent tasks.
local clients = {}

local function get_progress_text(value)
  if type(value.message) == 'string' and value.message ~= '' then
    return value.message
  end
  return value.title or 'Working...'
end

local function update(client_id, task)
  local client = vim.lsp.get_client_by_id(client_id)
  local name = client and client.name or 'lsp'
  local percent = task and task.percentage or 100
  local title = task and task.title
  local opts = {
    id = 'dcai.lsp.progress:' .. client_id,
    kind = 'progress',
    status = task and 'running' or 'success',
    percent = percent,
    title = title and (name .. ' - ' .. title) or name,
    source = name,
  }

  vim.g.set_terminal_progress(percent)
  vim.api.nvim_echo(
    { { task and get_progress_text(task) or 'Done' } },
    false,
    opts
  )
  if not task then
    clients[client_id] = nil
  end
end

vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('dcai_lsp_progress', { clear = true }),
  callback = function(event)
    local client_id = event.data.client_id
    local params = event.data.params
    local value = params.value
    if type(value) ~= 'table' then
      return
    end
    if
      value.kind ~= 'begin'
      and value.kind ~= 'report'
      and value.kind ~= 'end'
    then
      return
    end

    local state = clients[client_id]
    if value.kind == 'end' then
      if not state or not state[params.token] then
        return
      end
      state[params.token] = nil
      local _, remaining = next(state)
      update(client_id, remaining)
      return
    end

    state = state or {}
    clients[client_id] = state
    local task = state[params.token] or { percentage = 0 }
    task.title = value.title or task.title
    task.message = value.message or task.message
    task.percentage = type(value.percentage) == 'number' and value.percentage
      or task.percentage
    state[params.token] = task
    update(client_id, task)
  end,
})

vim.api.nvim_create_autocmd('Progress', {
  group = 'dcai_lsp_progress',
  callback = function(event)
    if not tostring(event.data.id):match('^dcai%.lsp%.progress:') then
      return
    end

    -- ui2 keeps the longest message width; resize after it renders the update.
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local config = vim.api.nvim_win_get_config(win)
        if
          vim.bo[buf].filetype == 'msg'
          and config.relative ~= ''
          and not config.hide
        then
          local width = 1
          for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
            width = math.max(width, vim.fn.strdisplaywidth(line))
          end
          config.width = math.min(width, vim.o.columns)
          config.col = 10000
          vim.api.nvim_win_set_config(win, config)
        end
      end
    end)
  end,
})
