# Nudge when a dev tool (sbt, scala, scalafmt, gradle, java, …) is run on the
# HOST instead of inside the `dev` distrobox, where the Scala/JVM toolchain lives.
# Inside the container those resolve normally, so this only fires on the host.
# Anything else falls through to fish's normal "Unknown command" message.
function fish_command_not_found
    set -l cmd $argv[1]
    set -l coursier_bin $HOME/.local/share/coursier/bin

    # `cs`/`coursier` work on the host, so never nudge for them.
    if not test -f /run/.containerenv
        and not contains -- $cmd cs coursier
        and begin
            test -x "$coursier_bin/$cmd" # Coursier-installed (sbt, scala, scalafmt, …)
            or contains -- $cmd gradle gradlew mvn mill java javac jar jshell
        end
        printf '%s⚠  %s lives in the `dev` distrobox, not on the host.%s\n' \
            (set_color --bold yellow) $cmd (set_color normal) >&2
        printf '   enter it:    %sdistrobox enter dev%s\n' \
            (set_color cyan) (set_color normal) >&2
        printf '   or one-shot: %sdistrobox enter dev -- %s …%s\n' \
            (set_color cyan) $cmd (set_color normal) >&2
        return 127
    end

    __fish_default_command_not_found_handler $argv
end
