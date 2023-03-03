local fzflua_loaded, fzflua = pcall(require, 'fzf-lua')
if not fzflua_loaded then
  return
end

local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')
if not lspconfig_loaded then
  return
end

FzfLuaConfig = {}

local root_pattern = nvim_lspconfig.util.root_pattern

fzflua.setup({
  winopts = {
    width = 1,
    row = 1,
    height = 0.5,
    hl = {
      normal = 'FzfLuaNormal', -- window normal color (fg+bg)
      border = 'FloatBorder', -- border color
      help_normal = 'Normal', -- <F1> window normal
      help_border = 'FloatBorder', -- <F1> window border
      -- Only used with the builtin previewer:
      cursor = 'Cursor', -- cursor highlight (grep/LSP matches)
      cursorline = 'CursorLine', -- cursor line
      cursorlinenr = 'CursorLineNr', -- cursor line number
      search = 'IncSearch', -- search matches (ctags|help)
      title = 'FzfLuaNormal', -- preview border title (file/buffer)
      -- Only used with 'winopts.preview.scrollbar = 'float'
      scrollfloat_e = 'PmenuSbar', -- scrollbar "empty" section highlight
      scrollfloat_f = 'PmenuThumb', -- scrollbar "full" section highlight
      -- Only used with 'winopts.preview.scrollbar = 'border'
      scrollborder_e = 'FloatBorder', -- scrollbar "empty" section highlight
      scrollborder_f = 'FloatBorder', -- scrollbar "full" section highlight
    },
    preview = {
      -- default = 'cat',
      border = 'border',
      -- hidden = 'hidden',
      title = false,
      winopts = {
        number = false,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = 'both',
        cursorcolumn = false,
        signcolumn = 'no',
        list = false,
        foldenable = false,
        foldmethod = 'manual',
      },
    },
    -- previewers = {
    --   builtin = {
    --     extensions = {
    --       ['png'] = { 'viu', '-b' },
    --       ['jpg'] = { 'viu', '-b' },
    --     },
    --   },
    -- },
  },
})

FzfLuaConfig.live_grep = function()
  local project_root = root_pattern('.git')(vim.fn.expand('%:p:h'))
  fzflua.live_grep({ cwd = project_root, multiprocess = true })
end

FzfLuaConfig.grep_cword = function()
  local project_root = root_pattern('.git')(vim.fn.expand('%:p:h'))
  fzflua.grep_cword({ cwd = project_root })
end

local fzfKeymap = function(key, input, raw)
  local cmd = ''
  if raw then
    cmd = string.format('<cmd>lua %s<CR>', input)
  else
    cmd = string.format('<cmd>lua require("fzf-lua").%s<CR>', input)
  end
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

fzfKeymap('<leader>ff', 'git_files()', false)
fzfKeymap('<leader>fr', 'oldfiles()', false)
fzfKeymap('<leader>ll', 'buffers()', false)
fzfKeymap('<leader>.', 'FzfLuaConfig.live_grep()', true)
fzfKeymap('<leader>/', 'builtin()', false)
fzfKeymap('K', 'FzfLuaConfig.grep_cword()', true)
