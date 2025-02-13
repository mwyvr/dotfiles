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
    VARMILO=$(dmesg | grep Varmilo)
    if [ -z "$VARMILO" ]; then
        echo "- Forcing Varmilo/hid_apple function keys as default (2)"
        # real time temp fix
        echo 2 | $DOAS tee -a /sys/module/hid_apple/parameters/fnmode
        # make fix permanent
        echo "options hid_apple fnmode=2" | $DOAS tee -a /etc/modprobe.d/$(hostname).conf
    fi

    ATHWIFI=$(lsmod | grep ath12k)
    if [ -n "$ATHWIFI" ]; then
        echo "- Disabling ath12k wifi kernel module via /etc/modprobe.d/"
        cat <<EOF >/etc/modprobe.d/10-ath12k.conf
blacklist ath12k
EOF
    fi

}

configuration() {

    $DOAS usermod -aG wheel,audio,video,storage,network,kvm $THEUSER
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
    $ADDCMD turnstile elogind
    $DOAS usermod -aG video $THEUSER
    $DOAS ln -sv /etc/sv/acpid /var/service/
    $DOAS ln -sv /etc/sv/turnstiled /var/service/
    $DOAS ln -sv /etc/sv/seatd /var/service/

    # https://docs.voidlinux.org/config/graphical-session/graphics-drivers/amd.html
    # laptop specific (mine are all Intel igpu)
    if [ -d "/proc/acpi/button/lid" ]; then
        $ADDCMD intel-media-driver
    else
        # Dual GPU system, AMD for Void; NVIDIA for GPU passthrough to Windows VM
        $ADDCMD linux-firmware-amd mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi mesa-vdpau
    fi

    # https://docs.voidlinux.org/config/graphical-session/wayland.html
    # TODO add env vars to startup script

    # https://docs.voidlinux.org/config/graphical-session/fonts.html
    fontinstall.sh

    # https://docs.voidlinux.org/config/graphical-session/icons.html
    # nothing to do, accept the default gtk adwaita that will get installed as apps are

    # https://docs.voidlinux.org/config/graphical-session/portals.html
    $ADDCMD xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    # https://docs.voidlinux.org/config/media/index.html
    $DOAS usermod -aG audio $THEUSER
    # https://docs.voidlinux.org/config/media/alsa.html
    # TODO check default

    # https://docs.voidlinux.org/config/media/pipewire.html
    $DOAS usermod -aG audio $THEUSER
    $ADDCMD pipewire pulseaudio-utils alsa-pipewire
    $DOAS mkdir -p /etc/pipewire/pipewire.conf.d
    $DOAS ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    $DOAS ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
    $DOAS mkdir -p /etc/alsa/conf.d
    $DOAS ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
    $DOAS ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

    # window manager
    $ADDCMD river foot kanshi wofi Waybar SwayNotificationCenter swaybg swayidle swaylock \
        wlopm polkit polkit-gnome libnotify nautilus file-roller xdg-user-dirs-gtk xdg-user-dirs
    # login manager/greeter
    $ADDCMD greetd tuigreet
    # TODO CONFIG plus pam.d config for gnome-keyring
}

applications() {
    $ADDCMD git lazygit delta chezmoi fish-shell htop
    # just in case being run separately
    $ADDCMD flatpak xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    for app in org.gnome.Evolution org.signal.Signal us.zoom.Zoom; do
        echo "Installing $app"
        flatpak install -y $app
    done
}

userconfig() {
    xdg-user-dirs-update
    xdg-user-dirs-update --force
    chezmoi init git@github.com:mwyvr/dotfiles.git
    chezmoi apply
}
### NOT UPDATED
#
# core utils and dotfiles
# TODO - move back to distrobox
# for Helix editor and dev
# $ADDCMD helix go nodejs cargo

# Desktop and laptop get the River window manager (Wayland) and supporting tools; Sway is
# added to pull in components until this is sorted out
# applications
# $ADDCMD evolution
# flatpak apps
$ADDCMD flatpak
# video player
flatpak remote-add --if-not-exists --user gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
flatpak install gnome-nightly org.gnome.Showtime.Devel

# install Google Chrome directly
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub >/tmp/chrome-linux_signing_key.pub
sudo rpm --import /tmp/chrome-linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
sudo zypper refresh
# set refresh on repo
sudo zypper ms -f Google-Chrome
$ADDCMD google-chrome-stable

# doing this first avoids pulling in docker for distrobox
$ADDCMD podman
$ADDCMD distrobox
echo "Create a default tumbleweed distrobox with: distrobox enter"

echo 'Configuration completed

Tip: adjust /etc/default/grub:
GRUB_CMDLINE_LINUX_DEFAULT="plymouth.enable=0 splash=silent resume=/dev/system/swap mitigations=auto security=apparmor"
And then:
grub2-mkconfig -o /boot/grub2/grub.cfg

To disable plymouth and return book log to screen

TODO XXX the following packages were not installed - these belong in opensuseway, the sway configuration
determine what is needed
adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts adwaita-qt5 bluez bluez-cups brightnessctl clipman dejavu-fonts
  desktop-file-utils ghostscript-fonts-other google-carlito-fonts google-droid-fonts google-noto-coloremoji-fonts
  google-noto-sans-fonts google-opensans-fonts jq libadwaitaqt5-1 libcairomm-1_16-1 libell0 libfido2-udev libgiomm-2_68-1
  libglibmm-2_68-1 libgtkmm-4_0-0 libjq1 libmbim libmbim-glib4 libonig5 libpangomm-2_48-1 libqmi-glib5 libqmi-tools
  libqrtr-glib0 libQt5X11Extras5 libsigc-3_0-0 mbimcli-bash-completion ModemManager ModemManager-bash-completion
  MozillaFirefox MozillaFirefox-branding-openSUSE mozilla-openh264 mpris-ctl NetworkManager-bluetooth NetworkManager-wwan
  openSUSEway pamixer pavucontrol playerctl playerctl-bash-completion qt5ct sbc sqlite3-tcl sway-branding-openSUSE sway-marker
  SwayNotificationCenter SwayNotificationCenter-bash-completion SwayNotificationCenter-fish-completion tcl usb_modeswitch
  usb_modeswitch-data wl-clipboard wl-clipboard-bash-completion wl-clipboard-fish-completion wob

see: https://github.com/openSUSE/openSUSEway

'
