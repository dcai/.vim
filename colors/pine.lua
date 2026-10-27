-- Pine color scheme
--
-- environment variables
-- - VIM_DISABLE_MODE_CHANGE=true
-- - VIM_PINE_COLORSCHEME_STL_FG='#FFFFFF'
-- - VIM_PINE_COLORSCHEME_STL_BG='#333333'
-- - VIM_PINE_COLORSCHEME_STL_BG_NC='#000000'

vim.opt.background = 'dark'
local colorscheme_name = 'pine'

-- Re-sourcing the file must restore the previous session before replacing it.
if vim.fn.exists('#PineModeChangedGroup') == 1 then
  vim.api.nvim_exec_autocmds('ColorSchemePre', {
    group = 'PineModeChangedGroup',
  })
end

local previous_semantic_priority
if vim.fn.has('nvim-0.11') == 1 then
  previous_semantic_priority = vim.hl.priorities.semantic_tokens
  -- Prefer Tree-sitter colors while Pine is active.
  vim.hl.priorities.semantic_tokens = 90
end

-- Environment variable names
local env_stl_fg = 'VIM_PINE_COLORSCHEME_STL_FG'
local env_stl_bg = 'VIM_PINE_COLORSCHEME_STL_BG'
local env_stl_bg_nc = 'VIM_PINE_COLORSCHEME_STL_BG_NC'
local env_disable_mode_change = 'VIM_DISABLE_MODE_CHANGE'

-- Helper functions for environment variables
local function get_env_or(var_name, default)
  local value = os.getenv(var_name)
  return value ~= nil and value or default
end

local function is_env_true(var_name)
  local value = os.getenv(var_name)
  return value == 'true' or value == '1'
end

vim.cmd.highlight('clear')

-- https://www.schemecolor.com/pine-tree-forest-color-combination.php
local pine_color_scheme = {
  black_leather_jacket = '#263e31',
  kombu_green = '#334a36',
  gray_asparagus = '#4c5e46',
  axolotl = '#697a50',
  moss = '#8d9967',
}

local colors = {
  -- Named RGB colors
  lightblue = 'LightBlue',
  darkblue = 'DarkBlue',
  lightgreen = 'LightGreen',
  green = 'Green',
  darkgreen = 'DarkGreen',
  red = 'Red',
  cyan = 'Cyan',
  darkcyan = 'DarkCyan',
  magenta = 'Magenta',
  darkmagenta = 'DarkMagenta',
  gray = 'Gray',
  darkgray = 'DarkGray',
  yellow = 'Yellow',
  darkyellow = 'DarkYellow',
  black = 'Black',
  white = 'White',
  -- GUI Colors (Hex)
  niceblack = '#0F0F0F',
  beige = '#f5f5dc',
  ivory = '#fffff0',
  niceyellow = '#F0D000',
  nicedarkgreen = '#012619',
  nicelightgreen = '#A6CC57',
  nicered = '#B30000',
  niceblue = '#87ceeb',
  nicegray = '#8F8F8F',
  nicepurple = '#ca5cdd',
  slategray = '#708090',
  darkslategray = '#2F4F4F',
  seagreen = '#2E8B57',
  limegreen = '#32CD32',
  lime = '#00FF00',
  teal = '#008080',
  nicebrown = '#664147',
}

local keyword_hl = { fg = colors.niceblue }
local exceptionfg = colors.red

local defaultfg = colors.beige

-- Highlight Definitions (Lua tables)
local comment_hl = { fg = colors.gray, italic = true }
local repeat_hl = { fg = colors.yellow }
local conditional_hl = { fg = colors.cyan }
local number_hl = { fg = colors.lime }
local function_definition = { fg = colors.nicelightgreen }
local function_call = { fg = colors.niceyellow }
local function_params = { fg = colors.lime }
local variable_hl = { fg = pine_color_scheme.moss }
local special_hl = { fg = colors.red }
local search_hl = { fg = colors.white, bg = colors.darkmagenta, bold = true }
local string_hl = { fg = colors.gray }
local field_hl = { fg = colors.green }
local badspell_hl = { fg = colors.darkgray, underline = true }
local delimiter_hl = { fg = colors.yellow }
local type_hl = { fg = colors.lightgreen, italic = true }

