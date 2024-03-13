-------------------------------
--- mason
-------------------------------
local mason_loaded, mason = pcall(require, 'mason')
if not mason_loaded then
  return
end
local masonpath = require('mason-core.path')
mason.setup({
  install_root_dir = masonpath.concat({ vim.fn.stdpath('data'), 'mason' }),
})
-------------------------------
--- mason-lspconfig
-------------------------------
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = {
    'lua_ls',
    'pyright',
    'tsserver',
  },
  automatic_installation = true,
})

-------------------------------
--- lspconfig
-------------------------------
local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  return
end

local root_pattern = nvim_lspconfig.util.root_pattern

local function organize_imports()
  vim.lsp.buf.execute_command({
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = '',
  })
end

local common_on_attach = function(_client, bufnr)
  vim.cmd([[command! LspFormat execute 'lua vim.lsp.buf.format()']])
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'D', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'R', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  -- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
end

nvim_lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force', -- force: use value from the rightmost map
  nvim_lspconfig.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities() -- must use require here
)

nvim_lspconfig.tsserver.setup({
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = root_pattern(
    'package.json',
    'tsconfig.json',
    'jsconfig.json',
    '.git'
  ),
  cmd = { 'typescript-language-server', '--stdio' },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = 'Organize Imports',
    },
  },
  init_options = {
    hostInfo = 'neovim',
  },
  on_attach = common_on_attach,
})

nvim_lspconfig.pyright.setup({
  on_attach = common_on_attach,
})

nvim_lspconfig.lua_ls.setup({
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file('', true),
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
        checkThirdParty = false,
      },
    },
  },
  on_attach = common_on_attach,
})

local fzfloaded, fzflua = pcall(require, 'fzf-lua')
if fzfloaded then
  local function lsp_to_fzf(item)
    local fzf_modifier = ':~:.' -- format FZF entries, see |filename-modifiers|
    local fzf_trim = true
    local ansi = {
      reset = string.char(0x001b) .. '[0m',
      red = string.char(0x001b) .. '[31m',
      green = string.char(0x001b) .. '[32m',
      yellow = string.char(0x001b) .. '[33m',
      blue = string.char(0x001b) .. '[34m',
      purple = string.char(0x001b) .. '[35m',
    }
    local fmt = string.format
    local filename = vim.fn.fnamemodify(item.filename, fzf_modifier)
    local path = fmt('%s%s%s', ansi.purple, filename, ansi.reset)
    local lnum = fmt('%s%s%s', ansi.green, item.lnum, ansi.reset)
    local text = fzf_trim and vim.trim(item.text) or item.text
    return fmt('%s:%s:%s: %s', path, lnum, item.col, text)
  end

  -- https://github.com/ojroques/nvim-lspfuzzy/blob/main/lua/lspfuzzy.lua
  local location_handler = function(_err, result, _ctx, _config)
    result = vim.tbl_islist(result) and result or { result }
    if #result == 0 then
      return
    end
    if #result == 1 then
      return vim.lsp.util.jump_to_location(result[1])
    end
    local items = vim.lsp.util.locations_to_items(result)
    local source = vim.tbl_map(lsp_to_fzf, items)
    fzflua.fzf_exec(source, { actions = fzflua.defaults.actions.files })
  end

  vim.lsp.handlers['textDocument/declaration'] = location_handler
  vim.lsp.handlers['textDocument/definition'] = location_handler
  vim.lsp.handlers['textDocument/implementation'] = location_handler
  vim.lsp.handlers['textDocument/references'] = location_handler
  vim.lsp.handlers['textDocument/typeDefinition'] = location_handler
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end

local lspsaga_loaded, lspsaga = pcall(require, 'lspsaga')
if lspsaga_loaded then
  lspsaga.setup({
    ui = {
      border = 'rounded',
      devicon = true,
      foldericon = true,
      title = true,
      expand = '⊞',
      collapse = '⊟',
      code_action = '💡',
      actionfix = ' ',
      lines = { '┗', '┣', '┃', '━', '┏' },
      kind = nil,
      imp_sign = '󰳛 ',
    },
    hover = {
      max_width = 0.9,
      max_height = 0.8,
      open_link = 'gx',
      open_cmd = '!chrome',
    },
    diagnostic = {
      show_code_action = true,
      show_layout = 'float',
      show_normal_height = 10,
      jump_num_shortcut = true,
      max_width = 0.8,
      max_height = 0.6,
      max_show_width = 0.9,
      max_show_height = 0.6,
      text_hl_follow = true,
      border_follow = true,
      wrap_long_lines = true,
      extend_relatedInformation = false,
      diagnostic_only_current = false,
      keys = {
        exec_action = 'o',
        quit = 'q',
        toggle_or_jump = '<CR>',
        quit_in_show = { 'q', '<ESC>' },
      },
    },
    code_action = {
      num_shortcut = true,
      show_server_name = false,
      extend_gitsigns = false,
      only_in_cursor = true,
      max_height = 0.3,
      keys = {
        quit = 'q',
        exec = '<CR>',
      },
    },
    lightbulb = {
      enable = false,
      sign = true,
      debounce = 10,
      sign_priority = 40,
      virtual_text = true,
      enable_in_insert = true,
    },
    scroll_preview = {
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
    },
    request_timeout = 2000,
    finder = {
      max_height = 0.5,
      left_width = 0.4,
      methods = {},
      default = 'ref+imp',
      layout = 'float',
      silent = false,
      filter = {},
      fname_sub = nil,
      sp_inexist = false,
      sp_global = false,
      ly_botright = false,
      keys = {
        shuttle = '[w',
        toggle_or_open = 'o',
        vsplit = 's',
        split = 'i',
        tabe = 't',
        tabnew = 'r',
        quit = 'q',
        close = '<C-c>k',
      },
    },
    definition = {
      width = 0.6,
      height = 0.5,
      save_pos = false,
      keys = {
        edit = '<C-c>o',
        vsplit = '<C-c>v',
        split = '<C-c>i',
        tabe = '<C-c>t',
        tabnew = '<C-c>n',
        quit = 'q',
        close = '<C-c>k',
      },
    },
    rename = {
      in_select = true,
      auto_save = false,
      project_max_width = 0.5,
      project_max_height = 0.5,
      keys = {
        quit = '<C-k>',
        exec = '<CR>',
        select = 'x',
      },
    },
    symbol_in_winbar = {
      enable = true,
      separator = ' › ',
      hide_keyword = false,
      ignore_patterns = nil,
      show_file = true,
      folder_level = 1,
      color_mode = true,
      dely = 300,
    },
    outline = {
      win_position = 'right',
      win_width = 30,
      auto_preview = true,
      detail = true,
      auto_close = true,
      close_after_jump = false,
      layout = 'normal',
      max_height = 0.5,
      left_width = 0.3,
      keys = {
        toggle_or_jump = 'o',
        quit = 'q',
        jump = 'e',
      },
    },
    callhierarchy = {
      layout = 'float',
      left_width = 0.2,
      keys = {
        edit = 'e',
        vsplit = 's',
        split = 'i',
        tabe = 't',
        close = '<C-c>k',
        quit = 'q',
        shuttle = '[w',
        toggle_or_req = 'u',
      },
    },
    implement = {
      enable = false,
      sign = true,
      lang = {},
      virtual_text = true,
      priority = 100,
    },
    beacon = {
      enable = true,
      frequency = 7,
    },
    floaterm = {
      height = 0.7,
      width = 0.7,
    },
  })
end
