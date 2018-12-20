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
let g:fzf_history_dir = '~/.local/share/fzf-history'

Plug 'w0rp/ale'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'Shougo/denite.nvim'
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
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
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

" Go, Golang Plugs
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "3s"
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>i <Plug>(go-info)
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

" Rust Plugs"
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
let g:autofmt_autosave = 1
Plug 'racer-rust/vim-racer'
set hidden
let g:racer_experimental_completer = 1

" Scala Plugs"
Plug 'natebosch/vim-lsc'
Plug 'derekwyatt/vim-scala'
au BufRead,BufNewFile *.sbt set filetype=scala
au BufRead,BufNewFile *.sc set filetype=scala
Plug 'Chiel92/vim-autoformat'
noremap <leader>f :Autoformat<CR>
let g:formatdef_scalafmt = "'scalafmt --stdin'"
let g:formatters_scala = ['scalafmt']

" Configuration for vim-lsc
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {
  \ 'scala': 'metals-vim'
  \}
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \}

" Frontend Plugs"
Plug 'walm/jshint.vim'
Plug 'moll/vim-node'
Plug 'jelera/vim-javascript-syntax'
Plug 'othree/javascript-libraries-syntax.vim'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

Plug 'reasonml-editor/vim-reason-plus'

Plug 'ElmCast/elm-vim'

" Add plugins to &runtimepath
call plug#end()

filetype indent on
filetype plugin on

set t_Co=256
set mouse=r
syntax on
set background=dark
silent! colorscheme nova

tnoremap <leader>h <C-\><C-n><C-w>h
tnoremap <leader>j <C-\><C-n><C-w>j
tnoremap <leader>k <C-\><C-n><C-w>k
tnoremap <leader>l <C-\><C-n><C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Completion
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:SuperTabDefaultCompletionType = "context"

" vim-test bindings
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tv :TestVisit<CR>

let test#strategy = "neovim"

let g:indentLine_setConceal = 0

" elixir.vim config
let g:elixir_autobuild = 1
let g:elixir_showerror = 1

" Remap gitgutter's mappings
nmap <leader>ga <Plug>GitGutterStageHunk
nmap <leader>gu <Plug>GitGutterRevertHunk
nmap <leader>gv <Plug>GitGutterPreviewHunk

inoremap <leader>q <Esc>

nnoremap <leader>w :w<CR>

imap <leader>x <C-\>

let g:user_emmet_leader_key='<C-Z>'

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
