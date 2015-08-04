colorscheme evening

syntax enable

" display "strange" symbols
set listchars=tab:▸\ ,trail:~,extends:>,precedes:<,nbsp:█
set list

set ruler

" tabs
set expandtab
set tabstop=4       " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.

" indent
filetype plugin indent on
syntax on

set autoindent
set smartindent
set pastetoggle=<F5>

vnoremap < <gv
vnoremap > >gv

" line numbering
set number
nmap <C-n><C-n> :set invnumber<CR>

" file operations
set encoding=utf-8

nmap <F2> :write<CR>
imap <F2> <Esc> :write<CR>
nmap <F10> :quit<CR>

nmap <F3> :NERDTreeToggle<CR>
nmap <C-o> :CommandT<CR>
imap <C-o> <Esc> :CommandT<CR>

nmap <M-Right> :bnext<CR>
nmap <M-Left> :bprev<CR>
nmap <C-w> :bd<CR>

" search and replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/boost

" build tags
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+lp --fields=+iaS --extra=+q --language-force=C++ .<CR>
map <C-S-F12> 
        \:!mkdir -p ~/.vim/tags<CR>
        \:!ctags -R --sort=yes --c++-kinds=+npx --fields=+ziaS --extra=+q --language-force=C++ -f ~/.vim/tags/cpp /usr/lib/gcc/$(uname -m)-pc-linux-gnu/$(gcc -dumpversion)/include<CR>
        \:!ctags -R --sort=yes --c++-kinds=+npx --fields=+ziaS --extra=+q --language-force=C++ -f ~/.vim/tags/boost --exclude=*/detail/* /usr/include/boost<CR>

let OmniCpp_NamespaceSearch = 2
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_DisplayMode = 0
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    inoremap <C-@> <C-x><C-o>
endif

nmap <F8> :colorscheme vayerx<CR>
