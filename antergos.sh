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
cp ~/.bashrc ~/.zshrc
echo "PS1='[$n @ %M]: '"
chsh -s /bin/zsh

sudo pacman -S --noconfirm emacs
