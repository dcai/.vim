-- Mini reporter: console output plus a GitHub Actions job summary and
-- failure annotations. Outside CI (no GITHUB_STEP_SUMMARY) it only prints.
local MiniTest = require('mini.test')

local console = MiniTest.gen_reporter.stdout({ quit_on_finish = false })

local function case_name(case)
  local name = table.concat(case.desc, ' | ')
  if #case.args > 0 then
    name = ('%s %s'):format(
      name,
      vim.inspect(case.args, { newline = '', indent = '' })
    )
  end
  return name
end

local function fails(case)
  return case.exec and case.exec.fails or {}
end

local function notes(case)
  return case.exec and case.exec.notes or {}
end

-- Escape GitHub workflow command data and property values.
local function data(text)
  return (
    tostring(text):gsub('%%', '%%25'):gsub('\r', '%%0D'):gsub('\n', '%%0A')
  )
end

local function property(text)
  return data(text):gsub(':', '%%3A'):gsub(',', '%%2C')
end

local function inline(text)
  return (text:gsub('\n', ' '):gsub('|', '\\|'))
end

local function summary(cases)
  local failed, passed, notes_count = {}, 0, 0
  for _, case in ipairs(cases) do
    if #fails(case) > 0 then
      failed[#failed + 1] = case
    else
      passed = passed + 1
    end
    notes_count = notes_count + #notes(case)
  end
  local lines = {
    '## Neovim tests',
    '',
    '| Result | Cases | Failures | Notes |',
    '|:--|--:|--:|--:|',
    ('| %s | %d | %d | %d |'):format(
      #failed == 0 and 'Passed' or 'Failed',
      #cases,
      #failed,
      notes_count
    ),
  }
  if #failed > 0 then
    table.insert(lines, '')
    table.insert(lines, '### Failures')
    table.insert(lines, '')
    for _, case in ipairs(failed) do
      table.insert(lines, ('- `%s`'):format(inline(case_name(case))))
      for _, message in ipairs(fails(case)) do
        local first = vim.split(message, '\n', { plain = true })[1]
        table.insert(lines, ('  - %s'):format(inline(first)))
      end
    end
  end
  if notes_count > 0 then
    table.insert(lines, '')
    table.insert(lines, '<details><summary>Notes</summary>')
    table.insert(lines, '')
    for _, case in ipairs(cases) do
      for _, note in ipairs(notes(case)) do
        table.insert(
          lines,
          ('- `%s`: %s'):format(inline(case_name(case)), inline(note))
        )
      end
    end
    table.insert(lines, '')
    table.insert(lines, '</details>')
  end
  return table.concat(lines, '\n') .. '\n', failed
end

local reporter = {}

reporter.start = function(cases)
  reporter.cases = cases
  console.start(cases)
end

reporter.update = function(case_num)
  console.update(case_num)
end

reporter.finish = function()
  local cases = reporter.cases or {}
  local markdown, failed = summary(cases)
  local path = vim.env.GITHUB_STEP_SUMMARY
  if path and path ~= '' then
    for _, case in ipairs(failed) do
      local message = table.concat(fails(case), '\n')
      -- Workflow commands must start on their own line.
      io.write(
        ('\n::error title=%s::%s\n'):format(
          property('Test failed: ' .. case_name(case)),
          data(message)
        )
      )
    end
    local file = io.open(path, 'a')
    if file then
      file:write(markdown)
      file:close()
    else
      io.write('Could not write GITHUB_STEP_SUMMARY\n')
    end
  end
  console.finish()
  vim.cmd('silent! ' .. (#failed > 0 and '1cquit' or '0cquit'))
end

return reporter
