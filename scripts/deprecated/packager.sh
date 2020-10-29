#!/bin/bash
#  ────────────────────────────────── Package Installer ─────────────────────────────────

I="pacman -S"
ECHO="echo -e"
CONT="echo -e \n \n"
MOVEDIR="cp -r"
MOVE=cp
D="echo -e \nDone.\n"

# Check if user is root
if [[ $EUID -ne 0 ]]; then
    echo -e "\nInstall script must be run as root!\nDon't run this script with sudo, log in as root instead.\nExiting...\n"
    exit 1
fi
$ECHO "\nInstalling basic system packages..."
$ECHO "\nDo you have an (intel) or (amd) CPU?"
read cpuven
$I "$cpuven"-ucode wget curl git base-devel zip unzip neofetch


$ECHO "\nApplying microcode...\n"
mkinitcpio -P
grub-mkconfig -o /boot/grub/grub.cfg


$ECHO "\nInstalling X...\n"
$I xorg xorg-server xorg-xrandr arandr xterm


$ECHO "\nInstalling graphics drivers..."
$ECHO "\nDo you have an (n)vidia, (a)md or (i)ntel GPU?"
read gpuven
if [ $gpuven = a ]; then
    $I mesa vulkan-radeon xf86-video-amdgpu mesa-vdpau
elif [ $gpuven = n ]; then
    $I nvidia
elif [ $gpuven = i ]; then
    $I mesa vulkan-intel
    $ECHO "Install the DDX driver? (improves 2D performance but often unstable) (y or n)"
    read ddx
    if [ $ddx = y ]; then
        $I xf86-video-intel
    elif [ $ddx != y ]; then
        $CONT
    fi
fi

FONTS_PKGS="ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-fira-code ttf-hack ttf-ibm-plex ttf-liberation ttf-linux-libertine ttf-monofur ttf-roboto noto-fonts ttf-fira-mono otf-fira-mono ttf-anonymous-pro ttf-cascadia-code adobe-source-code-pro-fonts ttf-inconsolata ttf-jetbrains-mono font-bh-ttf terminus-font-otb tex-gyre-fonts ttf-ubuntu-font-family"
$ECHO "\nInstall font families? (y or n)\n"
read fonts
if [ $fonts = y ]; then
    $I $FONTS_PKGS
elif [ $fonts = n ]; then
    $CONT
fi


$ECHO "\nInstall sound software? (y or n)\n"
read sound
if [ $sound = y ]; then
    $I pulseaudio pulseaudio-alsa alsa-utils
    $ECHO "\nRun alsamixer to unmute audio? (y or n)\n"
    read mixer
    if [ $mixer = y ]; then
        alsamixer
    elif [ $mixer = n ]; then
        $CONT
    fi
elif [ $sound = n ]; then
    $CONT
fi

$ECHO "\nInstalling NeoVim...\n"
$I neovim

$ECHO "\nInstall Emacs? (y or n)\n"
read emacs
if [ $emacs = y ]; then
    $I emacs
elif [ $emacs = n ]; then
    $CONT
fi

$ECHO "\nInstall basic GUI software (browser, media player, terminal emulator, etc)?\n (y or n)"
GUI_BASIC="firefox piper discord feh deluge deluge-gtk vlc lxappearance-gtk3 pcmanfm gtk-engine-murrine pavucontrol konsole"
read inst_gui
if [ $inst_gui = y ]; then
    $I $GUI_BASIC
elif [ $inst_gui != y ]; then
    $CONT
fi

$ECHO "\nChoose a desktop environment:\n"
$ECHO " (1): GNOME \n (2): KDE Plasma \n (3): Xfce \n (4): Custom (Stacking) \n (5): Custom (Tiling) \n (6): None \nEnter 1-6:"
DE_CUS="sxhkd sylpheed ranger rofi tint2 galculator"
read de_choice
if [ $de_choice = 1 ]; then
    $I $GUI_BASIC gnome gnome-extra tint2
elif [ $de_choice = 2 ]; then
    $I $GUI_BASIC plasma-meta kde-applications-meta
elif [ $de_choice = 3 ]; then
    $I $GUI_BASIC xfce4 xfce4-goodies lxdm
elif [ $de_choice = 4 ]; then
    $I $GUI_BASIC openbox obconf $DE_CUS
elif [ $de_choice = 5 ]; then
    $I $GUI_BASIC i3-gaps i3blocks i3lock i3status $DE_CUS
    $ECHO "\n **************\n The custom tiling DE uses i3 with xinit, make sure to install my xinitrc!\n **************\n"
elif [ $de_choice = 6 ]; then
    $CONT
fi

$ECHO "\nChoose a display manager:\n"
$ECHO " (1): GDM (recommended for GNOME) \n (2): SDDM (recommended for KDE Plasma) \n (3): LXDM (recommended for Xfce and the custom stacking DE) \n (4): None, use xinit instead (highly recommended for the custom tiling DE) \nEnter 1-4:"
read dm_choice

if [ $dm_choice = 1 ]; then
    $I gdm
    systemctl enable gdm
elif [ $dm_choice = 2 ]; then
    $I sddm
    systemctl enable sddm
elif [ $dm_choice = 3 ]; then
    $I lxdm
    systemctl enable lxdm
elif [ $dm_choice = 4 ]; then
    $I xorg-xinit
    systemctl disable display-manager
    $ECHO "Create example .xinitrc? (y or n):"
    read xin
    if [ $xin = y ]; then
        cp -i /etc/X11/xinit/xinitrc ~/.xinitrc
    elif [ $xin != y ]; then
        $CONT
    fi
fi
$ECHO "Done!"

if [ $gpuven = n ];then
    $ECHO "It appears we installed the NVIDIA driver. This requires a reboot. After rebooting, run nvidia-xconfig as root.\nREBOOTING IN 10 SECONDS..."
    sleep 10
    shutdown -r now
elif [ $gpuven != n ]; then
    $CONT
fi
