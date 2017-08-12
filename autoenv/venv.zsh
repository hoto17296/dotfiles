# Automatically activate Python virtualenvs
# Usage:
#   cp ~/.dotfiles/autoenv/venv.zsh ./.autoenv.zsh

if [[ $autoenv_event == 'enter' ]]; then
  script_dir=$(chpwd_functions= cd $(dirname $0); pwd)
  source ${script_dir}/.venv/bin/activate
else
  deactivate
fi
