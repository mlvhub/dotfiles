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
export PATH="$HOME/idea/idea-IC-241.14494.240/bin:$PATH"

export PATH="$HOME/.local/share/coursier/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export PATH="$HOME/.cargo/bin:$PATH"
#export RUSTC_WRAPPER=sccache
export RUST_SRC_PATH=/usr/local/src/rust/src

export PATH=$PATH:/snap/bin

export PATH=$PATH:$HOME/anaconda3/bin

. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

alias curl='noglob curl'
export PATH=$PATH:"/mnt/c/Users/migue/AppData/Local/Programs/Microsoft VS Code/bin"

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

eval "$(ssh-agent -s)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mlopez/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mlopez/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/mlopez/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mlopez/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="/home/mlopez/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
