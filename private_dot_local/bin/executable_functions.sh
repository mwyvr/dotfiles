#!/bin/sh
# reusble functions for posix shells, no bashisms

ask() {
    # usage:
    # if ! ask "Proceed with configuration? " Y; then
    #     echo "aborting"
    # else
    #     echo "proceeding"
    # fi

    if [ "$2" = 'Y' ]; then
        prompt='Y/n'
        default='Y'
    elif [ "$2" = 'N' ]; then
        prompt='y/N'
        default='N'
    else
        prompt='y/n'
        default=''
    fi

    while true; do
        echo "$1 [$prompt] "
        read -r reply </dev/tty
        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi
        case "$reply" in
        Y* | y*) return 0 ;;
        N* | n*) return 1 ;;
        esac
    done
}
