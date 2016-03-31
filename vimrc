" vundle
set nocompatible           " be iMproved, required
filetype off               " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()          " required
filetype plugin indent on  " required

" general vim
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set ruler                  " show line,column number
set number                 " show line numbers
set nowrap
