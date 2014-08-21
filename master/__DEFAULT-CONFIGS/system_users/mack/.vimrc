set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
syntax on
source /home/mack/.nginx.vim
:set hlsearch
