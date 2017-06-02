read -p “username: “ username
read -sp “password: “ password
read -p “hostname: “ hostname
 
github=https://raw.githubusercontent.com/Croissong
curl $github/.dotfiles/master/my-keys.map > /usr/share/kbd/keymaps/my-keys.map 
loadkeys my-keys
 
timedatectl set-ntp true
sgdisk -o \
-n 0:0:+1G -t 0:ef00 -c 0:”efi /boot” \
-n 0:0:+30G -t 0:8300 -c 0:“/” \
-n 0:0:0 -t 0:8300 -c 0:”/home” \
/dev/sda
 
mkfs.vfat /dev/sda1
mkfs.btrfs /dev/sda2 /dev/sda3
 
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/sda3 /mnt/home
 
mount -o remount,size=2G /run/archiso/cowspace
pacman -S reflector
reflector --latest 10 --age 24 --protocol https  --sort rate --save /etc/pacman.d/mirrorlist
 
curl $github/arch/master/locale.gen > /etc/locale.gen
 
pacstrap /mnt base
 
genfstab -L /mnt >> /mnt/etc/fstab
 
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
locale-gen
echo “KEYMAP=my-keys” > /etc/vconsole.conf
 
echo $hostname > /etc/hostname
sed -i ‘/::1/a 127.0.1.1\t$hostname.localdomain\t$hostname’ /etc/hosts
echo root:$password | chpasswd
 
pacman -S  intel-ucode
bootctl --path=/boot install
curl $github/arch/master/boot/loader.conf > /boot/loader/loader.conf
curl $github/arch/master/boot/arch.conf > /boot/loader/entries/arch.conf
 
 
exit
umount -R /mnt
reboot
