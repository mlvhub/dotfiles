if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export VISUAL=nvim
export EDITOR="$VISUAL"

alias v="nvim"

alias gc="git commit"
alias gco="git checkout"
alias gpso="git push origin"
alias gplo="git pull origin"
alias gfo="git fetch origin"
alias ga="git add"
alias gs="git status"
alias gl="git log"
alias gb="git branch"
alias gd="git diff"

alias k="kubectl"

alias tmux="tmux -2"
alias tc="clear && tmux clear-history"

export PATH=/usr/bin:/bin:/usr/sbin:/sbin
export PATH=/usr/local/bin:/usr/local/sbin:"$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

alias cargo="cargo --vcs none"
export PATH="$HOME/.cargo/bin:$PATH"
export RUSTC_WRAPPER=sccache
export RUST_SRC_PATH=/usr/local/src/rust/src

export PATH=$PATH:/snap/bin

export PATH=$PATH:$HOME/anaconda3/bin

alias curl='noglob curl'

function rnm() {
  WINDOW_NAME=$1
  printf "\033];%s\07\n" $WINDOW_NAME
}


export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opam configuration
test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

