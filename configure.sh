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

"${DIR}"/setup/oh-my-zsh.sh

echo "Pre-Requisite setup complete.  The following needs to be installed manually:"
echo "  - Slack"
echo "  - Spotify"
echo "  - Sublime"
echo "  - Terraform"
echo "  - Visual Studio Code"
echo "  - Zoom"
