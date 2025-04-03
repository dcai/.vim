-- Pine color scheme
--
-- environment variables
-- - VIM_DISABLE_MODE_CHANGE=true
-- - VIM_PINE_COLORSCHEME_STL_FG='#FFFFFF'
-- - VIM_PINE_COLORSCHEME_STL_BG='#333333'
-- - VIM_PINE_COLORSCHEME_STL_BG_NC='#000000'

vim.opt.background = 'dark'
local colorscheme_name = 'pine'

local vim_version = vim.version()
if vim_version.major >= 0 and vim_version.minor >= 11 then
  vim.hl.priorities = {
    syntax = 50,
    treesitter = 100,
    semantic_tokens = 90,
    diagnostics = 150,
    user = 200,
  }
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

vim.api.nvim_command('hi clear')

-- -- depends on treesitter, so don't depends on `syntax on`
-- if vim.fn.exists('syntax_on') then
--   vim.api.nvim_command('syntax reset')
-- end
-- https://www.schemecolor.com/pine-tree-forest-color-combination.php
local pine_color_scheme = {
  black_leather_jacket = '#263e31',
  kombu_green = '#334a36',
  gray_asparagus = '#4c5e46',
  axolotl = '#697a50',
  moss = '#8d9967',
}

local colors = {
  -- Base Colors (using names for cterm compatibility)
  lightblue = 'LightBlue',
  blue = 'Blue',
  darkblue = 'DarkBlue',
  lightgreen = 'LightGreen',
  green = 'Green',
  darkgreen = 'DarkGreen',
  lightred = 'LightRed',
  red = 'Red',
  darkred = 'DarkRed',
  lightcyan = 'LightCyan',
  cyan = 'Cyan',
  darkcyan = 'DarkCyan',
  lightmagenta = 'LightMagenta',
  magenta = 'Magenta',
  darkmagenta = 'DarkMagenta',
  lightgray = 'LightGray',
  gray = 'Gray',
  darkgray = 'DarkGray',
  lightyellow = 'LightYellow',
  yellow = 'Yellow',
  darkyellow = 'DarkYellow',
  brown = 'Brown',
  black = 'Black',
  white = 'White',
  -- GUI Colors (Hex)
  niceblack = '#0F0F0F',
  beige = '#f5f5dc',
  ivory = '#fffff0',
  olive = '#808000',
  niceyellow = '#F0D000',
  nicedarkgreen = '#012619',
  nicemidgreen = '#295535',
  nicelightgreen = '#A6CC57',
  nicered = '#B30000',
  niceblue = '#87ceeb',
  nicegray = '#8F8F8F',
  nicepurple = '#ca5cdd',
  deeppurple = '#36013f',
  russianviolet = '#32174d',
  slategray = '#708090',
  darkslategray = '#2F4F4F',
  seagreen = '#2E8B57',
  limegreen = '#32CD32',
  lime = '#00FF00',
  forestgreen = '#228B22',
  teal = '#008080',
  nicebrown = '#664147',
}

-- Attributes
local styles = {
  strikethrough = { strikethrough = true },
  bold = { bold = true },
  italic = { italic = true },
  underline = { underline = true },
  reverse = { reverse = true }
}

local keywordfg = colors.niceblue
local exceptionfg = colors.red

local defaultfg = colors.beige
-- local defaultbg = colors.nicedarkgreen -- Default background for Normal
local defaultbg = nil

-- Highlight Definitions (Lua tables)
local comment_hl = { fg = colors.gray, cterm = styles.italic }
local repeat_hl = { fg = colors.yellow }
local conditional_hl = { fg = colors.cyan, bg = nil }
local number_hl = { fg = colors.lime }
local function_definition = { fg = colors.nicelightgreen, bg = nil }
local function_call = { fg = colors.niceyellow, bg = nil }
local function_params = { fg = colors.lime, cterm = nil }
local variable_hl = { fg = pine_color_scheme.moss, bg = nil }
local special_hl = { fg = colors.red, bg = nil }
local search_hl = { fg = colors.white, bg = colors.darkmagenta, cterm = styles.bold }
local string_hl = { fg = colors.gray }
local field_hl = { fg = colors.green, bg = nil }
local badspell_hl = { fg = colors.darkgray, cterm = styles.underline }
local delimiter_hl = { fg = colors.yellow, bg = nil }
local type_hl = { fg = colors.lightgreen, cterm = styles.italic }

