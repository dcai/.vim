local marker = '# ===== #'

local function get_current_datetime()
  return os.date('%Y-%m-%d %H:%M:%S')
end

local function replace_between_markers(str)
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local start_idx = nil
  local end_idx = nil

  -- Find markers
  for i, line in ipairs(lines) do
    if line:match('^' .. marker .. '$') then
      if start_idx == nil then
        start_idx = i
      else
        end_idx = i
        break
      end
    end
  end

  if start_idx and end_idx then
    local replacement_text = {}
    if str then
      replacement_text = { str }
    end
    vim.api.nvim_buf_set_lines(
      bufnr,
      start_idx - 1,
      end_idx,
      false,
      replacement_text
    )
  end
end

local function append_to_buffer(bufnr, text)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    print('Invalid buffer')
    return
  end
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lines = type(text) == 'string'
      and vim.split(text, '\n', { plain = true })
    or text
  vim.api.nvim_buf_set_lines(
    bufnr,
    line_count,
    line_count + #lines,
    false,
    lines
  )
end
vim.api.nvim_create_user_command('HurlRun', function()
  local dir = vim.g.git_root()
  -- run current file
  local ft = vim.bo.filetype
  if not vim.tbl_contains({ 'hurl' }, ft) then
    vim.g.logger.warn('Not a hurl file')
    return
  end

  replace_between_markers()

  local filepath = vim.fn.expand('%:p')
  -- local popup = vim.g.new_popup({ title = 'hurl', number = false })
  -- popup.open()
  local PJob = require('plenary.job')

  -- local bufnr = vim.api.nvim_create_buf(false, true)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_current_buf(bufnr)
  -- local channel = vim.api.nvim_open_term(popup.buffer, {})
  -- local channel = vim.api.nvim_open_term(bufnr, {})
  -- local hr = vim.g.nl .. '============' .. vim.g.nl
  -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
  --   'loading...',
  -- })
  append_to_buffer(bufnr, marker)
  append_to_buffer(bufnr, '# loading ' .. get_current_datetime())

  local args = {
    '--no-color',
    '--insecure',
    filepath,
  }

  if dir and vim.g.file_exists(dir .. '/vars.txt') then
    table.insert(args, '--variables-file')
    table.insert(args, dir .. '/vars.txt')
  end

  PJob:new({
    command = 'hurl',
    args = args,
    cwd = dir,
    skip_validation = true,
    on_exit = vim.schedule_wrap(function(job, status)
      append_to_buffer(
        bufnr,
        '# Done, see response below ' .. get_current_datetime()
      )
      -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
      -- vim.api.nvim_set_option_value('filetype', 'json', { buf = bufnr })
      if status ~= 0 then
        -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, job:stderr_result())
        append_to_buffer(bufnr, job:stderr_result())
      else
        -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, job:result())
        append_to_buffer(bufnr, job:result())
      end
      append_to_buffer(bufnr, marker)
    end),
  }):start()
end, {})
