#!/bin/sh
# Starts the dwl window manager
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
dwl
