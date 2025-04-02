-- Pine color scheme (Lua version)
--
-- environment variables
-- - VIM_DISABLE_MODE_CHANGE=true
-- - VIM_PINE_COLORSCHEME_STL_FG='#FFFFFF'
-- - VIM_PINE_COLORSCHEME_STL_BG='#333333'
-- - VIM_PINE_COLORSCHEME_STL_BG_NC='#000000'

vim.opt.background = 'dark'
local colorscheme_name = 'pine'

-- Environment variable names
local env_name_stl_fg = 'VIM_PINE_COLORSCHEME_STL_FG'
local env_name_stl_bg = 'VIM_PINE_COLORSCHEME_STL_BG'
local env_name_stl_bg_nc = 'VIM_PINE_COLORSCHEME_STL_BG_NC'
local env_name_disable_mode_change = 'VIM_DISABLE_MODE_CHANGE'

-- Helper functions for environment variables
local function get_env_or(var_name, default)
  local value = os.getenv(var_name)
  return value ~= nil and value or default
end

local function is_env_true(var_name)
  local value = os.getenv(var_name)
  return value == 'true' or value == '1'
end

vim.api.nvim_command('hi clear')

if vim.fn.exists('syntax_on') then
  vim.api.nvim_command('syntax reset')
end

-- Attributes
local strikethrough = { strikethrough = true }
local bold = { bold = true }
local italic = { italic = true }
local underline = { underline = true }
local reverse = { reverse = true }

-- Base Colors (using names for cterm compatibility)
local lightblue = 'LightBlue'
local blue = 'Blue'
local darkblue = 'DarkBlue'
local lightgreen = 'LightGreen'
local green = 'Green'
local darkgreen = 'DarkGreen'
local lightred = 'LightRed'
local red = 'Red'
local darkred = 'DarkRed'
local lightcyan = 'LightCyan'
local cyan = 'Cyan'
local darkcyan = 'DarkCyan'
local lightmagenta = 'LightMagenta'
local magenta = 'Magenta'
local darkmagenta = 'DarkMagenta'
local lightgray = 'LightGray'
local gray = 'Gray'
local darkgray = 'DarkGray'
local lightyellow = 'LightYellow'
local yellow = 'Yellow'
local darkyellow = 'DarkYellow'
local brown = 'Brown'
local black = 'Black'
local white = 'White'

-- Adjust base colors if termguicolors is set (matches original logic)
if vim.o.termguicolors then
  blue = lightblue
  green = lightgreen
  yellow = lightyellow
end

-- GUI Colors (Hex)
local niceblack = '#0F0F0F'
local beige = '#f5f5dc'
local ivory = '#fffff0'
local olive = '#808000'
local niceyellow = '#F0D000'
local nicedarkgreen = '#012619'
local nicemidgreen = '#295535'
local nicelightgreen = '#A6CC57'
local nicered = '#B30000'
local niceblue = '#87ceeb'
local nicegray = '#8F8F8F'
local nicepurple = '#ca5cdd'
-- local deeppurple = '#36013f'
-- local russianviolet = '#32174d'
local slategray = '#708090'
local darkslategray = '#2F4F4F'
local seagreen = '#2E8B57'
local limegreen = '#32CD32'
local lime = '#00FF00'
local forestgreen = '#228B22'
local teal = '#008080'

-- Default Palette
local keywordfg = niceblue
local exceptionfg = red

local defaultctermbg = nil
local defaultctermfg = white
local defaultfg = beige
-- local defaultbg = nicedarkgreen -- Default background for Normal
local defaultbg = nil

-- Highlight Definitions (Lua tables)
local comment_hl = { fg = darkslategray }
local identifier_hl = { fg = nicelightgreen, bg = nil }
local repeat_hl = { fg = yellow }
local conditional_hl = { fg = cyan, bg = nil }
local boolean_hl = { fg = blue }
local number_hl = { fg = lime }
local function_hl = { fg = green, bg = nil }
local variable_hl = { fg = niceyellow, bg = nil }
local special_hl = { fg = red, bg = nil }
local search_hl = { fg = white, bg = darkmagenta, cterm = bold }
local string_hl = { fg = gray }
local field_hl = { fg = green, bg = nil }
local badspell_hl = { fg = darkgray, cterm = underline }
local delimiter_hl = { fg = yellow, bg = nil }
local operator_hl = { fg = nicepurple }
local modifier_hl = { fg = gray }
local type_hl = { fg = darkyellow, bg = nil }

