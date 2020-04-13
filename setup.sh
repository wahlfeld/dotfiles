#!/usr/bin/env bash

set -euo pipefail
export BIN="/usr/local/bin"
export ZSH_PATH="~/.oh-my-zsh"

[ ! -d "$HOME/projects" ] || mkdir -p $HOME/projects
[ ! -d "./cache" ] || mkdir -p ./cache

# xcode, git, etc
xcode-select --install

# brew
test -f $BIN/brew || yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
test -f $BIN/k9s || brew tap derailed/k9s
test -f $BIN/tfswitch || brew tap warrensbox/tap
brew bundle

# # ohmyzsh
test -f $ZSH_PATH/oh-my-zsh.sh || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh --unattended)"

test -f $ZSH_PATH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ||
    { git clone git://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$ZSH_PATH/custom}/plugins/zsh-autosuggestions ; }
test -f $ZSH_PATH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ||
    { git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$ZSH_PATH/custom}/plugins/zsh-syntax-highlighting ; }

test -f $ZSH_PATH/themes/agnoster-edit.zsh-theme || cp ./ohmyzsh/agnoster-edit.zsh-theme $ZSH_PATH/themes/

# for each dotfile, symlink to home directory
for i in `find ./dotfiles -maxdepth 1 | cut -c 3- | grep -v -e "^\s*$"`; do ln -svf $PWD/$i ~; done

# aws cli 2
test -f $BIN/aws || 
    { curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "cache/AWSCLIV2.pkg" ; 
    sudo installer -pkg ./cache/AWSCLIV2.pkg -target / ; }

# aws ssm cli plugin
test -f $BIN/session-manager-plugin || 
    { curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "cache/sessionmanager-bundle.zip" ;
    unzip -o ./cache/sessionmanager-bundle.zip -d ./cache/ ;
    sudo ./cache/sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b $BIN/session-manager-plugin ; }

# aws-azure-login
test -f $BIN/aws-azure-login || npm install -g aws-azure-login

# powerline fonts for iterm2
test -f ~/projects/fonts/install.sh || 
    { git clone git://github.com/powerline/fonts.git ~/projects ;
    ~/projects/fonts/install.sh ; }