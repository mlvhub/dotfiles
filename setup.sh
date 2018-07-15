# TODO: List requirements
# - zsh
# - ripgrep

# Link the zpreztorc file
ln -s $PWD/zpreztorc ~/.zpreztorc

# Link the zshrc file
ln -s $PWD/zshrc ~/.zshrc

# Clone the tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Link the tmux file
ln -s $PWD/tmux.conf ~/.tmux.conf

# Source the new zsh profile
source ~/.zshrc

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Link the init.vim
ln -s $PWD/init.vim ~/.config/nvim/init.vim

# Install the plugins in the background - NOT WORKING
vim +PlugInstall +qall
