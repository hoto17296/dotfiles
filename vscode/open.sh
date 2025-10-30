#!/bin/bash -eu

################################################################
# Shell script to select a repository and open it in VSCode (for macOS)
#
# Setup:
#   - Install the commands: ghq, peco, and devcontainer
#   - Create a shortcut that runs the following AppleScript:
#
# tell application "Terminal"
#   activate
#   do script "$(ghq root)/github.com/hoto17296/dotfiles/vscode/open.sh; exit"
# end tell
#
# Usage:
#   Run the created shortcut from Spotlight
################################################################

export DOCKER_HOST="unix://${HOME}/.rd/docker.sock"

has_devcontainer_settings() {
  [[ -n "$1" && -d "$1" ]] || return 1
  ls -d "$1"/.devcontainer* >/dev/null 2>&1
}

repos=$(ghq list | peco)
[[ -z "${repos}" ]] && exit

repos=$(ghq root)/${repos}

if has_devcontainer_settings "${repos}" >/dev/null; then
  devcontainer open ${repos}
else
  code ${repos}
fi