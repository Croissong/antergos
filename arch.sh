git clone https://github.com/Croissong/.dotfiles.git ~/.dotfiles
source ~/.dotfiles/alias

sudo -v
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
update
yaourt -Sy --noconfirm pacaur

install ttf-dejavu ttf-liberation noto-fonts ttf-fantasque-sans ttf-material-design-icons
sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

nvidia-xconfig --cool-bits=4
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=30"

sudo sed -i -e 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
sudo localectl --no-convert set-x11-keymap de
timedatectl set-ntp true
timedatectl set-timezone 'Europe/Berlin'

# touch /etc/modprobe.d/nobeep.conf  (works with sudo su)
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

uninstall nano
install emacs
install elixir
install gscreenshot
install discord
install google-chrome-dev
ln -s /usr/bin/google-chrome-unstable /usr/bin/google-chrome
install nginx-mainline
install mpv
install htop
install pass
install sshfs
install borg
install go go-tools
install pavucontrol
install sqlite
install dunst-git
install i3lock
install rofi
install antigen-git
install ripgrep

install python python2
install pip python2-pip

install rxvt-unicode
install zsh
chsh -s /bin/zsh

install redshift python-gobject python-xdg librsvg

install xorg-xinit xorg-server
install i3 perl-anyevent-i3

install chrome-remote-desktop
crd --setup

install jdk
install maven
install intellij-idea-community-edition
#if work install eclipse-java

install nodejs
install npm
install yarn

mkdir $GOPATH
install go
go get -u github.com/nsf/gocode

install slack-desktop

go get -u github.com/odeke-em/drive/cmd/drive
drive init ~/gdrive
