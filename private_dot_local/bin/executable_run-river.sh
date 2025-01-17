#!/bin/sh
# called by greetd on linux
WM=river
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP="$WM"
export XDG_CURRENT_DESKTOP="$WM"
export XDG_CONFIG_HOME="$HOME/.config"
export MOZ_ENABLE_WAYLAND=1
export XKB_DEFAULT_OPTIONS=ctrl:nocaps
export GTK_THEME=Adwaita:dark

eval "$(gnome-keyring-daemon --start)"
export SSH_AUTH_SOCK
river | logger -p daemon.info -t river