---@param highlights_table table<string, vim.api.keyset.highlight>
local function apply_highlights(highlights_table)
  for group, value in pairs(highlights_table) do
    vim.api.nvim_set_hl(0, group, value)
  end
end

-- UI Highlights
local normal_text_highlight = {
  fg = defaultfg,
}

local dict_visual_selection = {
  bg = colors.nicelightgreen,
  fg = colors.darkgreen,
}

local linenr_bg = get_env_or(env_stl_bg, pine_color_scheme.kombu_green)
local linenr_fg = colors.white

local floatbg = pine_color_scheme.black_leather_jacket
local popupmenubg = colors.darkslategray

local ui = {
  Cursor = { fg = colors.red }, -- Cursor color is often controlled by terminal
  CursorColumn = {}, -- Often set to a subtle background
  CursorLine = { bg = colors.niceblack }, -- Background for the cursor line
  Normal = normal_text_highlight,
  NormalNC = { fg = colors.gray }, -- Non-current window Normal
  NormalFloat = { fg = colors.white, bg = floatbg },
  FloatTitle = { fg = colors.green, bg = floatbg },
  FloatBorder = { bg = floatbg },
  FloatFooter = { bg = floatbg },
  ColorColumn = { bg = '#505050' }, -- Example subtle color for colorcolumn
  Directory = { fg = colors.darkcyan },
  ErrorMsg = { fg = colors.red, bg = colors.yellow },
  FoldColumn = { fg = colors.darkgray },
  Folded = { fg = colors.darkgray, bg = colors.niceblack },
  LineNr = { fg = linenr_fg, bg = linenr_bg },
  SignColumn = { bg = linenr_bg },
  MatchParen = { fg = colors.red },
  ModeMsg = { fg = colors.yellow },
  MoreMsg = { fg = colors.darkgreen },
  Noise = { fg = colors.gray }, -- Punctuation, delimiters in syntax
  NonText = { fg = colors.darkcyan }, -- Characters like trailing spaces, listchars
  Pmenu = { fg = colors.white, bg = popupmenubg },
  PmenuSel = { bg = colors.lightblue, fg = colors.black },
  PmenuSbar = { bg = colors.darkcyan },
  PmenuThumb = { bg = colors.yellow },
  Question = { fg = colors.green },
  Quote = { fg = colors.yellow },
  Search = search_hl,
  IncSearch = search_hl,
  CurSearch = search_hl,
  TabLine = { bg = colors.darkblue, fg = colors.gray }, -- Inactive tabs
  TabLineSel = { bg = colors.white, fg = colors.black }, -- Active tab
  Title = { fg = colors.green, bold = true },
  Underlined = { fg = colors.lightblue, underline = true },
  VertSplit = { fg = colors.green }, -- Separator line
  Visual = dict_visual_selection,
  VisualNOS = { fg = colors.gray, underline = true }, -- Visual selection when vim loses focus
  WarningMsg = { fg = colors.yellow },
}
apply_highlights(ui)

-- Spell Checking
local spell = {
  SpellBad = badspell_hl,
  SpellCap = badspell_hl,
  SpellLocal = badspell_hl,
  SpellRare = badspell_hl,
}
apply_highlights(spell)

-- User Highlights (for statusline etc.)
local user = {
  User1 = { bg = colors.niceyellow, fg = colors.nicedarkgreen },
  User2 = { bg = colors.darkyellow, fg = colors.nicedarkgreen },
  User3 = { bg = colors.nicelightgreen, fg = colors.nicedarkgreen },
  User4 = { bg = colors.niceblue, fg = colors.nicedarkgreen },
  User5 = { bg = colors.niceblack, fg = colors.nicedarkgreen },
  User6 = { bg = colors.nicegray, fg = colors.nicedarkgreen },
}
apply_highlights(user)

