#!/usr/bin/env bash
# Modern dotfiles bootstrap. Idempotent. Run the relevant target per machine.
#
#   ./bootstrap.sh container   # inside the `dev` Arch distrobox: CLI tools + link
#   ./bootstrap.sh host        # on the Bazzite host: WezTerm flatpak + ssh service
#   ./bootstrap.sh link        # just (re)create the stow symlinks
#
# Home is shared between host and container, so the symlinks, the ~/.local/bin
# starship binary, and the Nerd Font are created once (from the container) and
# seen by both sides.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(fish starship kitty zellij git ssh bin nvim)

in_container() { [ -f /run/.containerenv ]; }
log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

install_starship() {
    if [ -x "$HOME/.local/bin/starship" ]; then log "starship already in ~/.local/bin"; return; fi
    log "Installing starship into ~/.local/bin (shared by host + container)"
    mkdir -p "$HOME/.local/bin"
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

install_font() {
    local dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
    # fontconfig lives on the host (where the terminal runs), not in the container.
    local fc_cache="fc-cache"
    if ! command -v fc-cache >/dev/null && command -v distrobox-host-exec >/dev/null; then
        fc_cache="distrobox-host-exec fc-cache"
    fi
    if ls "$dir"/*.ttf >/dev/null 2>&1; then log "JetBrainsMono Nerd Font already extracted"; else
        log "Installing JetBrainsMono Nerd Font into ~/.local/share/fonts (shared)"
        mkdir -p "$dir"
        curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -o /tmp/JBMono.zip
        unzip -o /tmp/JBMono.zip -d "$dir" >/dev/null
    fi
    $fc_cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
}

backup_conflicts() {
    # Move pre-existing REAL files aside so stow can place its symlinks.
    local f
    for f in "$HOME/.ssh/config"; do
        if [ -f "$f" ] && [ ! -L "$f" ]; then
            mv "$f" "$f.pre-dotfiles.bak"
            log "backed up $f -> $f.pre-dotfiles.bak"
        fi
    done
}

link() {
    command -v stow >/dev/null || { echo "stow missing — run inside the dev container (pacman -S stow) first"; return 1; }
    backup_conflicts
    log "Linking packages: ${PACKAGES[*]}"
    cd "$DOTFILES"
    stow -v -t "$HOME" "${PACKAGES[@]}"
    # Point git at the now-linked global gitignore (~/.gitconfig is shared home).
    git config --global core.excludesfile "$HOME/.gitignore_global"
    log "git core.excludesfile -> ~/.gitignore_global"
}

container() {
    in_container || { echo "This target must run INSIDE the dev distrobox."; exit 1; }
    log "pacman: installing CLI toolchain"
    sudo pacman -S --needed --noconfirm \
        fish zellij fzf zoxide eza bat fd stow neovim ripgrep wl-clipboard unzip
    install_starship
    install_font
    link
    log "Container setup complete. Open a new fish shell to see the result."
}

install_kitty() {
    # Self-contained bundle into shared ~/.local; the host GUI runs it.
    if [ ! -x "$HOME/.local/kitty.app/bin/kitty" ]; then
        log "Installing Kitty into ~/.local/kitty.app"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    else
        log "Kitty already installed"
    fi
    # Put kitty/kitten on PATH (shared ~/.local/bin) and add a desktop launcher.
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/"
    mkdir -p "$HOME/.local/share/applications"
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME/.local/share/applications/kitty.desktop"
    sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" "$HOME/.local/share/applications/kitty.desktop"
    command -v update-desktop-database >/dev/null && update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
}

host() {
    in_container && { echo "This target must run on the Bazzite HOST."; exit 1; }
    install_kitty
    log "Enabling login-time SSH key auto-load (ksshaskpass/KWallet)"
    systemctl --user daemon-reload
    systemctl --user enable --now ssh-add.service
    log "Host setup complete. (Symlinks/starship/font come from the container — shared home.)"
}

case "${1:-}" in
    container) container ;;
    host)      host ;;
    link)      link ;;
    *) echo "usage: $0 {container|host|link}"; exit 1 ;;
esac
