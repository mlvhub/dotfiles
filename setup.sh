# Link the bash profile
ln -s $PWD/bash_profile ~/.bash_profile

# Source the new bash profile
source ~/.bash_profile

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Link the init.vim
ln -s $PWD/init.vim ~/.config/nvim/init.vim

# Install the plugins in the background - NOT WORKING
vim +PlugInstall +qall