---Helper function to apply highlights
---@class HighlightSpec
---@inlinedoc
---@field fg? string
---@field bg? string
---@field sp? string
---@field link? string
---@field cterm? string[] see `highlight-args`
---
---@param group string
---@param value HighlightSpec
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
local _normal_text_highlight_visualmode = { fg = colors.red }
local _normal_text_highlight_cmdmode = { fg = colors.darkgreen }

local dict_visual_selection = {
  bg = colors.nicelightgreen,
  fg = colors.darkgreen,
}

local linenr_bg = get_env_or(env_stl_bg, pine_color_scheme.kombu_green)
local linenr_fg = pine_color_scheme.moss

local floatbg = pine_color_scheme.black_leather_jacket
local popupmenubg = colors.darkslategray

local ui = {
  Cursor = { fg = colors.red, bg = nil },          -- Cursor color is often controlled by terminal
  CursorColumn = { bg = nil },                     -- Often set to a subtle background
  CursorLine = { bg = colors.niceblack },          -- Background for the cursor line
  Normal = normal_text_highlight,
  NormalNC = { fg = colors.gray, bg = defaultbg }, -- Non-current window Normal
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
  SignColumn = { bg = defaultbg }, -- Match Normal background
  MatchParen = { fg = colors.red, bg = colors.nicegray, cterm = styles.bold },
  ModeMsg = { fg = colors.yellow },
  MoreMsg = { fg = colors.darkgreen },
  Noise = { fg = colors.gray },       -- Punctuation, delimiters in syntax
  NonText = { fg = colors.darkcyan }, -- Characters like trailing spaces, listchars
  Pmenu = { fg = colors.white, bg = popupmenubg },
  PmenuSel = { bg = colors.lightblue, fg = colors.black },
  PmenuSbar = { bg = colors.darkcyan },
  PmenuThumb = { bg = colors.yellow },
  Question = { fg = colors.green },
  Quote = { fg = colors.yellow }, -- ??? Original had this, might be unused by default
  Search = search_hl,
  IncSearch = search_hl,
  CurSearch = search_hl,                                 -- Neovim specific? Often same as IncSearch
  TabLine = { bg = colors.darkblue, fg = colors.gray },  -- Inactive tabs
  TabLineSel = { bg = colors.white, fg = colors.black }, -- Active tab
  Title = { fg = colors.green, bg = nil, cterm = styles.bold },
  Underlined = { fg = colors.blue, cterm = styles.underline },
  VertSplit = { fg = colors.green },                          -- Separator line
  Visual = dict_visual_selection,
  VisualNOS = { fg = colors.gray, cterm = styles.underline }, -- Visual selection when vim loses focus
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
  Boolean = { fg = colors.blue },
  Character = { fg = colors.red },
  Comment = comment_hl,
  Conditional = conditional_hl,
  Constant = { fg = colors.darkgreen },
  Debug = { fg = colors.gray },
  Define = { bg = colors.red }, -- Often used for #define
  Delimiter = delimiter_hl,
  -- Diagnostics (LSP)
  DiagnosticError = { fg = colors.red },   -- Error text
  DiagnosticWarn = { fg = colors.yellow }, -- Warning text
  DiagnosticInfo = { fg = colors.blue },   -- Info text
  DiagnosticHint = { fg = colors.cyan },   -- Hint text
  DiagnosticOk = { fg = colors.green },    -- OK text (e.g., from null-ls)
  -- Diagnostic Virtual Text/Signs (adjust bg as needed)
  DiagnosticVirtualTextError = { fg = colors.red, bg = colors.nicedarkgreen },
  DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.nicedarkgreen },
  DiagnosticVirtualTextInfo = { fg = colors.blue, bg = colors.nicedarkgreen },
  DiagnosticVirtualTextHint = { fg = colors.cyan, bg = colors.nicedarkgreen },
  -- Use these for diagnostic signs if not using separate plugins
  DiagnosticSignError = { fg = colors.red, bg = defaultbg },
  DiagnosticSignWarn = { fg = colors.yellow, bg = defaultbg },
  DiagnosticSignInfo = { fg = colors.blue, bg = defaultbg },
  DiagnosticSignHint = { fg = colors.cyan, bg = defaultbg },

  -- Diff highlighting
  DiffAdd = { fg = colors.white, bg = '#004000' },    -- Darker green bg
  DiffChange = { fg = colors.white, bg = '#000040' }, -- Darker blue bg
  DiffDelete = { fg = colors.white, bg = '#400000' }, -- Darker red bg
  DiffText = { fg = colors.black, bg = '#707070' },   -- Changed text within a line

  Error = { fg = colors.gray, bg = colors.red, cterm = styles.bold },
  Exception = { fg = colors.red, bg = nil },
  Function = function_definition,
  Identifier = variable_hl, -- Variable names, etc. (often overridden by plugins/treesitter)
  Ignore = { fg = colors.darkgray },
  Include = { fg = colors.darkgray, bg = nil },
  Keyword = { fg = keywordfg, bg = nil },
  Label = { fg = colors.green }, -- case, default labels
  Macro = { fg = colors.red },   -- #define
  Number = number_hl,
  Operator = { fg = colors.nicepurple },
  PreCondit = { fg = keywordfg },             -- #if, #ifdef
  PreProc = { fg = keywordfg },               -- #include
  Repeat = repeat_hl,                         -- for, while
  Special = special_hl,                       -- Special characters in strings, etc.
  SpecialKey = special_hl,                    -- Unprintable characters in Normal text
  Statement = { fg = colors.darkyellow },     -- if, else, try, catch (often same as Keyword or Conditional)
  StorageClass = { fg = colors.nicered },     -- static, extern, auto
  String = string_hl,
  Structure = { fg = colors.nicelightgreen }, -- struct, union, enum, class
  Tag = { fg = colors.red },                  -- HTML tags, etc.
  Todo = { bg = colors.red, fg = colors.white, cterm = styles.bold },
  Type = type_hl,                             -- int, char, void
  Typedef = { fg = colors.magenta },          -- typedef
}
apply_highlights(syntax)

