require "nvim-treesitter.configs".setup {
    highlight = {
        enable = true,
        disable = {}
    },
    indent = {
        enable = false,
        disable = {}
    },
    ensure_installed = {
        "tsx",
        "lua",
        "fish",
        "json",
        "yaml",
        "html",
        "vim"
    }
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filename_to_parsename = {"javascript", "typescript.tsx"}
