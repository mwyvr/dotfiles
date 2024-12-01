#!/bin/sh
#
# Basic configuration of an openSUSE machine; requirements:
# - basic "server" install
# - add openSUSEWay (sway) Window manager. to pull in a few useful add-ons and
#   have as a backup to River

# . ~/.local/bin/functions.sh

ADDCMD="sudo zypper install -y"
USER="mw"

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as the regular user, not as root or sudo/doas"
    exit 1
fi

# cpu microcode and presuming intel igpu
if lscpu | grep "GenuineIntel"; then
    $ADDCMD ucode-intel
    # laptop specific (mine are all Intel igpu)
    if [ -d "/proc/acpi/button/lid" ]; then
        $ADDCMD intel-media-driver
    fi
fi
if lscpu | grep "AuthenticAMD"; then
    $ADDCMD ucode-amd
fi

# core utils and dotfiles
$ADDCMD git lazygit git-delta chezmoi fish htop powertop distrobox xdg-user-dirs-gtk
xdg-user-dirs-update --force
chezmoi init git@github.com:mwyvr/dotfiles.git
chezmoi apply
# TODO - move back to distrobox
# for Helix editor and dev
# $ADDCMD helix go nodejs cargo

# Desktop and laptop get the River window manager (Wayland) and supporting tools; Sway is
# added to pull in components until this is sorted out
$ADDCMD river patterns-sway-sway foot kanshi mako fuzzel waybar swaybg swayidle swaylock wlopm polkit-gnome libnotify-tools nautilus file-roller

# applications
# $ADDCMD evolution
# flatpak apps
$ADDCMD flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in org.signal.Signal us.zoom.Zoom; do
    echo "Installing $app"
    flatpak install -y $app
done
# video player
flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
flatpak install gnome-nightly org.gnome.Showtime.Devel

# install Google Chrome directly
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub >/tmp/chrome-linux_signing_key.pub
sudo rpm --import /tmp/chrome-linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
sudo zypper refresh
# set refresh on repo
sudo zypper ms -f Google-Chrome
$ADDCMD google-chrome-stable

# doing this first avoids pulling in docker for distrobox
$ADDCMD podman
$ADDCMD distrobox
echo "Create a default tumbleweed distrobox with: distrobox enter"

echo "Configuration completed"
