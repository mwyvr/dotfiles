#!/bin/sh

. ~/.local/bin/functions.sh

# flatpak apps
$ADDCMD flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in com.google.Chrome org.signal.Signal us.zoom.Zoom; do
    echo "Installing $app"
    flatpak install --user -y $app
done

echo ""
echo "Flatpak configuration complete."
