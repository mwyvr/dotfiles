# What is this

/etc/systemd/system service and timer files

## Simple mail log processing

See ~/.local/bin/dropbadips

### Installation

    ~/.local/bin/dropbadips install 

Copies the script to /usr/local/bin/dropbadips. 

TODO: automate this:

Manually copy the following to /etc/systemd/system and enable the two timers:

    dropbadips-boot.service
    dropbadips-boot.timer
    dropbadips.service
    dropbadips.timer
