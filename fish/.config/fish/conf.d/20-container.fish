# CONTAINER-ONLY environment (the `dev` Arch distrobox).
# Guarded by /run/.containerenv so these dev toolchains never leak onto the host.

test -f /run/.containerenv; or return 0

# Go
set -gx GOPATH $HOME/go
fish_add_path -g /usr/local/go/bin $GOPATH/bin

# Rust / Cargo
fish_add_path -g $HOME/.cargo/bin

# Python — uv (binary in ~/.local/bin, already on PATH via 00-env.fish).
# uv manages its own Pythons and per-project venvs; nothing extra needed here.

# OCaml — opam (binary in ~/.local/bin). Load the default switch's environment.
if command -q opam
    opam env --shell=fish | source
end

# Scala — Coursier-installed apps (scala, scalac, scala-cli, sbt, scalafmt, …)
fish_add_path -g $HOME/.local/share/coursier/bin

# Java — whatever `archlinux-java` has selected (currently JDK 21, matching the
# SiriusXM builds). `sudo archlinux-java set java-17-openjdk` reverts; JDK 17 is
# still installed for the Android tooling.
if test -d /usr/lib/jvm/default
    set -gx JAVA_HOME /usr/lib/jvm/default
end

# sbt — lazily load SDE creds (ARTIFACTORY_URL/USER/TOKEN) so the build plugin can
#   init + auth. fish never sources the bash SDE profile, so without this sbt dies
#   with `key not found: ARTIFACTORY_URL`. NB: guard on `-qx` (EXPORTED), not `-q` —
#   a set-but-unexported leftover is visible to `echo` but never reaches the JVM, so
#   `-q` would wrongly skip the load.
function sbt --wraps sbt --description 'sbt with SDE creds auto-loaded'
    if not set -qx ARTIFACTORY_URL; or not set -qx ARTIFACTORY_TOKEN
        sde-load
    end
    command sbt $argv
end

# Android SDK + emulator
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx ANDROID_USER_HOME $HOME/.android
fish_add_path -g $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator

# Visual marker so the prompt/echo makes it obvious you're inside the container.
set -gx DEV_CONTAINER dev
