#!/bin/bash
set -e

export github=https://raw.githubusercontent.com/Croissong

read -p "username: " username </dev/tty
read -sp "password: " password </dev/tty
read -sp "password again: " password2 </dev/tty
if [ "$password" != "$password2" ]; then 
    echo "passwords didnt match"
    exit
fi;
read -p "hostname: " hostname </dev/tty

export username password hostname
 
timedatectl set-ntp true
sgdisk -o \
-n 0:0:+1G -t 0:ef00 -c 0:"efi /boot" \
-n 0:0:+30G -t 0:8300 -c 0:"/" \
-n 0:0:0 -t 0:8300 -c 0:"/home" \
/dev/sda
 
mkfs.vfat /dev/sda1
mkfs.btrfs -f /dev/sda2 /dev/sda3
 
mount /dev/sda2 /mnt
mkdir /mnt/boot		
mount /dev/sda1 /mnt/boot		
mkdir /mnt/home		
mount /dev/sda3 /mnt/home
 
mount -o remount,size=2G /run/archiso/cowspace
pacman -Syy
pacman -S --noconfirm reflector
reflector --latest 10 --age 24 --protocol https  --sort rate --save /etc/pacman.d/mirrorlist
 
pacstrap /mnt base
 
curl -k $github/arch/master/etc/fstab > /mnt/etc/fstab
 
arch-chroot /mnt
alias install="pacman -S --noconfirm"

curl -k $github/arch/master/etc/locale.gen > /etc/locale.gen
curl -k $github/arch/master/etc/sudoers > /etc/sudoers
curl -k $github/arch/master/etc/blacklist.conf > /etc/modprobe.d/blacklist.conf
curl -k $github/.dotfiles/master/my-keys.map > /usr/share/kbd/keymaps/my-keys.map 
loadkeys my-keys

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
locale-gen
echo KEYMAP=my-keys > /etc/vconsole.conf
 
echo $hostname > /etc/hostname
sed -i ‘/::1/a 127.0.1.1\t$hostname.localdomain\t$hostname’ /etc/hosts
echo root:$password | chpasswd
 
install intel-ucode linux-lts linux-lts-headers
bootctl --path=/boot install
curl -k $github/arch/master/boot/loader.conf > /boot/loader/loader.conf
curl -k $github/arch/master/boot/arch.conf > /boot/loader/entries/arch.conf
curl -k $github/arch/master/boot/arch-lts.conf > /boot/loader/entries/arch-lts.conf

install connman
systemctl enable connman

install zsh sudo
useradd -m -G wheel -s /bin/zsh $username
echo $username:$password | chpasswd 

install --needed binutils make gcc fakeroot expac yajl git pkg-config

su $username && cd ~
aur=https://aur.archlinux.org
git clone $aur/cower.git && cd cower && makepkg -i --skippgpcheck --needed && cd - && rm -rf cower
git clone $aur/pacaur.git && cd pacaur && makepkg -i --needed && cd - && rm -rf pacaur

#install nvidia-beta
echo "done... now: umount -R /mnt && reboot"
