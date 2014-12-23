#!/bin/sh

brew update
brew upgrade

brew install zsh
brew install vim
brew install wget
brew install tree
brew install ag
brew install rbenv ruby-build
brew install rbenv-default-gems
brew install plenv perl-build
brew install node
brew install mysql
brew install awscli
brew install mecab mecab-ipadic
brew install imagemagick
brew install figlet
brew install rmtrash
brew install ttytter

brew tap peco/peco
brew install peco

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
brew cask install coteditor
brew cask install kobito
brew cask install sequel-pro
brew cask install vlc
brew cask install karabiner
brew cask install appcleaner
