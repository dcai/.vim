local loaded, gitlinker = pcall(require, 'gitlinker')

if not loaded then
  return
end

local hosts = gitlinker.hosts
local actions = gitlinker.actions

local get_azure_type_url = function(info)
  -- {
  --   file = "src/index.js",
  --   host = "dev.azure.com",
  --   lstart = 46,
  --   lend = 48,
  --   repo = "myorg/project/_git/repo-name",
  --   rev = "8e83589"
  -- }
  local lend = info.lstart + 1
  if info.lend then
    lend = info.lend
  end
  local url = hosts.get_base_https_url(info)
  return string.format(
    '%s?path=%s&version=GC%s&line=%d&lineEnd=%d&lineStartColumn=1&lineEndColumn=1&lineStyle=plain&_a=contents',
    url,
    info.file,
    info.rev,
    info.lstart,
    lend
  )
end

gitlinker.setup({
  opts = {
    remote = nil, -- force the use of a specific remote
    -- adds current line nr in the url for normal mode
    add_current_line_on_normal_mode = true,
    -- callback for what to do with the url
    action_callback = function(url)
      actions.copy_to_clipboard(url)
      actions.open_in_browser(url)
    end,
    print_url = true,
  },
  callbacks = {
    ['dev.azure.com'] = get_azure_type_url,
    ['github.customerlabs.com.au'] = hosts.get_github_type_url,
    ['github.com'] = hosts.get_github_type_url,
    ['gitlab.com'] = hosts.get_gitlab_type_url,
    ['try.gitea.io'] = hosts.get_gitea_type_url,
    ['codeberg.org'] = hosts.get_gitea_type_url,
    ['bitbucket.org'] = hosts.get_bitbucket_type_url,
    ['try.gogs.io'] = hosts.get_gogs_type_url,
    ['git.sr.ht'] = hosts.get_srht_type_url,
    ['git.launchpad.net'] = hosts.get_launchpad_type_url,
    ['repo.or.cz'] = hosts.get_repoorcz_type_url,
    ['git.kernel.org'] = hosts.get_cgit_type_url,
    ['git.savannah.gnu.org'] = hosts.get_cgit_type_url,
  },
  -- default mapping to call url generation with action_callback
  -- mappings = '<leader>gy',
  mappings = nil,
})
