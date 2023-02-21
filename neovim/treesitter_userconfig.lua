require "nvim-treesitter.configs".setup {
    highlight = {
        enable = true,
        disable = {}
    },
    indent = {
        enable = false,
        disable = {}
    },
    auth_install = true,
    ensure_installed = {
        "bash",
        "css",
        "diff",
        "dockerfile",
        "fish",
        "graphql",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "org",
        "terraform",
        "toml",
        "tsx",
        "twig",
        "typescript",
        "vim",
        "yaml"
    }
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = {"javascript", "typescript.tsx"}
