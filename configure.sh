#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"

sudo apt install -y ansible

ansible-playbook "${DIR}"/setup/configure.yml

go get github.com/derekparker/delve/cmd/dlv
go get github.com/golang/dep/cmd/dep

if [ ! -d ~/.oh-my-zsh ]; then
    "${DIR}"/setup/oh-my-zsh.sh
fi

if ! dpkg -l | grep ^ii | grep google-chrome 2>&1 > /dev/null; then
    echo "Google Chrome needs to be installed manually (https://www.google.com/chrome/)"
fi

if ! snap list | grep intellij-idea 2>&1 > /dev/null; then
    snap install intellij-idea-ultimate --classic
fi

if ! dpkg -l | grep ^ii | grep keybase 2>&1 > /dev/null; then
    curl -o /tmp/keybase_amd64.deb https://prerelease.keybase.io/keybase_amd64.deb
    sudo dpkg -i /tmp/keybase_amd64.deb
    sudo apt-get install -f
    run_keybase
fi

if ! dpkg -l | grep ^ii | grep sbt 2>&1 > /dev/null; then
        # SBT
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
    sudo apt-get update && sudo apt-get install sbt
fi

if ! snap list | grep spotify 2>&1 > /dev/null; then
    sudo snap install spotify
fi

if ! snap list | grep sublime-text 2>&1 > /dev/null; then
    sudo snap install sublime-text --classic
fi

if ! which terraform 2>&1 > /dev/null; then
    echo "Terraform needs to be installed manually (https://www.terraform.io/downloads.html)"
fi

if ! snap list | grep vscode 2>&1 > /dev/null; then
    sudo snap install vscode --classic
fi

if ! dpkg -l | grep ^ii | grep zoom 2>&1 > /dev/null; then
	echo "Zoom needs to be installed manually (https://zoom.us/download#client_4meeting)"
fi

if [ ! -d ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org ]; then
    curl -L https://github.com/negesti/gnome-shell-extensions-negesti/archive/v23.zip -o /tmp/put-windows.zip
    mkdir ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org
    unzip /tmp/put-windows.zip -d ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org
    gnome-shell-extension-tool -e putWindow@clemens.lab21.org
fi

echo "Setup complete:"
echo "  To enable OSX style theme, run the following:"
echo "    gsettings set org.gnome.desktop.interface gtk-theme 'Gnome-OSC-Space-Grey-(transparent)'"
echo "    gsettings set org.gnome.desktop.interface icon-theme 'la-capitaine-icon-theme'"
echo "    gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'"
echo "    gsettings set org.gnome.desktop.wm.preferences theme 'Gnome-OSC-Space-Grey-(transparent)'"
echo ""
echo "  To enable multi-touch support, add \`fusuma\` to startup applications"
echo ""
