# Neovim Configuration

This repository contains a Lua-first Neovim configuration with retained legacy Vimscript. Target Neovim 0.12 or newer. This is a personal setup, so local paths and external tools may need platform-specific handling.

## Repository Map

- `init.lua`: Entry point; loads `lua/dcai/init.lua`.
- `lua/dcai/globals.lua`: Shared helpers, paths, and environment handling.
- `lua/dcai/job.lua`: Shared asynchronous process runner with main-loop callbacks.
- `lua/dcai/http.lua`: Curl HTTP client with the `vim.net.request` calling convention.
- `lua/dcai/pack.lua`: Native plugin specifications, build hooks, and startup setup.
- `lua/dcai/plug.lua`: Deprecated vim-plug setup. Keep it for reference; it is not loaded by Neovim startup.
- `lua/dcai/keymaps/`: Mappings organized by topic, with which-key descriptions.
- `lua/dcai/lsp/`: Native language-server configuration and shared LSP helpers.
- `lua/dcai/llm/`: AI integrations and prompts.
- `after/plugin/`: Plugin-specific configuration.
- `after/ftplugin/`: Filetype-specific configuration.
- `plugin/`: Runtime plugin scripts.
- `colors/`, `queries/`: Color schemes and Tree-sitter queries.
- `loader.vim`, `core.vim`, `before/`, `os/`: Shared Vimscript and platform setup.
- `tests/`: Headless Lua tests.
- `.github/workflows/`: Separate Selene lint and Neovim test workflows.

Check the active declarations and startup calls before changing a feature. A configuration file on disk does not mean its plugin is enabled. Commented plugin declarations and legacy files are not evidence of active behavior.

## Implementation Guidelines

- Prefer Lua for new configuration. Keep changes in the existing topic or plugin module.
- Use native `vim.pack` in `lua/dcai/pack.lua`. All plugins load eagerly; do not reintroduce vim-plug into Neovim startup.
- Prefer native Neovim APIs and existing dependencies over additional plugins.
- Use `dcai.http.request(url, opts, callback)` for HTTP, with `callback(err, response)` and `handle:close()` cancellation. It uses curl through `dcai.job`, supports method/headers/body/status, and preserves response bytes. Retries default to zero; only GET/HEAD may opt in. Redirects are not followed. Headers/payloads go through stdin; never log credentials or enable verbose curl output with secrets.
- Use descriptive names, small helpers, and explicit setup calls. Avoid new globals unless an existing integration requires them.
- Follow `stylua.toml`: two-space indentation, an 80-column limit, and single quotes where possible.
- Preserve legacy Vimscript unless removal is explicitly requested. Do not add compatibility layers for obsolete APIs.
- Use Neovim path helpers for new path handling. Guard platform-specific commands and preserve existing OS behavior.

## Mappings and Buffer Lifecycle

- Place mappings in the appropriate `lua/dcai/keymaps/` module and provide descriptions for which-key.
- Before choosing a key, search the configuration and inspect loaded mappings with `maparg()` or `:verbose map` in the relevant modes and filetypes.
- Check terminal aliases such as Tab/Ctrl-i. A buffer-local mapping can shadow an existing global plugin mapping even when its fallback returns the original keycode.
- Scope feature-specific mappings and commands to eligible buffers. Cleanup must remove only mappings and commands owned by that feature.
- Give autocommands named augroups. Avoid duplicate registrations after reloads.
- Cancel pending work and clear owned state when buffers change, detach, or are wiped.
- Discard asynchronous responses for stale buffer contents or an old feature session. Cancellation alone cannot stop a callback already queued for execution.

## Language Servers and Plugins

- Define language servers with `vim.lsp.config()` and `vim.lsp.enable()` in `lua/dcai/lsp/`.
- Reuse `lua/dcai/lsp/utils.lua` for shared capabilities and attachment behavior.
- Keep Mason-managed packages in `lua/dcai/lsp/init.lua` aligned with the servers being configured. System-provided servers may need separate installation.
- Keep completion, diagnostics, and server-specific features distinct. Do not start duplicate clients for features that can share one server.
- Preserve position encoding and document-version handling when changing LSP requests or edits.
- Apply buffer exclusions before server attachment when the goal is to prevent document contents from being sent.
- Check active configuration before documenting defaults. For example, Python currently uses `ty`; the Pyright configuration is commented out.

