# macOS の各種設定
macOS 27 (Golden Gate) 時点での各種設定手順

## macOS の初期設定でやること
- ネットワークに接続
- ユーザアカウントの作成
- Apple アカウントでサインイン
- Touch ID の登録

etc...

## Command Line Tools をインストール
```console
$ sudo xcode-select --install
```

## システム環境設定

### 自動設定できるもの
```console
$ python3 build.py < defaults.jsonc > defaults.sh
$ bash -eu defaults.sh
```

### 自動設定できないもの
- `バッテリー` > `充電` > `充電上限` → 80% に設定
- `ディスプレイ` > `True Tone` → 無効
- `ロック画面` > `バッテリー駆動時に使用していない場合はディスプレイをオフにする` → 5分後 に設定
- `ロック画面` > `スクリーンセーバの開始後またはディスプレイがオフになった後にパスワードを要求` → すぐに に設定