-- Custom Plugin Highlighting
local custom = {
  StatusLineAccent = { bg = colors.niceyellow, fg = colors.nicedarkgreen },
  StatusLineProjectAccent = { bg = colors.nicelightgreen, fg = colors.nicedarkgreen },
  StatusLineHighlight = { bg = colors.nicelightgreen, fg = colors.nicedarkgreen },
  NotificationInfo = { fg = colors.white },
  NotificationWarning = { fg = colors.black },
  NotificationError = { fg = colors.white },

  -- ALE (Example - may need adjustment based on ALE config)
  ALEError = { link = 'ErrorMsg' },
  ALEErrorSign = { fg = colors.red, bg = defaultbg },
  ALEWarning = { link = 'WarningMsg' },
  ALEWarningSign = { fg = colors.yellow, bg = defaultbg },
  ALEVirtualTextError = { fg = colors.darkgray, bg = nil }, -- Or match DiagnosticVirtualText
  ALEVirtualTextInfo = { fg = colors.darkgray, bg = nil },
  ALEVirtualTextWarning = { fg = colors.darkgray, bg = nil },

  -- Codeium / Copilot
  CodeiumSuggestion = { fg = colors.slategray },
  CopilotSuggestion = { fg = colors.slategray }, -- Often same as Codeium

  -- Mini Notify
  MiniNotifyBorder = { link = 'NormalFloat' },
  MiniNotifyNormal = { link = 'NormalFloat' },
  MiniNotifyTitle = { link = 'FloatTitle' },

  -- GitSigns / Signify
  SignifySignAdd = { fg = colors.green },
  SignifySignChange = { fg = colors.yellow },
  SignifySignDelete = { fg = colors.darkred },
  SignifySignDeleteFirstLine = { fg = colors.darkred },
  GitSignsAdd = { fg = colors.green, bg = defaultbg },
  GitSignsChange = { fg = colors.yellow, bg = defaultbg },
  GitSignsDelete = { fg = colors.red, bg = defaultbg },

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
    cterm = styles.italic,
  },

  MasonHighlightSecondary = { bg = colors.red },
  MasonHighlightBlockSecondary = { bg = colors.red },
  MasonHighlightBlockBoldSecondary = { bg = colors.red },

  MasonLink = { fg = colors.black, cterm = styles.underline },

  MasonMuted = { fg = colors.nicegray },
  MasonMutedBlock = {
    -- this is the inactive menu items
    fg = colors.white,
    bg = colors.niceblack,
  },
  MasonMutedBlockBold = {
    fg = colors.nicegray,
    bg = colors.niceblack,
    cterm = styles.bold,
  },

  MasonError = { link = 'ErrorMsg' },
  MasonWarning = { link = 'WarningMsg' },
  MasonHeading = { link = 'FloatTitle' },
}
apply_highlights(custom)

