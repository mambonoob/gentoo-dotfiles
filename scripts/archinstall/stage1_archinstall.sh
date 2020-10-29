#!/bin/bash
### Arch autoinstaller script
### Requires manual partitioning and mounting of the disks prior to running it

# Run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "--------------------------------------"
echo "| Welcome to the Arch Install Script |"
echo "--------------------------------------"

# check if disks are partitioned
ispart () {
    echo "Have you partitioned and mounted your disks? (y or n)"
    read part
}
ispart
if [ $part = y ]; then
    echo "Good!"
elif [ $part = n ]; then
    echo "You have to manually partition and mount your disks to '/mnt'." 
    exit 0
else
    echo "Please try again with a proper value!" 
    ispart
fi

# pacstrap
echo "Let's install the base system!"
echo "What kernel package would you like? (e.g. linux, linux-lts...)"
read kern
echo "It's recommended that you install a text editor. Which one would you like? (e.g. vim, nano)"
read texted
echo "Do you have an amd or intel CPU? Please type one of the names."
read cpuven
echo "Enter any extra packages you would like to install. Seperate by spaces."
read extra
echo "Good! Running pacstrap to install the system..."
pacstrap -c /mnt base $kern $kern-headers $texted $cpuven-ucode linux-firmware $extra man-db man-pages texinfo grub efibootmgr dosfstools mtools os-prober ntfs-3g base-devel

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
cp ~/stage2_archinstall.sh /mnt/
chmod 777 /mnt/stage2_archinstall.sh
echo "Stage1 complete. Now, type ./stage2_archinstall.sh to finish the installation."
arch-chroot /mnt


# end of stage1
