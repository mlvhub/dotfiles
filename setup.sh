# TODO: List requirements
# - zsh
# - ripgrep

# Link the zpreztorc file
ln -s $PWD/zpreztorc ~/.zpreztorc

# Link the zshrc file
ln -s $PWD/zshrc ~/.zshrc

# Source the new bash profile
source ~/.zshrc

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Link the init.vim
ln -s $PWD/init.vim ~/.config/nvim/init.vim

# Install the plugins in the background - NOT WORKING
vim +PlugInstall +qall
