#!/bin/bash
#  ────────────────────────────── Install mambo's dotfiles ──────────────────────────────


# Check if user is root
if [[ $EUID -eq 0 ]]; then
    echo "This script must NOT be run as root!" 1<&2
    exit 1
fi


# Define variables
MKRWX="sudo chmod 777"
ECHO="echo -e"
EMACSDIR="$HOME/.emacs.d"
LOCSHARE="$HOME/.local/share"
XDGCONFS="$HOME/.config"
D="echo -e \nDone.\n" # lazy af

$ECHO "\nInstalling fonts...\n"
sudo pacman -S ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-fira-code ttf-hack ttf-ibm-plex ttf-liberation ttf-linux-libertine ttf-monofur ttf-roboto noto-fonts ttf-fira-mono otf-fira-mono ttf-anonymous-pro ttf-cascadia-code adobe-source-code-pro-fonts ttf-inconsolata ttf-jetbrains-mono font-bh-ttf terminus-font-otb tex-gyre-fonts ttf-ubuntu-font-family # Not all of these are required for my dotfiles to work but I always like to have these fonts installed

$ECHO "\nInstalling Konsole...\n"
sudo pacman -S konsole

$ECHO "\nInstalling dotfiles...\n  Installing Konsole dotfiles..."
cp -r $PWD/dot_files/konsole/ $LOCSHARE
$MKRWX $LOCSHARE/konsole # Avoid issues with konsole's config not loading/saving

cp $PWD/dot_files/konsolerc $XDGCONFS/
$MKRWX $XDGCONFS/konsolerc # See L28

$ECHO "  Installing Emacs dotfiles..."
sudo mv $EMACSDIR $HOME/.emacs.d.bak-$(date +%H:%M:%S-%d-%b-%Y)/ # Back up original emacs dotfiles
cp -r $PWD/dot_files/dot-emacs-dot-d/ $EMACSDIR
$MKRWX $EMACSDIR # Sometimes they end up as readonly

$ECHO "  Installing .xinitrc..."
sudo pacman -S xorg-xinit
cp $PWD/dot_files/.xinitrc $HOME/.xinitrc

$ECHO "Installing scripts...\n"
SHDEST="$HOME/mambo-scripts"
mkdir $SHDEST
cp -r $PWD/scripts/*.sh $SHDEST
sudo chmod ugo+x $SHDEST/*.sh # for obvious reasons

$D

