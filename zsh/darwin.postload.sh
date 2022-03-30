setopt ignoreeof # Ctrl+D でログアウトしない

export PATH="$(ghq root)/github.com/hoto17296/bin:$(python3 -m site --user-base)/bin:$PATH"
export LANG=ja_JP.UTF-8

export LSCOLORS=gxfxcxdxbxegedabagacag
alias l='ls -GFlah'

alias python=/usr/bin/python3
alias python3=/usr/bin/python3
alias pip=/usr/bin/pip3
alias pip3=/usr/bin/pip3

alias jupyter-app="(cd $(ghq root)/github.com/hoto17296/jupyter-app && npm start)"
alias jupyter-app-bash='docker exec -it --user jovyan jupyter-app bash'

alias brew-update='brew update && brew upgrade --skip-cask-deps && brew cleanup'

alias psql="docker run --rm -it --net=host postgres:11 psql"
alias pg_dump='docker run --rm -it -v $(pwd):/tmp -w /tmp postgres:11 pg_dump'
alias pg_restore='docker run --rm -it -v $(pwd):/tmp -w /tmp postgres:11 pg_restore'

# ImageMagick を Docker で動かす
# https://qiita.com/hoto17296/items/2a89ac94ca9128b70a51
alias imagemagick='docker run --rm -v "$(pwd)":/mnt -w /mnt imagemagick'

# Jupyter Notebook 起動時にブラウザが開かない問題の対応
# http://qiita.com/katsuyan/items/95bb7dbcd1671cc4e201
export BROWSER=open


# ディレクトリ移動時に ls の結果を表示する
# http://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059

function ls-chpwd {
  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS ls -CGF)
  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')
  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo ' :'
    echo "$ls_result" | tail -n 5
    echo "$(ls -1 | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}
add-zsh-hook chpwd ls-chpwd


# コマンドを実行するたびに英数モードに切り替える

function force-alphanumeric {
  case "${OSTYPE}" in
  darwin*)
    # 「英数」キーを押す
    # 若干重いので サブシェル + バックグラウンド で実行する
    (osascript -e 'tell application "System Events" to key code {102}' &)
  esac
}
add-zsh-hook precmd force-alphanumeric


# rm でゴミ箱に移動

executable rmtrash && alias rm='rmtrash'


# ディレクトリ移動時のフックを明示的に呼ぶための関数

function exec-chpwd {
  for chpwd_func in $chpwd_functions; do $chpwd_func; done
}

exec-chpwd # 初回実行
