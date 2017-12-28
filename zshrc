autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit

export EDITOR=vim
export LANG=ja_JP.UTF-8
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
export GOPATH=${HOME}/.go
export PATH=${GOPATH}/bin:$PATH

bindkey -d # キーバインドリセット
bindkey -e # emacsモード

alias be='bundle exec'
alias pag='ps aux | grep'
alias rake='noglob rake'
alias vg='vagrant'

parallel () {
  if [ $# -lt 2 ]; then
    echo -e "Usage:\n  parallel <N> <command>"
    return 1
  fi
  seq $1 | xargs -I{} -P $@
}

setopt correct         # typo補完
setopt nobeep          # beep音鳴らさない
setopt no_flow_control # Ctrl+S / Ctrl+Q によるフロー制御を使わない
setopt ignoreeof       # Ctrl+D でログアウトしない

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # 色付き補完


# パスを読み込み

[ -f ~/.zshrc_path.local ] && source ~/.zshrc_path.local


# 関数やコマンドが存在するかどうか

function executable {
  whence $@ &> /dev/null
}


# Python venv 設定

export VIRTUAL_ENV_DISABLE_PROMPT=1

function venv-activated {
  executable deactivate
}


# プラグイン設定

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

export AUTOENV_FILE_ENTER='.autoenv.zsh'
export AUTOENV_FILE_LEAVE='.autoenv.zsh'
export AUTOENV_HANDLE_LEAVE=1

zplug "Tarrasch/zsh-autoenv"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load


# 移動

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias pd='popd'
alias cdgr='cd $(git rev-parse --show-toplevel)' # リポジトリのルートに移動

setopt auto_cd           # ディレクトリ名だけで移動
setopt auto_pushd        # pushdで移動
setopt pushd_ignore_dups # pushdの履歴は残さない


# 履歴
# zsh の history は fc -l のエイリアス

[ -z $HISTFILE ] && HISTFILE=$HOME/.zsh_history

HISTSIZE=10000 # メモリへの保存件数
SAVEHIST=10000 # ファイルへの保存件数

setopt extended_history       # タイムスタンプと実行時間を記録
setopt hist_expire_dups_first # 削除時に重複する履歴から削除
setopt hist_ignore_dups       # 直前の重複するコマンドは無視
setopt hist_ignore_space      # スペースから始まるコマンドは無視
setopt hist_verify            # 補完時に編集可能にする
setopt inc_append_history     # インクリメンタルサーチに追加
setopt share_history          # 端末間で履歴を共有


# Git

alias g='git'
compdef g=git

function inside-git-work-tree {
  git rev-parse --is-inside-work-tree &> /dev/null
}

alias gpl='git pull origin $(git current-branch)'
alias gps='git push origin $(git current-branch)'


# プロンプト

function prompt-face {
  local venv
  venv-activated && venv='v' || venv=''
  echo "%(?:%F{green}${venv}(^_^)${venv}:%F{red}${venv}(>_<%)${venv}%s)%f"
}

function prompt-git-status {
  local branch st color
  inside-git-work-tree || return

  branch=$(basename `git current-branch`)

  st=`git status 2> /dev/null`
  if [[ $st =~ 'nothing to commit' ]]; then
    color=%f
  elif [[ $st =~ 'untracked files present' ]]; then
    color=%F{yellow}
  else
    color=%F{red}
  fi

  echo "$color($branch)%f%b"
}

PROMPT='$(prompt-face)%M:%c$(prompt-git-status)$ '
SPROMPT='%F{yellow}(?_?)%fもしかして: %B%r%b [y/N/a/e]? '
RPROMPT='`date +"%Y/%m/%d(%a) %k:%M:%S"`'

setopt prompt_subst      # プロンプト文字列を評価する
setopt transient_rprompt # 古い右プロンプトを消す


# peco

executable peco && source $HOME/.zshrc.peco


# Jupyter Notebook

executable jupyter && alias start-jupyter="jupyter notebook --notebook-dir=${HOME}/Dropbox/jupyter --NotebookApp.token="


# OS固有設定

case "${OSTYPE}" in
darwin*)
  source $HOME/.zshrc.osx
  ;;
linux*)
  alias v='vim'
  alias l='ls -Flah --color'
  ;;
esac


# マシン固有設定

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local


true
