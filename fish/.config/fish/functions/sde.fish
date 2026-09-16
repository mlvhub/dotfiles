function sde --description 'Run SDE in bash and import its env (AWS creds, etc.) into fish'
    if not test -f $HOME/.sde/profile/profile.sh
        echo "sde: $HOME/.sde not found — clone it first:" >&2
        echo "  git -C \$HOME clone https://ghe.siriusxm.com/platform-eng/.sde" >&2
        return 1
    end
    bass source $HOME/.sde/profile/profile.sh \; sde $argv
end
