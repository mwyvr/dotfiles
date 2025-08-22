local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'RobotoMono Nerd Font Mono'
config.font_size=14
config.window_background_opacity = 0.94
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
return config
