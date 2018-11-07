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

alias tmux="tmux -2"
alias tc="clear && tmux clear-history"

export PATH="/Users/miguellopez/protoc/bin:$PATH"
export PATH="/Users/miguellopez/kafka/bin:$PATH"
export PATH="~/.cargo/bin:$PATH"
export PATH=$PATH:~/Downloads/cmake-3.12.0-Linux-x86_64/bin
export PATH=$PATH:$HOME/.linkerd2/bin
export PATH="$HOME/.fastlane/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export RUSTC_WRAPPER=sccache

alias curl='noglob curl'

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home
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
