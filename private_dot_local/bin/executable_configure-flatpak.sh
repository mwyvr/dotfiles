#!/bin/sh
ADDCMD=""
# eyedropper does not appear to support wlr
APPS="org.chromium.Chromium org.signal.Signal us.zoom.Zoom com.github.finefindus.eyedropper "

. /etc/os-release
case $ID in
void)
    ADDCMD="sudo xbps-install -Suy"
    APPS="org.signal.Signal us.zoom.Zoom"
    echo "Install Chromium from packages"
    ;;
chimera)
    # presumes running GNOME
    doas apk update -y
    ADDCMD="doas apk add -y"
    ;;
aeon | "opensuse-tumbleweed")
    ADDCMD="sudo zypper in -y"
    ;;
esac

$ADDCMD flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in $APPS; do
    echo "Installing $app"
    flatpak install -y "$app"
done

flatpak remote-add --if-not-exists --user gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
flatpak install -y gnome-nightly org.gnome.Showtime.Devel
