# dotfiles

## macOS の各種設定
→ [macOS/README.md](macOS/README.md)

### SSH 秘密鍵を設定
(略)

### リポジトリを clone
``` console
$ mkdir -p ~/Work/github.com/hoto17296
$ git -c core.sshCommand="ssh -i ~/.ssh/id_XXX" clone git@github.com:hoto17296/dotfiles.git ~/Work/github.com/hoto17296/dotfiles
```

### スクリプトを実行
``` console
$ bash -eu ~/Work/github.com/hoto17296/dotfiles/setup.sh
```