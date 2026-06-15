alias v="nvim"
alias gc="git commit"
alias gco="git checkout"
alias gpso="git push origin"
alias gplo="git pull origin"
alias ga="git add"
alias gs="git status"
alias gl="git log"
alias gb="git branch"
alias gd="git diff"

[ -s "/Users/miguellopez/.jabba/jabba.sh" ] && source "/Users/miguellopez/.jabba/jabba.sh"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home

source ~/git-completion.bash

# Airline-like stuff
# colors
PS1='\w\[\033[0;32m\]$( git branch 2> /dev/null | cut -f2 -d\* -s | sed "s/^ / [/" | sed "s/$/]/" )\[\033[0m\] \$ '

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

function rnm() {
  WINDOW_NAME=$1
  PROMPT_COMMAND='echo -en "\033]0; $WINDOW_NAME \a"'
}

export PATH="$HOME/.cargo/bin:$PATH"
