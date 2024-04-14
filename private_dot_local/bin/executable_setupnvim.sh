#!/usr/bin/sh
# install supports for neovim

# not in chimera cports (yet), mapped to space-l
go install github.com/jesseduffield/lazygit@latest

. /etc/os-release
if [ $ID = "chimera" ]; then
	doas apk update
	doas apk add go nodejs python-pip fd ripgrep unzip wget curl wl-clipboard
elif [ $ID = "void" ]; then
	sudo xbps-install -Su go nodejs python3-pip fd ripgrep unzip wget curl wl-clipboard
else
	echo "Unknown Linux distribution, terminating."
	exit 1
fi
