#!$(which bash)

curl www.eacgh.cn/Linux/mirrorlist -Ls > /etc/pacman.d/mirrorlist

umount /dev/sda*
fdisk /dev/sda <<fdisk
o
n




w
fdisk

mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
pacstrap /mnt base base-devel linux linux-firmware grub dhcpcd
genfstab -U /mnt > /mnt/etc/fstab
arch-chroot /mnt <<system
systemctl enable dhcpcd
passwd -d root
grub-install /dev/sda
grub-mkconfig > /boot/grub/grub.cfg
system
umount /mnt
reboot
