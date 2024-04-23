#!/usr/bin/sh
# install supports for neovim


. /etc/os-release
if [ $ID = "chimera" ]; then
	doas apk update
	doas apk add go nodejs python-pip cargo fd ripgrep unzip wget curl wl-clipboard
    # not in chimera cports (yet), mapped to space-l
    go install github.com/jesseduffield/lazygit@latest
elif [ $ID = "void" ]; then
	sudo xbps-install -Su go nodejs python3-pip cargo fd ripgrep unzip wget curl wl-clipboard
elif grep -q "opensuse" /etc/os-release ; then
	sudo zypper in go1.22 nodejs python312-pip cargo fd ripgrep unzip wget curl wl-clipboard make
else
	echo "Unknown Linux distribution, terminating."
	exit 1
fi
