#!/bin/bash

## AUR Installer Script ##
## Requires Git ##

AURD="$HOME/.aur-script"
ECHO="echo -e"
if [ ! -d $AURD ]; then
  mkdir -p $AURD;
fi

git clone https://aur.archlinux.org/"$1".git $AURD/$1
cd $AURD/$1
git config pull.rebase false
git pull
makepkg -sci


