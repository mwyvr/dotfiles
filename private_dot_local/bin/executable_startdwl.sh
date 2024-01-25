#!/bin/sh
# Starts the dwl window manager
Environment=wayland

eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
export XKB_DEFAULT_OPTIONS=ctrl:nocaps
pipewire &
exec /usr/bin/dbus-launch /usr/bin/dwl -s /usr/bin/somebar
