#!/bin/sh
INSTALLPATH="/home/mw/.local/share/fonts/robotomono"
HOSTNAME=$(hostname)

install_fonts() {
	# I prefer Roboto Mono; current nvim config demands a patched Nerd Font
	# which is unlikely to be carried by most distributions, so install it in .local
	if ! [ -f $INSTALLPATH/RobotoMonoNerdFont-Regular.ttf ]; then
		ZIPFILE=$(mktemp)
		wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip" -O $ZIPFILE
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

install_fonts
