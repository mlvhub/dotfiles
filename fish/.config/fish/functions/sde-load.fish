function sde-load --description 'Load persisted SDE/AWS env into the current fish session'
    if not test -f $HOME/.sde/profile/profile.sh
        echo "sde-load: $HOME/.sde not found" >&2
        return 1
    end
    bass source $HOME/.sde/profile/profile.sh
end
