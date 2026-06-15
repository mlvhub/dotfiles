# dotfiles

Modern shell environment for a **Bazzite host + Arch `dev` distrobox** (shared home).

Stack: **Fish** (autosuggestions/completion) · **Starship** prompt · **Kitty**
terminal (installed to `~/.local`) · **Zellij** multiplexer · **GNU stow** for
linking · passphrase-protected SSH key auto-loaded via systemd + KWallet.

> Terminal note: WezTerm was the original pick but its only available build
> (Flathub/Arch `20240203`) crashes on KDE Plasma 6 Wayland (explicit-sync). Kitty
> is current, Wayland-native, and installs cleanly to shared `~/.local` — no
> Flatpak sandbox, no rpm-ostree layering.

## Layout (stow packages)

| Package    | Links to                                   | Where it's used   |
|------------|--------------------------------------------|-------------------|
| `fish`     | `~/.config/fish/`                          | host + container  |
| `starship` | `~/.config/starship.toml`                  | host + container  |
| `kitty`    | `~/.config/kitty/kitty.conf`               | host              |
| `zellij`   | `~/.config/zellij/config.kdl`              | container (+host) |
| `git`      | `~/.gitignore_global`                      | host + container  |
| `ssh`      | `~/.ssh/config`, `~/.config/systemd/user/ssh-add.service` | host |
| `bin`      | `~/.local/bin/set-wake.sh`                 | host              |
| `nvim`     | `~/.config/nvim/init.lua`                  | host + container  |

`legacy/` holds the previous zsh/prezto/alacritty configs (archived, not linked).
`tmux.conf` is kept at the root until Zellij is proven, then it can move to `legacy/`.

## Install

Home is shared, so symlinks + the `~/.local/bin/starship` binary + the Nerd Font
are created **once from the container** and seen by both sides.

```sh
# 1. Inside the dev distrobox — CLI tools, starship, font, and the symlinks:
cd ~/personal/dotfiles && ./bootstrap.sh container

# 2. On the Bazzite host — Kitty (install + launcher) + SSH auto-load service:
cd ~/personal/dotfiles && ./bootstrap.sh host
```

## SSH key auto-load

`ssh/.ssh/config` sets `AddKeysToAgent yes`; `ssh-add.service` loads
`~/.ssh/hetzner_mlvhub_id_ed25519` into the shared systemd ssh-agent at login,
prompting once via **ksshaskpass** (passphrase then stored in KWallet). The agent
socket is shared into the container, so the key is live on host **and** in `dev`.

First login after `./bootstrap.sh host`: enter the passphrase once, tick "store in
KWallet". Silent thereafter. Verify with `ssh-add -l` and `ssh -T git@github.com`.
