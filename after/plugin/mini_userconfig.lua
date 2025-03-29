local loaded, mini_surround = pcall(require, 'mini.surround')
if not loaded then
  print('mini.surround not loaded')
  return
end

mini_surround.setup({
  -- Add custom surroundings to be used on top of builtin ones. For more
  -- information with examples, see `:h MiniSurround.config`.
  custom_surroundings = nil,

  -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
  highlight_duration = 500,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    replace = 'cs', -- Replace surrounding
    delete = 'ds', -- Delete surrounding
    --- NOTE don't use `ys` as it slows down the yank action
    add = 'sa', -- Add surrounding in Normal and Visual modes
    find = '', -- Find surrounding (to the right)
    find_left = '', -- Find surrounding (to the left)
    highlight = '', -- Highlight surrounding
    update_n_lines = '', -- Update `n_lines`

    suffix_last = '', -- Suffix to search with "prev" method
    suffix_next = '', -- Suffix to search with "next" method
  },

  -- Number of lines within which surrounding is searched
  n_lines = 20,

  -- Whether to respect selection type:
  -- - Place surroundings on separate lines in linewise mode.
  -- - Place surroundings on each line in blockwise mode.
  respect_selection_type = false,

  -- How to search for surrounding (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
  -- see `:h MiniSurround.config`.
  search_method = 'cover',

  -- Whether to disable showing non-error feedback
  silent = false,
})

-- local animate = require('mini.animate')
-- animate.setup({
--   -- Cursor path
--   cursor = {
--     -- Whether to enable this animation
--     enable = false,
--     -- -- Timing of animation (how steps will progress in time)
--     -- timing = --<function: implements linear total 250ms animation duration>,
--     -- -- Path generator for visualized cursor movement
--     -- path = --<function: implements shortest line path>,
--   },
--
--   -- Vertical scroll
--   scroll = {
--     -- Whether to enable this animation
--     enable = true,
--     timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
--     -- for mouse scroll: set mousescroll=ver:25,hor:2
--     subscroll = animate.gen_subscroll.equal({ max_output_steps = 120 }),
--   },
--
--   -- Window resize
--   resize = {
--     -- Whether to enable this animation
--     enable = false,
--     -- -- Timing of animation (how steps will progress in time)
--     -- timing = --<function: implements linear total 250ms animation duration>,
--     -- -- Subresize generator for all steps of resize animations
--     -- subresize = --<function: implements equal linear steps>,
--   },
--
--   -- Window open
--   open = {
--     -- Whether to enable this animation
--     enable = false,
--     -- -- Timing of animation (how steps will progress in time)
--     -- timing = --<function: implements linear total 250ms animation duration>,
--     -- -- Floating window config generator visualizing specific window
--     -- winconfig = --<function: implements static window for 25 steps>,
--     -- -- 'winblend' (window transparency) generator for floating window
--     -- winblend = --<function: implements equal linear steps from 80 to 100>,
--   },
--
--   -- Window close
--   close = {
--     -- -- Whether to enable this animation
--     enable = false,
--     -- -- Timing of animation (how steps will progress in time)
--     -- timing = --<function: implements linear total 250ms animation duration>,
--     -- -- Floating window config generator visualizing specific window
--     -- winconfig = --<function: implements static window for 25 steps>,
--     -- -- 'winblend' (window transparency) generator for floating window
--     -- winblend = --<function: implements equal linear steps from 80 to 100>,
--   },
-- })

local context_commentstring_loaded, context_commentstring =
  pcall('require', 'ts_context_commentstring')
if context_commentstring_loaded then
  context_commentstring.setup({
    enable_autocmd = true,
  })
end
require('mini.comment').setup({
  -- Options which control module behavior
  options = {
    -- Function to compute custom 'commentstring' (optional)
    custom_commentstring = function()
      if context_commentstring_loaded then
        return context_commentstring.calculate_commentstring()
          or vim.bo.commentstring
      end
      return vim.bo.commentstring
    end,

    -- Whether to ignore blank lines
    ignore_blank_line = false,

    -- Whether to recognize as comment only lines without indent
    start_of_line = false,

    -- Whether to ensure single space pad for comment parts
    pad_comment_parts = true,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment on current line
    -- comment_line = '<leader>cc',
    comment_line = '<leader><space>',
    -- Toggle comment on visual selection
    comment_visual = '<leader><space>',

    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    -- Works also in Visual mode if mapping differs from `comment_visual`
    textobject = 'gc',
  },

  -- Hook functions to be executed at certain stage of commenting
  hooks = {
    -- Before successful commenting. Does nothing by default.
    pre = function() end,
    -- After successful commenting. Does nothing by default.
    post = function() end,
  },
})

require('mini.pairs').setup({
  -- In which modes mappings from this `config` should be created
  modes = { insert = true, command = false, terminal = false },

  -- Global mappings. Each right hand side should be a pair information, a
  -- table with at least these fields (see more in |MiniPairs.map|):
  -- - <action> - one of 'open', 'close', 'closeopen'.
  -- - <pair> - two character string for pair to be used.
  -- By default pair is not inserted after `\`, quotes are not recognized by
  -- `<CR>`, `'` does not insert pair after a letter.
  -- Only parts of tables can be tweaked (others will use these defaults).
  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

    ['"'] = {
      action = 'closeopen',
      pair = '""',
      neigh_pattern = '[^\\].',
      register = { cr = false },
    },
    ["'"] = {
      action = 'closeopen',
      pair = "''",
      neigh_pattern = '[^%a\\].',
      register = { cr = false },
    },
    ['`'] = {
      -- action = 'closeopen',
      action = 'close',
      pair = '``',
      neigh_pattern = '[^\\].',
      register = { cr = false },
    },
  },
})

