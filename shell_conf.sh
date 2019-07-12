#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

#preqs
apt install -y tmux 2>/dev/null
apt install -y git 2>/dev/null
apt install -y curl 2>/dev/null
apt install -y zsh 2>/dev/null
apt install -y dconf-cli uuid-runtime 2>/dev/null

git clone https://github.com/gpakosz/.tmux /root/.tmux
ln -s -f /root/.tmux/.tmux.conf
cp /root/.tmux/.tmux.conf.local /root/

tmuxconfig="#{prefix}#{pairing}#{synchronized} #(echo 'IP:') #(ifconfig eth0 | sed -n 2p | awk '{print $2}') , %R , %d %b | #{username}#{root} | #{hostname} "

echo "tmux_conf_theme_status_right=\"$tmuxconfig\"" >> /root/.tmux/.tmux.conf.local

git clone https://github.com/powerline/fonts /root/fonts
/root/fonts/install.sh

curl -L http://install.ohmyz.sh | sh
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="jtriley"/' /root/.zshrc
sed -i 's/white/red/1' /root/.oh-my-zsh/themes/jtriley.zsh-theme
sed -i 's/white/blue/1' /root/.oh-my-zsh/themes/jtriley.zsh-theme
sed -i 's/magenta/white/1' /root/.oh-my-zsh/themes/jtriley.zsh-theme

chsh -s /bin/zsh
echo "bash -c zsh" > /root/.bashrc

yes 34 | bash -c  "$(wget -qO- https://git.io/vQgMr)"

source /root/.zshrc
source /root/.bashrc
