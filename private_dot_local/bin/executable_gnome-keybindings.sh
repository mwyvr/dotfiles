#!/bin/sh

# adapted from https://gist.github.com/peterrus/e59a96688a4d49ee3d9302c0d3ff5fdd

set -e

CPATH="$HOME/.config/gnome/keybindings"

mkdir -p "$CPATH"

if [ "$1" = "backup" ]; then
    dconf dump '/org/gnome/desktop/wm/keybindings/' >$CPATH/wm-keybindings.dconf
    dconf dump '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/' >$CPATH/custom-values.dconf
    dconf read '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings' >$CPATH/custom-keys.dconf
    echo "keybindings saved"
    exit 0
fi
if [ "$1" = "restore" ]; then
    # caps lock as ctrl  always
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
    dconf reset -f '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/'
    dconf reset -f '/org/gnome/desktop/wm/keybindings/'
    dconf load '/org/gnome/desktop/wm/keybindings/' <$CPATH/wm-keybindings.dconf
    dconf load '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/' <$CPATH/custom-values.dconf
    dconf write '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings' "$(cat $CPATH/custom-keys.dconf)"
    echo "keybindings restored"
    exit 0
fi

echo "Usage: $(basename $0) [backup|restore]"
