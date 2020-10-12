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
export PATH="/Users/miguellopez/kafka/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$PATH:~/Downloads/cmake-3.12.0-Linux-x86_64/bin
export PATH=$PATH:$HOME/.linkerd2/bin
export PATH=$PATH:/usr/local/lib/ruby/gems/2.7.0/bin
export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="~/Library/Python/3.7/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="/usr/local/go/bin:$PATH"

export RUSTC_WRAPPER=sccache
export RUST_SRC_PATH=/usr/local/src/rust/src

alias curl='noglob curl'

export JAVA_HOME=/Users/miguellopez/Library/Caches/Coursier/jvm/adopt@1.8.0-252/Contents/Home
export NDK_HOME=/Users/miguellopez/Documents/android/android-ndk-r17

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
test -r /Users/miguellopez/.opam/opam-init/init.zsh && . /Users/miguellopez/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

autoload -U compinit
fpath=($HOME/.bloop/zsh $fpath)
compinit

[ -f "/Users/miguellopez/.ghcup/env" ] && source "/Users/miguellopez/.ghcup/env" # ghcup-env
