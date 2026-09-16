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

# ---------------------------------------------------------------------------
# Path spelling normalization: standardize on the /home spelling.
#
# Bazzite symlinks /home -> /var/home, so the same directory can be addressed
# two ways. Tools that key on the path string (like Claude Code's per-project
# history) then treat /home/valdev/X and /var/home/valdev/X as DIFFERENT
# projects, fragmenting history. All existing Claude Code history lives under
# the /home spelling, so we normalize every directory change to /home.
#
# Uses a PWD event handler so it works regardless of what changed the directory
# (cd, zoxide's z/zi, etc.). Direct string swap (not realpath, which would
# resolve the other way toward /var/home).
# ---------------------------------------------------------------------------
function __normalize_pwd_to_home --on-variable PWD
    status is-command-substitution; and return
    switch "$PWD"
        case '/var/home/*'
            set -l alt (string replace '/var/home/' '/home/' -- "$PWD")
            if test -d "$alt"; and test "$alt" != "$PWD"
                builtin cd "$alt" 2>/dev/null
            end
    end
end

# Normalize the initial directory at startup too.
__normalize_pwd_to_home

if not set -q XDG_RUNTIME_DIR
    set -gx XDG_RUNTIME_DIR /run/user/(id -u)
end
