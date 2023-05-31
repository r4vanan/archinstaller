#initial script
echo "Welcome to r4vanan arch linux installer script"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 10/" /etc/pacman.conf
pacman -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true
lsblk
read -r "drive?Enter the Drive: "
###i like to use the cfdisk some days before i like to use fdisk to use
cfdisk $drive
read -r "swap?Do you create the space for the SWAP memory? [y/n]"
if [[ $swap == 'y' ]] ; then
	read -r "swapmem?Enter the swap memory: "
	swapon $swapmem
fi
mkfs.ext4 $partition
read -r "answer?Did you also create efi partition? [y/n] "
if [[ $answer = "y" ]] ; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.vfat -F 32 $efipartition
fi
mount $partition /mnt 
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit
