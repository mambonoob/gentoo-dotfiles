#!/bin/bash
## Stage 2 (after chroot)
echo "What timezone are you in? (e.g. America/Los_Angeles or America/New_York)"
read tz
echo "Linking timezone..."
ln -sf /usr/share/zoneinfo/$tz /etc/localtime
echo "Generating adjtime..."
hwclock --systohc

echo "Setting locale..."
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "What hostname would you like to use?"
read hostn
echo $hostn > /etc/hostname
echo "127.0.0.1         localhost" >> /etc/hosts
echo "::1               localhost" >> /etc/hosts
echo "127.0.1.1         $hostn.localdomain      $hostn" >> /etc/hosts

echo "Setting the root password..."
passwd

echo "Installing the boot loader! Where is your EFI System Partition mounted? (give full path, e.g. /efi)"
read esp
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=$esp --recheck
os-prober
grub-mkconfig -o /boot/grub/grub.cfg

makeuser () {
    echo "Create a user account? y or n" 
    read useryn
}
makeuser
if [ $useryn = y ]; then
    echo "Name for the new user?"
    read username
    echo "Creating user..."
    useradd -mG users,wheel,video,audio,input,sys,network,lp,storage,power $username
    echo "Password for the new user?"
    passwd
    sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
elif [ $useryn = n ]; then
    echo " "
else
    makeuser
fi
echo "Would you like to install Xorg? Please enter y or n."
read xorg 
echo "Would you like to install network management software? Please enter y or n."
read net 
   
choosenetwork () {
    echo "Enable (n)etworkmanager or (s)ystemd-networkd? (networkmanager is recommended)"
    read whichn
}
chwifi () {
    echo "Enable wifi daemon (iwd/iwctl)? y or n"
    read whichwifi
}
gdriver () {
    echo "Which graphics driver would you like to install? (n)vidia, (i)ntel, or (a)mdgpu?"
    read gpuven
}
echo "Installing extra packages!"
lts=linux-lts
if [ $xorg = y ]; then
    gdriver
    if [ $gpuven = n ]; then
	    echo "Installing NVIDIA driver..."
	    pacman -S nvidia-utils
	    if pacman -Qs $lts > /dev/null; then
		    pacman -S nvidia-lts
	    else
		    pacman -S nvidia
	    fi
    elif [ $gpuven = i ]; then
	    echo "Installing Intel driver..."
	    pacman -S mesa vulkan-intel xf86-video-intel
    elif [ $gpuven = a]; then
	    echo "Installing AMD driver..."
	    pacman -S mesa vulkan-radeon xf86-video-amdgpu
    else
	    gdriver
    fi
    echo "Installing xorg..."
    pacman -S xorg xorg-xinit
elif [ $xorg = n ]; then
    echo "Nevermind, Xorg was not selected. "
fi
if [ $net = y ]; then
    echo "Installing network management software..."
    pacman -S iwd networkmanager dhcpcd
    choosenetwork
    if [ $whichn = n ]; then
        systemctl enable NetworkManager.service
    elif [ $whichn = s ]; then
        systemctl enable systemd-networkd.service
    else
        choosenetwork
    fi
    chwifi
    if [ $whichwifi = y ]; then
        systemctl enable iwd
    elif [ $whichwifi = n ]; then
        echo " "
    else
        chwifi
    fi
    systemctl enable dhcpcd systemd-resolved
elif [ $net = n ]; then
    echo "Nevermind, network software was not selected."
else
    echo "Nevermind, network software was not selected."
fi
echo "Done! Now type exit and then reboot to use your new installation!" 
# end of stage2
