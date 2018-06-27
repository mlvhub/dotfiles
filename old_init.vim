set nocompatible              " be iMproved
filetype off                  " required!

call plug#begin('~/.config/nvim/plugged')

" My Plugs
" General Plugs"
Plug 'scrooloose/syntastic'
Plug 'mattn/emmet-vim'
Plug 'Raimondi/delimitMate'
Plug 'kien/ctrlp.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'bling/vim-airline'
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
Plug 'Yggdroot/indentLine'
Plug 'Keithbsmiley/investigate.vim'
Plug 'justinmk/vim-sneak'
Plug 'ervandew/supertab'
Plug 'wavded/vim-stylus'
Plug 'Shougo/neocomplcache.vim'
Plug 'airblade/vim-gitgutter'
Plug 'jceb/vim-hier'
Plug 'scrooloose/nerdcommenter'
Plug 'janko-m/vim-test'
Plug 'eugen0329/vim-esearch'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'

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
Plug 'tpope/vim-markdown'
Plug 'jtratner/vim-flavored-markdown'
Plug 'vim-scripts/LanguageTool'

" Themes
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'trevordmiller/nova-vim'

" Ruby & Rails Plugs"
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-haml'

" Rust Plugs"
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'

" Scala Plugs"
Plug 'derekwyatt/vim-scala'
Plug 'gre/play2vim'

" Frontend Plugs"
Plug 'walm/jshint.vim'
Plug 'digitaltoad/vim-jade'
Plug 'moll/vim-node'
Plug 'jelera/vim-javascript-syntax'
Plug 'kchmck/vim-coffee-script'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'claco/jasmine.vim'

Plug 'reasonml-editor/vim-reason-plus'
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }

" Elixir Plugs
Plug 'thinca/vim-ref'
Plug 'elixir-lang/vim-elixir'
" Plug 'Shougo/vimproc.vim', { 'do': 'make' }
" Plug 'sanmiguel/helpex.vim'
Plug 'awetzel/elixir.nvim', { 'do': './install.sh' }

" Haskell Plugs
Plug 'hspec/hspec.vim'
Plug 'begriffs/haskell-vim-now'
Plug 'eagletmt/neco-ghc'

" Elm Plugs"
Plug 'lambdatoast/elm.vim'

" Add plugins to &runtimepath
call plug#end()

let $PATH = $PATH . ':' . expand("~/.cabal/bin")

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

let mapleader = ","
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

let g:sneak#s_next = 1

let g:user_emmet_leader_key='<C-Z>'

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

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
