function cursor --description 'Launch the Cursor server binary'
    set -l bin (find ~/.cursor-server/bin -name cursor -type f 2>/dev/null | head -n 1)
    if test -z "$bin"
        echo "cursor: no binary found under ~/.cursor-server/bin" >&2
        return 1
    end
    $bin $argv
end
