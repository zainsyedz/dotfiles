local theme_path = vim.fn.expand '~/.local/state/omarchy/current/theme/neovim.lua'

local theme_plugins = {
  { 'ribru17/bamboo.nvim', lazy = true, priority = 1000 },
  { 'bjarneo/aether.nvim', branch = 'v3', name = 'aether', lazy = true, priority = 1000 },
  { 'bjarneo/ethereal.nvim', lazy = true, priority = 1000 },
  { 'bjarneo/hackerman.nvim', lazy = true, priority = 1000 },
  { 'bjarneo/vantablack.nvim', lazy = true, priority = 1000 },
  { 'bjarneo/white.nvim', lazy = true, priority = 1000 },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true, priority = 1000 },
  { 'neanias/everforest-nvim', lazy = true, priority = 1000 },
  { 'kepano/flexoki-neovim', lazy = true, priority = 1000 },
  { 'ellisonleao/gruvbox.nvim', lazy = true, priority = 1000 },
  { 'rebelot/kanagawa.nvim', lazy = true, priority = 1000 },
  { 'tahayvr/matteblack.nvim', lazy = true, priority = 1000 },
  { 'EdenEast/nightfox.nvim', lazy = true, priority = 1000 },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true, priority = 1000 },
  { 'ficcdaf/ashen.nvim', lazy = true, priority = 1000 },
  { 'folke/tokyonight.nvim', lazy = true, priority = 1000 },
  { 'OldJobobo/miasma.nvim', lazy = true, priority = 1000 },
  { 'OldJobobo/retro-82.nvim', lazy = true, priority = 1000 },
  { 'omacom-io/lumon.nvim', lazy = true, priority = 1000 },
}

local function active_theme()
  local chunk, err = loadfile(theme_path)
  if not chunk then
    vim.notify('Unable to load Omarchy theme: ' .. err, vim.log.levels.WARN)
    return
  end

  local ok, specs = pcall(chunk)
  if not ok or type(specs) ~= 'table' then
    vim.notify('Omarchy theme did not return plugin specifications', vim.log.levels.WARN)
    return
  end

  local colorscheme
  local plugin_spec
  for _, spec in ipairs(specs) do
    if spec[1] == 'LazyVim/LazyVim' then
      colorscheme = spec.opts and spec.opts.colorscheme
    elseif spec[1] then
      plugin_spec = spec
    end
  end

  return colorscheme, plugin_spec
end

local function plugin_for(spec)
  local url = 'https://github.com/' .. spec[1] .. '.git'
  for _, plugin in pairs(require('lazy.core.config').plugins) do
    if plugin.url == url then
      return plugin
    end
  end
end

local function apply_theme()
  local colorscheme, spec = active_theme()
  if not colorscheme or not spec then
    return
  end

  local loader = require 'lazy.core.loader'
  for _, dependency in ipairs(spec.dependencies or {}) do
    local dependency_spec = type(dependency) == 'string' and { dependency } or dependency
    local plugin = plugin_for(dependency_spec)
    if plugin then
      loader.load(plugin, { colorscheme = colorscheme })
    end
  end

  local plugin = plugin_for(spec)
  if not plugin then
    vim.notify('Omarchy theme plugin is unavailable: ' .. spec[1], vim.log.levels.WARN)
    return
  end

  loader.load(plugin, { colorscheme = colorscheme })
  if spec.opts then
    local main = loader.get_main(plugin)
    local ok, theme = pcall(require, main)
    if ok and theme.setup then
      theme.setup(spec.opts)
    end
  end

  vim.cmd.colorscheme(colorscheme)
  vim.cmd 'redraw!'
end

local _, active_plugin = active_theme()
if active_plugin then
  theme_plugins[#theme_plugins + 1] = active_plugin
end

theme_plugins[#theme_plugins + 1] = {
  name = 'omarchy-theme',
  dir = vim.fn.stdpath 'config',
  lazy = false,
  priority = 1,
  config = function()
    apply_theme()

    vim.api.nvim_create_user_command('OmarchyThemeReload', apply_theme, {
      desc = 'Reload the active Omarchy theme',
    })

    local watcher = vim.uv.new_fs_event()
    local pending = false
    watcher:start(vim.fn.expand '~/.local/state/omarchy/current', {}, function(err)
      if err or pending then
        return
      end

      pending = true
      vim.defer_fn(function()
        pending = false
        vim.schedule(apply_theme)
      end, 100)
    end)

    vim.api.nvim_create_autocmd('VimLeavePre', {
      once = true,
      callback = function()
        watcher:stop()
        watcher:close()
      end,
    })
  end,
}

return theme_plugins