-- Syntax Highlighting
local syntax = {
  Boolean = { fg = colors.lightblue },
  Character = { fg = colors.red },
  Comment = comment_hl,
  Conditional = conditional_hl,
  Constant = { fg = colors.darkgreen },
  Debug = { fg = colors.gray },
  Define = { bg = colors.red }, -- Often used for #define
  Delimiter = delimiter_hl,
  -- Diagnostics (LSP)
  DiagnosticError = { fg = colors.red }, -- Error text
  DiagnosticWarn = { fg = colors.yellow }, -- Warning text
  DiagnosticInfo = { fg = colors.lightblue }, -- Info text
  DiagnosticHint = { fg = colors.cyan }, -- Hint text
  DiagnosticOk = { fg = colors.green }, -- OK text (e.g., from null-ls)
  -- Diagnostic Virtual Text/Signs (adjust bg as needed)
  DiagnosticVirtualTextError = { fg = colors.red, bg = colors.nicedarkgreen },
  DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.nicedarkgreen },
  DiagnosticVirtualTextInfo = {
    fg = colors.lightblue,
    bg = colors.nicedarkgreen,
  },
  DiagnosticVirtualTextHint = { fg = colors.cyan, bg = colors.nicedarkgreen },
  -- Use these for diagnostic signs if not using separate plugins
  DiagnosticSignError = { fg = colors.red },
  DiagnosticSignWarn = { fg = colors.yellow },
  DiagnosticSignInfo = { fg = colors.lightblue },
  DiagnosticSignHint = { fg = colors.cyan },

  -- Diff highlighting
  DiffAdd = { fg = colors.white, bg = '#004000' }, -- Darker green bg
  DiffChange = { fg = colors.white, bg = '#000040' }, -- Darker blue bg
  DiffDelete = { fg = colors.white, bg = '#400000' }, -- Darker red bg
  DiffText = { fg = colors.black, bg = '#707070' }, -- Changed text within a line

  Error = { fg = colors.gray, bg = colors.red, bold = true },
  Exception = { fg = colors.red },
  Function = function_definition,
  Identifier = variable_hl, -- Variable names, etc. (often overridden by plugins/treesitter)
  Ignore = { fg = colors.darkgray },
  Include = { fg = pine_color_scheme.gray_asparagus },
  Keyword = keyword_hl,
  Label = { fg = colors.green }, -- case, default labels
  Macro = { fg = colors.red }, -- #define
  Number = number_hl,
  Operator = { fg = colors.nicepurple },
  PreCondit = { fg = colors.darkblue }, -- #if, #ifdef
  PreProc = { fg = colors.darkgray }, -- #include
  Repeat = repeat_hl, -- for, while
  Special = special_hl, -- Special characters in strings, etc.
  SpecialKey = special_hl, -- Unprintable characters in Normal text
  Statement = { fg = colors.darkyellow }, -- if, else, try, catch (often same as Keyword or Conditional)
  StorageClass = { fg = colors.nicered }, -- static, extern, auto
  String = string_hl,
  Structure = { fg = colors.nicelightgreen }, -- struct, union, enum, class
  Tag = { fg = colors.red }, -- HTML tags, etc.
  Todo = { bg = colors.red, fg = colors.white, bold = true },
  Type = type_hl, -- int, char, void
  Typedef = { fg = colors.magenta }, -- typedef
}
apply_highlights(syntax)

