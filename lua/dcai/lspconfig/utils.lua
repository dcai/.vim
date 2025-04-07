local M = {}
local fzflua = require('fzf-lua')

---get client instance
---@param client_name string
---@param bufnr? number
---@return vim.lsp.Client | nil
local function get_client(client_name, bufnr)
  local clients = vim.lsp.get_clients({ name = client_name, bufnr = bufnr })
  return clients[1] or nil
end

---return a function
---@param direction number
---@return function
local function diagnostic_jump(direction)
  return function()
    vim.diagnostic.jump({ count = direction, float = true })
  end
end

---@param mode string
---@param buffer integer
---@return function
local function key_map(mode, buffer)
  local opts = { noremap = true, silent = true, buffer = buffer }
  return function(lhs, rhs, desc)
    if desc then
      opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

M.ts_ls_organize_imports = function(client, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
  }
  local c = client or get_client('pyright', bufnr)
  c:exec_cmd(params, { bufnr = bufnr })
end

M.organize_imports = {
  pyright = function(client, bufnr)
    local command = {
      command = 'pyright.organizeimports',
      arguments = { vim.api.nvim_buf_get_name(bufnr) },
    }
    local c = client or get_client('pyright', bufnr)
    c:exec_cmd(command, { bufnr = bufnr })
  end,
  ts_ls = M.ts_ls_organize_imports,
}

M.ts_ls_supported_filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
}

---location to fzf params
---@param options vim.lsp.LocationOpts.OnList
---@return string[]
M.locations_to_fzf = function(options)
  local items = options.items
  local fzf_items = {}
  for _index, item in ipairs(items) do
    local fzf_modifier = ':~:.' -- format FZF entries, see |filename-modifiers|
    local fzf_trim = true
    local filename = vim.fn.fnamemodify(item.filename, fzf_modifier)
    local path = vim.g.purple(filename)
    local lnum = vim.g.green(item.lnum)
    local text = fzf_trim and vim.trim(item.text) or item.text
    table.insert(
      fzf_items,
      string.format('%s:%s:%s: %s', path, lnum, item.col, text)
    )
  end

  return fzf_items
end

---handle lsp location list, use fzf when multiple locations found
---@param options vim.lsp.LocationOpts.OnList
M.lsp_on_list_handler = function(options)
  local result = options.items
  if #result == 1 then
    vim.fn.setqflist(result, 'r')
    return vim.cmd('cfirst')
  end
  local fzf_items = M.locations_to_fzf(options)
  if #fzf_items > 0 then
    fzflua.fzf_exec(fzf_items, {
      actions = fzflua.defaults.actions.files,
      fzf_opts = {
        ['--preview-window'] = 'nohidden,right,50%',
      },
      preview = {
        type = 'cmd',
        hidden = 'nohidden',
        fn = function(items)
          local file = fzflua.path.entry_to_file(items[1])
          vim.g.logger.info('file: ' .. vim.inspect(file))
          return string.format(
            'bat --color always %s --highlight-line=%s --line-range %s:',
            file.path,
            file.line,
            file.line - 5 < 1 and 1 or file.line - 5
          )
        end,
      },
    })
  end
end

M.common_on_attach = function(client, bufnr)
  local nmap = key_map('n', bufnr)
  -- local xmap = key_map('x', bufnr)
  nmap('[d', diagnostic_jump(-1), 'go to prev diagnostic')
  nmap(']d', diagnostic_jump(1), 'go to next diagnostic')
  nmap('gd', function()
    vim.lsp.buf.definition({ on_list = M.lsp_on_list_handler })
  end, 'go to definition')
  nmap('grr', function()
    vim.lsp.buf.references(nil, { on_list = M.lsp_on_list_handler })
  end, 'go to references')
  nmap('gO', function()
    vim.lsp.buf.document_symbol({ on_list = M.lsp_on_list_handler })
  end, 'go to symbol')

  nmap('grf', function()
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
    local lsp_type = ''
    if vim.list_contains(M.ts_ls_supported_filetypes, filetype) then
      lsp_type = 'ts_ls'
    end
    if filetype == 'php' then
      lsp_type = 'phpactor'
    end

    vim.g.logger.info('lsp_type: ' .. lsp_type)
    vim.g.logger.info('organize: ' .. vim.inspect(M.organize_imports[lsp_type]))
    if lsp_type and M.organize_imports[lsp_type] then
      M.organize_imports[lsp_type](client, bufnr)
    else
      print('No organize imports for ' .. filetype)
    end
  end, 'Organize Imports')
end

return M
