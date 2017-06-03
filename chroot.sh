github=https://raw.githubusercontent.com/Croissong
curl $github/.dotfiles/master/my-keys.map | loadkeys
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home
arch-chroot /mnt
