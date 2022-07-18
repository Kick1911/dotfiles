#!/bin/sh

CONFIG=$HOME/.config/

# link git config
ln -s $PWD/.gitconfig $HOME
ln -s $PWD/.gitignore_global $HOME

# link zsh stuff
ln -s $PWD/.zprofile $HOME
ln -s $PWD/.zshrc $HOME
sudo ln -s $PWD/etc/zsh/ /etc/

# link .config stuff
ln -s $PWD/nvim $CONFIG
ln -s $PWD/polybar $CONFIG
ln -s $PWD/bspwm $CONFIG
ln -s $PWD/sxhkd $CONFIG

# link other etc stuff
sudo ln -s $PWD/etc/cron.daily/fstrim /etc/cron.daily/
