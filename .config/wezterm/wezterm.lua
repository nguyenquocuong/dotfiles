-- Ported from .config/alacritty/alacritty.toml.
-- Default keys already match the old Alacritty bindings:
-- Ctrl+Shift+C/V copy/paste, Ctrl+=/-/0 font size.
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local is_macos = wezterm.target_triple:find("darwin") ~= nil

-- GUI apps on macOS do not get the Homebrew PATH, so use full paths
local fish = is_macos and "/opt/homebrew/bin/fish" or "/usr/bin/fish"
config.default_prog = { fish, "--command", "tmux" }

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = is_macos and 11 or 6
config.bold_brightens_ansi_colors = "BrightAndBold"

config.colors = {
  foreground = "#B3B1AD",
  background = "#0A0E14",
  cursor_bg = "#EDC29A",
  cursor_fg = "#0A1124",
  cursor_border = "#EDC29A",
  ansi = { "#01060E", "#EA6C73", "#91B362", "#F9AF4F", "#53BDFA", "#FAE994", "#90E1C6", "#C7C7C7" },
  brights = { "#686868", "#F07178", "#C2D94C", "#FFB454", "#59C2FF", "#FFEE99", "#95E6CB", "#FFFFFF" },
}
config.default_cursor_style = "SteadyBlock"

-- No title bar, still resizable. tmux handles tabs, so hide the tab bar.
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
-- Small even padding: clears the rounded window corners, keeps the tmux bar close to the edges
config.window_padding = { left = "6pt", right = "6pt", top = "6pt", bottom = "6pt" }

config.scrollback_lines = 10000
config.hide_mouse_cursor_when_typing = true

return config
