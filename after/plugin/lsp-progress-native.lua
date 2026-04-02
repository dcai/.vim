if vim.fn.has('nvim-0.12') ~= 1 then
  return
end

local original_lsp_progress_handler = vim.lsp.handlers['$/progress']

---@type table<string, table>
local progress_messages = {}

local function get_progress_key(ctx, token)
  return string.format('%s:%s', ctx.client_id, tostring(token))
end

local function get_progress_text(value)
  if value.message and value.message ~= '' then
    return value.message
  end

  if value.title and value.title ~= '' then
    return value.title
  end

  return 'Working...'
end

local function get_progress_done_text(value)
  if value.message and value.message ~= '' then
    return value.message
  end

  return 'Done!'
end

local function update(msg, progress)
  return vim.api.nvim_echo({ { msg } }, false, progress)
end

local function finish_progress(key, value)
  local progress = progress_messages[key]
  if not progress then
    return
  end

  progress.status = 'success'
  progress.percent = 100
  progress.title = progress.source
  update(get_progress_done_text(value), progress)
  progress_messages[key] = nil
end

local function get_client_name(ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name then
    return client.name
  end

  return 'lsp'
end

local function get_title(value, client_name)
  -- vim.g.logger.debug(
  --   'get_title',
  --   vim.inspect({ value = value, client_name = client_name })
  -- )
  if value.title and value.title ~= '' then
    return client_name .. ' - ' .. value.title
  end

  return client_name
end

vim.lsp.handlers['$/progress'] = function(err, result, ctx, config)
  if original_lsp_progress_handler then
    original_lsp_progress_handler(err, result, ctx, config)
  end

  if err then
    return
  end

  if not result or not result.value then
    return
  end

  local value = result.value
  local key = get_progress_key(ctx, result.token)
  local client_name = get_client_name(ctx)
  local progress = progress_messages[key]

  if not progress then
    progress = {
      kind = 'progress',
      status = 'running',
      percent = 0,
      title = get_title(value, client_name),
      source = client_name,
    }
    progress_messages[key] = progress
  end

  -- data payload example:
  -- result = {
  --   token = 2,
  --   value = {
  --     cancellable = false,
  --     kind = "begin",
  --     message = "58/183",
  --     percentage = 31,
  --     title = "Loading workspace"
  --   }
  -- }
  if value.kind == 'begin' then
    progress.status = 'running'
    progress.percent = value.percentage or 0
    progress.id = update(get_progress_text(value), progress)
    return
  end

  -- data payload example:
  -- result = {
  --   token = 2,
  --   value = {
  --     kind = 'report',
  --     message = '183/183',
  --     percentage = 100,
  --     title = 'Loading workspace',
  --   },
  -- }

  if value.kind == 'report' then
    progress.status = 'running'
    if value.percentage ~= nil then
      progress.percent = value.percentage
    end
    progress.id = update(get_progress_text(value), progress)
    return
  end

  if value.kind == 'end' then
    finish_progress(key, value)
  end
end

-- vim.api.nvim_create_autocmd('LspProgress', {
--   callback = function(ev)
--     local value = ev.data.params.value or {}
--     if not value.kind then
--       return
--     end
--
--     local status = value.kind == 'end' and 0 or 1
--     local percent = value.percentage or 0
--
--     local osc_seq = string.format('\27]9;4;%d;%d\a', status, percent)
--
--     if os.getenv('TMUX') then
--       osc_seq = string.format('\27Ptmux;\27%s\27\\', osc_seq)
--     end
--
--     io.stdout:write(osc_seq)
--     io.stdout:flush()
--   end,
-- })
