git clone git@github.com:Croissong/.dotfiles.git ~/.dotfiles
source ~/.alias

sudo -v
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
update
yaourt -Sy --noconfirm pacaur

nvidia-xconfig --cool-bits=4
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=30"

install emacs
install elixir
install discord
install google-chrome-dev
install nginx-mainline
install mpv
install htop

install xorg-xinit xorg-server xorg-utils xorg-server-utils
install i3 perl-anyevent-i3

install chrome-remote-desktop
crd --setup

install jdk
install maven
install intellij-idea-community-edition

install nodejs
install npm
install yarn
