#!/bin/sh
# a starting point config

IS_SERVER=""
IS_DESKTOP=""
USER="mw"

pkgupdate() {
        # set to latest rather than updates
    mkdir -p /usr/local/etc/pkg/repos
    echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
    pkg update -f
}

baseconfig() {

    # prevent old key types
    rm /etc/ssh/ssh_host_*
    sysrc sshd_dsa_enable="no"
    sysrc sshd_ecdsa_enable="no"
    sysrc sshd_ed25519_enable="yes"
    sysrc sshd_rsa_enable="yes"
    service sshd keygen
    service sshd restart
    
    pkg install doas git-lite chezmoi lazygit helix fish htop tmux rsync coretemp

    # cpu temp reporting (htop and more)
    sysrc coretemp_load="YES"

    cat<<EOF >/usr/local/etc/doas.conf
permit nopass :wheel
EOF
    
}

workstation(){
    # we'll be running some things...
    sysrc linux_enable="YES"
    service linux start
    # running wayland here
    pw groupmod video -m $USER
    pkg install drm-kmod wayland seatd foot river chromium nerd-fonts noto liberation-fonts-ttf cantarell-fonts source-code-pro-ttf dejavu 
    sysrc kld_list+=amdgpu
    sysrc dbus_enable="YES"
    service dbus start
    sysrc seatd_enable="YES"
    service seatd start
}


widevine(){
    # https://forums.freebsd.org/threads/watching-spotify-and-listening-to-netflix-in-2023.90695/
    pkg install foreign-cdm
    mkdir -p /home/$USER/src
    cd /home/$USER/src
    doas -u $USER git clone --depth 1 https://github.com/freebsd/freebsd-ports
    cd freebsd-ports/www/linux-widevine-cdm
    doas -u $USER make
    make install
}


pkgupdate
# baseconfig
# workstation
# widevine
