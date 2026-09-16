function zed --description "Launch Zed (Flatpak) in a new window"
    flatpak run --command=zed dev.zed.Zed -n $argv
end