-- Neovim Specific Highlighting
if vim.fn.has('nvim') == 1 then
  local neovim_only = {
    MsgArea = { bg = nil, fg = colors.nicelightgreen },     -- Command line area
    TermCursor = { bg = colors.red, fg = colors.white },    -- Terminal mode cursor
    TermCursorNC = { bg = colors.gray, fg = colors.black }, -- Terminal mode cursor in inactive window
  }
  apply_highlights(neovim_only)

  -- WhichKey
  local whichkeybg = colors.darkslategray
  local whichkey = {
    WhichKey = { fg = colors.niceblue },           -- Key bindings
    WhichKeyGroup = { fg = colors.nicepurple },    -- Group titles
    WhichKeyDesc = { fg = colors.nicelightgreen }, -- Descriptions
    WhichKeySeparator = { fg = colors.nicegray },  -- Separators
    -- Floating window style
    WhichKeyFloat = { bg = whichkeybg },
    WhichKeyBorder = { bg = whichkeybg },
    -- Legacy names? (Included from original script)
    WhichKeyTitle = { fg = colors.white, bg = whichkeybg, cterm = styles.bold },
    WhichKeyNormal = { fg = colors.darkgray, bg = whichkeybg }, -- Unused?
  }
  apply_highlights(whichkey)

  -- Treesitter Highlighting Groups (https://github.com/nvim-treesitter/nvim-treesitter#highlight-groups)
  local treesitter = {
    ['@attribute'] = field_hl, -- @field / @property ?
    ['@boolean'] = { link = 'Boolean' },
    ['@character'] = { link = 'Character' },
    ['@character.special'] = { link = 'Special' }, -- Special characters like escape sequences \n
    ['@comment'] = { link = 'Comment' },
    ['@comment.error'] = { fg = colors.red, cterm = styles.bold },
    ['@comment.todo'] = { link = 'Todo' }, -- Link to existing Todo group
    ['@comment.note'] = { fg = colors.blue },
    ['@comment.warning'] = { fg = colors.yellow, cterm = styles.bold },
    ['@conditional'] = { link = 'Conditional' },
    ['@constant'] = { link = 'Constant' },                        -- General constants
    ['@constant.builtin'] = { fg = colors.magenta, cterm = nil }, -- Built-in constants like true, false, nil
    ['@constant.macro'] = { link = 'Macro' },                     -- Constants defined by macros
    ['@constructor'] = { link = 'Function' },                     -- Class constructors
    ['@error'] = { link = 'Error' },
    ['@exception'] = { link = 'Exception' },
    ['@field'] = field_hl,                            -- Object/struct fields
    ['@float'] = { link = 'Number' },                 -- Floating point numbers
    ['@function'] = { link = 'Function' },            -- Function definitions
    ['@function.builtin'] = { cterm = styles.bold },  -- Built-in functions
    ['@function.call'] = function_call,               -- Function calls
    ['@function.macro'] = { link = 'Macro' },         -- Macro definitions
    ['@include'] = { link = 'Include' },
    ['@keyword'] = { link = 'Keyword' },              -- General keywords
    ['@keyword.conditional'] = conditional_hl,        -- if, else, switch, case
    ['@keyword.debug'] = { link = 'Debug' },          -- Debug related keywords
    ['@keyword.directive'] = { link = 'PreProc' },    -- Preprocessor directives
    ['@keyword.exception'] = { fg = exceptionfg },    -- try, catch, throw
    ['@keyword.function'] = { link = 'Function' },    -- `function` keyword
    ['@keyword.import'] = { link = 'Include' },       -- import, require, use
    ['@keyword.modifier'] = { fg = colors.teal },     -- public, private, static (Added from original script)
    ['@keyword.operator'] = { link = 'Operator' },    -- `operator` keyword (e.g. in C++)
    ['@keyword.repeat'] = { link = 'Repeat' },        -- for, while, loop
    ['@keyword.return'] = { fg = colors.niceblue },   -- return
    ['@keyword.storage'] = { link = 'StorageClass' }, -- static, extern, const, let, var
    ['@label'] = { link = 'Label' },
    -- ['@lsp.type.class'] = { link = 'Structure' }, -- LSP semantic token for classes
    -- ['@lsp.type.comment'] = { link = '@comment' }, -- LSP semantic token for comments
    -- ['@lsp.type.decorator'] = { link = '@attribute' }, -- LSP semantic token for decorators
    -- ['@lsp.type.enum'] = { fg = olive }, -- LSP semantic token for enums
    -- ['@lsp.type.enumMember'] = { link = '@constant' }, -- LSP semantic token for enum members
    -- ['@lsp.type.function'] = { link = 'Function' }, -- LSP semantic token for functions
    -- ['@lsp.type.interface'] = { fg = beige }, -- LSP semantic token for interfaces
    -- ['@lsp.type.macro'] = { link = '@function.macro' }, -- LSP semantic token for macros
    -- ['@lsp.type.method'] = { link = '@method' }, -- LSP semantic token for methods
    -- ['@lsp.type.namespace'] = { fg =colors.niceblue }, -- LSP semantic token for namespaces
    -- ['@lsp.type.parameter'] = { link = '@parameter' }, -- LSP semantic token for parameters
    -- ['@lsp.type.property'] = field_hl, -- LSP semantic token for properties
    -- ['@lsp.type.struct'] = { link = '@structure' }, -- LSP semantic token for structs
    -- ['@lsp.type.type'] = { link = '@type' }, -- LSP semantic token for types
    -- ['@lsp.type.typeParameter'] = { link = '@type.definition' }, -- LSP semantic token for type parameters
    -- ['@lsp.type.variable'] = { link = '@variable' }, -- LSP semantic token for variables
    -- ['@lsp.mod.readonly'] = { cterm = nil }, -- Modifiers for LSP semantic tokens (e.g., @lsp.mod.readonly) - typically don't need color, maybe italic/bold
    -- ['@lsp.mod.static'] = { cterm = nil },
    -- ['@lsp.mod.declaration'] = { link = '@variable' },
    ['@method'] = function_definition,  -- Method definitions
    ['@method.call'] = function_call,   -- Method calls
    ['@module'] = { fg = colors.lime }, -- Modules or namespaces
    ['@namespace'] = { link = '@module' },
    ['@none'] = {},                     -- Fallback group
    ['@number'] = number_hl,
    ['@operator'] = { link = 'Operator' },
    ['@parameter'] = function_params,                   -- Function parameters
    ['@property'] = field_hl,                           -- Same as @field
    ['@punctuation.bracket'] = { fg = colors.ivory },   -- Brackets [], {}
    ['@punctuation.delimiter'] = { fg = colors.ivory }, -- Delimiters like ;, ,, .
    ['@punctuation.special'] = { fg = colors.ivory },   -- Special punctuation like string interpolation ${}
    ['@repeat'] = { link = 'Repeat' },
    ['@string'] = { link = 'String' },
    ['@string.escape'] = { link = '@character.special' },                       -- Escape sequences within strings
    ['@string.regex'] = { fg = colors.limegreen },                              -- Regular expressions
    ['@string.special'] = { fg = colors.nicepurple },                           -- Strings with special meaning (e.g. symbols)
    ['@symbol'] = { link = '@constant' },                                       -- Symbols (e.g. in Ruby)
    ['@tag'] = { fg = colors.teal },                                            -- XML/HTML tags
    ['@tag.attribute'] = { fg = colors.nicelightgreen, cterm = styles.italic }, -- XML/HTML tag attributes
    ['@tag.delimiter'] = { fg = colors.gray },                                  -- XML/HTML tag delimiters <> /
    ['@text'] = { link = 'Normal' },                                            -- Base text
    ['@text.danger'] = { link = '@error' },
    ['@text.diff.add'] = { link = 'DiffAdd' },
    ['@text.diff.delete'] = { link = 'DiffDelete' },
    ['@text.emphasis'] = { cterm = styles.italic },                           -- Italic text in markup
    ['@text.environment'] = { link = '@module' },                             -- Environment variable in Makefiles etc.
    ['@text.literal'] = { link = '@string' },                                 -- Literal text in markup
    ['@text.math'] = { link = '@operator' },                                  -- Math environments in markup
    ['@text.note'] = { link = '@comment.note' },
    ['@text.quote'] = { link = '@string.special' },                           -- Block quotes in markup
    ['@text.reference'] = { link = '@identifier' },                           -- Links, references in markup
    ['@text.strike'] = { cterm = styles.strikethrough },                      -- Strikethrough text in markup
    ['@text.strong'] = { cterm = styles.bold },                               -- Bold text in markup
    ['@text.title'] = { link = 'Title' },                                     -- Titles in markup
    ['@text.todo'] = { link = 'Todo' },
    ['@text.underline'] = { cterm = styles.underline },                       -- Underlined text in markup
    ['@text.uri'] = { fg = colors.niceblue, cterm = styles.underline },       -- URIs/URLs
    ['@text.warning'] = { link = '@comment.warning' },
    ['@type'] = type_hl,                                                      -- Type definitions
    ['@type.builtin'] = { fg = colors.magenta, cterm = styles.italic },       -- Built-in types, boolean/string/number
    ['@type.definition'] = { link = 'Typedef' },                              -- Type definitions (typedefs, aliases)
    ['@type.qualifier'] = { link = '@keyword.storage' },                      -- Type qualifiers (const, volatile)
    ['@variable'] = { link = 'identifier' },                                  -- Variable names
    ['@variable.builtin'] = { fg = colors.nicebrown, cterm = styles.italic }, -- Super, self, this
    ['@variable.member'] = field_hl,                                          -- Class/struct member variables
    ['@variable.parameter'] = { link = '@parameter' },                        -- Variables used as parameters
  }
  apply_highlights(treesitter)
end

-- Statusline Mode Highlighting
local statusline_fg = get_env_or(env_stl_fg, pine_color_scheme.moss)
local statusline_bg = get_env_or(env_stl_bg, pine_color_scheme.kombu_green) -- Used nicemidgreen before, darkgreen is original
local statusline_bg_nc = get_env_or(env_stl_bg_nc, pine_color_scheme.axolotl)

local statusline_n = { -- Normal mode
  fg = statusline_fg,
  bg = statusline_bg,
}
local statusline_nc = { -- Inactive window statusline
  fg = colors.ivory,
  bg = statusline_bg_nc,
}
local statusline_i = {        -- Insert mode
  fg = colors.white,
  bg = colors.seagreen,       -- A different green for insert
}
local statusline_v = {        -- Visual mode
  fg = colors.black,
  bg = colors.nicelightgreen, -- Light green for visual
}
local statusline_r = {        -- Replace mode
  fg = colors.white,
  bg = colors.nicered,        -- Red for replace
}
local statusline_c = {        -- Command mode
  fg = colors.black,
  bg = colors.niceyellow,     -- Yellow for command
}
local statusline_t = {        -- Terminal mode
  fg = colors.white,
  bg = colors.niceblue,       -- Blue for terminal
}

local mode_statusline_map = {
  ['n'] = statusline_n,  -- Normal
  ['no'] = statusline_n, -- Operator pending
  ['nov'] = statusline_n,
  ['noV'] = statusline_n,
  ['no\22'] = statusline_n, -- Ctrl+V Operator pending
  ['niI'] = statusline_n,   -- Normal mode (startup) - Insert
  ['niR'] = statusline_n,   -- Normal mode (startup) - Replace
  ['niV'] = statusline_n,   -- Normal mode (startup) - Virtual Replace
  ['nt'] = statusline_n,    -- Normal mode in Terminal
  ['v'] = statusline_v,     -- Visual character
  ['V'] = statusline_v,     -- Visual line
  ['\22'] = statusline_v,   -- Visual block (Ctrl+V)
  ['s'] = statusline_v,     -- Select character
  ['S'] = statusline_v,     -- Select line
  ['\19'] = statusline_v,   -- Select block (Ctrl+S)
  ['i'] = statusline_i,     -- Insert
  ['ic'] = statusline_i,    -- Insert (completion)
  ['ix'] = statusline_i,    -- Insert (completion)
  ['R'] = statusline_r,     -- Replace
  ['Rc'] = statusline_r,    -- Replace (completion)
  ['Rx'] = statusline_r,    -- Replace (completion)
  ['Rv'] = statusline_r,    -- Virtual Replace
  ['Rvc'] = statusline_r,   -- Virtual Replace (completion)
  ['Rvx'] = statusline_r,   -- Virtual Replace (completion)
  ['c'] = statusline_c,     -- Command line
  ['cv'] = statusline_c,    -- Vim Ex mode
  ['ce'] = statusline_c,    -- Normal Ex mode
  ['r'] = statusline_c,     -- Prompt (more, input)
  ['rm'] = statusline_c,    -- More prompt
  ['r?'] = statusline_c,    -- Confirm prompt
  ['!'] = statusline_t,     -- Shell command in terminal
  ['t'] = statusline_t,     -- Terminal mode
}

---@diagnostic disable-next-line: unused-local
local default_text_highlight_map = {
  ['n'] = normal_text_highlight,
  ['v'] = normal_text_highlight, -- Keep normal text colors in visual mode
  ['V'] = normal_text_highlight,
  ['\22'] = normal_text_highlight,
  ['i'] = normal_text_highlight,     -- Keep normal text colors in insert mode
  ['c'] = { fg = colors.darkgreen }, -- Maybe change command mode text slightly? Optional.
  -- Add other modes if desired
}

-- Apply initial StatusLine highlights
set_hl('StatusLine', statusline_n)
set_hl('StatusLineNC', statusline_nc)

-- Mode Change Autocommand
local au_cmd_group = 'PineModeChangedGroup'

vim.api.nvim_create_augroup(au_cmd_group, { clear = true })

local function handleModeChange()
  if is_env_true(env_disable_mode_change) then
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
  pattern = '*',
  callback = handleModeChange,
})

vim.g.colors_name = colorscheme_name
