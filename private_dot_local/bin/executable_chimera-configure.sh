#!/bin/sh
echo "Configure Chimera Linux for laptop or desktop (implying KVM host)"
echo "Press a key to continue or ctrl-c to abort"
read -r FOO
unset $FOO
# Adds necessary packages and services.

doas apk update
doas apk upgrade
doas apk add chrony
doas dinitctl enable chrony
doas dinitctl enable syslog-ng

if [ ! -d "/proc/acpi/button/lid" ]; then
    # machine is a desktop
    doas dinitctl enable sshd
    # ensure machine does not suspend at gdm login prompt; may need to configure /etc/elogind
    doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
    doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    # kvm/qemu virtual machine support
    doas apk add qemu qemu-edk2-firmware qemu-system-x86_64 libvirt virt-manager virt-viewer ufw
    doas usermod -aG kvm libvirt $USER
    # virtlockd and virtlogd are enabled automatically by the following
    for svc in virtqemud virtnodedevd virtstoraged virtnetworkd; do
        dinitctl enable $svc
    done
else
    # machine is a laptop
    doas apk add powertop
fi

# cpu microcode
if lscpu | grep "GenuineIntel"; then
    doas apk add ucode-intel
else
    doas apk add ucode-amd
fi

# after microcode
doas update-initramfs -c -k all

# flatpak apps
doas add flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in com.google.Chrome org.signal.Signal us.zoom.Zoom; do
    echo "Installing $app"
    flatpak install -y $app
done

# core utils
doas apk add gnome-tweaks git chezmoi foot fish-shell fonts-nerd-roboto-mono btop distrobox

# for Helix & dev
doas apk add helix go nodejs cargo

# applications
doas apk add evolution

# lazygit not yet in cports
go install github.com/jesseduffield/lazygit@latest