-- Helper function to apply highlights
local function set_hl(group, value)
  if not value then
    return
  end -- Skip if value is nil

  local hl_spec = {
    bg = nil,
    ctermbg = nil,
  }
  hl_spec.fg = value.fg
  hl_spec.bg = value.bg
  hl_spec.sp = value.sp

  -- cterm colors (fall back to generic fg/bg if ctermfg/bg not specified)
  hl_spec.ctermfg = value.ctermfg or nil
  hl_spec.ctermbg = value.ctermbg or nil

  if value.cterm and value.cterm ~= nil then
    hl_spec.cterm = value.cterm
    for key, val in pairs(value.cterm) do
      hl_spec[key] = val
    end
  end

  -- soft link to another color group
  if value.link then
    hl_spec.link = value.link
    hl_spec.default = true -- Required when linking
  end

  -- Apply the highlight
  vim.api.nvim_set_hl(0, group, hl_spec)
end

-- Function to apply a table of highlights
local function apply_highlights(highlights_table)
  for group, value in pairs(highlights_table) do
    set_hl(group, value)
  end
end

-- UI Highlights
local normal_text_highlight = {
  bg = defaultbg, -- Set the default background here
  fg = defaultfg,
}
local normal_text_highlight_visualmode = { fg = red }
local normal_text_highlight_cmdmode = { fg = darkgreen }

local dict_visual_selection = {
  bg = nicelightgreen,
  fg = darkgreen,
}

local linenr_bg = niceblack
local linenr_fg = nicelightgreen

local floatnormalbg = nicemidgreen
local popupmenubg = darkslategray

local ui = {
  Cursor = { fg = red, bg = nil }, -- Cursor color is often controlled by terminal
  CursorColumn = { bg = nil }, -- Often set to a subtle background
  CursorLine = { bg = niceblack }, -- Background for the cursor line
  Normal = normal_text_highlight,
  NormalNC = { fg = gray, bg = defaultbg }, -- Non-current window Normal
  NormalFloat = { fg = green, bg = floatnormalbg },
  FloatTitle = { fg = green, bg = floatnormalbg },
  FloatBorder = { fg = green, bg = floatnormalbg },
  ColorColumn = { bg = '#505050' }, -- Example subtle color for colorcolumn
  Directory = { fg = darkcyan },
  ErrorMsg = { fg = red, bg = yellow },
  FoldColumn = { fg = darkgray },
  Folded = { fg = darkgray, bg = niceblack },
  LineNr = { fg = linenr_fg, bg = linenr_bg },
  SignColumn = { bg = defaultbg }, -- Match Normal background
  MatchParen = { fg = red, bg = nicegray, cterm = bold },
  ModeMsg = { fg = yellow },
  MoreMsg = { fg = darkgreen },
  Noise = { fg = gray }, -- Punctuation, delimiters in syntax
  NonText = { fg = darkcyan }, -- Characters like trailing spaces, listchars
  Pmenu = { fg = white, bg = popupmenubg },
  PmenuSel = { bg = blue, fg = black },
  PmenuSbar = { bg = darkcyan },
  PmenuThumb = { bg = yellow },
  Question = { fg = green },
  Quote = { fg = yellow }, -- ??? Original had this, might be unused by default
  Search = search_hl,
  IncSearch = search_hl,
  CurSearch = search_hl, -- Neovim specific? Often same as IncSearch
  TabLine = { bg = darkblue, fg = gray }, -- Inactive tabs
  TabLineSel = { bg = white, fg = black }, -- Active tab
  Title = { fg = green, bg = nil, cterm = bold },
  Underlined = { fg = blue, cterm = underline },
  VertSplit = { fg = green }, -- Separator line
  Visual = dict_visual_selection,
  VisualNOS = { fg = gray, cterm = underline }, -- Visual selection when vim loses focus
  WarningMsg = { fg = yellow },
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
  User1 = { bg = niceyellow, fg = nicedarkgreen },
  User2 = { bg = darkyellow, fg = nicedarkgreen },
  User3 = { bg = nicelightgreen, fg = nicedarkgreen },
  User4 = { bg = niceblue, fg = nicedarkgreen },
  User5 = { bg = niceblack, fg = nicedarkgreen },
  User6 = { bg = nicegray, fg = nicedarkgreen },
}
apply_highlights(user)

