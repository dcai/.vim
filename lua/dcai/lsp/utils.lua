local M = {}
local has_fzflua, fzflua = pcall(require, 'fzf-lua')

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

M.organize_imports = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = 'textDocument/codeAction',
  })
  if #clients == 0 then
    vim.notify(
      'No LSP client supports code actions in this buffer',
      vim.log.levels.WARN
    )
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.lsp.buf.code_action({
      context = { only = { 'source.organizeImports' }, diagnostics = {} },
      apply = true,
    })
  end)
end

M.ts_root_markers = {
  'pnpm-lock.yaml',
  'package-lock.json',
  'yarn.lock',
  'bun.lock',
  '.git',
  'tsconfig.json',
  'jsconfig.json',
}

M.ts_ls_supported_filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
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
local function lsp_on_list_handler(options)
  local result = options.items
  if #result == 1 then
    vim.fn.setqflist(result, 'r')
    return vim.cmd('cfirst')
  end
  if not has_fzflua then
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
          -- vim.g.logger.info('file: ' .. vim.inspect(file))
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
    vim.lsp.buf.definition({ on_list = lsp_on_list_handler })
  end, 'go to definition')
  nmap('grr', function()
    vim.lsp.buf.references(nil, { on_list = lsp_on_list_handler })
  end, 'go to references')
  nmap('gO', function()
    vim.lsp.buf.document_symbol({ on_list = lsp_on_list_handler })
  end, 'go to symbol')

  vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function()
    M.organize_imports(bufnr)
  end, { desc = 'Organize imports with LSP' })
  nmap('grf', function()
    M.organize_imports(bufnr)
  end, 'Organize Imports')
end

M.support_native_lsp_config = function()
  return vim.version.cmp(vim.version(), '0.11.0') >= 0
end

---@param overrides? table merged over the base capabilities (vim.tbl_deep_extend)
---@return table
M.get_lsp_capabilities = function(overrides)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_loaded, blinkcmp = pcall(require, 'blink.cmp')
  if cmp_loaded then
    capabilities = vim.tbl_deep_extend(
      'force',
      capabilities,
      blinkcmp.get_lsp_capabilities()
    )
  end

  if overrides then
    capabilities = vim.tbl_deep_extend('force', capabilities, overrides)
  end

  return capabilities
end

return M
