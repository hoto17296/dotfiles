" dein
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('Shougo/dein.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('connorholyday/vim-snazzy')
  call dein#add('Townk/vim-autoclose')
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('othree/eregex.vim')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" カラーリングする
colorscheme snazzy

" タイトルを表示
set title

" カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

" □や○などの文字があってもカーソル位置がずれないようにする
set ambiwidth=double

" 行番号表示
set number

" インデント設定
set autoindent
set expandtab
set tabstop=2     " TABの見た目幅
set shiftwidth=2  " autoindent時のスペース量
set softtabstop=0 " TAB展開時のスペース量(0:tsと同量)

" クリップボードを共有
set clipboard=unnamed

" タブと行末スペースを可視化する
set list
set listchars=tab:\:\ ,trail:~

" セミコロンでもコマンドが使えるようにする
noremap ; :

" jjでインサートモードを抜ける
inoremap jj <ESC>

" カレント行をハイライト
set cursorline

" lightline
let g:lightline = { 'colorscheme': 'wombat' }
