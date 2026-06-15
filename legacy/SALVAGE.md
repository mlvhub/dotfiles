# Salvage list — port these into the new Fish config (step 2)

Extracted from `legacy/zshrc` and `legacy/bash_profile`. Everything below is to be
**kept** and re-expressed in Fish. The cruft that is NOT here (macOS paths, `/home/mlopez`
hardcodes, the PATH-clobbering line, conda/sdkman/jenv/jabba/opam/coursier/fastlane) is
intentionally dropped.

## Aliases — keep
- Editor: `v=nvim`
- Git: `ga=git add`, `gb=git branch`, `gc=git commit`, `gco=git checkout`, `gd=git diff`,
  `gl=git log`, `gs=git status`, `gfo=git fetch origin`, `gplo=git pull origin`,
  `gpso=git push origin`, `gwl=git worktree list`, `gwr=git worktree remove`
- Kube: `k=kubectl`
- Zellij: `zj=zellij`, `zjs=zellij -s`, `zja=zellij attach`, `zjl=zellij ls`,
  `zjk=zellij kill-session`, `zjka=zellij kill-all-sessions`, `zjac=zellij attach --create`
- Cursor: `cursor='$(find ~/.cursor-server/bin -name cursor -type f | head -n 1)'`
- tmux: `tmux=tmux -2`, `tc=clear && tmux clear-history`  (keep only if tmux is retained)

## Functions — keep
- `rnm <name>` — set terminal/window title (re-express as a Fish function)

## Env — keep
- `EDITOR/VISUAL=nvim`, `COLORTERM=truecolor`
- `FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'`
- `GOPATH=$HOME/go`, add `$GOPATH/bin` + `/usr/local/go/bin` to PATH  (container-only)

## Per-machine notes
- Dev toolchain PATH (cargo, go, pyenv, .local/bin) → container-only conf.d block.
- SSH: replace `keychain` with systemd ssh-agent + ksshaskpass/KWallet (step 6).
