#!/bin/sh
#
# Basic configuration of workstation running Void Linux

export ADDCMD="doas xbps-install -Sy"
export DOAS="doas"
export THEUSER="mw"
export TIMEZONE="America/Vancouver"

if [ "$(id -u)" -eq 0 ]; then
    echo "Run as the regular user, not as root or sudo/doas"
    exit 1
fi

# update index first
$ADDCMD -u

base_hardware() {

    # fix capslock=control for console keymap
    cat <<EOF | $DOAS tee /usr/share/kbd/keymaps/i386/qwerty/us-nocaps.map
include "us.map"
keycode 58 = Control
EOF
    $DOAS gzip /usr/share/kbd/keymaps/i386/qwerty/us-nocaps.map
    echo "KEYMAP=\"us-nocaps\"" | doas tee -a /etc/rc.conf

    # https://docs.voidlinux.org/config/firmware.html
    # cpu microcode and presuming intel igpu
    if lscpu | grep "GenuineIntel"; then
        $ADDCMD void-repo-nonfree
        $ADDCMD -u
        $ADDCMD intel-ucode linux-firmware-intel
    fi
    if lscpu | grep "AuthenticAMD"; then
        $ADDCMD linux-firmware-amd
    fi
    # my Varmilo keyboard firmware IDs as an Apple; the function keys act as
    # media keys unless pressed with Fn button, which is annoying.
    if $DOAS dmesg | grep Varmilo; then
        echo "- Forcing Varmilo/hid_apple function keys as default (2)"
        # real time temp fix
        echo 2 | $DOAS tee -a /sys/module/hid_apple/parameters/fnmode
        # make fix permanent
        echo "options hid_apple fnmode=2" | $DOAS tee -a /etc/modprobe.d/$(hostname).conf
    fi

    if lsmod | grep ath12k; then
        echo "- Disabling ath12k wifi kernel module via /etc/modprobe.d/"
        cat <<EOF >/etc/modprobe.d/10-ath12k.conf
blacklist ath12k
EOF
    fi

}

configuration() {

    # standard groups
    $DOAS usermod -aG wheel,audio,video,storage,network,kvm $THEUSER
    # these have probably been added manually but just in case
    $ADDCMD dbus NetworkManager polkit
    $DOAS ln -sv /etc/sv/dbus /var/service/
    $DOAS ln -sv /etc/sv/NetworkManager /var/service/

    # https://docs.voidlinux.org/config/services/logging.html
    $ADDCMD socklog-void
    $DOAS ln -sv /etc/sv/socklog-unix /var/service/
    $DOAS ln -sv /etc/sv/nanoklogd /var/service/
    $DOAS usermod -aG socklog $THEUSER

    # https://docs.voidlinux.org/config/date-time.html
    ln -svf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    $ADDCMD chrony
    $DOAS ln -sv /etc/sv/chronyd /var/service/

    # https://docs.voidlinux.org/config/session-management.html
    # ensure not running; elogin will manage power, for now
    $DOAS rm /var/service/acpid
    $ADDCMD turnstile elogind
    $DOAS ln -sv /etc/sv/turnstiled /var/service/

    # https://docs.voidlinux.org/config/graphical-session/graphics-drivers/amd.html
    # laptop specific (mine are all Intel igpu)
    if [ -d "/proc/acpi/button/lid" ]; then
        $ADDCMD linux-firmware-intel mesa-dri vulkan-loader mesa-vulkan-intel intel-video-accel
    else
        # Dual GPU system, AMD for Void; NVIDIA for GPU passthrough to Windows VM
        $ADDCMD linux-firmware-amd mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi mesa-vdpau
    fi

    # https://docs.voidlinux.org/config/graphical-session/wayland.html
    $ADDCMD xorg-server-xwayland 
    # window manager
    $ADDCMD river foot kanshi wofi Waybar SwayNotificationCenter swaybg swayidle swaylock \
        wlopm polkit polkit-gnome libnotify nautilus file-roller xdg-user-dirs-gtk xdg-user-dirs \
        brightnessctl pamixer PAmix
    xdg-user-dirs-update
    xdg-user-dirs-update --force
    # login manager/greeter
    $ADDCMD greetd tuigreet gnome-keyring
    # TODO CONFIG plus pam.d config for gnome-keyring

    # https://docs.voidlinux.org/config/graphical-session/fonts.html
    fontinstall.sh

    # https://docs.voidlinux.org/config/graphical-session/icons.html
    # nothing to do, accept the default gtk adwaita that will get installed as apps are
    $ADDCMD adwaita-icon-theme

    # https://docs.voidlinux.org/config/graphical-session/portals.html
    $ADDCMD xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    # https://docs.voidlinux.org/config/media/pipewire.html
    $ADDCMD pipewire pulseaudio-utils alsa-pipewire
    $DOAS mkdir -p /etc/pipewire/pipewire.conf.d
    $DOAS ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    $DOAS ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
    $DOAS mkdir -p /etc/alsa/conf.d
    $DOAS ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
    $DOAS ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

}

applications() {
    $ADDCMD git lazygit delta chezmoi htop evolution
    $ADDCMD helix go nodejs cargo
}

flatpak(){
    # just in case being run separately
    $ADDCMD flatpak xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    for app in org.gnome.Evolution org.signal.Signal us.zoom.Zoom; do
        echo "Installing $app"
        flatpak install -y $app
    done
# video player
flatpak remote-add --if-not-exists --user gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
flatpak install gnome-nightly org.gnome.Showtime.Devel
}

# base_hardware
configuration
applications
# flatpak
echo "
    Configure greetd + pamd
    Start greetd & reboot
"
