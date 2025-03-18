-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'

config.use_fancy_tab_bar = false

config.hide_tab_bar_if_only_one_tab = true
-- config.enable_tab_bar = false

local workspaces = function()
  local names = wezterm.mux.get_workspace_names()
  ws = {}
  for _, name in ipairs(names) do
    table.insert(ws, { label = name })
  end

  return ws
end
config.leader = { key = ' ', mods = 'CTRL' }

config.launch_menu = {
  {
    label = "k9s",
    args = { "zsh", "-l", "-c", "nvim" }
  }
}


config.keys = {
  {
    key = 'p',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'x',
    mods = 'CMD',
    action = wezterm.action.ShowLauncher
  },
  -- {
  --   key = 'p',
  --   mods = 'CMD',
  --   action = wezterm.action.ShowLauncherArgs {
  --     flags = "FUZZY|WORKSPACES"
  --   }
  -- }
  {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      -- local choices = workspaces()
      window:perform_action(
        wezterm.action.InputSelector {
          action = wezterm.action_callback(function(window, pane, id, label)
          end),
          choices = workspaces(),
          title = "Choose a project",
          fuzzy_description = "Choose a project> ",
          fuzzy = true
        },
        pane
      )
      -- window:perform_action(
      -- wezterm.action.InputSelector {
      --     action = wezterm.action_callback(function(window, pane, id, label)
      --       pane:send_text(label)
      --     end),
      --     title = "Choose a project",
      --     choices = { { label = "hi", id = 10 } },
      --     description = "What",
      --     alphabet = "ABCDEF"
      -- },
      -- pane
      -- )
    end)
  }
}

local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)

  -- directional keys to use in order of: left, down, up, right
  direction_keys = { 'h', 'j', 'k', 'l' },
  -- if you want to use separate direction keys for move vs. resize, you
  -- can also do this:
  -- direction_keys = {
  --   move = { 'h', 'j', 'k', 'l' },
  --   resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  -- },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'META',   -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'CTRL', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})

return config
