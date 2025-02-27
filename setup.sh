#!/bin/bash -eu

DIR=$(cd $(dirname $0); pwd)

XDG_CONFIG_HOME=${HOME}/.config
mkdir -p ${XDG_CONFIG_HOME}

symlink() {
  echo -n "Create symlink { ${2/${HOME}/~} -> ${1/${HOME}/~} } ... "
  if [ -L $2 ]; then
    echo "skip"
    return
  fi
  ln -s $1 $2
  echo "ok"
}

# Homebrew
if ! (type brew > /dev/null 2>&1); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install --file ${DIR}/Brewfile

if ! [ -f ${HOME}/.npmrc ]; then cp ${DIR}/npmrc ${HOME}/.npmrc; fi
symlink ${DIR}/git ${XDG_CONFIG_HOME}/git
symlink ${DIR}/peco ${XDG_CONFIG_HOME}/peco

# SSH
mkdir -p ${HOME}/.ssh/conf.d
symlink ${DIR}/ssh_config ${HOME}/.ssh/config

# Visual Studio Code
VSCODE_DIR=${HOME}/Library/Application\ Support/Code/User
rm -f ${VSCODE_DIR}/keybindings.json
symlink ${DIR}/vscode/keybindings.json ${VSCODE_DIR}/keybindings.json
rm -f ${VSCODE_DIR}/settings.json
symlink ${DIR}/vscode/settings.json ${VSCODE_DIR}/settings.json

# Karabiner-Elements
mkdir -p ${XDG_CONFIG_HOME}/karabiner
rm -f ${XDG_CONFIG_HOME}/karabiner/karabiner.json
symlink ${DIR}/karabiner.json ${XDG_CONFIG_HOME}/karabiner/karabiner.json

# Neovim
symlink ${DIR}/nvim ${XDG_CONFIG_HOME}/nvim
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
symlink ${DIR}/zsh ${HOME}/.zsh
symlink ${DIR}/zshrc ${HOME}/.zshrc

# Screen Captures
SCREEN_CAPTURES_DIR="${HOME}/Pictures/Screen Captures"
mkdir -p "${SCREEN_CAPTURES_DIR}"
defaults write com.apple.screencapture location "${SCREEN_CAPTURES_DIR}"
