#!/bin/bash -eu

# Firefox.app の設定を適用するためのスクリプト
# 一度 Firefox.app を起動したあとに実行する必要がある

cd "$(dirname "$0")"

APP_PATH=/Applications/Firefox.app
DATA_DIR="${HOME}/Library/Application Support/Firefox"

# policies.json をコピーする (署名の検証に影響するかもしれないのでシンボリックリンクにはしない)
sudo mkdir -p "${APP_PATH}/Contents/Resources/distribution"
sudo cp policies.json "${APP_PATH}/Contents/Resources/distribution/"

# profiles.ini から既定のプロファイルのパスを取得する
profile() { awk -F= '/^\[/{f=/^\[Install/} f&&$1=="Default"{print $2;exit}' "${DATA_DIR}/profiles.ini" 2>/dev/null || true; }

# user.js のシンボリックリンクを作成する
ln -sf "$PWD/user.js" "${DATA_DIR}/$(profile)/user.js"