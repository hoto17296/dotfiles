filetype off

" dein
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')

  call dein#add('Shougo/dein.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('itchyny/lightline.vim')
  call dein#add('tomasr/molokai')
  call dein#add('Townk/vim-autoclose')
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('airblade/vim-gitgutter')

  call dein#add('nikvdp/ejs-syntax')
  call dein#add('vim-scripts/nginx.vim')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" カラーリングする
syntax on
colorscheme molokai

" 常にステータスラインを表示
set laststatus=2

" lightline
let g:lightline = {
\   'active': {
\     'left': [ [ 'mode', 'paste' ],
\               [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
\   },
\   'component': {
\     'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
\     'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
\     'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
\   },
\   'component_visible_condition': {
\     'readonly': '(&filetype!="help"&& &readonly)',
\     'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
\     'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
\   },
\   'separator': { 'left': '⮀', 'right': '⮂' },
\   'subseparator': { 'left': '⮁', 'right': '⮃' }
\ }

" カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

" □や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double

" コマンドライン補完するときに強化されたものを使う
set wildmenu

" 行番号表示
set number

" 括弧の対応表示時間
set showmatch matchtime=1

" インデント設定
set autoindent
set expandtab
set tabstop=2     " TABの見た目幅
set shiftwidth=2  " autoindent時のスペース量
set softtabstop=0 " TAB展開時のスペース量(0:tsと同量)

" クリップボードを共有
set clipboard=unnamed,autoselect

" カレント行に下線
set cursorline
highlight CursorLine ctermbg=Black

" タブと行末スペースを可視化する
set list
set listchars=tab:\:\ ,trail:~

" セミコロンでもコマンド使えるようにする
noremap ; :

" beep音を消す
set noerrorbells
set vb t_vb=

" jjでインサートモードを抜ける
inoremap jj <ESC>

" ディレクトリ毎の .vimrc.local を読み込む
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

filetype plugin indent on
