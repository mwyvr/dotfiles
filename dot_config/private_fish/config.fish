if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_key_bindings fish_vi_key_bindings
end

fish_add_path ~/.local/bin
fish_add_path ~/go/bin

set -U EDITOR nvim
set -U LIBVIRT_DEFAULT_URI qemu:///system
# for wlroots
set -U XKB_DEFAULT_OPTIONS ctrl:nocaps
