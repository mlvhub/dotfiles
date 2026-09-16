function dotenv --description 'Export KEY=value pairs from a .env into the current shell'
    set -l file (test -n "$argv[1]"; and echo $argv[1]; or echo .env)
    if not test -f $file
        echo "dotenv: $file not found" >&2
        return 1
    end
    set -l count 0
    for line in (grep -vE '^#|^$' $file)
        set -l pair (string split -m1 '=' -- $line)
        if test (count $pair) -ne 2
            continue
        end
        set -gx $pair[1] (string trim --chars='"\'' -- $pair[2])
        set count (math $count + 1)
    end
    echo "dotenv: exported $count vars from $file"
end
