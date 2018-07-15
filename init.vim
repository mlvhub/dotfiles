set nocompatible              " be iMproved
filetype off                  " required!
let mapleader = ","

call plug#begin('~/.config/nvim/plugged')

" My Plugs
" General Plugs"
Plug 'scrooloose/syntastic'
Plug 'mattn/emmet-vim'
Plug 'Raimondi/delimitMate'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :FZF<cr>

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'ervandew/supertab'

Plug 'luochen1990/rainbow'
Plug 'bling/vim-airline'
Plug 'Yggdroot/indentLine'
"Plug 'jceb/vim-hier'
Plug 'scrooloose/nerdcommenter'
Plug 'janko-m/vim-test'
Plug 'eugen0329/vim-esearch'
Plug 'easymotion/vim-easymotion'
"Plug 'tpope/vim-projectionist'
"Plug 'tpope/vim-dispatch'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<cr>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<cr>
nnoremap <silent> <cr> :call LanguageClient_textDocument_hover()<cr>

" Writing
Plug 'lervag/vimtex'
Plug 'reedes/vim-pencil'
Plug 'jtratner/vim-flavored-markdown'
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'dpelle/vim-LanguageTool'

" Themes
Plug 'trevordmiller/nova-vim'

" Go Plugs
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Rust Plugs"
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" Scala Plugs"
Plug 'derekwyatt/vim-scala'
Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }
autocmd BufWritePost *.scala silent :EnTypeCheck
nnoremap <localleader>t :EnType<CR>


" Frontend Plugs"
Plug 'walm/jshint.vim'
Plug 'moll/vim-node'
Plug 'jelera/vim-javascript-syntax'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'claco/jasmine.vim'

Plug 'reasonml-editor/vim-reason-plus'
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }

" Elm Plugs"
Plug 'lambdatoast/elm.vim'

" Add plugins to &runtimepath
call plug#end()

filetype indent on
filetype plugin on

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

set t_Co=16
set mouse=r
syntax on
set background=dark
let g:solarized_termcolors=16
silent! colorscheme nova

tnoremap <Leader>h <C-\><C-n><C-w>h
tnoremap <Leader>j <C-\><C-n><C-w>j
tnoremap <Leader>k <C-\><C-n><C-w>k
tnoremap <Leader>l <C-\><C-n><C-w>l
nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l

" Completion
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:SuperTabDefaultCompletionType = "context"

" vim-test bindings
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>ts :TestSuite<CR>
nmap <silent> <Leader>tv :TestVisit<CR>

let test#strategy = "neovim"

let g:indentLine_setConceal = 0

" elixir.vim config
let g:elixir_autobuild = 1
let g:elixir_showerror = 1

" Remap gitgutter's mappings
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterRevertHunk
nmap <Leader>gv <Plug>GitGutterPreviewHunk

:nnoremap <Leader>d :!zeal --query "<cword>"&<CR><CR>

inoremap <Leader>q <Esc>

nnoremap <Leader>w :w<CR>

imap <Leader>x <C-\>

let g:ctrlp_cmd = 'CtrlP pwd'

let g:user_emmet_leader_key='<C-Z>'

let g:ctrlp_custom_ignore = '\v[\/](node_modules|platforms|target|dist|www|_build)|(\.(swp|ico|git|svn))$'

"set foldmethod=syntax
set ignorecase
set hlsearch
set fileencoding=utf-8
set encoding=utf-8
set backspace=indent,eol,start
set ts=2 sts=2 sw=2 expandtab

set smartcase
set gdefault
set incsearch
set showmatch

set list
set number
set relativenumber
set visualbell
set cursorline
set background=dark
