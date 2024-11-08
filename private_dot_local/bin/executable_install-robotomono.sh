#!/bin/sh

# I prefer Roboto Mono for my terminal / editor (Helix or neovim); a patched
# Nerd Font makes things nicer still but typically is not packaged in the base
# repo of most distributions. So, for those, install it in ~/.local.
install_fonts() {
    INSTALLPATH="/home/$USER/.local/share/fonts/robotomono"
    HOSTNAME=$(hostname)
    if ! [ -f $INSTALLPATH/RobotoMonoNerdFont-Regular.ttf ]; then
        ZIPFILE=$(mktemp)
        wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip" -O $ZIPFILE
        mkdir -p $INSTALLPATH
        unzip -d $INSTALLPATH $ZIPFILE
        rm $ZIPFILE
    fi
    # higher order # and location overrides the dejavu files to follow
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
opensuse-tumbleweed)
    # symbols *may* satisfy needs, ymmv
    sudo zypper in symbols-only-nerd-fonts
    install_fonts
    ;;
*)
    # all others
    # void packages a large bundle of nerd fonts, I just want the one
    install_fonts
    ;;
esac
