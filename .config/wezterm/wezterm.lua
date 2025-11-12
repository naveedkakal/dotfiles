-- ============================================================================
-- WezTerm Configuration
-- https://wezfurlong.org/wezterm/
-- ============================================================================

local wezterm = require 'wezterm'
local config = {}

-- Use config builder for better error reporting
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================================
-- Appearance
-- ============================================================================

-- Color scheme
config.color_scheme = 'Tokyo Night'

-- Font configuration
config.font = wezterm.font('Hack Nerd Font Mono')
config.font_size = 15.0
config.line_height = 1.2

-- Window appearance
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 5,
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false

-- Window opacity
config.window_background_opacity = 0.83
config.macos_window_background_blur = 20

-- ============================================================================
-- Performance
-- ============================================================================

config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 800

-- ============================================================================
-- Behavior
-- ============================================================================

-- Scrollback
config.scrollback_lines = 10000

-- Mouse
config.mouse_bindings = {
  -- Open URLs with Cmd+Click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- ============================================================================
-- Key Bindings
-- ============================================================================

config.keys = {
  -- Word and line navigation (macOS style)
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'b', mods = 'ALT' },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'f', mods = 'ALT' },
  },
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'e', mods = 'CTRL' },
  },
  {
    key = 'Backspace',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'u', mods = 'CTRL' },
  },

  -- Splits
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Navigate splits
  {
    key = 'h',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },

  -- Close pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

  -- Clear scrollback
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },

  -- Font size
  {
    key = '+',
    mods = 'CMD',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CMD',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CMD',
    action = wezterm.action.ResetFontSize,
  },
}

-- ============================================================================
-- Shell
-- ============================================================================

-- Default shell
config.default_prog = { '/bin/zsh', '-l' }

-- ============================================================================
-- Return Configuration
-- ============================================================================

return config
