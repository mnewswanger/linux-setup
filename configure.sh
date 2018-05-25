#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"

sudo apt install -y ansible

ansible-playbook "${DIR}"/setup/configure.yml

# curl -O https://prerelease.keybase.io/keybase_amd64.deb
# # if you see an error about missing `libappindicator1`
# # from the next command, you can ignore it, as the
# # subsequent command corrects it
# sudo dpkg -i keybase_amd64.deb
# sudo apt-get install -f
# run_keybase

if [ ! -d ~/.oh-my-zsh ]; then
    "${DIR}"/setup/oh-my-zsh.sh
fi

echo "Pre-Requisite setup complete.  The following applications to be installed manually:"
if ! dpkg -l | grep ^ii | grep google-chrome 2>&1 > /dev/null; then
    echo "  - Chrome (Manual)"
fi
if ! snap list | grep slack 2>&1 > /dev/null; then
    echo "  - Slack (Snap)"
fi
if ! snap list | grep spotify 2>&1 > /dev/null; then
    echo "  - Spotify (Snap)"
fi
if ! snap list | grep sublime-text 2>&1 > /dev/null; then
    echo "  - Sublime Text (Snap)"
fi
if ! which terraform 2>&1 > /dev/null; then
    echo "  - Terraform (Manual)"
fi
if ! snap list | grep vscode 2>&1 > /dev/null; then
    echo "  - Visual Studio Code (Snap)"
fi
if ! snap list | grep slack 2>&1 > /dev/null; then
    echo "  - Zoom (Manual)"
fi
