# 履歴のインクリメンタルサーチ

function peco-history() {
  local tac
  executable tac \
    && tac="tac" \
    || tac="tail -r"
  BUFFER=$(history -n 1 | eval $tac | peco --query "$LBUFFER" --prompt "HISTORY>")
  CURSOR=$#BUFFER
}

zle -N peco-history
bindkey '^r' peco-history


# ファイル選択

function peco-path() {
  local filepath="$(find . | grep -v '/\.' | grep -v '__pycache__' | peco --prompt 'PATH>')"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="$LBUFFER$filepath"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath"
    fi
  fi
  CURSOR=$#BUFFER
}

zle -N peco-path
bindkey '^f' peco-path


# ブランチ選択

function peco-branch() {
  local branch="$(git recent-branch 2> /dev/null | peco --prompt 'GIT BRANCH>')"
  [ -z "$branch" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="$LBUFFER$branch"
  else
    BUFFER="git checkout $branch"
  fi
  CURSOR=$#BUFFER
}

zle -N peco-branch
bindkey '^b' peco-branch


# git grep した結果を絞り込んでエディタで開く

function peco-git-grep() {
  inside-git-work-tree || return
  [ -z "$LBUFFER" ] && return
  local peco="$(\git grep -n "$LBUFFER" | peco --prompt 'GIT GREP>' 2> /dev/null)"
  [ -z "$peco" ] && return
  local file="$(echo $peco | cut -d':' -f1)"
  local line="$(echo $peco | cut -d':' -f2)"
  BUFFER="$EDITOR $file +$line"
  CURSOR=$#BUFFER
}

zle -N peco-git-grep
bindkey '^g' peco-git-grep


# sshconfig からホスト一覧を取得して peco で表示

function peco-ssh() {
  local dir="$HOME/.ssh"
  [ -d $dir ] || return
  local host=$(cat $dir/config $dir/conf.d/* | grep "^\s*Host " | sed s/"[\s ]*Host "// | grep -v "^\*$" | sort | peco --prompt "SSH>")
  [ -z "$host" ] && return
  BUFFER="ssh $host"
  CURSOR=$#BUFFER
}

zle -N peco-ssh
bindkey '^s' peco-ssh


# ディレクトリを遡る

function peco-parent() {
  local dir=$(get-parents | peco --prompt "DIR>" | awk '{print $2}')
  [ -z "$dir" ] && return
  BUFFER="cd $dir"
  CURSOR=$#BUFFER
}

function get-parents() {
  local current=`pwd`
  local count=0
  while true
  do
    echo "${count}: ${current}"
    current=${current%/*}
    [ -z "$current" ] && return
    count=$(($count + 1))
  done
}

zle -N peco-parent
bindkey '^x^f' peco-parent


# 移動履歴から選択して移動

function peco-cdr {
  local dir=$(dirs -v | peco --prompt "DIR>" | awk '{print $2}')
  [ -z "$dir" ] && return
  BUFFER="cd $dir"
  CURSOR=$#BUFFER
}

zle -N peco-cdr
bindkey '^x^d' peco-cdr


# リポジトリ移動

function peco-ghq() {
  local repo=$(find $(ghq root) -maxdepth 5 -type d -name .git | sed -E "s|^$(ghq root)/?||g" | sed -E 's|/\.git$||g' | peco --prompt 'REPOSITORY>')
  [ -z "${repo}" ] && return
  BUFFER='cd $(ghq root)/'${repo}
  CURSOR=$#BUFFER
}

zle -N peco-ghq
bindkey '^g^h' peco-ghq


# Docker Image ID を選択
function peco-docker-images() {
  local images="$(docker images | tail +2 | sort | peco --prompt 'DOCKER IMAGES>' | awk '{print $3}' ORS=' ')"
  [ -z "$images" ] && return
  BUFFER="$LBUFFER$images$RBUFFER"
  CURSOR=$#BUFFER
}

zle -N peco-docker-images
bindkey '^x^i' peco-docker-images


# Docker Container ID を選択
function peco-docker-containers() {
  local containers="$(docker ps -a | tail +2 | sort | peco --prompt 'DOCKER CONTAINERS>' | awk '{print $1}' ORS=' ')"
  [ -z "$containers" ] && return
  BUFFER="$LBUFFER$containers$RBUFFER"
  CURSOR=$#BUFFER
}

zle -N peco-docker-containers
bindkey '^x^k' peco-docker-containers


# Azure Subscription を切り替え
function peco-azure-switch() {
  local subscription="$(az account list | jq -r '.[] | .id + " " + .name' | peco | awk '{print $1}' ORS=' ')"
  [ -z "${subscription}" ] && return
  BUFFER="az account set --subscription ${subscription}"
  CURSOR=$#BUFFER
}

zle -N peco-azure-switch
bindkey '^a^z' peco-azure-switch
