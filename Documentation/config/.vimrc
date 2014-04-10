colorscheme evening

syntax enable

" display "strange" symbols
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

set ruler

" tabs
set expandtab
set tabstop=8       " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.

" visual ident
vnoremap < <gv
vnoremap > >gv

" line numbering
set number
nmap <C-n><C-n> :set invnumber<CR>

nmap <F2> :write<CR>
nmap <F10> :quit<CR>

" search and replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

filetype plugin indent on
syntax on

" configure tags - add additional tags here or comment out not-used ones
" set tags+=~/.vim/tags/cpp
" set tags+=~/.vim/tags/gl
" set tags+=~/.vim/tags/sdl
" set tags+=~/.vim/tags/qt4
set tags+=~/.vim/tags/boost54

" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+lp --fields=+iaS --extra=+q --language-force=C++ .<CR>

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
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

nmap <A-S-o> :CommandT<CR>
nmap <F8> :colorscheme vayerx<CR>
