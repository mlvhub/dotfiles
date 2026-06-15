function rnm --description 'Set the terminal/window title'
    printf '\033];%s\007' $argv[1]
end
