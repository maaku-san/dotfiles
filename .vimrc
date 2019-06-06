execute pathogen#infect()

syntax on
filetype plugin indent on

let g:terraform_fmt_on_save=1
let g:terraform_align=1

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible              " Use Vim defaults (much better!)
set bs=indent,eol,start       " allow backspacing over everything in insert mode
"set ai                       " always set autoindenting on
"set backup                   " keep a backup file
set directory=~/.vim/swaps    " centralized swaps
set backupdir=~/.vim/backups  " centralized backups
set undodir=~/.vim/undo       " centralized undo history
set viminfo='20,\"50          " read/write a .viminfo file, don't store more
                              " than 50 lines of registers
set history=50                " keep 50 lines of command line history
set ruler                     " show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" turn on line numbering
"set relativenumber
set number

" show existing tab with 2 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab

set nowrap


" Most color xterms have only eight colors.  
" If you don't get colors with the default setup, this may fix things
if &term=="xterm"
     set t_Co=8
     set t_Sb=ESC[4%dm
     set t_Sf=ESC[3%dm
endif
