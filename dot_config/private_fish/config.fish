if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
    set -U EDITOR nvim
    set fish_greeting # disable welcome
end

# make ctrl-f accept auto suggestion in vi mode as it does in emacs mode
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

fish_add_path ~/.local/bin
fish_add_path ~/go/bin
