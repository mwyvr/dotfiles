function fish_prompt --description 'custom prompt'
    set -l last_status $status

    # prompt_login; instead fqdn hostname:
    echo -n -s (set_color $fish_color_user) "$USER" (set_color normal) @ (set_color $color_host) (hostname) (set_color normal)

    echo -n ':'

    # PWD
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal

    echo

    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    echo -n '➤ '
    set_color normal
end
