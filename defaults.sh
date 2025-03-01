#!/bin/bash -eu

# ※ 以下の設定値は macOS 15.3.1 (Sequoia) で作成
# ※ TODO: 動作確認できていない

# Spotlight > 検索結果
defaults write com.apple.spotlight orderedItems -array \
  '{ "enabled" = 0; "name" = "PDF"; }' \
  '{ "enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS"; }' \
  '{ "enabled" = 0; "name" = "BOOKMARKS"; }' \
  '{ "enabled" = 1; "name" = "APPLICATIONS"; }' \
  '{ "enabled" = 0; "name" = "EVENT_TODO"; }' \
  '{ "enabled" = 1; "name" = "SYSTEM_PREFS"; }' \
  '{ "enabled" = 0; "name" = "SPREADSHEETS"; }' \
  '{ "enabled" = 0; "name" = "MENU_OTHER"; }' \
  '{ "enabled" = 0; "name" = "TIPS"; }' \
  '{ "enabled" = 0; "name" = "DIRECTORIES"; }' \
  '{ "enabled" = 0; "name" = "FONTS"; }' \
  '{ "enabled" = 0; "name" = "PRESENTATIONS"; }' \
  '{ "enabled" = 0; "name" = "MUSIC"; }' \
  '{ "enabled" = 0; "name" = "MOVIES"; }' \
  '{ "enabled" = 0; "name" = "MESSAGES"; }' \
  '{ "enabled" = 0; "name" = "IMAGES"; }' \
  '{ "enabled" = 1; "name" = "MENU_EXPRESSION"; }' \
  '{ "enabled" = 0; "name" = "DOCUMENTS"; }' \
  '{ "enabled" = 0; "name" = "MENU_DEFINITION"; }' \
  '{ "enabled" = 0; "name" = "MENU_CONVERSION"; }' \
  '{ "enabled" = 0; "name" = "CONTACT"; }'

# アクセシビリティ > ズーム機能 > スクロールジェスチャと修飾キーを使って拡大縮小
# TODO: 有効にして「^ Control」を割り当てたい

# アクセシビリティ > ポインタコントロール > トラックパッドオプション > 3本指のドラッグ
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# コントロールセンター > コントロールセンターモジュール > サウンド > メニューバーに常に表示
# TODO: これでは動かなかったので違うっぽい
# defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

# コントロールセンター > バッテリー > 割合 (%) を表示
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# コントロールセンター > メニューバーのみ > 時計 > 時計のオプション > 時刻 > 秒を表示
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# ディスプレイ > True Tone
# TODO: オフにしたい

# デスクトップと Dock > Dock > サイズ (最小 16, 最大 128)
defaults write com.apple.dock tilesize -int 16

# デスクトップと Dock > Dock > 画面上の位置
defaults write com.apple.dock orientation -string "left"

# デスクトップと Dock > Dock > Dock を自動的に表示/非表示
defaults write com.apple.dock autohide -bool true

# デスクトップと Dock > デスクトップとステージマネージャ > 壁紙をクリックしてデスクトップを表示
# TODO: オフにしたい

# デスクトップと Dock > Mission Control > 操作スペースを自動的に並べ替える
defaults write com.apple.dock mru-spaces -bool false

# ロック画面 > バッテリー駆動時に使用していない場合はディスプレイをオフにする
# TODO: 設定を変更したいが、defaults コマンドからは触れなくなったらしい

# キーボード > キーのリピート速度 (最速 2, ※小さいほど速い)
defaults write -g KeyRepeat -int 2

# キーボード > キーボードショートカット > 次のウィンドウを操作対象にする
# ※「macOS が日本語設定」かつ「キーボードが US 配列」の場合に、macOS 側の ⌘ + @ ショートカットを無効化しないと
#   一部のアプリ (Vivaldi や VSCode など) で ⌘ + [ ショートカットが効かなくなる問題があるため
#   参考: https://aotamasaki.hatenablog.com/entry/command_with_open_bracket_is_unavailable
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><false/></dict>"

# トラックパッド > 軌道の速さ (最大 3.0)
defaults write -g com.apple.trackpad.scaling -float 2.0

# トラックパッド > タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
