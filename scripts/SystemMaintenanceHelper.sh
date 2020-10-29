#!/bin/bash

##### Mambo's Archlinux System Maintenance Script #####
##### Fri Sep 25 2020 #####
# yea it kinda sucks please don't hate me

#### Prep Work ####

# Check if user is root
if [[ $EUID -ne 0 ]]; then
    echo -e "\nMaintenance script must be run as root!\nDon't run this script with sudo, log in as root instead.\nExiting...\n"
    exit 1
fi

# Go into root home directory
cd /root/

# Define variables
ECHO="echo -e"
MAN="$ECHO \n (S)how this info\n (e)xit\n(c)heck failed units\n(u)pdate PKGLIST\n(i)nstall needed packages from PKGLIST\n(I)nstall all packages from PKGLIST, even unnecessary ones\n(r)ank mirrors\n(U)pgrade the system"
INP="$ECHO \nEnter a command (0 to exit):"
CONT="echo """
# Show the user some info
$ECHO "What would you like to do?"
$MAN
$ECHO "Enter a command: "

#### The actual script ####

read option # Actually runs the script by prompting for an option

# Show commands (help)
if [ $option = S ]; then
    $MAN
    $INP
    read option
fi

# Exit the script (0)
if [ $option = e ]; then
    exit 0
fi

# Check failed units (1)
if [ $option = c ]; then
    $ECHO "Checking failed units...\n"
    systemctl --failed
    $INP && read option
fi

# Update PKGLIST (2)
PKGLIST_LOC_SH="/root/PKGLIST-$(date +%F-%H:%M).TXT"
if [ $option = u ]; then
    $ECHO "Writing PKGLIST to $PKGLIST_LOC_SH with pacman -Qqe..."
    pacman -Qqe > "$PKGLIST_LOC_SH"
    $ECHO "PKGLIST updated in $PKGLIST_LOC_SH"
    $INP && read option
fi

# Install needed packages from PKGLIST (3)
if [ $option = i ]; then
    $ECHO "List of PKGLISTs in /root : "
    ls /root/ | grep PKGLIST
    $ECHO "Enter name of PKGLIST:  "
    read pkglist_loc
    pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort /root/$pkglist_loc))
    $INP && read option
fi

# Install all packages from PKGLIST (4)
if [ $option = I ]; then
    $ECHO "List of PKGLISTs in /root : "
    ls /root/ | grep PKGLIST
    $ECHO "Enter name of PKGLIST:  "
    read pkglist_loc
    pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort /root/$pkglist_loc))
    $INP && read option
fi

# Update mirrorlist
if [ $option = r ]; then
    $ECHO "We need pacman-contrib, checking if it is installed..."
    pactrib=pacman-contrib
    if pacman -Qs $pactrib > /dev/null ; then
        echo "$pactrib is installed, great!"
    else
        echo "$pactrib is not installed, installing now..."
        pacman -S $pactrib
    fi
    $ECHO "Backing up current mirrorlist..."
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    $ECHO "Updating mirrorlist..."
    $ECHO "Country to get mirrors from? (enter uppercase 2 letter abbreviation, like "US", "FR", or "GB")"
    read cn
    $ECHO "Sorting mirrors..."
    curl -s "https://www.archlinux.org/mirrorlist/?country="$cn"&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d'| rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
    $ECHO "New mirrorlist written to /etc/pacman.d/mirrorlist"
    $ECHO "Remove $pactrib? (required to sort mirrors) (y or n)"
    read rmp
    if [ $rmp = y ]; then
        pacman -Rs $pactrib
    elif [ $rmp = n ]; then
        $CONT
    fi
    $INP && read option
fi

# Upgrade system (6)
if [ $option = U ]; then
    $ECHO "Upgrading system with pacman -Syu..."
    pacman -Syu
    $INP && read option
fi
