function sde-shell --description 'Drop into a native bash subshell with SDE loaded (fallback to bass)'
    bash -ic 'source "$HOME/.sde/profile/profile.sh"; exec bash'
end
