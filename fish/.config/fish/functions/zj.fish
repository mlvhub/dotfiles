# Fish helper -> install to  ~/.config/fish/functions/zj.fish
#
# Attaches to the persistent "workspace" Zellij session if it's alive,
# otherwise creates it from the workspace layout. This is the single command
# that gives you "reopen Kitty (or SSH in) -> exact same workspace".

function zj --description 'Attach to (or create) the persistent Zellij workspace'
    # If already inside Zellij, do nothing (avoid nesting).
    if set -q ZELLIJ
        return
    end

    # Is a "workspace" session already running?
    if zellij list-sessions -s 2>/dev/null | grep -qx workspace
        exec zellij attach workspace
    else
        exec zellij --new-session-with-layout workspace --session workspace
    end
end
