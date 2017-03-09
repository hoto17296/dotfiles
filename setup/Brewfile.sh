#!/bin/sh

brew update
brew upgrade

brew install zsh
brew install zsh-completions
brew install vim
brew install git
brew install tig
brew install wget
brew install tree
brew install ag
brew install go
brew install mysql
brew install awscli
brew install mecab mecab-ipadic
brew install imagemagick
brew install figlet
brew install rmtrash
brew install ttytter
brew install peco
brew install direnv

brew tap caskroom/cask
brew tap caskroom/versions
brew install brew-cask

brew cask install iterm2
brew cask install java
brew cask install firefox-ja
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install virtualbox
brew cask install vagrant
brew cask install boot2docker
brew cask install sequel-pro
brew cask install vlc
brew cask install karabiner
brew cask install appcleaner
