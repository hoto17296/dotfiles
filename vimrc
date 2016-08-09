filetype off

if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'airblade/vim-gitgutter'

" Syntax highlight
NeoBundle 'tpope/vim-markdown'
NeoBundle 'othree/html5.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundle 'leafgarland/typescript-vim'

call neobundle#end()

NeoBundleCheck


" カラーリングする
syntax on
colorscheme molokai

" 常にステータスラインを表示
set laststatus=2

" lightline.vim
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

" 言語ごとのインデント設定
autocmd FileType javascript     setlocal sw=2 sts=2 ts=2 et
autocmd FileType javascript.jsx setlocal sw=2 sts=2 ts=2 et
autocmd FileType ruby           setlocal sw=2 sts=2 ts=2 et
autocmd FileType coffee         setlocal sw=2 sts=2 ts=2 et
autocmd FileType go             setlocal noet

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


" neocomplcacheを自動起動させる
let g:neocomplcache_enable_at_startup = 1
" smartcase機能を有効化
" (大文字が入力されるまで大文字小文字の区別を無視する)
let g:neocomplcache_enable_smart_case = 1

" ファイルタイプ毎のディクショナリ設定
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
\ }

" キーワードパターンの設定
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" 前回の補完をキャンセル
inoremap <expr><C-g> neocomplcache#undo_completion()

" 補完候補のなかから共通する部分を補完
inoremap <expr><C-l> neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction

" TABで補完候補を表示
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" 補完が誤爆しないための設定
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  neocomplcache#smart_close_popup()."\<C-h>"

" 現在選択している候補を確定
inoremap <expr><C-y> neocomplcache#close_popup()

" 補完をキャンセル
inoremap <expr><C-e> neocomplcache#cancel_popup()

" jjでインサートモードを抜ける
inoremap jj <ESC>

" カーソルキーで補完候補を表示しない
let g:neocomplcache_enable_insert_char_pre = 1

" Enable omni completion.
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable()
\? "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable()
\? "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


filetype plugin indent on


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
