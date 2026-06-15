# Aliases / abbreviations — ported from legacy/zshrc (see legacy/SALVAGE.md).
# Common to host + container.

# Editor
alias v 'nvim'

# Git — abbreviations expand inline (append args, see the real command)
abbr -a ga   'git add'
abbr -a gb   'git branch'
abbr -a gc   'git commit'
abbr -a gco  'git checkout'
abbr -a gd   'git diff'
abbr -a gl   'git log'
abbr -a gs   'git status'
abbr -a gfo  'git fetch origin'
abbr -a gplo 'git pull origin'
abbr -a gpso 'git push origin'
abbr -a gwl  'git worktree list'
abbr -a gwr  'git worktree remove'

# Kubernetes
abbr -a k 'kubectl'

# Zellij (multiplexer)
abbr -a zj   'zellij'
abbr -a zjs  'zellij -s'                  # named session: zjs trading
abbr -a zja  'zellij attach'              # reattach:      zja trading
abbr -a zjl  'zellij ls'                  # list sessions
abbr -a zjk  'zellij kill-session'        # kill:          zjk trading
abbr -a zjka 'zellij kill-all-sessions'
abbr -a zjac 'zellij attach --create'     # attach or create
