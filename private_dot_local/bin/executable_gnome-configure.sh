#!/bin/sh
#
# Configures GNOME

config="[org/gnome/desktop/input-sources]
current=uint32 0
sources=[('xkb', 'us')]
xkb-options=['caps:ctrl_modifier']

[org/gnome/desktop/interface]
enable-hot-corners=false

[org/gnome/desktop/wm/keybindings]
move-to-workspace-1=['<Shift><Alt>1']
move-to-workspace-2=['<Shift><Alt>2']
move-to-workspace-3=['<Shift><Alt>3']
move-to-workspace-4=['<Shift><Alt>4']
switch-to-workspace-1=['<Alt>1']
switch-to-workspace-2=['<Alt>2']
switch-to-workspace-3=['<Alt>3']
switch-to-workspace-4=['<Alt>4']

[org/gnome/mutter]
dynamic-workspaces=false
workspaces-only-on-primary=true

[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=false
night-light-temperature=uint32 4371
"
echo "$config" | dconf load /
