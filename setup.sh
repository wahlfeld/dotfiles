#!/usr/bin/env bash

set -euo pipefail
# set -o xtrace

export WORKDIR="$PWD"
export CACHE="$WORKDIR"/cache
export LOCAL="$HOME"/.local
mkdir -p "$LOCAL"/bin
export BIN="$LOCAL"/bin
export ZSH_PATH="$HOME"/.oh-my-zsh
export PATH="$LOCAL":"$PATH"
export PATH="$LOCAL"/bin:"$PATH"
export PATH="$LOCAL"/homebrew/bin:"$PATH"

[ -d "$HOME/git" ] || mkdir "$HOME"/git
[ -d "$HOME/.ssh" ] || mkdir "$HOME"/.ssh
[ -d "$HOME/Library/Fonts" ] || mkdir "$HOME"/Library/Fonts
[ -d "./cache" ] || mkdir "$WORKDIR"/cache

read -rep "Install Xcode? " y
case $y in
    [Yy]* ) xcode-select --install ;
            exit 0 ;;
    * ) ;;
esac

# brew
test -f "$LOCAL"/homebrew/bin/brew ||
    { mkdir "$LOCAL"/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$LOCAL"/homebrew ; }
brew bundle

# zsh
test -f "$ZSH_PATH"/oh-my-zsh.sh ||
    { cd "$CACHE"/ ;
    curl -O https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh ;
    chmod +x "$CACHE"/install.sh && "$CACHE"/install.sh --unattended && cd - ; }

test -f "$ZSH_PATH"/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ||
    { git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PATH"/custom/plugins/zsh-autosuggestions ; }
test -f "$ZSH_PATH"/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ||
    { git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PATH"/custom/plugins/zsh-syntax-highlighting ; }

# themes
test -f "$ZSH_PATH"/themes/agnoster-edit.zsh-theme || cp "$WORKDIR"/terminal/agnoster-edit.zsh-theme "$ZSH_PATH"/themes/
test -f "$HOME"/Library/Fonts/Meslo\ LG\ M\ Regular\ for\ Powerline.ttf || cp "$WORKDIR"/terminal/Meslo\ LG\ M\ Regular\ for\ Powerline.ttf "$HOME"/Library/Fonts/

# for each dotfile, symlink to home directory
for i in $(find ./dotfiles -maxdepth 1 | cut -c 3- | grep -v -e "^\s*$"); do ln -svf "$PWD"/"$i" "$HOME"; done

# aws cli
rm -rf "$CACHE"/choices.xml
cat >> "$CACHE"/choices.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <array>
    <dict>
      <key>choiceAttribute</key>
      <string>customLocation</string>
      <key>attributeSetting</key>
      <string>$LOCAL</string>
      <key>choiceIdentifier</key>
      <string>default</string>
    </dict>
  </array>
</plist>
EOF
test -f "$BIN"/aws ||
    { curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$CACHE/AWSCLIV2.pkg" ;
    installer -pkg "$CACHE"/AWSCLIV2.pkg -target CurrentUserHomeDirectory -applyChoiceChangesXML "$CACHE"/choices.xml ;
    ln -s "$LOCAL"/aws-cli/aws "$BIN"/aws ;
    ln -s "$LOCAL"/aws-cli/aws_completer "$BIN"/aws_completer ; }

# aws ssm cli plugin
test -f "$BIN"/session-manager-plugin ||
    { curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "$CACHE/sessionmanager-bundle.zip" ;
    unzip -o "$CACHE"/sessionmanager-bundle.zip -d "$CACHE"/ ;
    "$CACHE"/sessionmanager-bundle/install -i "$BIN"/sessionmanagerplugin -b "$BIN"/session-manager-plugin ; }

# aws-azure-login
test -f "$BIN"/aws-azure-login || npm install -g aws-azure-login

# set iterm2 custom preferences
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# git
read -rep "Configure Git? " y
case $y in
    [Yy]* ) read -rep "Enter your first name: " FIRST_NAME ;
            read -rep "Enter your last name: " LAST_NAME ;
            read -rep "Enter your email address: " EMAIL ;
            git config --global user.name "$FIRST_NAME $LAST_NAME" ;
            git config --global user.email "$EMAIL" ;;
    * ) ;;
esac
