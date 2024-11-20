#!/bin/sh
set -e

# I prefer Roboto Mono; current editor config demands a patched Nerd Font, and it
# which is not carried by all distributions, so for thosse, install it ~/.local
install_fonts() {
    INSTALLPATH="/home/$USER/.local/share/fonts/robotomono"
    mkdir -p /home/$USER/.config/fontconfig
    HOSTNAME=$(hostname)
    if ! [ -f $INSTALLPATH/RobotoMonoNerdFont-Regular.ttf ]; then
        mkdir -p "$INSTALLPATH"
        ZIPFILE=$(mktemp)
        fetch -o $ZIPFILE "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip"
        unzip -d $INSTALLPATH $ZIPFILE
        rm $ZIPFILE
    fi
    #
    # Override distributions fontconfig for monospace. Higher order # and
    # location overrides dejavu or other distro defaults.
    cat <<EOF >$HOME/.config/fontconfig/52-$HOSTNAME.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <description>local overrides</description>
  <!-- Generic name assignment for RobotoMono; don't use nerd font ending in Mono, small icons -->
  <alias>
    <family>RobotoMono Nerd Font</family>
    <default>
      <family>monospace</family>
    </default>
  </alias>

  <!-- monospace name aliasing for fonts we've installed on this machine -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>RobotoMono Nerd Font</family>
      <family>Source Code Pro</family>
      <family>Noto Sans Mono</family>
      <family>DejaVu Sans Mono</family>
    </prefer>
  </alias>
</fontconfig>
EOF
    # force, really
    fc-cache -f -r
}

. /etc/os-release
case $ID in
chimera)
    # does not require a custom fontconfig, pkg handles
    doas apk update
    doas apk add fonts-nerd-roboto-mono
    ;;
*)
    # all others
    # void packages a large bundle of nerd fonts, I just want the one
    # Aeon/Tumbleweed needed local font config as of Fall 2024
    install_fonts
    ;;
esac
