if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_key_bindings fish_vi_key_bindings
end
function fish_title
    # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
    echo $argv[1] (prompt_pwd)
    pwd
end

fish_add_path -m ~/.local/bin
fish_add_path ~/go/bin

set -U EDITOR nvim
set -U LIBVIRT_DEFAULT_URI qemu:///system
# for wlroots
set -U XKB_DEFAULT_OPTIONS ctrl:nocaps
