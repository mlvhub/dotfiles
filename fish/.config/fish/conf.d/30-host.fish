# HOST-ONLY environment (Bazzite / KDE Plasma).
# Runs when NOT inside the dev container.

test -f /run/.containerenv; and return 0

# Convenience: jump straight into the dev container.
abbr -a dev 'distrobox enter dev'

# (Flatpak / ujust host helpers can go here as needed.)
