#!/usr/bin/sh
# install supports for neovim on various Linux distributions (Chimera Linux, Void Linux, openSUSE Tumbleweed/Aeon in a tw container)
. /etc/os-release
case $ID in
chimera)
	doas apk update
	doas apk add neovim go git nodejs python-pip cargo fd ripgrep unzip wget curl wl-clipboard clang cmake awk
	# not in chimera cports (yet)
	go install github.com/jesseduffield/lazygit@latest
	;;
void)
	sudo xbps-install -Su neovim go lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl wl-clipboard base-devel awk
	;;
"opensuse-tumbleweed")
	sudo zypper refresh
	sudo zypper in neovim go1.22 git lazygit nodejs python312-pip cargo fd ripgrep unzip wget curl wl-clipboard gcc gcc-c++ make awk
	if [ $CONTAINER_ID == "tumbleweed" ]; then
		distrobox-export --bin /usr/bin/nvim
	fi
	;;
"opensuse-aeon")
	echo "This system runs immutable openSUSE Aeon; run this script in the default Tumbleweed container."
	echo "e.g.:"
	echo "    distrobox enter"
	echo "    setupnvim.sh"
	;;
"opensuse-microos")
	echo "This system runs immutable openSUSE MicroOS (Aeon); run this script in the default Tumbleweed container."
	echo "e.g.:"
	echo "    distrobox enter"
	echo "    setupnvim.sh"
	;;
*)
	echo "Unknown Linux distribution; currently supports Chimera/Void/openSUSE Tumbleweed+Aeon. Terminating."
	exit 1
	;;
esac