## Environment and Personal Settings

Use file paths, not line numbers, when documenting these settings. Verify that an environment-variable lookup is active rather than commented out.

- `after/plugin/ale.lua`: `JSONFIXER`, `JSFIXER`, `CSSFIXER`, `YAMLFIXER`, and `MDFIXER` default to `prettier`; `JSLINTER` defaults to `biome`.
- `lua/dcai/init.lua`: `NVIM_SHADA` overrides the ShaDa path; `SSH_CONNECTION` selects the OSC52 clipboard provider.
- `lua/dcai/lsp/init.lua`: `USE_TSC` selects the native TypeScript server or `ts_ls`. `USE_TSGO` is checked only when `USE_TSC` is unset.
- `lua/dcai/codestats.lua`: `CODESTATS_API_KEY` enables Code::Stats integration. The API URL environment override is commented out.
- `colors/pine.lua`: `VIM_PINE_COLORSCHEME_STL_FG`, `VIM_PINE_COLORSCHEME_STL_BG`, and `VIM_PINE_COLORSCHEME_STL_BG_NC` control statusline colors. `VIM_DISABLE_MODE_CHANGE=true` or `1` disables mode-based statusline color changes.

`init.lua` and `mise.toml` currently set `NODE_TLS_REJECT_UNAUTHORIZED=0`, which disables Node TLS certificate verification. Copilot telemetry is explicitly enabled in its server configuration. These are deliberate personal settings with security and privacy implications; do not change them incidentally or describe them as secure defaults. Never expose credentials or tokens in logs, tests, or documentation.

## Validation

Run commands from the repository root. Selene and StyLua must be installed separately.

```sh
selene init.lua lua after/plugin plugin colors --display-style quiet
stylua --check init.lua lua after/plugin plugin colors tests
```

`mise run lint` runs the Selene command above. `package.json` currently has no npm scripts; do not assume `npm run lint` exists.

Run all tests through Mini from the repository root:

```sh
mise run test
```

The collector includes `tests/*-test.lua` and `tests/test_*.lua`. Stateful suites use `tests/helpers.lua` to restart a child Neovim for each case and clean up its temporary files, even after failures. Use `child.lua_func()` for real Lua functions without upvalues; do not quit the child from a test body. The job tests exercise real subprocesses without replacing global Neovim functions.

To run one file directly, use `nvim --headless --noplugin -u tests/minimal-init.lua -i NONE -c "lua MiniTest.run_file('tests/copilot-test.lua')"`. The installer cases run the retained Vimscript test in separate Neovim/Vim processes; missing Vim or unsupported POSIX fixtures are reported as skips.

- When a bug involves a native Neovim API, exercise the real API in regression tests rather than mocking away the failing behavior.
- Use scratch buffers and synthetic content for runtime checks. Disable auto-save before modifying test buffers in a full-config session. Do not overwrite the user's open files or saved edits.
- Test affected platform behavior where possible. State which environments were actually checked; do not claim cross-platform validation from a single local run.

## Continuous Integration

- Keep linting in `.github/workflows/selene.yml` and Neovim tests in `.github/workflows/neovim-tests.yml`.
- The test workflow runs only on pushes affecting Lua files or the workflow itself. Do not add scheduled or pull-request triggers unless requested.
- Test against latest stable Neovim and latest upstream test dependencies. Do not pin them to a particular version or commit; upstream breakages should be visible.
- Validate workflow changes with the mise-managed `jactionlint` (`mise exec -- jactionlint`). YAML parsing alone does not check GitHub Actions expression contexts or semantics.

## Documentation

- Keep `readme.md` generic: overview, requirements, installation, structure, development, and history.
- Do not add detailed keymap references or plugin-specific walkthroughs to the README unless requested.
- Update existing documentation instead of creating parallel guides. Avoid duplicate instructions, exhaustive plugin inventories, and references to unstable line numbers.
