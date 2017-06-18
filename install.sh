#!/bin/bash
set -e

export github=https://api.github.com/repos/croissong

curl -L $github/arch/tarball | tar -xvz --strip-components=1 -C arch

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
mount -B /run/archiso/img_dev/files /mnt/mnt
 
mount -o remount,size=2G /run/archiso/cowspace
pacman -Syy
pacman -S --noconfirm reflector
reflector --latest 10 --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
 
pacstrap /mnt base

mv arch/etc/blacklist.conf /mnt/etc/modprobe.d/blacklist.conf
mv arch/etc/fstab /mnt/etc/fstab
mv arch/etc/iptables/iptables.rules /mnt/etc/iptables/iptables.rules
mv arch/etc/locale.gen/mnt/etc/locale.gen
mv arch/etc/sudoers /mnt/etc/sudoers
mv arch/etc/systemd/system/* /mnt/etc/systemd/system/
mv arch/etc/vconsole.conf /mnt/etc/vconsole.conf

mv arch/usr/my-keys.map /mnt/usr/share/kbd/keymaps/my-keys.map

mv arch/boot/loader.conf /mnt/boot/loader/loader.conf
mv arch/boot/arch.conf /mnt/boot/loader/entries/arch.conf
mv arch/boot/arch-lts.conf /mnt/boot/loader/entries/arch-lts.conf

arch-chroot /mnt
alias install="pacman -S --noconfirm"

loadkeys my-keys

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
locale-gen
 
echo $hostname > /etc/hostname
sed -i ‘/::1/a 127.0.1.1\t$hostname.localdomain\t$hostname’ /etc/hosts
echo root:$password | chpasswd
 
install intel-ucode linux-lts linux-lts-headers
bootctl --path=/boot install

install connman
systemctl enable connman

install zsh sudo
useradd -m -G wheel -s /bin/zsh $username
echo $username:$password | chpasswd 

su $username && cd ~

curl -L $github/dotfiles/tarball | tar -xvz --strip-components=1

gpg --import /mnt/privkey.asc

install --needed binutils make gcc fakeroot expac yajl git pkg-config
aur=https://aur.archlinux.org
git clone $aur/cower.git && cd cower && makepkg -i --skippgpcheck --needed && cd - && rm -rf cower
git clone $aur/pacaur.git && cd pacaur && makepkg -i --needed && cd - && rm -rf pacaur

alias install="pacaur -S --noconfirm"

install openssh yadm-git

cp /mnt/.ssh/id_rsa_$hostname ~/.ssh/id_rsa
cp /mnt/.ssh/id_rsa_$hostname.pub ~/.ssh/id_rsa.pub

yadm clone git@github.com:Croissong/.dotfiles.git
yadm submodule update --init --recursive && yadm submodule foreach git checkout master

install physlock
systemctl enable physlock@$username

#install nvidia-beta
echo "done... now: umount -R /mnt && reboot"
