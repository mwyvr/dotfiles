#!/bin/sh
export USER=mw
doas apk update
doas apk upgrade
doas apk add gnome-tweaks git helix neovim wl-copy go chezmoi foot fish-shell fonts-nerd-roboto-mono htop
# lazygit not yet in cports
go install github.com/jesseduffield/lazygit@latest
doas apk add chrony
doas dinitctl enable chrony
doas dinitctl enable syslog-ng
doas dinitctl enable sshd
doas apk add ucode-intel
doas update-initramfs -c -k all
# ensure machine does not suspend at gdm login prompt
doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing

# containers
doas add flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# more containers
doas apk add qemu qemu-edk2-firmware qemu-system-x86_64 libvirt virt-manager virt-viewer ufw
doas usermod -aG kvm libvirt $USER
# virtlockd and virtlogd are enabled automatically by the following
for svc in virtqemud virtnodedevd virtstoraged virtnetworkd; do
    dinitctl enable $svc
done

# applications
doas apk add evolution

# fix gdm so it doesn't suspend on this desktop, seems to be the default now but was not
doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing
