#!/bin/sh

export MOZ_ENABLE_WAYLAND=1
# Let the windows decide to use Wayland
# Note: WinBox will not start, if set, due to dependencies
# export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export ECORE_EVAS_ENGINE=wayland
export ELM_ENGINE=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export NO_AT_BRIDGE=1
# Session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=river
export XDG_CURRENT_DESKTOP=river


set -a
# Import openSUSEway environment variables
# . /etc/river/env
# Import environment.d variables by calling the systemd generator
eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
set +a

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
if test -f $HOME/.env; then
  . $HOME/.env
fi

export XKB_DEFAULT_OPTIONS=ctrl:nocaps
# Start the river session
systemctl --user start river-session.target
systemd-cat --identifier=river /usr/bin/river -log-level debug $@
