# envsource parses the filepath argument if it exits, expecting
# KEY=VALUE structure, exporting the variables to the fish shell
function envsource
    set -f envfile "$argv"
    if test -f "$envfile"
        while read line
            if not string match -qr '^#|^$' "$line"
                set item (string split -m 1 '=' $line)
                set -gx $item[1] $item[2]
            end
        end <"$envfile"
    end
end
