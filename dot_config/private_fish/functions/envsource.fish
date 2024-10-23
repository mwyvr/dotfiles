function envsource
    set -f envfile "$argv"
    if test -f "$envfile"
        while read line
            if not string match -qr '^#|^$' "$line"
                set item (string split -m 1 '=' $line)
                set -gx $item[1] $item[2]
                # echo "Exported key $item[1]"
            end
        end <"$envfile"
    end
end
