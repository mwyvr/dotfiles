#!/bin/sh
set -e

FETCHER="fetch -o" # freebsd and chimera, others use wget

# I prefer Roboto Mono; current editor config demands a patched Nerd Font, and it
# which is not carried by all distributions, so for thosse, install it ~/.local
install_font() {
    INSTALLPATH="$HOME/.local/share/fonts/robotomono"
    HOSTNAME=$(hostname)
    if ! [ -f $INSTALLPATH/RobotoMonoNerdFont-Regular.ttf ]; then
        mkdir -p "$INSTALLPATH"
        ZIPFILE=$(mktemp)
        $FETCHER $ZIPFILE "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip"
        unzip -d $INSTALLPATH $ZIPFILE
        rm $ZIPFILE
    fi
    #
}

install_fontconfig() {
    # Override distributions fontconfig for monospace. Higher order # and
    # location overrides dejavu or other distro defaults.
    mkdir -p "$HOME/.config/fontconfig"
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
    echo "Running fc-cache -f -r"
    fc-cache -f -r
}

. /etc/os-release
case $ID in
chimera)
    doas apk update
    # already has a good selection of fonts in base-desktop
    doas apk add fonts-nerd-roboto-mono
    ;;
freebsd)
    doas pkg install -y roboto-fonts-ttf cantarell-fonts roboto-fonts-ttf source-code-pro-ttf liberation-fonts-ttf webfonts nerd-fonts font-awesome
    # also want the nerd mono
    install_font
    ;;
*)
    # all others
    echo "ONLY SETTING UP ROBOTO MONO NERD FONT, update font-install.sh"
    FETCHER="wget -O"
    install_font
    ;;
esac

install_fontconfig