-- Syntax Highlighting
local syntax = {
  Boolean = boolean_hl,
  Character = { fg = red },
  Comment = comment_hl,
  Conditional = conditional_hl,
  Constant = { fg = darkgreen },
  Debug = { fg = gray },
  Define = { bg = red }, -- Often used for #define
  Delimiter = delimiter_hl,
  -- Diagnostics (LSP)
  DiagnosticError = { fg = red }, -- Error text
  DiagnosticWarn = { fg = yellow }, -- Warning text
  DiagnosticInfo = { fg = blue }, -- Info text
  DiagnosticHint = { fg = cyan }, -- Hint text
  DiagnosticOk = { fg = green }, -- OK text (e.g., from null-ls)
  -- Diagnostic Virtual Text/Signs (adjust bg as needed)
  DiagnosticVirtualTextError = { fg = red, bg = nicedarkgreen },
  DiagnosticVirtualTextWarn = { fg = yellow, bg = nicedarkgreen },
  DiagnosticVirtualTextInfo = { fg = blue, bg = nicedarkgreen },
  DiagnosticVirtualTextHint = { fg = cyan, bg = nicedarkgreen },
  -- Use these for diagnostic signs if not using separate plugins
  DiagnosticSignError = { fg = red, bg = defaultbg },
  DiagnosticSignWarn = { fg = yellow, bg = defaultbg },
  DiagnosticSignInfo = { fg = blue, bg = defaultbg },
  DiagnosticSignHint = { fg = cyan, bg = defaultbg },

  -- Diff highlighting
  DiffAdd = { fg = white, bg = '#004000' }, -- Darker green bg
  DiffChange = { fg = white, bg = '#000040' }, -- Darker blue bg
  DiffDelete = { fg = white, bg = '#400000' }, -- Darker red bg
  DiffText = { fg = black, bg = '#707070' }, -- Changed text within a line

  Error = { fg = gray, bg = red, cterm = bold },
  Exception = { fg = red, bg = nil },
  Function = function_hl,
  Identifier = identifier_hl, -- Variable names, etc. (often overridden by plugins/treesitter)
  Ignore = { fg = darkgray },
  Include = { fg = darkgray, bg = nil },
  Keyword = { fg = keywordfg, bg = nil },
  Label = { fg = green }, -- case, default labels
  Macro = { fg = red }, -- #define
  Number = number_hl,
  Operator = operator_hl,
  PreCondit = { fg = keywordfg }, -- #if, #ifdef
  PreProc = { fg = keywordfg }, -- #include
  Repeat = repeat_hl, -- for, while
  Special = special_hl, -- Special characters in strings, etc.
  SpecialKey = special_hl, -- Unprintable characters in Normal text
  Statement = { fg = darkyellow }, -- if, else, try, catch (often same as Keyword or Conditional)
  StorageClass = { fg = darkred }, -- static, extern, auto
  String = string_hl,
  Structure = { fg = red }, -- struct, union, enum
  Tag = { fg = red }, -- HTML tags, etc.
  Todo = { bg = red, fg = white, cterm = bold },
  Type = type_hl, -- int, char, void
  Typedef = { fg = magenta }, -- typedef
}
apply_highlights(syntax)

