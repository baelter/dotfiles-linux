syntax on
set tabstop=2 " a tab is 2 spaces wide
set shiftwidth=2 " 
set expandtab " tab = spaces
set backspace=indent,eol,start

set nu
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set smartcase
set hlsearch
set viewoptions=cursor,folds
set nobomb " no utf8 bom
set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right
set ttyfast " fast tty?
set shell=zsh

set laststatus=2 " Always show the statusline
set t_Co=256 " Explicitly tell vim that the terminal has 256 colors
set autoindent		" always set autoindenting on
set undofile " tell it to use an undo file
set undodir=~/.vimundo " set a directory to store the undo history
set mouse=r
