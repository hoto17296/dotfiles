#!/bin/sh

brew update
brew upgrade

brew install zplug
brew install neovim
brew install wget
brew install tree
brew install rmtrash
brew install oysttyer
brew install peco
brew install jq
brew install awscli
brew install ghq

brew tap sanemat/font
brew install ricty
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ${HOME}/Library/Fonts/
fc-cache -vf

brew tap caskroom/cask

brew cask install iterm2
brew cask install vivaldi
brew cask install docker
brew cask install java
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install cmd-eikana
brew cask install postico
brew cask install sequel-pro
brew cask install appcleaner
brew cask install insomnia

brew install mas

mas install 409183694   # Keynote
mas install 443987910   # 1Password
mas install 803453959   # Slack
mas install 485812721   # TweetDeck
mas install 407963104   # Pixelmator
mas install 1091189122  # Bear
mas install 1024640650  # CotEditor
mas install 568494494   # Pocket
mas install 411680127   # WiFi Scanner
