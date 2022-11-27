#!/bin/bash

mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.vim/colors/molokai.vim --create-dirs https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
cp vimrc ~/.vimrc