-- Custom Plugin Highlighting
local custom = {
  StatusLineAccent = { bg = niceyellow, fg = nicedarkgreen },
  StatusLineProjectAccent = { bg = nicelightgreen, fg = nicedarkgreen },
  StatusLineHighlight = { bg = nicelightgreen, fg = nicedarkgreen },
  NotificationInfo = { bg = darkslategray, fg = white },
  NotificationWarning = { bg = darkslategray, fg = black },
  NotificationError = { bg = darkslategray, fg = white },

  -- ALE (Example - may need adjustment based on ALE config)
  ALEError = { link = 'ErrorMsg' },
  ALEErrorSign = { fg = red, bg = defaultbg },
  ALEWarning = { link = 'WarningMsg' },
  ALEWarningSign = { fg = yellow, bg = defaultbg },
  ALEVirtualTextError = { fg = darkgray, bg = nil }, -- Or match DiagnosticVirtualText
  ALEVirtualTextInfo = { fg = darkgray, bg = nil },
  ALEVirtualTextWarning = { fg = darkgray, bg = nil },

  -- Coc (Example - may need adjustment)
  CocErrorFloat = { fg = red },
  CocHighlightText = { bg = red, fg = white },
  CocHintFloat = { fg = black }, -- Check appearance
  CocInfoFloat = { fg = blue },
  CocMenuSel = { bg = red }, -- Check appearance
  CocSearch = { fg = darkblue },
  CocWarningFloat = { fg = red },

  -- Codeium / Copilot
  CodeiumSuggestion = { fg = slategray },
  CopilotSuggestion = { fg = slategray }, -- Often same as Codeium

  -- Mini Notify
  MiniNotifyBorder = { fg = darkslategray },
  MiniNotifyNormal = { fg = white, bg = darkslategray },

  -- GitSigns / Signify
  SignifySignAdd = { fg = green },
  SignifySignChange = { fg = yellow },
  SignifySignDelete = { fg = darkred },
  SignifySignDeleteFirstLine = { fg = darkred },
  GitSignsAdd = { fg = green, bg = defaultbg },
  GitSignsChange = { fg = yellow, bg = defaultbg },
  GitSignsDelete = { fg = red, bg = defaultbg },

  -- FzfLua
  FzfLuaNormal = {
    bg = darkslategray,
    fg = white,
  },

  -- Mason
  MasonNormal = { bg = teal, fg = white },
  MasonHeader = {
    bg = white,
    fg = black,
    cterm = bold,
  },
  MasonHeading = { fg = yellow, cterm = bold },
  MasonError = { fg = nicered },
  MasonWarning = { fg = yellow },
  MasonHighlight = { fg = green },
  MasonHighlightBlock = {
    fg = green,
    bg = niceblack,
  },
  MasonHighlightBlockBold = {
    fg = green,
    bg = niceblack,
    cterm = bold,
  },
  MasonHighlightSecondary = { fg = blue },
  MasonLink = { fg = black, cterm = underline },
  MasonMuted = { fg = nicegray },
  MasonMutedBlock = {
    fg = nicegray,
    bg = niceblack,
  },
  MasonMutedBlockBold = {
    fg = nicegray,
    bg = niceblack,
    cterm = bold,
  },
}
apply_highlights(custom)

-- Language Specific (Example: Javascript/JSX/TSX)
local js = {
  -- Legacy vim-javascript syntax groups
  jsxTagName = { fg = green },
  tsxTagName = { fg = green },
  jsxElement = { fg = red },
  jsFuncArgs = { fg = yellow },
  jsObjectKey = {
    fg = nicered,
    bg = nicedarkgreen,
  },
  -- Treesitter groups often preferred (see below)
}
apply_highlights(js)

