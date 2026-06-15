# Common environment — applies on BOTH host and container.

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx COLORTERM truecolor

# fzf: use fd for the default file walk (guarded — fd may not be installed yet)
if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
end

# ~/.local/bin is shared via the common home dir. Starship and other single-file
# binaries live here and work for both host and container (both x86_64 Linux).
fish_add_path -g $HOME/.local/bin
