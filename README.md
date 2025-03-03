# dotfiles

## Setup macOS

### インターネットに接続

### Apple アカウントでサインイン

### システム環境設定
``` console
$ curl -fsSL https://raw.github.com/hoto17296/dotfiles/master/defaults.sh | bash -eu
```

### SSH 秘密鍵を設定

### Command Line Developer Tools をインストール
``` console
$ xcode-select --install
```

### リポジトリを clone
``` console
$ mkdir -p ~/Work/github.com/hoto17296
$ git -c core.sshCommand="ssh -i ~/.ssh/id_XXX" clone git@github.com:hoto17296/dotfiles.git ~/Work/github.com/hoto17296/dotfiles
```

### スクリプトを実行
``` console
$ bash -eu ~/Work/github.com/hoto17296/dotfiles/setup.sh
```