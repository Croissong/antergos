sudo -v

gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
yaourt -S --noconfirm pacaur
pacaur -Syu

pacaur -S --noconfirm xorg-xinit xorg-server xorg-utils xorg-server-utils
# replace i3status with i3block
pacaur -S --noconfirm i3-wm i3status i3lock

# replace with outer launcher
pacaur -S --noconfirm dmenu

mkdir ~/.i3
cp /etc/i3/config ~/.i3/
echo "exec i3" >> ~/.xinitrc
#echo "[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources" >> ~/.xinitrc

# x terminal emulator
pacaur -S --noconfirm termite
pacaur -S --noconfirm zsh
echo "[[ -f ~/.zshrc ]] && ~/.zshrc" >> ~/.zprofile
echo "[ -z \"$DISPLAY\" -a \"$(fgconsole)\" -eq 1 ] && exec startx" >> ~/.zprofile
echo "[ -z \"$DISPLAY\" -a \"$(fgconsole)\" -eq 1 ] && exec startx" >> ~/.bash_profile

# oh my zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o ~/zshohmy.sh
sed -i -e "s/env zsh//" ~/zshohmy.sh
sh ~/zshohmy.sh
rm ~/zshohmy.sh

#Install fonts
mkdir -p ~/.local/share/fonts
git clone https://github.com/gabrielelana/awesome-terminal-fonts.git ~/deletethis_font_install
cp ~/deletethis_font_install/build/* ~/.local/share/fonts/

fc-cache -fv

mkdir -p ~/.config/fontconfig/conf.d
cp ~/deletethis_font_install/config/10-symbols.conf ~/.config/fontconfig/conf.d/
rm -rf ~/deletethis_font_install/


# Install+enable zsh theme
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel9k\/powerlevel9k"\\nPOWERLEVEL9K_MODE="awesome-fontconfig"/' ~/.zshrc

sudo sed -i -e 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

sudo localectl set-locale LANG=en_US.UTF-8

sudo localectl --no-convert set-x11-keymap de

#pacaur -S --noconfirm emacs
