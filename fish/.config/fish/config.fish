# ~/.config/fish/config.fish
# Loaded after conf.d/*.fish. Interactive-only / prompt init lives here.
# Shared between the Bazzite host and the `dev` Arch distrobox (home is shared).

status is-interactive; or exit 0

# No shell greeting
set -g fish_greeting

# Prompt
command -q starship; and starship init fish | source

# Smarter cd (z / zi). Falls back silently if not installed yet.
command -q zoxide; and zoxide init fish | source

# fzf key bindings + completion (fzf >= 0.48 ships `--fish`)
if command -q fzf
    fzf --fish | source 2>/dev/null
end
