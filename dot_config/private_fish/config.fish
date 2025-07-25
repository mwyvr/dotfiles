# fish config
fish_config theme choose mui-dark
set -g fish_greeting # disable welcome
set -g fish_key_bindings fish_vi_key_bindings


# git
set -g __fish_git_prompt_showdirtystate false
set -g __fish_git_prompt_showuntrackedfiles false
set -g __fish_git_prompt_showstashstate false
set -g __fish_git_prompt_showupstream verbose
# env
set -gx HOSTNAME (hostname)
if type -q hx
    set -gx EDITOR hx
end
fish_add_path ~/.cargo/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/bin

set -gx XKB_DEFAULT_OPTIONS ctrl:nocaps
set -gx GTK_THEME Adwaita:dark
set -gx SIGNAL_PASSWORD_STORE gnome-libsecret
set -gx GDK_BACKEND wayland
# envsource $HOME/.env

# make ctrl-f accept auto suggestion in vi mode as it does in emacs mode
# this has to be in config.fish for some reason
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
