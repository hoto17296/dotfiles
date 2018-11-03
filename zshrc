#!/bin/zsh

autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit


# OS固有設定 (前)

PRELOAD_SCRIPT=$HOME/.zsh/$(uname | awk '{print tolower($0)}').preload.sh
[ -f $PRELOAD_SCRIPT ] && source $PRELOAD_SCRIPT


# もろもろ

export GOPATH=${HOME}/.go
export PATH=${GOPATH}/bin:$PATH

bindkey -d # キーバインドリセット
bindkey -e # emacsモード

alias pag='ps aux | grep'
alias v=$EDITOR
alias vi=$EDITOR
alias vim=$EDITOR


_parallel () {
  if [ $# -lt 2 ]; then
    echo -e "Usage:\n  parallel <N> <command>"
    return 1
  fi
  seq $1 | xargs -I{} -P $@
}

setopt correct         # typo補完
setopt nobeep          # beep音鳴らさない
setopt no_flow_control # Ctrl+S / Ctrl+Q によるフロー制御を使わない

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # 色付き補完


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

source $ZPLUG_HOME/init.zsh

export AUTOENV_FILE_ENTER='.autoenv.zsh'
export AUTOENV_FILE_LEAVE='.autoenv.zsh'
export AUTOENV_HANDLE_LEAVE=1

zplug "Tarrasch/zsh-autoenv"
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"

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

setopt auto_cd           # ディレクトリ名だけで移動
setopt auto_pushd        # pushdで移動
setopt pushd_ignore_dups # pushdの履歴は残さない


# 履歴
# ※ zsh の history は fc -l のエイリアス

[ -z $HISTFILE ] && HISTFILE=$HOME/.zsh_history

HISTSIZE=10000 # メモリへの保存件数
SAVEHIST=10000 # ファイルへの保存件数

setopt extended_history       # タイムスタンプと実行時間を記録
setopt hist_expire_dups_first # 削除時に重複する履歴から削除
setopt hist_ignore_all_dups   # 重複するコマンドは履歴に記録しない
setopt hist_ignore_space      # スペースから始まるコマンドは無視
setopt hist_verify            # 補完時に編集可能にする
setopt hist_reduce_blanks     # 重複スペースは除去して履歴に記録する
setopt inc_append_history     # インクリメンタルサーチに追加
setopt share_history          # 端末間で履歴を共有


# Git

alias g='git'
compdef g=git

function inside-git-work-tree {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function change-dir-to-git-root {
  if inside-git-work-tree
  then cd ./$(git rev-parse --show-cdup)
  else false
  fi
}
alias cdgr=change-dir-to-git-root

alias gpl='git pull origin $(git current-branch)'
alias gps='git push origin $(git current-branch)'


# peco

executable peco && source $HOME/.zsh/peco.sh


# OS固有設定 (後)

POSTLOAD_SCRIPT=$HOME/.zsh/$(uname | awk '{print tolower($0)}').postload.sh
[ -f $POSTLOAD_SCRIPT ] && source $POSTLOAD_SCRIPT


# マシン固有設定

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local


true