#!/bin/bash -eu

DIR=$(cd $(dirname $0); pwd)
XDG_CONFIG_HOME=${HOME}/.config

enabled() { type $1 > /dev/null 2>&1; }
dotalias() { if ! [ -L ${HOME}/.$1 ]; then ln -s ${DIR}/$1 ${HOME}/.$1; fi }
dotcopy() { if ! [ -L ${HOME}/.$1 ]; then cp ${DIR}/$1 ${HOME}/.$1; fi }
xdgalias() { if ! [ -L ${XDG_CONFIG_HOME}/$1 ]; then ln -s ${DIR}/$1 ${XDG_CONFIG_HOME}/$1; fi }

# Homebrew
if ! enabled brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install --file ${DIR}/Brewfile

dotalias ssh
dotcopy  npmrc
xdgalias git
xdgalias peco

# Visual Studio Code
VSCODE_DIR=${HOME}/Library/Application\ Support/Code/User
\rm -f ${VSCODE_DIR}/keybindings.json
ln -s ${DIR}/vscode/keybindings.json ${VSCODE_DIR}/keybindings.json
\rm -f ${VSCODE_DIR}/settings.json
ln -s ${DIR}/vscode/settings.json ${VSCODE_DIR}/settings.json

# Karabiner-Elements
mkdir -p ${XDG_CONFIG_HOME}/karabiner
\rm -f ${XDG_CONFIG_HOME}/karabiner/karabiner.json
ln -s ${DIR}/karabiner.json ${XDG_CONFIG_HOME}/karabiner/karabiner.json

# Neovim
xdgalias nvim
DEIN_DIR=${HOME}/.cache/dein/repos/github.com/Shougo/dein.vim
if ! [ -d ${DEIN_DIR} ]; then
  git clone https://github.com/Shougo/dein.vim.git ${DEIN_DIR}
fi

# Font
HACKGEN_VERSION=v2.10.0
TMP_FILE=hackgen.zip
wget -O ${TMP_FILE} https://github.com/yuru7/HackGen/releases/download/${HACKGEN_VERSION}/HackGen_${HACKGEN_VERSION}.zip
unzip ${TMP_FILE}
cp HackGen_${HACKGEN_VERSION}/HackGen35-{Regular,Bold}.ttf ${HOME}/Library/Fonts
rm -rf ${TMP_FILE} HackGen_${HACKGEN_VERSION}

# zsh
dotalias zsh
dotalias zshrc

# Screen Captures
SCREEN_CAPTURES_DIR="${HOME}/Pictures/Screen Captures"
mkdir -p "${SCREEN_CAPTURES_DIR}"
defaults write com.apple.screencapture location "${SCREEN_CAPTURES_DIR}"
