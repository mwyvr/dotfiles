#!/bin/sh
#
# Basic configuration of an openSUSE machine; requirements:
# - basic "server" install
# - add openSUSEWay (sway) Window manager. to pull in a few useful add-ons and
#   have as a backup to River

# . ~/.local/bin/functions.sh

ADDCMD="sudo zypper install -y"
USER="mw"

# cpu microcode
if lscpu | grep "GenuineIntel"; then
    $ADDCMD ucode-intel
fi
if lscpu | grep "AuthenticAMD"; then
    $ADDCMD ucode-amd
fi

# core utils and dotfiles
$ADDCMD git lazygit git-delta chezmoi fish htop powertop flatpak which
chezmoi init git@github.com:mwyvr/dotfiles.git
chezmoi apply
# TODO - move back to distrobox
# for Helix editor and dev
# $ADDCMD helix go nodejs cargo

# Desktop and laptop get these
$ADDCMD river foot

# applications
# $ADDCMD evolution
# flatpak apps
$ADDCMD flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in org.signal.Signal us.zoom.Zoom; do
    echo "Installing $app"
    flatpak install -y $app
done

# install Google Chrome directly
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub >/tmp/chrome-linux_signing_key.pub
sudo rpm --import /tmp/chrome-linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
sudo zypper refresh
$ADDCMD google-chrome-stable

# laptop specific (mine are all Intel igpu)
if [ -d "/proc/acpi/button/lid" ]; then
    $ADDCMD intel-media-driver
fi
#
# doing this first avoids pulling in docker for distrobox
$ADDCMD podman
$ADDCMD distrobox
echo "Create a default tumbleweed distrobox with: distrobox enter"

echo "Configuration completed"
