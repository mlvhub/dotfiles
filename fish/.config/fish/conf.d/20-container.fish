# CONTAINER-ONLY environment (the `dev` Arch distrobox).
# Guarded by /run/.containerenv so these dev toolchains never leak onto the host.

test -f /run/.containerenv; or return 0

# Go
set -gx GOPATH $HOME/go
fish_add_path -g /usr/local/go/bin $GOPATH/bin

# Rust / Cargo
fish_add_path -g $HOME/.cargo/bin

# pyenv (only if present — guarded so a fresh container doesn't error)
if test -d $HOME/.pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path -g $PYENV_ROOT/bin
    command -q pyenv; and pyenv init - fish | source
end

# Visual marker so the prompt/echo makes it obvious you're inside the container.
set -gx DEV_CONTAINER dev
