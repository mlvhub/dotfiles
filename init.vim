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

Plug 'jparise/vim-graphql'

Plug 'w0rp/ale'

Plug 'ervandew/supertab'

Plug 'luochen1990/rainbow'
Plug 'bling/vim-airline'
Plug 'Yggdroot/indentLine'
"Plug 'jceb/vim-hier'
Plug 'scrooloose/nerdcommenter'
Plug 'janko-m/vim-test'
Plug 'eugen0329/vim-esearch'
Plug 'easymotion/vim-easymotion'
Plug 'martinda/Jenkinsfile-vim-syntax'
"Plug 'tpope/vim-projectionist'
"Plug 'tpope/vim-dispatch'

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
set cmdheight=2
let g:racer_experimental_completer = 1

" Scala Plugs"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)

" Remap for do action format
nnoremap <silent> F :call CocAction('format')<CR>

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

autocmd FileType json syntax match Comment +\/\/.\+$+
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

Plug 'derekwyatt/vim-scala'
au BufRead,BufNewFile *.sbt set filetype=scala
au BufRead,BufNewFile *.sc set filetype=scala
Plug 'Chiel92/vim-autoformat'
noremap <leader>f :Autoformat<CR>
noremap gb :bd<CR>
let g:formatdef_scalafmt = "'scalafmt --stdin'"
let g:formatters_scala = ['scalafmt']

" Frontend Plugs"
Plug 'walm/jshint.vim'
Plug 'moll/vim-node'
Plug 'jelera/vim-javascript-syntax'
Plug 'othree/javascript-libraries-syntax.vim'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

Plug 'reasonml-editor/vim-reason-plus'
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
let g:syntastic_ocaml_checkers = ['merlin']


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
