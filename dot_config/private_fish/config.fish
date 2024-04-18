if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
    set -U EDITOR nvim
end

fish_add_path ~/.local/bin
fish_add_path ~/go/bin
