#!/bin/sh
pkg update
pkg install chezmoi git helix fish htop doas tmux rsync

# for wayland
pkg install drm-kmod wayland seatd foot nerd-fonts noto liberation-fonts-ttf cantarell-fonts source-code-pro-ttf dejavu 
sysrc kld_list+=amdgpu
sysrc seatd_enable="YES"
service seatd start
pw groupmod video -m mw


root@elron /etc# mkdir -p /usr/local/etc/pkg/repos
root@elron /etc# 
root@elron /etc# cd /usr/local/etc/pkg/repos/
root@elron /u/l/e/p/repos# ls
root@elron /u/l/e/p/repos# echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
root@elron /u/l/e/p/repos# pkg update -f

https://forums.freebsd.org/threads/watching-spotify-and-listening-to-netflix-in-2023.90695/


% sudo pkg install chromium # 117.0.5938.149_2 or higher

% sudo pkg install foreign-cdm
% sudo sysrc linux_enable="YES"
% sudo service linux start

% git clone --depth 1 https://github.com/freebsd/freebsd-ports
% cd freebsd-ports/www/linux-widevine-cdm
% make
% sudo make install


