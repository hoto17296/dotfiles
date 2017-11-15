#!/bin/sh

brew update
brew upgrade

brew install zsh
brew install zsh-completions
brew install zplug
brew install vim --without-python --without-ruby --without-perl
brew install wget
brew install tree
brew install rmtrash
brew install oysttyer
brew install peco
brew install jq
brew install awscli
brew install heroku

brew tap sanemat/font
brew install ricty --with-powerline
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ${HOME}/Library/Fonts/
fc-cache -vf

brew tap caskroom/cask
brew install brew-cask

brew cask install iterm2
brew cask install vivaldi
brew cask install 1password
brew cask install docker
brew cask install java
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install cmd-eikana
brew cask install postico
brew cask install sequel-pro
brew cask install appcleaner
brew cask install insomnia
