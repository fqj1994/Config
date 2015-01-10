#!/bin/bash
cd $(dirname $0)
CWD=$(pwd)
cd

# deploy vim
rm .vimrc
rm .vim
ln -sv "$CWD/home/vim/vimrc" .vimrc
ln -sv "$CWD/home/vim/vim" .vim

# deploy xmonad
rm .xmobarrc
rm .xmonad/xmonad.hs
mkdir .xmonad
ln -sv "$CWD/home/xmonad/xmobarrc" .xmobarrc
cd .xmonad
ln -sv "$CWD/home/xmonad/xmonad/xmonad.hs"
cd ..
xmonad --recompile