-- Custom Plugin Highlighting
local custom = {
  StatusLineAccent = { bg = colors.niceyellow, fg = colors.nicedarkgreen },
  StatusLineProjectAccent = {
    bg = colors.nicelightgreen,
    fg = colors.nicedarkgreen,
  },
  StatusLineHighlight = {
    bg = colors.nicelightgreen,
    fg = colors.nicedarkgreen,
  },
  NotificationInfo = { fg = colors.white },
  NotificationWarning = { fg = colors.black },
  NotificationError = { fg = colors.white },

  -- ALE
  ALEError = { link = 'ErrorMsg' },
  ALEErrorSign = { fg = colors.red },
  ALEWarning = { link = 'WarningMsg' },
  ALEWarningSign = { fg = colors.yellow },
  ALEVirtualTextError = { fg = colors.darkgray }, -- Or match DiagnosticVirtualText
  ALEVirtualTextInfo = { fg = colors.darkgray },
  ALEVirtualTextWarning = { fg = colors.darkgray },

  -- Native inline completion (including Copilot)
  ComplHint = { fg = colors.slategray },

  -- Mini Notify
  MiniNotifyBorder = { link = 'NormalFloat' },
  MiniNotifyNormal = { link = 'NormalFloat' },
  MiniNotifyTitle = { link = 'FloatTitle' },

  -- FzfLua
  FzfLuaNormal = {
    bg = colors.darkslategray,
    fg = colors.white,
  },

  -- Mason
  MasonBackdrop = { bg = colors.black },
  MasonNormal = { link = 'NormalFloat' },
  MasonHeader = { link = 'FloatTitle' },
  MasonHeaderSecondary = { bg = colors.red },

  MasonHighlight = {},
  MasonHighlightBlock = {
    fg = colors.green,
    bg = colors.niceblack,
  },
  MasonHighlightBlockBold = {
    -- this is the selected menu item on top
    fg = colors.green,
    bg = colors.niceblack,
    italic = true,
  },

  MasonHighlightSecondary = { bg = colors.red },
  MasonHighlightBlockSecondary = { bg = colors.red },
  MasonHighlightBlockBoldSecondary = { bg = colors.red },

  MasonLink = { fg = colors.black, underline = true },

  MasonMuted = { fg = colors.nicegray },
  MasonMutedBlock = {
    -- this is the inactive menu items
    fg = colors.white,
    bg = colors.niceblack,
  },
  MasonMutedBlockBold = {
    fg = colors.nicegray,
    bg = colors.niceblack,
    bold = true,
  },

  MasonError = { link = 'ErrorMsg' },
  MasonWarning = { link = 'WarningMsg' },
  MasonHeading = { link = 'FloatTitle' },
}
apply_highlights(custom)

