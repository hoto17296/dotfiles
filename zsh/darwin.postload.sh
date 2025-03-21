setopt ignoreeof # Ctrl+D でログアウトしない

alias python=/usr/bin/python3
alias python3=/usr/bin/python3
alias pip=/usr/bin/pip3
alias pip3=/usr/bin/pip3

export PATH="$(python3 -m site --user-base)/bin:${HOME}/.rd/bin:$PATH"
export LANG=ja_JP.UTF-8

export LSCOLORS=gxfxcxdxbxegedabagacag
alias l='ls -GFlah'
alias ll='ls -GFlah'

alias brew-update='brew update && brew upgrade --skip-cask-deps && brew cleanup'


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


# ディレクトリ移動時のフックを明示的に呼ぶための関数

function exec-chpwd {
  for chpwd_func in $chpwd_functions; do $chpwd_func; done
}

exec-chpwd # 初回実行