require('mini.ai').setup({
  -- Table with textobject id as fields, textobject specification as values.
  -- Also use this to disable builtin textobjects. See |MiniAi.config|.
  custom_textobjects = nil,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',

    -- Next/last variants
    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },

  -- Number of lines within which textobject is searched
  n_lines = 100000,

  -- How to search for object (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
  search_method = 'cover_or_next',

  -- Whether to disable showing non-error feedback
  silent = false,
})

require('mini.align').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },

  -- Default options controlling alignment process
  options = {
    split_pattern = '',
    justify_side = 'left',
    merge_delimiter = '',
  },

  -- Default steps performing alignment (if `nil`, default is used)
  steps = {
    pre_split = {},
    split = nil,
    pre_justify = {},
    justify = nil,
    pre_merge = {},
    merge = nil,
  },

  -- Whether to disable showing non-error feedback
  silent = false,
})

require('mini.notify').setup({
  -- Content management
  content = {
    -- Function which formats the notification message
    -- By default prepends message with notification time
    format = function(notif)
      -- {
      --   hl_group = "DiagnosticInfo",
      --   level = "INFO",
      --   msg = "test",
      --   ts_add = 1711014047.1013,
      --   ts_update = 1711014047.1013
      -- }
      return notif.msg
    end,

    -- Function which orders notification array from most to least important
    -- By default orders first by level and then by update timestamp
    sort = function(notif_arr)
      table.sort(notif_arr, function(a, b)
        return a.ts_update > b.ts_update
      end)
      return notif_arr
    end,
  },

  -- Notifications about LSP progress
  lsp_progress = {
    -- Whether to enable showing
    enable = true,

    -- Duration (in ms) of how long last message should be shown
    duration_last = 1000,
  },

  -- Window options
  window = {
    -- Floating window config
    config = {},

    -- Maximum window width as share (between 0 and 1) of available columns
    max_width_share = 0.382,

    -- Value of 'winblend' option
    winblend = 25,
  },
})
-- vim.notify = require('mini.notify').make_notify()

require('mini.jump2d').setup({

  -- Function producing jump spots (byte indexed) for a particular line.
  -- For more information see |MiniJump2d.start|.
  -- If `nil` (default) - use |MiniJump2d.default_spotter|
  spotter = nil,

  -- Characters used for labels of jump spots (in supplied order)
  labels = 'abcdefghijklmnopqrstuvwxyz',

  -- Options for visual effects
  view = {
    -- Whether to dim lines with at least one jump spot
    dim = false,

    -- How many steps ahead to show. Set to big number to show all steps.
    n_steps_ahead = 0,
  },

  -- Which lines are used for computing spots
  allowed_lines = {
    blank = false, -- Blank line (not sent to spotter even if `true`)
    cursor_before = true, -- Lines before cursor line
    cursor_at = false, -- Cursor line
    cursor_after = true, -- Lines after cursor line
    fold = true, -- Start of fold (not sent to spotter even if `true`)
  },

  -- Which windows from current tabpage are used for visible lines
  allowed_windows = {
    current = true,
    not_current = false,
  },

  -- Functions to be executed at certain events
  hooks = {
    before_start = nil, -- Before jump start
    after_jump = nil, -- After jump was actually done
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- start_jumping = '<CR>',
    start_jumping = '\\',
  },

  -- Whether to disable showing non-error feedback
  silent = false,
})
require('mini.files').setup()
require('mini.diff').setup({
  -- Options for how hunks are visualized
  view = {
    -- Visualization style. Possible values are 'sign' and 'number'.
    -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
    -- style = vim.go.number and 'number' or 'sign',
    style = 'sign',

    -- Signs used for hunks with 'sign' view
    -- signs = { add = '▒', change = '▒', delete = '▒' },
    signs = { add = '+', change = '~', delete = '-' },

    -- Priority of used visualization extmarks
    priority = 199,
  },

  -- Source for how reference text is computed/updated/etc
  -- Uses content from Git index by default
  source = nil,

  -- Delays (in ms) defining asynchronous processes
  delay = {
    -- How much to wait before update following every text change
    text_change = 200,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = 'gh',

    -- Reset hunks inside a visual/operator region
    reset = 'gH',

    -- Hunk range textobject to be used inside operator
    -- Works also in Visual mode if mapping differs from apply and reset
    textobject = 'gh',

    -- Go to hunk range in corresponding direction
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  },

  -- Various options
  options = {
    -- Diff algorithm. See `:h vim.diff()`.
    algorithm = 'histogram',

    -- Whether to use "indent heuristic". See `:h vim.diff()`.
    indent_heuristic = true,

    -- The amount of second-stage diff to align lines (in Neovim>=0.9)
    linematch = 60,

    -- Whether to wrap around edges during hunk navigation
    wrap_goto = false,
  },
})
require('mini.splitjoin').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  -- Created for both Normal and Visual modes.
  mappings = {
    toggle = 'gS',
    split = '',
    join = '',
  },

  -- Detection options: where split/join should be done
  detect = {
    -- Array of Lua patterns to detect region with arguments.
    -- Default: { '%b()', '%b[]', '%b{}' }
    brackets = nil,

    -- String Lua pattern defining argument separator
    separator = ',',

    -- Array of Lua patterns for sub-regions to exclude separators from.
    -- Enables correct detection in presence of nested brackets and quotes.
    -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
    exclude_regions = nil,
  },

  -- Split options
  split = {
    hooks_pre = {},
    hooks_post = {},
  },

  -- Join options
  join = {
    hooks_pre = {},
    hooks_post = {},
  },
})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    xxx = { pattern = '%f[%w]()XXX()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    disabled = {
      pattern = '%f[%w]()disable = true()%f[%W]',
      group = 'MiniHipatternsFixme',
    },
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
