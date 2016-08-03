sudo pacman -Syu
sudo pacman -S --noconfirm xorg-xinit xorg-server xorg-utils xorg-server-utils
# replace i3status with i3block
sudo pacman -S --noconfirm i3-wm i3status i3lock

# replace with outer launcher
sudo pacman -S --noconfirm dmenu

mkdir ~/.i3
cp /etc/i3/config ~/.i3/
echo "exec i3" >> ~/.xinitrc

# x terminal simulator, alternative for xterm
sudo pacman -S --noconfirm rxvt-unicode
sudo pacman -S --noconfirm zsh
echo "[[ -f ~/.zshrc ]] && ~/.zshrc" >> ~/.zprofile
echo "[ -z \"$DISPLAY\" -a \"$(fgconsole)\" -eq 1 ] && exec startx" >> ~/.zprofile
chsh -s /bin/zsh

# oh my zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o zshohmy.sh
sed -i -e "s/env zsh//" zshohmy.sh
sh zshohmy.sh
rm zshohmy.sh

sudo sed -i -e 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

localectl set-locale LANG=en_US.UTF-8
# sudo echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# sudo echo "LANGUAGE=en_US.UTF-8:en" >> /etc/locale.conf
# sudo echo "LC_ADDRESS=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_COLLATE=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_CTYPE=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_IDENTIFICATION=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_MEASUREMENT=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_MESSAGES=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_MONETARY=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_NAME=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_NUMERIC=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_PAPER=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_TELEPHONE=de_DE.UTF-8" >> /etc/locale.conf
# sudo echo "LC_TIME=de_DE.UTF-8" >> /etc/locale.conf

#Keyboard layout
localectl --no-convert set-x11-keymap de

#sudo pacman -S --noconfirm emacs
