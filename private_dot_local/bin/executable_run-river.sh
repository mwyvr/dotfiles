#!/bin/sh
# called by greetd on linux
WM=river
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP="$WM"
export XDG_CURRENT_DESKTOP="$WM"
export XDG_CONFIG_HOME="$HOME/.config"
export MOZ_ENABLE_WAYLAND=1
export XKB_DEFAULT_OPTIONS=ctrl:nocaps

# yes, this is intentional
# xdg-user-dirs-gtk-update
# xdg-user-dirs-gtk-update --force

eval "$(gnome-keyring-daemon --start)"
export SSH_AUTH_SOCK

dbus-run-session river | logger -p daemon.info -t river
pkill chrome