-- Neovim Specific Highlighting
if vim.fn.has('nvim') == 1 then
  local neovim_only = {
    MsgArea = { fg = colors.nicelightgreen }, -- Command line area
    TermCursor = { bg = colors.red, fg = colors.white }, -- Terminal mode cursor
  }
  apply_highlights(neovim_only)

  -- WhichKey
  local whichkey = {
    WhichKey = { fg = colors.niceyellow }, -- Key bindings
    WhichKeyGroup = { fg = colors.nicelightgreen }, -- Group titles
    WhichKeyDesc = { fg = colors.nicelightgreen }, -- Descriptions
    WhichKeySeparator = { fg = colors.nicegray }, -- Separators
    -- Floating window style
    WhichKeyBorder = { link = 'FloatBorder' },
    WhichKeyTitle = { link = 'FloatTitle' },
    WhichKeyNormal = { link = 'NormalFloat' },
  }
  apply_highlights(whichkey)

  -- Tree-sitter captures (:help treesitter-highlight-groups)
  local treesitter = {
    ['@attribute'] = field_hl,
    ['@boolean'] = { link = 'Boolean' },
    ['@character'] = { link = 'Character' },
    ['@character.special'] = { link = 'Special' }, -- Special characters like escape sequences \n
    ['@comment'] = { link = 'Comment' },
    ['@comment.error'] = { fg = colors.red, bold = true },
    ['@comment.todo'] = { link = 'Todo' }, -- Link to existing Todo group
    ['@comment.note'] = { fg = colors.lightblue },
    ['@comment.warning'] = { fg = colors.yellow, bold = true },
    ['@constant'] = { link = 'Constant' }, -- General constants
    ['@constant.builtin'] = { fg = colors.magenta }, -- Built-in constants like true, false, nil
    ['@constant.macro'] = { link = 'Macro' }, -- Constants defined by macros
    ['@constructor'] = { link = 'Function' }, -- Class constructors
    ['@number.float'] = { link = 'Number' }, -- Floating point numbers
    ['@function'] = { link = 'Function' }, -- Function definitions
    ['@function.builtin'] = { bold = true }, -- Built-in functions
    ['@function.call'] = function_call, -- Function calls
    ['@function.macro'] = { link = 'Macro' }, -- Macro definitions
    ['@keyword'] = { link = 'Keyword' }, -- General keywords
    ['@keyword.conditional'] = conditional_hl, -- if, else, switch, case
    ['@keyword.debug'] = { link = 'Debug' }, -- Debug related keywords
    ['@keyword.directive'] = { link = 'PreProc' }, -- Preprocessor directives
    ['@keyword.exception'] = { fg = exceptionfg }, -- try, catch, throw
    ['@keyword.function'] = { link = 'Function' }, -- `function` keyword
    ['@keyword.import'] = { link = 'Include' }, -- import, require, use
    ['@keyword.modifier'] = { fg = colors.teal }, -- public, private, static (Added from original script)
    ['@keyword.operator'] = { link = 'Operator' }, -- `operator` keyword (e.g. in C++)
    ['@keyword.repeat'] = { link = 'Repeat' }, -- for, while, loop
    ['@keyword.return'] = { fg = colors.niceblue }, -- return
    ['@label'] = { link = 'Label' },
    ['@function.method'] = function_definition, -- Method definitions
    ['@function.method.call'] = function_call, -- Method calls
    ['@module'] = { fg = colors.lime }, -- Modules or namespaces
    ['@none'] = {}, -- Fallback group
    ['@number'] = number_hl,
    ['@operator'] = { link = 'Operator' },
    ['@property'] = field_hl,
    ['@punctuation.bracket'] = { fg = colors.ivory }, -- Brackets [], {}
    ['@punctuation.delimiter'] = { fg = colors.ivory }, -- Delimiters like ;, ,, .
    ['@punctuation.special'] = { fg = colors.ivory }, -- Special punctuation like string interpolation ${}
    ['@string'] = { link = 'String' },
    ['@string.escape'] = { link = '@character.special' }, -- Escape sequences within strings
    ['@string.regexp'] = { fg = colors.limegreen }, -- Regular expressions
    ['@string.special'] = { fg = colors.nicepurple }, -- Strings with special meaning (e.g. symbols)
    ['@string.special.symbol'] = { link = '@constant' }, -- Symbols (e.g. in Ruby)
    ['@tag'] = { fg = colors.teal }, -- XML/HTML tags
    ['@tag.attribute'] = { fg = colors.nicelightgreen, italic = true }, -- XML/HTML tag attributes
    ['@tag.delimiter'] = { fg = colors.gray }, -- XML/HTML tag delimiters <> /
    ['@diff.plus'] = { link = 'DiffAdd' },
    ['@diff.minus'] = { link = 'DiffDelete' },
    ['@markup.italic'] = { italic = true }, -- Italic text in markup
    ['@markup.raw'] = { link = '@string' }, -- Literal text in markup
    ['@markup.math'] = { link = '@operator' }, -- Math environments in markup
    ['@markup.quote'] = { link = '@string.special' }, -- Block quotes in markup
    ['@markup.link'] = { link = 'Identifier' }, -- Links, references in markup
    ['@markup.strikethrough'] = { strikethrough = true }, -- Strikethrough text in markup
    ['@markup.strong'] = { bold = true }, -- Bold text in markup
    ['@markup.heading'] = { link = 'Title' }, -- Titles in markup
    ['@markup.underline'] = { underline = true }, -- Underlined text in markup
    ['@markup.link.url'] = { fg = colors.niceblue, underline = true }, -- URIs/URLs
    ['@type'] = type_hl, -- Type definitions
    ['@type.builtin'] = { fg = colors.magenta, italic = true }, -- Built-in types, boolean/string/number
    ['@type.definition'] = { link = 'Typedef' }, -- Type definitions (typedefs, aliases)
    ['@variable'] = variable_hl, -- Variable names
    ['@variable.builtin'] = { fg = colors.nicebrown, italic = true }, -- Super, self, this
    ['@variable.member'] = field_hl, -- Class/struct member variables
    ['@variable.parameter'] = function_params, -- Variables used as parameters
  }
  apply_highlights(treesitter)
