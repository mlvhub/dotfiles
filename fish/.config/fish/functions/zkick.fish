function zkick --description "Drop all Zellij clients and reattach here at full size"
    distrobox enter dev -- pkill -f "zellij attach workspace"
    distrobox enter dev -- zellij attach workspace
end
