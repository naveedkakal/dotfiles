-- ============================================================================
-- WezTerm Configuration
-- https://wezfurlong.org/wezterm/
-- ============================================================================

local wezterm = require("wezterm")
local config = {}

-- Use config builder for better error reporting
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- ============================================================================
-- Appearance
-- ============================================================================

-- Color scheme
config.color_scheme = "Tokyo Night"

-- Font configuration
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font Mono", weight = "Regular" },
	{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
	{ family = "Symbols Nerd Font Mono", weight = "Regular" },
	{ family = "Menlo", weight = "Regular" },
})
config.font_size = 15.0
config.line_height = 1.2
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Font rendering (better for external monitors)
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"

-- Window appearance
config.window_decorations = "RESIZE"
config.window_frame = {
	border_left_width = "0.25cell",
	border_right_width = "0.25cell",
	border_bottom_height = "0.15cell",
	border_top_height = "0.15cell",
	border_left_color = "#444444",
	border_right_color = "#444444",
	border_bottom_color = "#444444",
	border_top_color = "#444444",
}

-- Pane highlighting (active pane border)
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.6,
}
config.pane_focus_follows_mouse = false
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

-- Hyperlink rules to detect file paths
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Detect file paths (matches most common patterns)
table.insert(config.hyperlink_rules, {
	regex = [=[["]?(\S+/[\w\d._\-/]+\.\w+)["]?]=],
	format = "$1",
})

-- Mouse
config.mouse_bindings = {
	-- Cmd+Click to open URLs in browser or files in VS Code
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- Intercept link opening to handle files vs URLs
wezterm.on("open-uri", function(window, pane, uri)
	wezterm.log_info("Opening URI: " .. uri)

	-- If it's a URL, let it open normally
	if uri:match("^https?://") then
		return true
	end

	-- Get current working directory for relative paths
	local cwd = pane:get_current_working_dir()
	if cwd then
		cwd = cwd.file_path
	end

	-- If path is relative (doesn't start with /), resolve it
	local file_path = uri
	if cwd and not uri:match("^/") then
		file_path = cwd .. "/" .. uri
	end

	-- Open in VS Code
	wezterm.background_child_process({ "/opt/homebrew/bin/code", file_path })
	return false
end)

-- ============================================================================
-- Key Bindings
-- ============================================================================

config.keys = {
	-- Word and line navigation (macOS style)
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action.SendKey({ key = "b", mods = "ALT" }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action.SendKey({ key = "f", mods = "ALT" }),
	},
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }),
	},
	{
		key = "Backspace",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "u", mods = "CTRL" }),
	},

	-- Splits
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Navigate splits
	{
		key = "h",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},

	-- Close pane
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- Clear scrollback
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},

	-- Font size
	{
		key = "+",
		mods = "CMD",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CMD",
		action = wezterm.action.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "CMD",
		action = wezterm.action.ResetFontSize,
	},

	-- Claude Shift Enter
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action({ SendString = "\x1b\r" }),
	},
}

-- ============================================================================
-- Shell
-- ============================================================================

-- Default shell
config.default_prog = { "/bin/zsh", "-l" }

-- ============================================================================
-- Return Configuration
-- ============================================================================

return config