end

-- Statusline Mode Highlighting
local statusline_fg = get_env_or(env_stl_fg, pine_color_scheme.moss)
local statusline_bg = get_env_or(env_stl_bg, pine_color_scheme.kombu_green)
local statusline_bg_nc = get_env_or(env_stl_bg_nc, pine_color_scheme.axolotl)

local statusline_n = { -- Normal mode
  fg = statusline_fg,
  bg = statusline_bg,
}
local statusline_nc = { -- Inactive window statusline
  fg = colors.ivory,
  bg = statusline_bg_nc,
}
local statusline_i = { -- Insert mode
  fg = colors.white,
  bg = colors.seagreen, -- A different green for insert
}
local statusline_v = { -- Visual mode
  fg = colors.black,
  bg = colors.nicelightgreen, -- Light green for visual
}
local statusline_r = { -- Replace mode
  fg = colors.white,
  bg = colors.nicered, -- Red for replace
}
local statusline_c = { -- Command mode
  fg = colors.black,
  bg = colors.niceyellow, -- Yellow for command
}
local statusline_t = { -- Terminal mode
  fg = colors.white,
  bg = colors.darkblue, -- Blue for terminal
}

-- mode(1) submodes share the style of their first character.
local mode_statusline_map = {
  i = statusline_i,
  R = statusline_r,
  v = statusline_v,
  V = statusline_v,
  ['\22'] = statusline_v,
  s = statusline_v,
  S = statusline_v,
  ['\19'] = statusline_v,
  c = statusline_c,
  r = statusline_c,
  ['!'] = statusline_t,
  t = statusline_t,
}

-- Apply initial StatusLine highlights
vim.api.nvim_set_hl(0, 'StatusLine', statusline_n)
vim.api.nvim_set_hl(0, 'StatusLineNC', statusline_nc)

-- Mode Change Autocommand
local au_cmd_group = 'PineModeChangedGroup'

vim.api.nvim_create_augroup(au_cmd_group, { clear = true })

local function handle_mode_change()
  if
    is_env_true(env_disable_mode_change)
    or vim.g.colors_name ~= colorscheme_name
  then
    return
  end

  local mode = vim.fn.mode(1):sub(1, 1)
  local highlight = mode_statusline_map[mode] or statusline_n
  vim.api.nvim_set_hl(0, 'StatusLine', highlight)
end

vim.api.nvim_create_autocmd('ModeChanged', {
  group = au_cmd_group,
  callback = handle_mode_change,
})

-- Restore global state and remove Pine's callbacks when switching themes.
vim.api.nvim_create_autocmd('ColorSchemePre', {
  group = au_cmd_group,
  once = true,
  callback = function()
    if
      previous_semantic_priority ~= nil
      and vim.hl.priorities.semantic_tokens == 90
    then
      vim.hl.priorities.semantic_tokens = previous_semantic_priority
    end
    vim.api.nvim_del_augroup_by_name(au_cmd_group)
  end,
})

vim.g.colors_name = colorscheme_name
handle_mode_change()
