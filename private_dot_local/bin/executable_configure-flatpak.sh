#!/bin/sh
ADDCMD=""
APPS="com.google.Chrome org.signal.Signal us.zoom.Zoom org.gnome.Showtime"

. /etc/os-release
case $ID in
void)
    ADDCMD="sudo xbps-install -Suy"
    # chrome in repo
    APPS="org.signal.Signal us.zoom.Zoom"
    echo "Install Chromium from packages"
    ;;
chimera)
    doas apk update --no-interactive
    ADDCMD="doas apk add --no-interactive"
    ;;
aeon | "opensuse-tumbleweed")
    ADDCMD="sudo zypper in -y"
    ;;
esac

$ADDCMD flatpak
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in $APPS; do
    echo "Installing $app"
    flatpak install -y "$app"
done

# flatpak remote-add --if-not-exists --user gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
# flatpak install -y gnome-nightly org.gnome.Showtime.Devel