-- Neovim Specific Highlighting
if vim.fn.has('nvim') == 1 then
  local neovim_only = {
    MsgArea = { bg = nil, fg = nicelightgreen }, -- Command line area
    TermCursor = { bg = red, fg = white }, -- Terminal mode cursor
    TermCursorNC = { bg = gray, fg = black }, -- Terminal mode cursor in inactive window
  }
  apply_highlights(neovim_only)

  -- WhichKey
  local whichkeybg = darkslategray
  local whichkey = {
    WhichKey = { fg = niceblue }, -- Key bindings
    WhichKeyGroup = { fg = nicepurple }, -- Group titles
    WhichKeyDesc = { fg = nicelightgreen }, -- Descriptions
    WhichKeySeparator = { fg = nicegray }, -- Separators
    -- Floating window style
    WhichKeyFloat = { bg = whichkeybg },
    WhichKeyBorder = { bg = whichkeybg },
    -- Legacy names? (Included from original script)
    WhichKeyTitle = { fg = white, bg = whichkeybg, cterm = bold },
    WhichKeyNormal = { fg = darkgray, bg = whichkeybg }, -- Unused?
  }
  apply_highlights(whichkey)

  -- Nvim-Cmp (Completion Menu)
  local cmp = {
    CmpItemAbbr = { bg = nil, fg = nicegray }, -- Abbreviation Text
    CmpItemAbbrDeprecated = { fg = green, bg = nil, cterm = strikethrough },
    CmpItemAbbrMatch = { fg = blue, bg = nil, cterm = bold }, -- Matched characters
    CmpItemAbbrMatchFuzzy = { fg = blue, bg = nil, cterm = bold }, -- Fuzzy matched characters
    CmpItemKind = { fg = yellow, bg = nil }, -- Default Kind Icon/Text
    CmpItemMenu = { fg = black, bg = nicelightgreen }, -- Source Name (LSP, Buffer, etc.)

    -- Specific Kind Highlighting (Examples - customize based on icons/prefs)
    CmpItemKindText = { fg = white, bg = nil },
    CmpItemKindMethod = { bg = nil, fg = niceblue },
    CmpItemKindFunction = { bg = nil, fg = niceblue },
    CmpItemKindConstructor = { bg = nil, fg = nicepurple },
    CmpItemKindField = { bg = nil, fg = nicelightgreen },
    CmpItemKindVariable = { bg = nil, fg = ivory }, -- Light color for variables
    CmpItemKindClass = { bg = nil, fg = niceyellow },
    CmpItemKindInterface = { bg = nil, fg = niceyellow },
    CmpItemKindModule = { fg = darkgreen, bg = nil },
    CmpItemKindProperty = { bg = nil, fg = nicelightgreen },
    CmpItemKindUnit = { fg = darkcyan, bg = nil },
    CmpItemKindValue = { fg = lightmagenta, bg = nil },
    CmpItemKindEnum = { fg = darkcyan, bg = nil },
    CmpItemKindKeyword = { fg = red, bg = nil },
    CmpItemKindSnippet = { fg = gray, bg = nil },
    CmpItemKindColor = { fg = magenta, bg = nil },
    CmpItemKindFile = { fg = darkcyan, bg = nil },
    CmpItemKindReference = { fg = magenta, bg = nil },
    CmpItemKindFolder = { fg = darkcyan, bg = nil },
    CmpItemKindEnumMember = { bg = nil, fg = nicelightgreen },
    CmpItemKindConstant = { bg = nil, fg = niceyellow },
    CmpItemKindStruct = { fg = red, bg = nil },
    CmpItemKindEvent = { fg = magenta, bg = nil },
    CmpItemKindOperator = { bg = nil, fg = nicepurple },
    CmpItemKindTypeParameter = { fg = red, bg = nil },

    -- Plugin specific Kinds
    CmpItemKindCodeium = { fg = yellow, bg = red }, -- Original style
    CmpItemKindCopilot = { fg = cyan, bg = darkmagenta }, -- Example style
  }
  apply_highlights(cmp)

  -- Treesitter Highlighting Groups (https://github.com/nvim-treesitter/nvim-treesitter#highlight-groups)
  local treesitter = {
    ['@attribute'] = field_hl, -- @field / @property ?
    ['@boolean'] = boolean_hl,
    ['@character'] = { fg = darkgreen },
    ['@character.special'] = special_hl, -- Special characters like escape sequences \n
    ['@comment'] = comment_hl,
    ['@comment.error'] = { fg = red, cterm = bold },
    ['@comment.todo'] = { link = 'Todo' }, -- Link to existing Todo group
    ['@comment.note'] = { fg = blue },
    ['@comment.warning'] = { fg = yellow, cterm = bold },
    ['@conditional'] = conditional_hl,
    ['@constant'] = { fg = darkgreen }, -- General constants
    ['@constant.builtin'] = { fg = magenta, cterm = italic }, -- Built-in constants like true, false, nil
    ['@constant.macro'] = { link = 'Macro' }, -- Constants defined by macros
    ['@constructor'] = { fg = nicepurple }, -- Class constructors
    ['@error'] = { link = 'Error' },
    ['@exception'] = { fg = exceptionfg },
    ['@field'] = field_hl, -- Object/struct fields
    ['@float'] = number_hl, -- Floating point numbers
    ['@function'] = function_hl, -- Function definitions
    ['@function.builtin'] = { fg = niceblue, cterm = italic }, -- Built-in functions
    ['@function.call'] = function_hl, -- Function calls
    ['@function.macro'] = { link = 'Macro' }, -- Macro definitions
    ['@include'] = { link = 'Include' },
    ['@keyword'] = { fg = keywordfg }, -- General keywords
    ['@keyword.conditional'] = conditional_hl, -- if, else, switch, case
    ['@keyword.debug'] = { link = 'Debug' }, -- Debug related keywords
    ['@keyword.directive'] = { link = 'PreProc' }, -- Preprocessor directives
    ['@keyword.exception'] = { fg = exceptionfg }, -- try, catch, throw
    ['@keyword.function'] = { fg = yellow }, -- `function` keyword
    ['@keyword.import'] = { link = 'Include' }, -- import, require, use
    ['@keyword.modifier'] = modifier_hl, -- public, private, static (Added from original script)
    ['@keyword.operator'] = operator_hl, -- `operator` keyword (e.g. in C++)
    ['@keyword.repeat'] = repeat_hl, -- for, while, loop
    ['@keyword.return'] = { fg = niceblue }, -- return
    ['@keyword.storage'] = { link = 'StorageClass' }, -- static, extern, const, let, var
    ['@label'] = { link = 'Label' },
    ['@lsp.type.class'] = { fg = nicepurple }, -- LSP semantic token for classes
    ['@lsp.type.comment'] = comment_hl, -- LSP semantic token for comments
    ['@lsp.type.decorator'] = { link = '@attribute' }, -- LSP semantic token for decorators
    ['@lsp.type.enum'] = { fg = olive }, -- LSP semantic token for enums
    ['@lsp.type.enumMember'] = { link = '@constant' }, -- LSP semantic token for enum members
    ['@lsp.type.function'] = { link = '@function' }, -- LSP semantic token for functions
    ['@lsp.type.interface'] = { fg = beige }, -- LSP semantic token for interfaces
    ['@lsp.type.macro'] = { link = '@function.macro' }, -- LSP semantic token for macros
    ['@lsp.type.method'] = { link = '@method' }, -- LSP semantic token for methods
    ['@lsp.type.namespace'] = { fg = niceblue }, -- LSP semantic token for namespaces
    ['@lsp.type.parameter'] = { link = '@parameter' }, -- LSP semantic token for parameters
    ['@lsp.type.property'] = field_hl, -- LSP semantic token for properties
    ['@lsp.type.struct'] = { fg = red }, -- LSP semantic token for structs
    ['@lsp.type.type'] = { link = '@type' }, -- LSP semantic token for types
    ['@lsp.type.typeParameter'] = { link = '@type.definition' }, -- LSP semantic token for type parameters
    ['@lsp.type.variable'] = { link = '@variable' }, -- LSP semantic token for variables
    -- Modifiers for LSP semantic tokens (e.g., @lsp.mod.readonly) - typically don't need color, maybe italic/bold
    ['@lsp.mod.readonly'] = { cterm = nil },
    ['@lsp.mod.static'] = { cterm = nil },
    ['@lsp.mod.declaration'] = { cterm = italic },
    ['@method'] = function_hl, -- Method definitions
    ['@method.call'] = function_hl, -- Method calls
    ['@module'] = { fg = lime }, -- Modules or namespaces
    ['@namespace'] = { link = '@module' },
    ['@none'] = {}, -- Fallback group
    ['@number'] = number_hl,
    ['@operator'] = operator_hl,
    ['@parameter'] = { fg = lightblue, cterm = italic }, -- Function parameters
    ['@property'] = field_hl, -- Same as @field
    ['@punctuation.bracket'] = { fg = ivory }, -- Brackets [], {}
    ['@punctuation.delimiter'] = { fg = ivory }, -- Delimiters like ;, ,, .
    ['@punctuation.special'] = { fg = ivory }, -- Special punctuation like string interpolation ${}
    ['@repeat'] = repeat_hl,
    ['@string'] = string_hl,
    ['@string.escape'] = { link = '@character.special' }, -- Escape sequences within strings
    ['@string.regex'] = { fg = limegreen }, -- Regular expressions
    ['@string.special'] = { fg = nicepurple }, -- Strings with special meaning (e.g. symbols)
    ['@symbol'] = { link = '@constant' }, -- Symbols (e.g. in Ruby)
    ['@tag'] = { fg = teal }, -- XML/HTML tags
    ['@tag.attribute'] = { fg = nicelightgreen, cterm = italic }, -- XML/HTML tag attributes
    ['@tag.delimiter'] = { fg = gray }, -- XML/HTML tag delimiters <> /
    ['@text'] = { link = 'Normal' }, -- Base text
    ['@text.danger'] = { link = '@error' },
    ['@text.diff.add'] = { link = 'DiffAdd' },
    ['@text.diff.delete'] = { link = 'DiffDelete' },
    ['@text.emphasis'] = { cterm = italic }, -- Italic text in markup
    ['@text.environment'] = { link = '@module' }, -- Environment variable in Makefiles etc.
    ['@text.literal'] = { link = '@string' }, -- Literal text in markup
    ['@text.math'] = { link = '@operator' }, -- Math environments in markup
    ['@text.note'] = { link = '@comment.note' },
    ['@text.quote'] = { link = '@string.special' }, -- Block quotes in markup
    ['@text.reference'] = { link = '@identifier' }, -- Links, references in markup
    ['@text.strike'] = { cterm = strikethrough }, -- Strikethrough text in markup
    ['@text.strong'] = { cterm = bold }, -- Bold text in markup
    ['@text.title'] = { link = 'Title' }, -- Titles in markup
    ['@text.todo'] = { link = 'Todo' },
    ['@text.underline'] = { cterm = underline }, -- Underlined text in markup
    ['@text.uri'] = { fg = niceblue, cterm = underline }, -- URIs/URLs
    ['@text.warning'] = { link = '@comment.warning' },
    ['@type'] = type_hl, -- Type definitions
    ['@type.builtin'] = { fg = magenta, cterm = italic }, -- Built-in types
    ['@type.definition'] = type_hl, -- Type definitions (typedefs, aliases)
    ['@type.qualifier'] = { link = '@keyword.storage' }, -- Type qualifiers (const, volatile)
    ['@variable'] = variable_hl, -- Variable names
    ['@variable.builtin'] = { fg = nicepurple, cterm = italic }, -- Super, self, this
    ['@variable.member'] = field_hl, -- Class/struct member variables
    ['@variable.parameter'] = { link = '@parameter' }, -- Variables used as parameters
  }
  apply_highlights(treesitter)
end

-- Statusline Mode Highlighting
local statusline_fg = get_env_or(env_name_stl_fg, nicelightgreen)
local statusline_bg = get_env_or(env_name_stl_bg, darkgreen) -- Used nicemidgreen before, darkgreen is original
local statusline_bg_nc = get_env_or(env_name_stl_bg_nc, darkgray)

local statusline_n = { -- Normal mode
  fg = statusline_fg,
  bg = statusline_bg,
}
local statusline_nc = { -- Inactive window statusline
  fg = ivory,
  bg = statusline_bg_nc,
}
local statusline_i = { -- Insert mode
  fg = white,
  bg = seagreen, -- A different green for insert
}
local statusline_v = { -- Visual mode
  fg = black,
  bg = nicelightgreen, -- Light green for visual
}
local statusline_r = { -- Replace mode
  fg = white,
  bg = nicered, -- Red for replace
}
local statusline_c = { -- Command mode
  fg = black,
  bg = niceyellow, -- Yellow for command
}
local statusline_t = { -- Terminal mode
  fg = white,
  bg = niceblue, -- Blue for terminal
}

local mode_statusline_map = {
  ['n'] = statusline_n, -- Normal
  ['no'] = statusline_n, -- Operator pending
  ['nov'] = statusline_n,
  ['noV'] = statusline_n,
  ['no\22'] = statusline_n, -- Ctrl+V Operator pending
  ['niI'] = statusline_n, -- Normal mode (startup) - Insert
  ['niR'] = statusline_n, -- Normal mode (startup) - Replace
  ['niV'] = statusline_n, -- Normal mode (startup) - Virtual Replace
  ['nt'] = statusline_n, -- Normal mode in Terminal
  ['v'] = statusline_v, -- Visual character
  ['V'] = statusline_v, -- Visual line
  ['\22'] = statusline_v, -- Visual block (Ctrl+V)
  ['s'] = statusline_v, -- Select character
  ['S'] = statusline_v, -- Select line
  ['\19'] = statusline_v, -- Select block (Ctrl+S)
  ['i'] = statusline_i, -- Insert
  ['ic'] = statusline_i, -- Insert (completion)
  ['ix'] = statusline_i, -- Insert (completion)
  ['R'] = statusline_r, -- Replace
  ['Rc'] = statusline_r, -- Replace (completion)
  ['Rx'] = statusline_r, -- Replace (completion)
  ['Rv'] = statusline_r, -- Virtual Replace
  ['Rvc'] = statusline_r, -- Virtual Replace (completion)
  ['Rvx'] = statusline_r, -- Virtual Replace (completion)
  ['c'] = statusline_c, -- Command line
  ['cv'] = statusline_c, -- Vim Ex mode
  ['ce'] = statusline_c, -- Normal Ex mode
  ['r'] = statusline_c, -- Prompt (more, input)
  ['rm'] = statusline_c, -- More prompt
  ['r?'] = statusline_c, -- Confirm prompt
  ['!'] = statusline_t, -- Shell command in terminal
  ['t'] = statusline_t, -- Terminal mode
}

-- Default Text Highlighting Per Mode (Subtle changes)
local default_text_highlight_map = {
  ['n'] = normal_text_highlight,
  ['v'] = normal_text_highlight, -- Keep normal text colors in visual mode
  ['V'] = normal_text_highlight,
  ['\22'] = normal_text_highlight,
  ['i'] = normal_text_highlight, -- Keep normal text colors in insert mode
  ['c'] = { fg = darkgreen }, -- Maybe change command mode text slightly? Optional.
  -- Add other modes if desired
}

-- Apply initial StatusLine highlights
set_hl('StatusLine', statusline_n)
set_hl('StatusLineNC', statusline_nc)

-- Mode Change Autocommand
local au_cmd_group = 'PineModeChangedGroup'

vim.api.nvim_create_augroup(au_cmd_group, { clear = true })

local function handleModeChange()
  if is_env_true(env_name_disable_mode_change) then
    return
  end
  if vim.g.colors_name ~= colorscheme_name then
    -- Only apply if this colorscheme is active
    -- Can clear the autocommand here if desired, but checking is cheap
    return
  end

  local current_mode = vim.fn.mode()
  -- print("Mode changed to: " .. current_mode) -- Debugging

  -- Update StatusLine highlight
  local stl_hl = mode_statusline_map[current_mode] or statusline_n -- Default to Normal mode style

  set_hl('StatusLine', stl_hl)

  -- -- Update Normal text highlight (Optional - subtle changes)
  -- local normal_hl = default_text_highlight_map[current_mode]
  --   or normal_text_highlight
  -- -- Need to merge with base Normal to keep background etc.
  -- local final_normal_hl =
  --   vim.tbl_deep_extend('force', {}, normal_text_highlight, normal_hl)
  -- set_hl('Normal', final_normal_hl)
end

vim.api.nvim_create_autocmd('ModeChanged', {
  group = au_cmd_group,
  pattern = '*', -- Trigger on all mode changes
  callback = handleModeChange,
})

vim.g.colors_name = colorscheme_name
